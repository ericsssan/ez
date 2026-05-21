# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.35s | 1546 | 1.0ms | 245 |

**Top 10:** `parse` 32.3%, `walkNodes` 7.0%, `walkNodes` 5.6%, `walkNodes` 4.0%, `_dispatchSeg` 3.9%, `walkNodes` 3.4%, `walkNodes` 3.1%, `walkNodes` 2.9%, `_NodeView` 2.6%, `onCodePathSegmentStart` 2.5%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 32.3% | 761.2ms | 32.3% | 761.2ms | `parse` | `[native code]` |
| 7.0% | 165.2ms | 9.2% | 217.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 5.6% | 132.5ms | 6.5% | 153.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` |
| 4.0% | 94.8ms | 4.1% | 96.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` |
| 3.9% | 92.0ms | 7.9% | 186.9ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` |
| 3.4% | 81.5ms | 8.8% | 208.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 3.1% | 73.5ms | 3.1% | 73.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` |
| 2.9% | 68.6ms | 3.1% | 73.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` |
| 2.6% | 62.6ms | 2.6% | 62.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 2.5% | 60.3ms | 2.5% | 60.3ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:219` |
| 1.4% | 32.9ms | 1.4% | 32.9ms | `defineProperty` | `[native code]` |
| 1.3% | 30.7ms | 1.3% | 30.7ms | `create` | `[native code]` |
| 1.1% | 26.8ms | 1.1% | 26.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4480` |
| 1.0% | 25.6ms | 1.0% | 25.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 1.0% | 24.2ms | 1.0% | 24.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` |
| 1.0% | 23.7ms | 1.9% | 45.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` |
| 0.9% | 22.4ms | 0.9% | 22.4ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:186` |
| 0.8% | 19.3ms | 0.8% | 19.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4440` |
| 0.7% | 18.7ms | 0.8% | 20.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.7% | 18.2ms | 0.7% | 18.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` |
| 0.7% | 17.9ms | 0.8% | 19.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` |
| 0.7% | 16.8ms | 3.1% | 74.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 0.6% | 16.1ms | 0.6% | 16.1ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` |
| 0.6% | 16.0ms | 0.6% | 16.0ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:215` |
| 0.6% | 15.7ms | 2.5% | 59.1ms | `anonymous` | `[native code]` |
| 0.6% | 15.4ms | 4.1% | 97.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.6% | 14.4ms | 0.6% | 14.4ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` |
| 0.6% | 14.1ms | 0.6% | 14.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 12.4ms | 0.5% | 12.4ms | `decode` | `[native code]` |
| 0.5% | 12.3ms | 10.7% | 253.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` |
| 0.4% | 11.2ms | 0.4% | 11.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1183` |
| 0.4% | 11.0ms | 0.4% | 11.0ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4520` |
| 0.4% | 10.4ms | 0.4% | 10.4ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:207` |
| 0.4% | 10.2ms | 0.4% | 10.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 0.4% | 10.1ms | 1.3% | 32.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` |
| 0.3% | 9.1ms | 7.5% | 176.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` |
| 0.3% | 8.7ms | 3.2% | 76.1ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 0.3% | 7.7ms | 0.7% | 16.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` |
| 0.3% | 7.6ms | 0.4% | 11.2ms | `readdirSync` | `[native code]` |
| 0.3% | 7.6ms | 1.7% | 40.4ms | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` |
| 0.3% | 7.5ms | 0.7% | 18.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.3% | 7.4ms | 0.3% | 8.9ms | `areAllSegmentsUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:32` |
| 0.3% | 7.3ms | 0.3% | 7.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` |
| 0.2% | 6.8ms | 1.2% | 29.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` |
| 0.2% | 6.8ms | 0.2% | 6.8ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:156` |
| 0.2% | 6.7ms | 0.2% | 6.7ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:211` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` |
| 0.2% | 5.9ms | 4.8% | 113.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.5ms | 0.2% | 5.5ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:198` |
| 0.2% | 4.9ms | 0.6% | 16.0ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `dlopen` | `[native code]` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4592` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.3ms | 0.3% | 9.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` |
| 0.1% | 3.8ms | 0.1% | 3.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` |
| 0.1% | 3.6ms | 0.1% | 3.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4449` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4471` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4460` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.1% | 2.9ms | 0.1% | 4.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6672` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `currentSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4621` |
| 0.1% | 2.8ms | 2.6% | 62.3ms | `nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4482` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `next` | `[native code]` |
| 0.1% | 2.7ms | 0.4% | 11.4ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4472` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2704` |
| 0.0% | 2.3ms | 0.0% | 2.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6673` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4438` |
| 0.0% | 1.7ms | 0.2% | 5.9ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:244` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_extendRangeToIncludeSemicolon` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4446` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:187` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4455` |
| 0.0% | 1.6ms | 0.4% | 11.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5246` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `encodeInto` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5380` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4032` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6823` |
| 0.0% | 1.5ms | 0.2% | 6.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6271` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3919` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` |
| 0.0% | 1.5ms | 3.5% | 84.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6671` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7285` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `allNextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4557` |
| 0.0% | 1.5ms | 0.7% | 18.3ms | `parseModule` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` |
| 0.0% | 1.4ms | 0.1% | 4.1ms | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` |
| 0.0% | 1.4ms | 0.1% | 2.9ms | `readFileSync` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:122` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5816` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:465` |
| 0.0% | 1.3ms | 1.7% | 41.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6278` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | 0.4% | 10.3ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:157` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `DataView` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5951` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1147` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `existsSync` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` |
| 0.0% | 1.2ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7295` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5904` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4492` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `set` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 65.8% | 1.54s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 65.0% | 1.52s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` |
| 32.8% | 771.3ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 32.3% | 761.2ms | 32.3% | 761.2ms | `parse` | `[native code]` |
| 32.3% | 761.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 10.7% | 253.3ms | 0.5% | 12.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` |
| 9.2% | 217.1ms | 7.0% | 165.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 8.8% | 208.5ms | 3.4% | 81.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 7.9% | 186.9ms | 3.9% | 92.0ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` |
| 7.5% | 176.7ms | 0.3% | 9.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` |
| 6.5% | 153.6ms | 5.6% | 132.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` |
| 4.8% | 113.8ms | 0.2% | 5.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` |
| 4.6% | 109.3ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 4.1% | 97.0ms | 0.6% | 15.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 4.1% | 96.4ms | 4.0% | 94.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` |
| 3.5% | 84.3ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6671` |
| 3.2% | 76.1ms | 0.3% | 8.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 3.1% | 74.7ms | 0.7% | 16.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 3.1% | 73.6ms | 2.9% | 68.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` |
| 3.1% | 73.5ms | 3.1% | 73.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` |
| 2.6% | 62.6ms | 2.6% | 62.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 2.6% | 62.3ms | 0.1% | 2.8ms | `nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` |
| 2.5% | 60.3ms | 2.5% | 60.3ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:219` |
| 2.5% | 59.1ms | 0.6% | 15.7ms | `anonymous` | `[native code]` |
| 2.4% | 57.6ms | 0.0% | 0us | `bound require` | `[native code]` |
| 2.3% | 54.2ms | 0.0% | 0us | `require` | `[native code]` |
| 2.1% | 51.5ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6663` |
| 1.9% | 45.7ms | 1.0% | 23.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` |
| 1.7% | 41.8ms | 0.0% | 1.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 1.7% | 40.4ms | 0.3% | 7.6ms | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` |
| 1.4% | 32.9ms | 1.4% | 32.9ms | `defineProperty` | `[native code]` |
| 1.3% | 32.0ms | 0.4% | 10.1ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` |
| 1.3% | 30.7ms | 1.3% | 30.7ms | `create` | `[native code]` |
| 1.2% | 29.3ms | 0.2% | 6.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` |
| 1.1% | 26.8ms | 1.1% | 26.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4480` |
| 1.0% | 25.6ms | 1.0% | 25.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 1.0% | 24.2ms | 1.0% | 24.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` |
| 0.9% | 22.4ms | 0.9% | 22.4ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:186` |
| 0.8% | 20.3ms | 0.0% | 0us | `get nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` |
| 0.8% | 20.3ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6665` |
| 0.8% | 20.1ms | 0.7% | 18.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.8% | 19.3ms | 0.8% | 19.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4440` |
| 0.8% | 19.1ms | 0.7% | 17.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` |
| 0.7% | 18.3ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.7% | 18.3ms | 0.0% | 1.5ms | `parseModule` | `[native code]` |
| 0.7% | 18.2ms | 0.7% | 18.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` |
| 0.7% | 18.0ms | 0.3% | 7.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.7% | 16.5ms | 0.3% | 7.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` |
| 0.6% | 16.1ms | 0.6% | 16.1ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` |
| 0.6% | 16.0ms | 0.6% | 16.0ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:215` |
| 0.6% | 16.0ms | 0.2% | 4.9ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` |
| 0.6% | 14.4ms | 0.6% | 14.4ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` |
| 0.6% | 14.1ms | 0.6% | 14.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 14.0ms | 0.0% | 0us | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:171` |
| 0.5% | 14.0ms | 0.0% | 0us | `isConsecutive` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:88` |
| 0.5% | 14.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7594` |
| 0.5% | 13.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.5% | 12.4ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1587` |
| 0.5% | 12.4ms | 0.5% | 12.4ms | `decode` | `[native code]` |
| 0.5% | 12.4ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.4% | 11.4ms | 0.1% | 2.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` |
| 0.4% | 11.3ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.4% | 11.2ms | 0.3% | 7.6ms | `readdirSync` | `[native code]` |
| 0.4% | 11.2ms | 0.4% | 11.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1183` |
| 0.4% | 11.0ms | 0.4% | 11.0ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4520` |
| 0.4% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.4% | 10.4ms | 0.4% | 10.4ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:207` |
| 0.4% | 10.3ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` |
| 0.4% | 10.3ms | 0.0% | 1.3ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:157` |
| 0.4% | 10.2ms | 0.4% | 10.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 0.4% | 9.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` |
| 0.4% | 9.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` |
| 0.3% | 9.3ms | 0.1% | 4.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` |
| 0.3% | 8.9ms | 0.3% | 7.4ms | `areAllSegmentsUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:32` |
| 0.3% | 8.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.3% | 7.6ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.3% | 7.3ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.3% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.3% | 7.3ms | 0.3% | 7.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` |
| 0.2% | 6.8ms | 0.2% | 6.8ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:156` |
| 0.2% | 6.7ms | 0.2% | 6.7ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:211` |
| 0.2% | 6.6ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6361` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 6.5ms | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6215` |
| 0.2% | 6.5ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` |
| 0.2% | 6.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` |
| 0.2% | 6.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` |
| 0.2% | 6.2ms | 0.0% | 0us | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:246` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` |
| 0.2% | 5.9ms | 0.0% | 1.7ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:244` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.6ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.2% | 5.5ms | 0.2% | 5.5ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:198` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `dlopen` | `[native code]` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4592` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` |
| 0.2% | 4.7ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7601` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.5ms | 0.1% | 2.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6672` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` |
| 0.1% | 4.1ms | 0.0% | 1.4ms | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` |
| 0.1% | 3.8ms | 0.1% | 3.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` |
| 0.1% | 3.6ms | 0.1% | 3.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4449` |
| 0.1% | 3.5ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6639` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` |
| 0.1% | 3.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.1% | 3.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` |
| 0.1% | 3.3ms | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.1ms | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6251` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4471` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4460` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.1% | 2.9ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` |
| 0.1% | 2.9ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.1% | 2.9ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.1% | 2.9ms | 0.0% | 0us | `isInitialized` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:23` |
| 0.1% | 2.9ms | 0.0% | 0us | `some` | `[native code]` |
| 0.1% | 2.9ms | 0.0% | 1.4ms | `readFileSync` | `[native code]` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `currentSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4621` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4482` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `next` | `[native code]` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` |
| 0.1% | 2.7ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7295` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4472` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2704` |
| 0.1% | 2.6ms | 0.0% | 0us | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:243` |
| 0.0% | 2.3ms | 0.0% | 2.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` |
| 0.0% | 1.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6673` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4438` |
| 0.0% | 1.7ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.0% | 1.7ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` |
| 0.0% | 1.7ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.0% | 1.7ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_extendRangeToIncludeSemicolon` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3626` |
| 0.0% | 1.7ms | 0.0% | 0us | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:166` |
| 0.0% | 1.7ms | 0.0% | 0us | `contains` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:77` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4446` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:187` |
| 0.0% | 1.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4455` |
| 0.0% | 1.6ms | 0.0% | 0us | `get initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` |
| 0.0% | 1.6ms | 0.0% | 0us | `find` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5246` |
| 0.0% | 1.6ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5422` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5246` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 1.6ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `encodeInto` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5380` |
| 0.0% | 1.6ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6162` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4032` |
| 0.0% | 1.6ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1556` |
| 0.0% | 1.6ms | 0.0% | 0us | `_getFfi` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` |
| 0.0% | 1.6ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` |
| 0.0% | 1.6ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` |
| 0.0% | 1.5ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6823` |
| 0.0% | 1.5ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.5ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6271` |
| 0.0% | 1.5ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3919` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7285` |
| 0.0% | 1.5ms | 0.0% | 0us | `SourceCode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1048` |
| 0.0% | 1.5ms | 0.0% | 0us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4004` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` |
| 0.0% | 1.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7597` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `allNextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4557` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` |
| 0.0% | 1.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:122` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5816` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:465` |
| 0.0% | 1.3ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6365` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6278` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:286` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `DataView` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5963` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5951` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5941` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5930` |
| 0.0% | 1.2ms | 0.0% | 0us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5001` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1147` |
| 0.0% | 1.2ms | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1244` |
| 0.0% | 1.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:42` |
| 0.0% | 1.2ms | 0.0% | 0us | `existsSync` | `node:fs:273` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `existsSync` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5810` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` |
| 0.0% | 1.2ms | 0.0% | 0us | `get declarations` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2649` |
| 0.0% | 1.2ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5904` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4492` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `set` | `[native code]` |

## Function Details

### `parse`
`[native code]` | Self: 32.3% (761.2ms) | Total: 32.3% (761.2ms) | Samples: 501

**Called by:**
- `parseSource` (501)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` | Self: 7.0% (165.2ms) | Total: 9.2% (217.1ms) | Samples: 110

