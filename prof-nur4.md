# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.18s | 1430 | 1.0ms | 213 |

**Top 10:** `walkNodes` 6.6%, `onCodePathSegmentStart` 6.2%, `walkNodes` 5.2%, `_fireCfgEvents` 5.0%, `markReturnStatementsOnSegmentAsUsed` 4.5%, `walkNodes` 3.9%, `onCodePathSegmentStart` 3.7%, `parse` 3.5%, `walkNodes` 3.5%, `walkNodes` 3.5%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 6.6% | 144.5ms | 9.3% | 203.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 6.2% | 135.7ms | 6.2% | 135.7ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` |
| 5.2% | 115.1ms | 10.5% | 230.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` |
| 5.0% | 109.8ms | 31.4% | 686.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` |
| 4.5% | 98.5ms | 4.5% | 98.5ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` |
| 3.9% | 87.0ms | 4.3% | 95.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` |
| 3.7% | 82.9ms | 3.7% | 82.9ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` |
| 3.5% | 78.5ms | 3.5% | 78.5ms | `parse` | `[native code]` |
| 3.5% | 78.3ms | 3.7% | 81.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` |
| 3.5% | 78.0ms | 16.8% | 367.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 3.3% | 72.1ms | 3.3% | 73.8ms | `filter` | `[native code]` |
| 3.1% | 68.0ms | 3.1% | 68.0ms | `WeakSet` | `[native code]` |
| 3.0% | 66.8ms | 6.6% | 145.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6114` |
| 3.0% | 66.5ms | 5.9% | 129.4ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` |
| 3.0% | 66.4ms | 3.0% | 66.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 2.9% | 64.4ms | 2.9% | 64.4ms | `push` | `[native code]` |
| 2.4% | 53.5ms | 29.4% | 644.4ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` |
| 2.3% | 51.3ms | 9.0% | 198.4ms | `forEach` | `[native code]` |
| 1.4% | 32.3ms | 1.4% | 32.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` |
| 1.3% | 30.5ms | 4.5% | 98.5ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` |
| 1.3% | 29.0ms | 1.3% | 29.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 0.9% | 21.5ms | 2.3% | 51.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 0.9% | 21.0ms | 0.9% | 21.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.8% | 18.3ms | 15.4% | 338.1ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` |
| 0.7% | 17.0ms | 1.9% | 42.7ms | `anonymous` | `[native code]` |
| 0.7% | 16.8ms | 23.0% | 504.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` |
| 0.7% | 16.7ms | 0.7% | 16.7ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` |
| 0.6% | 14.6ms | 0.6% | 14.6ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` |
| 0.6% | 14.4ms | 0.6% | 14.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.6% | 13.5ms | 12.2% | 267.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 0.5% | 12.9ms | 0.5% | 12.9ms | `getUint32` | `[native code]` |
| 0.5% | 12.6ms | 0.5% | 12.6ms | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` |
| 0.5% | 12.6ms | 0.5% | 12.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 12.1ms | 0.5% | 12.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` |
| 0.5% | 12.0ms | 0.5% | 12.0ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.5% | 12.0ms | 0.5% | 12.0ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 10.6ms | 0.4% | 10.6ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` |
| 0.4% | 9.5ms | 0.4% | 9.5ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.4% | 9.2ms | 0.4% | 9.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6125` |
| 0.4% | 8.9ms | 0.4% | 8.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` |
| 0.3% | 8.4ms | 0.3% | 8.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` |
| 0.3% | 8.3ms | 0.3% | 8.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` |
| 0.3% | 8.0ms | 0.3% | 8.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` |
| 0.3% | 7.6ms | 8.5% | 186.7ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6159` |
| 0.3% | 7.6ms | 0.3% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` |
| 0.3% | 7.6ms | 11.6% | 254.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` |
| 0.3% | 7.6ms | 9.4% | 206.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` |
| 0.3% | 7.5ms | 0.3% | 7.5ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` |
| 0.3% | 7.4ms | 0.3% | 7.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 6.8ms | 0.3% | 6.8ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` |
| 0.2% | 6.3ms | 0.6% | 13.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.2% | 6.3ms | 0.5% | 12.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 0.2% | 6.0ms | 1.0% | 22.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` |
| 0.2% | 6.0ms | 2.7% | 59.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.2% | 5.9ms | 0.2% | 5.9ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` |
| 0.2% | 5.6ms | 0.3% | 7.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` |
| 0.2% | 5.3ms | 0.2% | 5.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` |
| 0.2% | 5.0ms | 1.2% | 26.5ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` |
| 0.2% | 4.6ms | 0.2% | 4.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` |
| 0.2% | 4.6ms | 0.8% | 18.7ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` |
| 0.2% | 4.6ms | 0.8% | 18.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` |
| 0.2% | 4.5ms | 1.7% | 38.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6663` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` |
| 0.1% | 4.0ms | 0.1% | 4.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4123` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `create` | `[native code]` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` |
| 0.1% | 3.1ms | 8.7% | 191.1ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6251` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` |
| 0.1% | 3.0ms | 9.2% | 201.4ms | `markReturnStatementsOnCurrentSegmentsAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4485` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6687` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6271` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6118` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isReturned` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:53` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraTryData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:696` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:725` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6669` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:349` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4460` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `moduleEvaluation` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` |
| 0.0% | 1.5ms | 0.2% | 4.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4453` |
| 0.0% | 1.5ms | 0.1% | 3.0ms | `readFileSync` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `defineProperty` | `[native code]` |
| 0.0% | 1.5ms | 0.2% | 4.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3251` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1890` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1536` |
| 0.0% | 1.4ms | 99.9% | 2.18s | `parseModule` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6123` |
| 0.0% | 1.4ms | 0.1% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `rewrittenPath` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js` |
| 0.0% | 1.3ms | 0.1% | 4.1ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:103` |
| 0.0% | 1.3ms | 0.8% | 18.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6119` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` |
| 0.0% | 1.2ms | 0.1% | 3.0ms | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6143` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4420` |
| 0.0% | 1.2ms | 0.2% | 4.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 99.9% | 2.18s | 0.0% | 1.4ms | `parseModule` | `[native code]` |
| 99.9% | 2.18s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 99.7% | 2.17s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.7% | 2.17s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 94.9% | 2.07s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` |
| 88.1% | 1.92s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 31.4% | 686.8ms | 5.0% | 109.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` |
| 29.4% | 644.4ms | 2.4% | 53.5ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` |
| 23.0% | 504.5ms | 0.7% | 16.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` |
| 16.8% | 367.6ms | 3.5% | 78.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 15.4% | 338.1ms | 0.8% | 18.3ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` |
| 12.2% | 267.4ms | 0.6% | 13.5ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 11.6% | 254.5ms | 0.3% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` |
| 10.5% | 230.0ms | 5.2% | 115.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` |
| 9.4% | 206.2ms | 0.3% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` |
| 9.3% | 203.2ms | 6.6% | 144.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 9.2% | 201.4ms | 0.1% | 3.0ms | `markReturnStatementsOnCurrentSegmentsAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` |
| 9.0% | 198.4ms | 2.3% | 51.3ms | `forEach` | `[native code]` |
| 8.7% | 191.1ms | 0.1% | 3.1ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6251` |
| 8.5% | 186.7ms | 0.3% | 7.6ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6159` |
| 7.1% | 155.9ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 6.6% | 145.1ms | 3.0% | 66.8ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6114` |
| 6.2% | 135.7ms | 6.2% | 135.7ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` |
| 5.9% | 129.4ms | 3.0% | 66.5ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` |
| 4.5% | 98.5ms | 4.5% | 98.5ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` |
| 4.5% | 98.5ms | 1.3% | 30.5ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` |
| 4.3% | 95.9ms | 3.9% | 87.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` |
| 3.9% | 87.1ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:342` |
| 3.8% | 83.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 3.7% | 82.9ms | 3.7% | 82.9ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` |
| 3.7% | 81.5ms | 3.5% | 78.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` |
| 3.5% | 78.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 3.5% | 78.5ms | 3.5% | 78.5ms | `parse` | `[native code]` |
| 3.3% | 73.8ms | 3.3% | 72.1ms | `filter` | `[native code]` |
| 3.1% | 68.0ms | 3.1% | 68.0ms | `WeakSet` | `[native code]` |
| 3.0% | 66.4ms | 3.0% | 66.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 2.9% | 64.4ms | 2.9% | 64.4ms | `push` | `[native code]` |
| 2.7% | 59.0ms | 0.2% | 6.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 2.3% | 51.2ms | 0.9% | 21.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 1.9% | 42.7ms | 0.7% | 17.0ms | `anonymous` | `[native code]` |
| 1.9% | 42.0ms | 0.0% | 0us | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:149` |
| 1.7% | 38.9ms | 0.2% | 4.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6663` |
| 1.7% | 37.6ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.6% | 36.3ms | 0.0% | 0us | `require` | `[native code]` |
| 1.4% | 32.3ms | 1.4% | 32.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` |
| 1.3% | 29.0ms | 1.3% | 29.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 1.2% | 26.5ms | 0.2% | 5.0ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` |
| 1.0% | 22.6ms | 0.2% | 6.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` |
| 1.0% | 21.9ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` |
| 0.9% | 21.0ms | 0.9% | 21.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.8% | 18.7ms | 0.2% | 4.6ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` |
| 0.8% | 18.5ms | 0.2% | 4.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` |
| 0.8% | 18.0ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6665` |
| 0.8% | 18.0ms | 0.0% | 1.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` |
| 0.8% | 17.6ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` |
| 0.7% | 16.7ms | 0.7% | 16.7ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` |
| 0.6% | 14.6ms | 0.6% | 14.6ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` |
| 0.6% | 14.4ms | 0.6% | 14.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.6% | 13.7ms | 0.2% | 6.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.5% | 12.9ms | 0.5% | 12.9ms | `getUint32` | `[native code]` |
| 0.5% | 12.6ms | 0.5% | 12.6ms | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` |
| 0.5% | 12.6ms | 0.5% | 12.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 12.3ms | 0.2% | 6.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 0.5% | 12.1ms | 0.5% | 12.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` |
| 0.5% | 12.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` |
| 0.5% | 12.0ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6671` |
| 0.5% | 12.0ms | 0.0% | 0us | `get nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` |
| 0.5% | 12.0ms | 0.5% | 12.0ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.5% | 12.0ms | 0.5% | 12.0ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.5% | 11.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.4% | 10.6ms | 0.4% | 10.6ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` |
| 0.4% | 9.5ms | 0.4% | 9.5ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.4% | 9.2ms | 0.4% | 9.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6125` |
| 0.4% | 8.9ms | 0.4% | 8.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` |
| 0.3% | 8.4ms | 0.3% | 8.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` |
| 0.3% | 8.3ms | 0.3% | 8.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` |
| 0.3% | 8.1ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:191` |
| 0.3% | 8.0ms | 0.3% | 8.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` |
| 0.3% | 7.6ms | 0.3% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` |
| 0.3% | 7.5ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.3% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.3% | 7.5ms | 0.3% | 7.5ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` |
| 0.3% | 7.4ms | 0.3% | 7.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 7.3ms | 0.2% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` |
| 0.3% | 6.8ms | 0.3% | 6.8ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` |
| 0.2% | 6.0ms | 0.0% | 0us | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` |
| 0.2% | 5.9ms | 0.2% | 5.9ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` |
| 0.2% | 5.3ms | 0.2% | 5.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` |
| 0.2% | 5.0ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:347` |
| 0.2% | 4.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.2% | 4.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` |
| 0.2% | 4.6ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` |
| 0.2% | 4.6ms | 0.2% | 4.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` |
| 0.2% | 4.5ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` |
| 0.2% | 4.5ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` |
| 0.1% | 4.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7601` |
| 0.1% | 4.1ms | 0.0% | 1.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` |
| 0.1% | 4.0ms | 0.1% | 4.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4123` |
| 0.1% | 3.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7277` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.1% | 3.5ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` |
| 0.1% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 3.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `create` | `[native code]` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` |
| 0.1% | 3.0ms | 0.0% | 1.5ms | `readFileSync` | `[native code]` |
| 0.1% | 3.0ms | 0.0% | 1.2ms | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` |
| 0.1% | 2.9ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` |
| 0.1% | 2.9ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6639` |
| 0.1% | 2.8ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` |
| 0.1% | 2.8ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.1% | 2.7ms | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6215` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.8ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4485` |
| 0.0% | 1.8ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5935` |
| 0.0% | 1.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6687` |
| 0.0% | 1.7ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:192` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6271` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:147` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6118` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isReturned` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:53` |
| 0.0% | 1.6ms | 0.0% | 0us | `get finalizer` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3288` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraTryData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:696` |
| 0.0% | 1.6ms | 0.0% | 0us | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:54` |
| 0.0% | 1.6ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` |
| 0.0% | 1.6ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` |
| 0.0% | 1.6ms | 0.0% | 0us | `SourceCode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1048` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:725` |
| 0.0% | 1.6ms | 0.0% | 0us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4004` |
| 0.0% | 1.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7597` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7357` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6669` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:349` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4460` |
| 0.0% | 1.6ms | 0.0% | 0us | `async loadAndEvaluateModule` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `moduleEvaluation` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4453` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `defineProperty` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3251` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1890` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1536` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6123` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `rewrittenPath` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:53` |
| 0.0% | 1.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.0% | 1.3ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:346` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` |
| 0.0% | 1.3ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4281` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:103` |
| 0.0% | 1.3ms | 0.0% | 0us | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:281` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` |
| 0.0% | 1.3ms | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.0% | 1.3ms | 0.0% | 0us | `test` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `retainEnclosingFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js:62` |
| 0.0% | 1.3ms | 0.0% | 0us | `fix` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:297` |
| 0.0% | 1.3ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3916` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6119` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6143` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4420` |
| 0.0% | 1.2ms | 0.0% | 0us | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:318` |
| 0.0% | 1.2ms | 0.0% | 0us | `allPrevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4567` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |

## Function Details

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` | Self: 6.6% (144.5ms) | Total: 9.3% (203.2ms) | Samples: 95

**Called by:**
- `runPlugins` (134)

**Calls:**
- `_fireCfgEvents` (10)
- `_fireCfgEvents` (9)
- `_fireCfgEvents` (6)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` | Self: 6.2% (135.7ms) | Total: 6.2% (135.7ms) | Samples: 88

**Called by:**
- `_dispatchSeg` (88)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` | Self: 5.2% (115.1ms) | Total: 10.5% (230.0ms) | Samples: 75

**Called by:**
- `runPlugins` (150)

**Calls:**
- `_fireCfgEvents` (66)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` | Self: 5.0% (109.8ms) | Total: 31.4% (686.8ms) | Samples: 72

**Called by:**
- `walkNodes` (269)
- `walkNodes` (112)
- `walkNodes` (66)
- `walkNodes` (3)

**Calls:**
- `_dispatchSeg` (378)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` | Self: 4.5% (98.5ms) | Total: 4.5% (98.5ms) | Samples: 66

**Called by:**
- `forEach` (66)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` | Self: 3.9% (87.0ms) | Total: 4.3% (95.9ms) | Samples: 58

**Called by:**
- `runPlugins` (64)

**Calls:**
- `_resolveHandlers` (6)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` | Self: 3.7% (82.9ms) | Total: 3.7% (82.9ms) | Samples: 54

**Called by:**
- `_dispatchSeg` (54)

### `parse`
`[native code]` | Self: 3.5% (78.5ms) | Total: 3.5% (78.5ms) | Samples: 53

**Called by:**
- `parseSource` (53)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` | Self: 3.5% (78.3ms) | Total: 3.7% (81.5ms) | Samples: 52

**Called by:**
- `runPlugins` (54)

**Calls:**
- `_resolveHandlers` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` | Self: 3.5% (78.0ms) | Total: 16.8% (367.6ms) | Samples: 51

**Called by:**
- `runPlugins` (240)

**Calls:**
- `_invokeFused` (174)
- `_nodeViewRaw` (5)
- `nodeView` (3)
- `nodeView` (3)
- `_invokeFused` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `filter`
`[native code]` | Self: 3.3% (72.1ms) | Total: 3.3% (73.8ms) | Samples: 47

**Called by:**
- `getUselessReturns` (27)
- `markReturnStatementsOnSegmentAsUsed` (15)
- `markReturnStatementsOnSegmentAsUsed` (5)
- `markReturnStatementsOnSegmentAsUsed` (1)

**Calls:**
- `isReturned` (1)

### `WeakSet`
`[native code]` | Self: 3.1% (68.0ms) | Total: 3.1% (68.0ms) | Samples: 46

**Called by:**
- `getUselessReturns` (46)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6114` | Self: 3.0% (66.8ms) | Total: 6.6% (145.1ms) | Samples: 43

**Called by:**
- `_runSelectorList` (94)

**Calls:**
- `nodeView` (26)
- `_nodeViewRaw` (13)
- `nodeView` (5)
- `nodeView` (3)
- `nodeView` (2)
- `_nodeViewRaw` (2)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` | Self: 3.0% (66.5ms) | Total: 5.9% (129.4ms) | Samples: 43

**Called by:**
- `onCodePathSegmentStart` (84)
- `getUselessReturns` (1)

**Calls:**
- `push` (42)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` | Self: 3.0% (66.4ms) | Total: 3.0% (66.4ms) | Samples: 44