**Called by:**
- `runPlugins` (143)

**Calls:**
- `_fireCfgEvents` (12)
- `_fireCfgEvents` (7)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (4)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` | Self: 5.6% (132.5ms) | Total: 6.5% (153.6ms) | Samples: 86

**Called by:**
- `runPlugins` (99)

**Calls:**
- `_fireCfgEvents` (6)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` | Self: 4.0% (94.8ms) | Total: 4.1% (96.4ms) | Samples: 61

**Called by:**
- `runPlugins` (62)

**Calls:**
- `_resolveHandlers` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` | Self: 3.9% (92.0ms) | Total: 7.9% (186.9ms) | Samples: 61

**Called by:**
- `_fireCfgEvents` (63)
- `_fireCfgEvents` (34)
- `_fireCfgEvents` (14)
- `_fireCfgEvents` (12)

**Calls:**
- `onCodePathSegmentStart` (39)
- `onCodePathSegmentEnd` (11)
- `onUnreachableCodePathSegmentStart` (7)
- `onUnreachableCodePathSegmentEnd` (4)
- `onCodePathSegmentEnd` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` | Self: 3.4% (81.5ms) | Total: 8.8% (208.5ms) | Samples: 54

**Called by:**
- `runPlugins` (139)

**Calls:**
- `_invokeFused` (51)
- `nodeView` (29)
- `_invokeFused` (4)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` | Self: 3.1% (73.5ms) | Total: 3.1% (73.5ms) | Samples: 49

**Called by:**
- `runPlugins` (49)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` | Self: 2.9% (68.6ms) | Total: 3.1% (73.6ms) | Samples: 45