**Called by:**
- `nodeView` (29)
- `getAncestorsFor` (13)
- `ReturnStatement` (1)
- `walkNodes` (1)

### `push`
`[native code]` | Self: 2.9% (64.4ms) | Total: 2.9% (64.4ms) | Samples: 43

**Called by:**
- `getUselessReturns` (42)
- `walkNodes` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` | Self: 2.4% (53.5ms) | Total: 29.4% (644.4ms) | Samples: 35

**Called by:**
- `_fireCfgEvents` (378)
- `_fireCfgEvents` (22)
- `_fireCfgEvents` (12)
- `_fireCfgEvents` (11)

**Calls:**
- `onCodePathSegmentStart` (223)
- `onCodePathSegmentStart` (88)
- `onCodePathSegmentStart` (54)
- `onUnreachableCodePathSegmentStart` (11)
- `onUnreachableCodePathSegmentEnd` (5)
- `onCodePathSegmentEnd` (5)
- `onUnreachableCodePathSegmentEnd` (1)
- `onCodePathSegmentStart` (1)

### `forEach`
`[native code]` | Self: 2.3% (51.3ms) | Total: 9.0% (198.4ms) | Samples: 33

**Called by:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (129)

**Calls:**
- `markReturnStatementsOnSegmentAsUsed` (66)
- `markReturnStatementsOnSegmentAsUsed` (15)
- `markReturnStatementsOnSegmentAsUsed` (5)
- `(anonymous)` (4)
- `markReturnStatementsOnSegmentAsUsed` (4)
- `markReturnStatementsOnSegmentAsUsed` (1)
- `markReturnStatementsOnSegmentAsUsed` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` | Self: 1.4% (32.3ms) | Total: 1.4% (32.3ms) | Samples: 22

**Called by:**
- `onCodePathSegmentStart` (22)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` | Self: 1.3% (30.5ms) | Total: 4.5% (98.5ms) | Samples: 20

**Called by:**
- `onCodePathSegmentStart` (66)

**Calls:**
- `WeakSet` (46)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` | Self: 1.3% (29.0ms) | Total: 1.3% (29.0ms) | Samples: 19

**Called by:**
- `runPlugins` (19)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` | Self: 0.9% (21.5ms) | Total: 2.3% (51.2ms) | Samples: 14

**Called by:**
- `walkNodes` (14)
- `walkNodes` (11)
- `walkNodes` (6)
- `walkNodes` (3)

**Calls:**
- `nodeView` (6)
- `nodeView` (5)
- `_nodeViewRaw` (5)
- `nodeView` (3)
- `_nodeViewRaw` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 0.9% (21.0ms) | Total: 0.9% (21.0ms) | Samples: 14

**Called by:**
- `_fireCfgEvents` (5)
- `walkNodes` (5)
- `getAncestorsFor` (2)
- `walkNodes` (1)
- `ReturnStatement` (1)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` | Self: 0.8% (18.3ms) | Total: 15.4% (338.1ms) | Samples: 11

**Called by:**
- `_dispatchSeg` (223)

**Calls:**
- `getUselessReturns` (84)
- `getUselessReturns` (66)
- `getUselessReturns` (27)
- `getUselessReturns` (22)
- `getUselessReturns` (10)
- `getUselessReturns` (3)

### `anonymous`
`[native code]` | Self: 0.7% (17.0ms) | Total: 1.9% (42.7ms) | Samples: 11

**Called by:**
- `require` (23)
- `internal:shared` (1)
- `internal:validators` (1)
- `bound require` (1)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `internal:validators` (1)
- `node:fs` (1)
- `node:events` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` | Self: 0.7% (16.8ms) | Total: 23.0% (504.5ms) | Samples: 11

**Called by:**
- `runPlugins` (331)

**Calls:**
- `_fireCfgEvents` (269)
- `_fireCfgEvents` (14)
- `_fireCfgEvents` (11)
- `_fireCfgEvents` (10)
- `_fireCfgEvents` (8)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `onUnreachableCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` | Self: 0.7% (16.7ms) | Total: 0.7% (16.7ms) | Samples: 11

**Called by:**
- `_dispatchSeg` (11)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` | Self: 0.6% (14.6ms) | Total: 0.6% (14.6ms) | Samples: 10

**Called by:**
- `onCodePathSegmentStart` (10)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.6% (14.4ms) | Total: 0.6% (14.4ms) | Samples: 10

**Called by:**
- `getAncestorsFor` (3)
- `ReturnStatement` (3)
- `ReturnStatement` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` | Self: 0.6% (13.5ms) | Total: 12.2% (267.4ms) | Samples: 9

**Called by:**
- `walkNodes` (174)

**Calls:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (73)
- `ReturnStatement` (58)
- `ReturnStatement` (17)
- `ReturnStatement` (12)
- `ReturnStatement` (3)
- `ReturnStatement` (1)
- `ReturnStatement` (1)

### `getUint32`
`[native code]` | Self: 0.5% (12.9ms) | Total: 0.5% (12.9ms) | Samples: 8

**Called by:**
- `get argument` (5)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` | Self: 0.5% (12.6ms) | Total: 0.5% (12.6ms) | Samples: 8

**Called by:**
- `_fireCfgEvents` (8)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.5% (12.6ms) | Total: 0.5% (12.6ms) | Samples: 8

**Called by:**
- `_fireCfgEvents` (3)
- `walkNodes` (3)
- `getAncestorsFor` (2)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` | Self: 0.5% (12.1ms) | Total: 0.5% (12.1ms) | Samples: 8

**Called by:**
- `_runSelectorList` (8)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.5% (12.0ms) | Total: 0.5% (12.0ms) | Samples: 8

**Called by:**
- `walkNodes` (5)
- `walkNodes` (3)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.5% (12.0ms) | Total: 0.5% (12.0ms) | Samples: 8

**Called by:**
- `walkNodes` (6)
- `walkNodes` (2)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` | Self: 0.4% (10.6ms) | Total: 0.4% (10.6ms) | Samples: 7

**Called by:**
- `_fireCfgEvents` (7)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` | Self: 0.4% (9.5ms) | Total: 0.4% (9.5ms) | Samples: 6

**Called by:**
- `get argument` (4)
- `walkNodes` (1)
- `walkNodes` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6125` | Self: 0.4% (9.2ms) | Total: 0.4% (9.2ms) | Samples: 6