**Called by:**
- `runPlugins` (48)

**Calls:**
- `_resolveHandlers` (3)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 2.6% (62.6ms) | Total: 2.6% (62.6ms) | Samples: 41

**Called by:**
- `_nodeViewRaw` (41)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:219` | Self: 2.5% (60.3ms) | Total: 2.5% (60.3ms) | Samples: 39

**Called by:**
- `_dispatchSeg` (39)

### `defineProperty`
`[native code]` | Self: 1.4% (32.9ms) | Total: 1.4% (32.9ms) | Samples: 22

**Called by:**
- `walkNodes` (15)
- `walkNodes` (7)

### `create`
`[native code]` | Self: 1.3% (30.7ms) | Total: 1.3% (30.7ms) | Samples: 20

**Called by:**
- `walkNodes` (14)
- `walkNodes` (6)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4480` | Self: 1.1% (26.8ms) | Total: 1.1% (26.8ms) | Samples: 17

**Called by:**
- `nextSegments` (17)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` | Self: 1.0% (25.6ms) | Total: 1.0% (25.6ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` | Self: 1.0% (24.2ms) | Total: 1.0% (24.2ms) | Samples: 15

**Called by:**
- `runPlugins` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` | Self: 1.0% (23.7ms) | Total: 1.9% (45.7ms) | Samples: 16

**Called by:**
- `runPlugins` (30)

**Calls:**
- `create` (14)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:186` | Self: 0.9% (22.4ms) | Total: 0.9% (22.4ms) | Samples: 15

**Called by:**
- `_invokeFused` (15)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4440` | Self: 0.8% (19.3ms) | Total: 0.8% (19.3ms) | Samples: 13

**Called by:**
- `nextSegments` (13)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.7% (18.7ms) | Total: 0.8% (20.1ms) | Samples: 12

**Called by:**
- `nodeView` (12)
- `get init` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` | Self: 0.7% (18.2ms) | Total: 0.7% (18.2ms) | Samples: 12

**Called by:**
- `runPlugins` (12)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` | Self: 0.7% (17.9ms) | Total: 0.8% (19.1ms) | Samples: 12

**Called by:**
- `runPlugins` (13)

**Calls:**
- `set` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` | Self: 0.7% (16.8ms) | Total: 3.1% (74.7ms) | Samples: 11

**Called by:**
- `walkNodes` (24)
- `walkNodes` (23)
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `nodeView` (35)
- `_nodeViewRaw` (3)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` | Self: 0.6% (16.1ms) | Total: 0.6% (16.1ms) | Samples: 11

**Called by:**
- `codepath` (11)

### `onCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:215` | Self: 0.6% (16.0ms) | Total: 0.6% (16.0ms) | Samples: 11

**Called by:**
- `_dispatchSeg` (11)

### `anonymous`
`[native code]` | Self: 0.6% (15.7ms) | Total: 2.5% (59.1ms) | Samples: 10

**Called by:**
- `require` (36)
- `bound require` (2)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.6% (15.4ms) | Total: 4.1% (97.0ms) | Samples: 10

**Called by:**
- `nodeView` (60)
- `_fireCfgEvents` (3)
- `walkNodes` (1)

**Calls:**
- `_NodeView` (41)
- `_NodeView` (10)
- `_NodeView_LR` (2)
- `_NodeView_LRN` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` | Self: 0.6% (14.4ms) | Total: 0.6% (14.4ms) | Samples: 9