**Called by:**
- `_runSelectorList` (6)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` | Self: 0.4% (8.9ms) | Total: 0.4% (8.9ms) | Samples: 6

**Called by:**
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` | Self: 0.3% (8.4ms) | Total: 0.3% (8.4ms) | Samples: 4

**Called by:**
- `forEach` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` | Self: 0.3% (8.3ms) | Total: 0.3% (8.3ms) | Samples: 5

**Called by:**
- `getAncestorsFor` (5)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` | Self: 0.3% (8.0ms) | Total: 0.3% (8.0ms) | Samples: 5

**Called by:**
- `_runSelectorList` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` | Self: 0.3% (7.8ms) | Total: 0.3% (7.8ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` | Self: 0.3% (7.8ms) | Total: 0.3% (7.8ms) | Samples: 5

**Called by:**
- `_fireCfgEvents` (5)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6159` | Self: 0.3% (7.6ms) | Total: 8.5% (186.7ms) | Samples: 5

**Called by:**
- `invokeSelectorHandlers` (121)

**Calls:**
- `getAncestorsFor` (94)
- `getAncestorsFor` (8)
- `getAncestorsFor` (6)
- `getAncestorsFor` (5)
- `getAncestorsFor` (1)
- `getAncestorsFor` (1)
- `getAncestorsFor` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` | Self: 0.3% (7.6ms) | Total: 0.3% (7.6ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` | Self: 0.3% (7.6ms) | Total: 11.6% (254.5ms) | Samples: 5

**Called by:**
- `runPlugins` (167)

**Calls:**
- `_fireCfgEvents` (112)
- `_fireCfgEvents` (15)
- `_fireCfgEvents` (14)
- `_fireCfgEvents` (6)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` | Self: 0.3% (7.6ms) | Total: 9.4% (206.2ms) | Samples: 5

**Called by:**
- `runPlugins` (134)

**Calls:**
- `invokeSelectorHandlers` (124)
- `invokeSelectorHandlers` (3)
- `invokeSelectorHandlers` (2)

### `onCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` | Self: 0.3% (7.5ms) | Total: 0.3% (7.5ms) | Samples: 5

**Called by:**
- `_dispatchSeg` (5)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (7.4ms) | Total: 0.3% (7.4ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `onUnreachableCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` | Self: 0.3% (6.8ms) | Total: 0.3% (6.8ms) | Samples: 5

**Called by:**
- `_dispatchSeg` (5)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `forEach` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` | Self: 0.2% (6.3ms) | Total: 0.6% (13.7ms) | Samples: 4

**Called by:**
- `runPlugins` (9)

**Calls:**
- `invokeSelectorHandlers` (5)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` | Self: 0.2% (6.3ms) | Total: 0.5% (12.3ms) | Samples: 4

**Called by:**
- `walkNodes` (5)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `codepath` (4)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` | Self: 0.2% (6.0ms) | Total: 1.0% (22.6ms) | Samples: 4

**Called by:**
- `walkNodes` (15)

**Calls:**
- `onCodePathStart` (7)
- `onCodePathStart` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.2% (6.0ms) | Total: 2.7% (59.0ms) | Samples: 4

**Called by:**
- `getAncestorsFor` (26)
- `_fireCfgEvents` (6)
- `walkNodes` (3)
- `walkNodes` (2)
- `invokeSelectorHandlers` (2)
- `ReturnStatement` (1)

**Calls:**
- `_nodeViewRaw` (29)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` | Self: 0.2% (5.9ms) | Total: 0.2% (5.9ms) | Samples: 4

**Called by:**
- `ReturnStatement` (2)
- `ReturnStatement` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` | Self: 0.2% (5.8ms) | Total: 0.2% (5.8ms) | Samples: 4

**Called by:**
- `nodeView` (4)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` | Self: 0.2% (5.8ms) | Total: 0.2% (5.8ms) | Samples: 4

**Called by:**
- `_fireCfgEvents` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` | Self: 0.2% (5.6ms) | Total: 0.3% (7.3ms) | Samples: 4

**Called by:**
- `runPlugins` (5)

**Calls:**
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` | Self: 0.2% (5.3ms) | Total: 0.2% (5.3ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` | Self: 0.2% (5.0ms) | Total: 1.2% (26.5ms) | Samples: 3

**Called by:**
- `_invokeFused` (17)

**Calls:**
- `get argument` (5)
- `nodeView` (2)
- `get argument` (2)
- `get argument` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` | Self: 0.2% (4.7ms) | Total: 0.2% (4.7ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` | Self: 0.2% (4.6ms) | Total: 0.2% (4.6ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` | Self: 0.2% (4.6ms) | Total: 0.8% (18.7ms) | Samples: 3

**Called by:**
- `ReturnStatement` (7)
- `ReturnStatement` (5)

**Calls:**
- `getUint32` (5)
- `nodeLhs` (4)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` | Self: 0.2% (4.6ms) | Total: 0.8% (18.5ms) | Samples: 3

**Called by:**
- `walkNodes` (10)
- `walkNodes` (2)

**Calls:**
- `onCodePathEnd` (8)
- `onCodePathEnd` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6663` | Self: 0.2% (4.5ms) | Total: 1.7% (38.9ms) | Samples: 3

**Called by:**
- `walkNodes` (14)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (22)
- `_dispatchSeg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` | Self: 0.2% (4.3ms) | Total: 0.2% (4.3ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4123` | Self: 0.1% (4.0ms) | Total: 0.1% (4.0ms) | Samples: 3

**Called by:**
- `nodeView` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `create`
`[native code]` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `get nextSegments` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6251` | Self: 0.1% (3.1ms) | Total: 8.7% (191.1ms) | Samples: 2

**Called by:**
- `walkNodes` (124)

**Calls:**
- `_runSelectorList` (121)
- `_runSelectorList` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `markReturnStatementsOnCurrentSegmentsAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` | Self: 0.1% (3.0ms) | Total: 9.2% (201.4ms) | Samples: 2

**Called by:**
- `_invokeFused` (73)
- `ReturnStatement` (58)

**Calls:**
- `forEach` (129)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (1)
- `ReturnStatement` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4485` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6687` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `initialSegment` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6271` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `codepath` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `TokenType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6118` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `isReturned`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `filter` (1)

### `isInFinally`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `isInFinally`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:53` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `extraTryData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:696` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get finalizer` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:725` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `SourceCode` (1)

### `get`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `onUnreachableCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_dispatchSeg` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6669` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:349` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4460` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `moduleEvaluation`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `async loadAndEvaluateModule` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `codepath` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` | Self: 0.0% (1.5ms) | Total: 0.2% (4.6ms) | Samples: 1

**Called by:**
- `runPlugins` (3)

**Calls:**
- `nodeRhs` (1)
- `getUint32` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4453` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `defineProperty`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` | Self: 0.0% (1.5ms) | Total: 0.2% (4.5ms) | Samples: 1

**Called by:**
- `walkNodes` (2)
- `walkNodes` (1)

**Calls:**
- `initialSegment` (2)

### `get label`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3251` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1890` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1536` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `parseModule`
`[native code]` | Self: 0.0% (1.4ms) | Total: 99.9% (2.18s) | Samples: 1

**Called by:**
- `async (anonymous)` (1429)

**Calls:**
- `(anonymous)` (1426)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6123` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` | Self: 0.0% (1.4ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `defineProperty` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `rewrittenPath`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `loadCoreRules` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` | Self: 0.0% (1.3ms) | Total: 0.1% (4.1ms) | Samples: 1

**Called by:**
- `onCodePathSegmentStart` (3)

**Calls:**
- `getUselessReturns` (1)
- `getUselessReturns` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `codepath` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getUselessReturns` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:103` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` | Self: 0.0% (1.3ms) | Total: 0.8% (18.0ms) | Samples: 1

**Called by:**
- `walkNodes` (9)
- `walkNodes` (3)

**Calls:**
- `_dispatchSeg` (11)

### `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `test` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `codepath` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6119` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` | Self: 0.0% (1.2ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (2)

**Calls:**
- `segment` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6143` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `_csrSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4420` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `allPrevSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` | Self: 0.0% (1.2ms) | Total: 0.2% (4.5ms) | Samples: 1

**Called by:**
- `runPlugins` (3)

**Calls:**
- `nodeLhs` (1)
- `getUint32` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:191` | Self: 0.0% (0us) | Total: 0.3% (8.1ms) | Samples: 0

**Called by:**
- `forEach` (5)

**Calls:**
- `filter` (5)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.5% (11.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 7.1% (155.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (99)

**Calls:**
- `runPlugins` (96)
- `runPlugins` (2)
- `runPlugins` (1)

### `test`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getUpperFunction` (1)

**Calls:**
- `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:149` | Self: 0.0% (0us) | Total: 1.9% (42.0ms) | Samples: 0

**Called by:**
- `onCodePathSegmentStart` (27)

**Calls:**
- `filter` (27)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` | Self: 0.0% (0us) | Total: 0.5% (12.1ms) | Samples: 0

**Called by:**
- `runPlugins` (8)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (3)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `retainEnclosingFunction` (1)

**Calls:**
- `test` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6639` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get label` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `push` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5935` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_extractBatchScannable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:318` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_dispatchSeg` (1)

**Calls:**
- `allPrevSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7357` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `create` (1)

### `SourceCode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1048` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `RuleContext` (1)

**Calls:**
- `_getSharedCaches` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadCoreRules` (1)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:281` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `report` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4281` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `create` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `bound require` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.3% (7.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `onCodePathEnd` (1)

**Calls:**
- `_execReport` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3916` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `fix` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 3.8% (83.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (55)

**Calls:**
- `parseSource` (53)
- `parseSource` (2)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.6% (36.3ms) | Samples: 0

**Called by:**
- `bound require` (23)

**Calls:**
- `anonymous` (23)

### `get nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` | Self: 0.0% (0us) | Total: 0.5% (12.0ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (8)

**Calls:**
- `_ensureNextAdjacency` (2)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `rewrittenPath` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 99.9% (2.18s) | Samples: 0

**Calls:**
- `parseModule` (1429)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7601` | Self: 0.0% (0us) | Total: 0.1% (4.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)
- `async (anonymous)` (1)

**Calls:**
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` | Self: 0.0% (0us) | Total: 94.9% (2.07s) | Samples: 0

**Called by:**
- `async (anonymous)` (1262)
- `async (anonymous)` (96)

**Calls:**
- `walkNodes` (331)
- `walkNodes` (240)
- `walkNodes` (167)
- `walkNodes` (150)
- `walkNodes` (134)
- `walkNodes` (134)
- `walkNodes` (64)
- `walkNodes` (54)
- `walkNodes` (19)
- `walkNodes` (9)
- `walkNodes` (8)
- `walkNodes` (5)
- `walkNodes` (5)
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
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` | Self: 0.0% (0us) | Total: 1.0% (21.9ms) | Samples: 0

**Called by:**
- `forEach` (15)

**Calls:**
- `filter` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7277` | Self: 0.0% (0us) | Total: 0.1% (3.6ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `nodeLhs` (1)
- `getUint32` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.7% (2.17s) | Samples: 0

**Called by:**
- `(anonymous)` (1426)

**Calls:**
- `async (anonymous)` (1263)
- `async (anonymous)` (99)
- `async (anonymous)` (55)
- `async (anonymous)` (7)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.2% (4.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:347` | Self: 0.0% (0us) | Total: 0.2% (5.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `isInFinally` (1)
- `isInFinally` (1)
- `isInFinally` (1)

### `retainEnclosingFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js:62` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `fix` (1)

**Calls:**
- `getUpperFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.3% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.7% (2.17s) | Samples: 0

**Called by:**
- `parseModule` (1426)

**Calls:**
- `async (anonymous)` (1426)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:147` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `TokenType` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `esquery` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6665` | Self: 0.0% (0us) | Total: 0.8% (18.0ms) | Samples: 0

**Called by:**
- `walkNodes` (10)
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 3.5% (78.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (53)

**Calls:**
- `parse` (53)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 1.7% (37.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)
- `patchAstUtils` (5)
- `esquery` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `_getFfiSelector` (1)
- `async (anonymous)` (1)

**Calls:**
- `require` (23)
- `anonymous` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6215` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `nodeView` (2)

### `fix`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:297` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `retainEnclosingFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `codepath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` | Self: 0.0% (0us) | Total: 0.2% (6.0ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (4)

**Calls:**
- `CfgCodePath` (1)
- `CfgCodePath` (1)
- `CfgCodePath` (1)
- `CfgCodePath` (1)

### `isInFinally`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `ReturnStatement` (1)

**Calls:**
- `get finalizer` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:192` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `filter` (1)

### `get finalizer`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3288` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isInFinally` (1)

**Calls:**
- `extraTryData` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfiSelector` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4004` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `SourceCode` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `bound require` (2)

### `allPrevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4567` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `onCodePathSegmentStart` (1)

**Calls:**
- `_csrSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildSelectorPlan` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` | Self: 0.0% (0us) | Total: 0.8% (17.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (12)

**Calls:**
- `get argument` (7)
- `nodeView` (3)
- `get argument` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7597` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `RuleContext` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6671` | Self: 0.0% (0us) | Total: 0.5% (12.0ms) | Samples: 0

**Called by:**
- `walkNodes` (8)

**Calls:**
- `get nextSegments` (8)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:346` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `isInLoop` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` | Self: 0.0% (0us) | Total: 0.2% (4.9ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `nodeView` (2)
- `nodeView` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:342` | Self: 0.0% (0us) | Total: 3.9% (87.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (58)

**Calls:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (58)

### `async loadAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Calls:**
- `moduleEvaluation` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 88.1% (1.92s) | Samples: 0

**Called by:**
- `async (anonymous)` (1263)

**Calls:**
- `runPlugins` (1262)
- `runPlugins` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 46.7% | 1.02s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 26.4% | 577.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 17.2% | 376.9ms | `[native code]` |
| 9.4% | 206.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js` |