**Called by:**
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.6% (14.1ms) | Total: 0.6% (14.1ms) | Samples: 10

**Called by:**
- `_nodeViewRaw` (10)

### `decode`
`[native code]` | Self: 0.5% (12.4ms) | Total: 0.5% (12.4ms) | Samples: 8

**Called by:**
- `get source` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` | Self: 0.5% (12.3ms) | Total: 10.7% (253.3ms) | Samples: 8

**Called by:**
- `runPlugins` (166)

**Calls:**
- `_fireCfgEvents` (55)
- `_fireCfgEvents` (39)
- `_fireCfgEvents` (23)
- `_fireCfgEvents` (20)
- `_fireCfgEvents` (7)
- `_fireCfgEvents` (4)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1183` | Self: 0.4% (11.2ms) | Total: 0.4% (11.2ms) | Samples: 7

**Called by:**
- `getTokenBefore` (7)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4520` | Self: 0.4% (11.0ms) | Total: 0.4% (11.0ms) | Samples: 8

**Called by:**
- `segment` (8)

### `onUnreachableCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:207` | Self: 0.4% (10.4ms) | Total: 0.4% (10.4ms) | Samples: 7

**Called by:**
- `_dispatchSeg` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` | Self: 0.4% (10.2ms) | Total: 0.4% (10.2ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` | Self: 0.4% (10.1ms) | Total: 1.3% (32.0ms) | Samples: 5

**Called by:**
- `walkNodes` (12)
- `walkNodes` (4)
- `walkNodes` (4)

**Calls:**
- `_dispatchSeg` (14)
- `segment` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` | Self: 0.3% (9.1ms) | Total: 7.5% (176.7ms) | Samples: 7

**Called by:**
- `runPlugins` (118)

**Calls:**
- `_fireCfgEvents` (28)
- `_fireCfgEvents` (24)
- `_fireCfgEvents` (24)
- `_fireCfgEvents` (8)
- `_fireCfgEvents` (6)
- `_fireCfgEvents` (6)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (4)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` | Self: 0.3% (8.7ms) | Total: 3.2% (76.1ms) | Samples: 6

**Called by:**
- `walkNodes` (51)

**Calls:**
- `reportIfUnreachable` (15)
- `reportIfUnreachable` (9)
- `reportIfUnreachable` (5)
- `VariableDeclaration` (4)
- `reportIfUnreachable` (4)
- `VariableDeclaration` (4)
- `VariableDeclaration` (2)
- `reportIfUnreachable` (1)
- `reportIfUnreachable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` | Self: 0.3% (7.7ms) | Total: 0.7% (16.5ms) | Samples: 5

**Called by:**
- `runPlugins` (11)

**Calls:**
- `create` (6)

### `readdirSync`
`[native code]` | Self: 0.3% (7.6ms) | Total: 0.4% (11.2ms) | Samples: 5

**Called by:**
- `loadCoreRules` (5)
- `readdirSync` (2)

**Calls:**
- `readdirSync` (2)

### `codepath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` | Self: 0.3% (7.6ms) | Total: 1.7% (40.4ms) | Samples: 5

**Called by:**
- `_fireCfgEvents` (27)

**Calls:**
- `CfgCodePath` (11)
- `CfgCodePath` (4)
- `CfgCodePath` (3)
- `CfgCodePath` (2)
- `CfgCodePath` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` | Self: 0.3% (7.5ms) | Total: 0.7% (18.0ms) | Samples: 5

**Called by:**
- `runPlugins` (12)

**Calls:**
- `defineProperty` (7)

### `areAllSegmentsUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:32` | Self: 0.3% (7.4ms) | Total: 0.3% (8.9ms) | Samples: 5

**Called by:**
- `reportIfUnreachable` (6)

**Calls:**
- `next` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` | Self: 0.3% (7.3ms) | Total: 0.3% (7.3ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` | Self: 0.2% (6.8ms) | Total: 1.2% (29.3ms) | Samples: 5

**Called by:**
- `runPlugins` (20)

**Calls:**
- `defineProperty` (15)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:156` | Self: 0.2% (6.8ms) | Total: 0.2% (6.8ms) | Samples: 5

**Called by:**
- `_invokeFused` (5)

### `onUnreachableCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:211` | Self: 0.2% (6.7ms) | Total: 0.2% (6.7ms) | Samples: 4

**Called by:**
- `_dispatchSeg` (4)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (6.6ms) | Total: 0.2% (6.6ms) | Samples: 4

**Called by:**
- `walkNodes` (3)
- `walkNodes` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` | Self: 0.2% (6.2ms) | Total: 0.2% (6.2ms) | Samples: 4

**Called by:**
- `get nextSegments` (4)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` | Self: 0.2% (5.9ms) | Total: 4.8% (113.8ms) | Samples: 4

**Called by:**
- `walkNodes` (39)
- `walkNodes` (24)
- `walkNodes` (6)
- `walkNodes` (5)

**Calls:**
- `_dispatchSeg` (63)
- `segment` (7)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (5.7ms) | Total: 0.2% (5.7ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (5.7ms) | Total: 0.2% (5.7ms) | Samples: 4

**Called by:**
- `walkNodes` (3)
- `walkNodes` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` | Self: 0.2% (5.5ms) | Total: 0.2% (5.5ms) | Samples: 4

**Called by:**
- `codepath` (4)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:198` | Self: 0.2% (4.9ms) | Total: 0.2% (4.9ms) | Samples: 3

**Called by:**
- `_fireCfgEvents` (3)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` | Self: 0.2% (4.9ms) | Total: 0.6% (16.0ms) | Samples: 3

**Called by:**
- `_fireCfgEvents` (7)
- `initialSegment` (2)
- `_fireCfgEvents` (1)
- `get initialSegment` (1)

**Calls:**
- `CfgSegment` (8)

### `dlopen`
`[native code]` | Self: 0.2% (4.9ms) | Total: 0.2% (4.9ms) | Samples: 3

**Called by:**
- `dlopen` (2)
- `(anonymous)` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4592` | Self: 0.2% (4.9ms) | Total: 0.2% (4.9ms) | Samples: 3

**Called by:**
- `codepath` (3)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` | Self: 0.2% (4.7ms) | Total: 0.2% (4.7ms) | Samples: 3

**Called by:**
- `get nextSegments` (3)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` | Self: 0.1% (4.3ms) | Total: 0.3% (9.3ms) | Samples: 3

**Called by:**
- `walkNodes` (6)

**Calls:**
- `onCodePathStart` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` | Self: 0.1% (3.8ms) | Total: 0.1% (3.8ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4449` | Self: 0.1% (3.6ms) | Total: 0.1% (3.6ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `codepath` (2)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `get value` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4471` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `nextSegments` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4460` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6672` | Self: 0.1% (2.9ms) | Total: 0.1% (4.5ms) | Samples: 2

**Called by:**
- `walkNodes` (3)

**Calls:**
- `allNextSegments` (1)

### `currentSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4621` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (2)

### `nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` | Self: 0.1% (2.8ms) | Total: 2.6% (62.3ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (41)

**Calls:**
- `_ensureNextAdjacency` (17)
- `_ensureNextAdjacency` (13)
- `_ensureNextAdjacency` (2)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4482` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `next`
`[native code]` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `_extractFileLevelRules` (1)
- `areAllSegmentsUnreachable` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` | Self: 0.1% (2.7ms) | Total: 0.4% (11.4ms) | Samples: 2

**Called by:**
- `walkNodes` (6)
- `walkNodes` (2)

**Calls:**
- `initialSegment` (3)
- `currentSegments` (2)
- `get initialSegment` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `codepath` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4472` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2704` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `VariableDeclaration` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (2.3ms) | Total: 0.0% (2.3ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6673` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4438` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:244` | Self: 0.0% (1.7ms) | Total: 0.2% (5.9ms) | Samples: 1

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `some` (2)
- `get declarations` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `VariableDeclaration` (1)

### `_extendRangeToIncludeSemicolon`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get range` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4446` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:187` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4455` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` | Self: 0.0% (1.6ms) | Total: 0.4% (11.3ms) | Samples: 1

**Called by:**
- `runPlugins` (7)

**Calls:**
- `invokeSelectorHandlers` (4)
- `invokeSelectorHandlers` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5246` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `find` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5380` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4032` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6823` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` | Self: 0.0% (1.5ms) | Total: 0.2% (6.5ms) | Samples: 1

**Called by:**
- `runPlugins` (4)

**Calls:**
- `nodeView` (2)
- `nodeView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6271` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3919` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6671` | Self: 0.0% (1.5ms) | Total: 3.5% (84.3ms) | Samples: 1

**Called by:**
- `walkNodes` (55)

**Calls:**
- `nextSegments` (41)
- `get nextSegments` (13)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7285` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `SourceCode` (1)

### `allNextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4557` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `parseModule`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.7% (18.3ms) | Samples: 1

**Called by:**
- `async (anonymous)` (12)

**Calls:**
- `(anonymous)` (9)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get value` (1)

### `initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` | Self: 0.0% (1.4ms) | Total: 0.1% (4.1ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (3)

**Calls:**
- `segment` (2)

### `readFileSync`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:122` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5816` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:465` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` | Self: 0.0% (1.3ms) | Total: 1.7% (41.8ms) | Samples: 1

**Called by:**
- `walkNodes` (28)

**Calls:**
- `codepath` (27)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `onCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_dispatchSeg` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6278` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:157` | Self: 0.0% (1.3ms) | Total: 0.4% (10.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (4)
- `VariableDeclaration` (3)

**Calls:**
- `areAllSegmentsUnreachable` (6)

### `DataView`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `slotTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5951` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildTemplate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1147` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `existsSync`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `existsSync` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7295` | Self: 0.0% (1.2ms) | Total: 0.1% (2.7ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `get` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5904` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4492` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `set`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `isAvailable` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `get declarations` (1)

**Calls:**
- `nodeView` (1)

### `isConsecutive`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:88` | Self: 0.0% (0us) | Total: 0.5% (14.0ms) | Samples: 0

**Called by:**
- `reportIfUnreachable` (9)

**Calls:**
- `getTokenBefore` (8)
- `getTokenBefore` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1587` | Self: 0.0% (0us) | Total: 0.5% (12.4ms) | Samples: 0

**Called by:**
- `isConsecutive` (8)

**Calls:**
- `_makeToken` (7)
- `_makeToken` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `existsSync` (1)

### `get initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `segment` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6215` | Self: 0.0% (0us) | Total: 0.2% (6.5ms) | Samples: 0

**Called by:**
- `walkNodes` (4)

**Calls:**
- `nodeView` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 4.6% (109.3ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (35)
- `walkNodes` (29)
- `invokeSelectorHandlers` (4)
- `walkNodes` (2)
- `_nodesFromRange` (1)
- `get value` (1)

**Calls:**
- `_nodeViewRaw` (60)
- `_nodeViewRaw` (12)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:243` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `get kind` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6663` | Self: 0.0% (0us) | Total: 2.1% (51.5ms) | Samples: 0

**Called by:**
- `walkNodes` (20)
- `walkNodes` (8)
- `walkNodes` (7)

**Calls:**
- `_dispatchSeg` (34)
- `_dispatchSeg` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.3% (7.3ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7601` | Self: 0.0% (0us) | Total: 0.2% (4.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.2% (5.6ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `CfgGraph` (2)
- `CfgGraph` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.3% (8.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `AstView` (3)
- `AstView` (1)
- `AstView` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.3% (7.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 65.8% (1.54s) | Samples: 0

**Calls:**
- `runPlugins` (1006)
- `runPlugins` (9)
- `runPlugins` (3)
- `runPlugins` (1)

### `SourceCode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1048` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `RuleContext` (1)

**Calls:**
- `_getSharedCaches` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.3% (7.6ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (5)

**Calls:**
- `readdirSync` (5)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 32.3% (761.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (501)

**Calls:**
- `parse` (501)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6361` | Self: 0.0% (0us) | Total: 0.2% (6.6ms) | Samples: 0

**Called by:**
- `walkNodes` (4)

**Calls:**
- `get value` (1)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 32.8% (771.3ms) | Samples: 0

**Calls:**
- `parseSource` (501)
- `parseSource` (5)
- `parseSource` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:166` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `contains` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5941` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_buildTemplate` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6251` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_runSelectorList` (1)
- `_runSelectorList` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5810` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_getSelectorRootTypes` (1)

### `get declarations`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2649` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `VariableDeclaration` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `nodeView` (1)

### `contains`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:77` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `reportIfUnreachable` (1)

**Calls:**
- `get range` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5963` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `slotTemplate` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1244` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `getTokenBefore` (1)

**Calls:**
- `_getJsxTextTokFlags` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.5% (12.4ms) | Samples: 0

**Called by:**
- `runPlugins` (8)

**Calls:**
- `decode` (8)

### `find`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (1)

**Calls:**
- `(anonymous)` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfiSelector` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5001` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `next` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `nodeRhs` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7594` | Self: 0.0% (0us) | Total: 0.5% (14.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (9)

**Calls:**
- `get source` (8)
- `reset` (1)

### `get nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` | Self: 0.0% (0us) | Total: 0.8% (20.3ms) | Samples: 0

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

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodesFromRange` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `esquery` (2)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6365` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `get range` (1)

### `some`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `VariableDeclaration` (2)

**Calls:**
- `isInitialized` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` | Self: 0.0% (0us) | Total: 0.4% (9.6ms) | Samples: 0

**Called by:**
- `runPlugins` (6)

**Calls:**
- `invokeMethodFnHandlers` (4)
- `invokeMethodFnHandlers` (2)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_rawTokenText` (1)

### `_getFfi`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getTokenBefore` (1)

**Calls:**
- `isAvailable` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6665` | Self: 0.0% (0us) | Total: 0.8% (20.3ms) | Samples: 0

**Called by:**
- `walkNodes` (7)
- `walkNodes` (4)
- `walkNodes` (2)

**Calls:**
- `_dispatchSeg` (12)
- `_dispatchSeg` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5246` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `find` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `get loc` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` | Self: 0.0% (0us) | Total: 65.0% (1.52s) | Samples: 0

**Called by:**
- `_lintSourceOne` (1006)

**Calls:**
- `walkNodes` (166)
- `walkNodes` (143)
- `walkNodes` (139)
- `walkNodes` (118)
- `walkNodes` (99)
- `walkNodes` (62)
- `walkNodes` (49)
- `walkNodes` (48)
- `walkNodes` (30)
- `walkNodes` (20)
- `walkNodes` (17)
- `walkNodes` (15)
- `walkNodes` (13)
- `walkNodes` (12)
- `walkNodes` (12)
- `walkNodes` (11)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (3)
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

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get init` (1)

**Calls:**
- `_isChainNode` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 2.4% (57.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (9)
- `(anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `esquery` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (35)
- `anonymous` (2)
- `(anonymous)` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (1)

**Calls:**
- `_tryLoad` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.4% (10.8ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:171` | Self: 0.0% (0us) | Total: 0.5% (14.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (9)

**Calls:**
- `isConsecutive` (9)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `isInitialized` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeViewChain` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` | Self: 0.0% (0us) | Total: 0.4% (9.8ms) | Samples: 0

**Called by:**
- `runPlugins` (7)

**Calls:**
- `getDFSEvents` (3)
- `getDFSEvents` (3)
- `getDFSEvents` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` | Self: 0.0% (0us) | Total: 0.2% (6.5ms) | Samples: 0

**Called by:**
- `runPlugins` (5)

**Calls:**
- `_getOrBuildPlan` (5)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6162` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (1)

**Calls:**
- `(anonymous)` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.7% (18.3ms) | Samples: 0

**Calls:**
- `parseModule` (12)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)
- `_tryLoad` (1)

**Calls:**
- `dlopen` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6639` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` | Self: 0.0% (0us) | Total: 0.4% (10.3ms) | Samples: 0

**Calls:**
- `loadCoreRules` (5)
- `loadCoreRules` (1)
- `loadCoreRules` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 2.3% (54.2ms) | Samples: 0

**Called by:**
- `bound require` (35)
- `loadCoreRules` (1)

**Calls:**
- `anonymous` (36)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isInitialized`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:23` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `some` (2)

**Calls:**
- `get init` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5930` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_extractFileLevelRules` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)

### `existsSync`
`node:fs:273` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `loadCoreRules` (1)

**Calls:**
- `existsSync` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_getFfi` (1)

**Calls:**
- `_tryLoad` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7597` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `RuleContext` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3626` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `contains` (1)

**Calls:**
- `_extendRangeToIncludeSemicolon` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.5% (13.7ms) | Samples: 0

**Called by:**
- `parseModule` (9)

**Calls:**
- `bound require` (9)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1556` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isConsecutive` (1)

**Calls:**
- `_getFfi` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5422` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_compileSelectorFastMatcher` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:286` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `DataView` (1)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:246` | Self: 0.0% (0us) | Total: 0.2% (6.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `reportIfUnreachable` (3)
- `reportIfUnreachable` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` | Self: 0.0% (0us) | Total: 0.2% (6.5ms) | Samples: 0

**Called by:**
- `walkNodes` (5)

**Calls:**
- `_buildPlan` (1)
- `_buildPlan` (1)
- `_buildPlan` (1)
- `_buildPlan` (1)
- `_buildPlan` (1)

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

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4004` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `SourceCode` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 44.0% | 1.03s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 37.4% | 879.8ms | `[native code]` |
| 12.2% | 287.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 6.0% | 143.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
