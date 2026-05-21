# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.24s | 1478 | 1.0ms | 199 |

**Top 10:** `walkNodes` 11.8%, `walkNodes` 8.7%, `walkNodes` 7.1%, `walkNodes` 5.5%, `_fireCfgEvents` 4.5%, `_fireCfgEvents` 4.5%, `walkNodes` 3.8%, `walkNodes` 3.6%, `walkNodes` 3.1%, `walkNodes` 3.1%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 11.8% | 266.3ms | 12.1% | 271.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 8.7% | 195.1ms | 8.8% | 199.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7011` |
| 7.1% | 159.4ms | 7.9% | 177.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7085` |
| 5.5% | 123.7ms | 6.7% | 150.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6567` |
| 4.5% | 102.9ms | 4.6% | 104.1ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6591` |
| 4.5% | 101.3ms | 7.7% | 174.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6626` |
| 3.8% | 85.9ms | 3.8% | 85.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7223` |
| 3.6% | 82.5ms | 3.6% | 82.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 3.1% | 71.5ms | 3.1% | 71.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 3.1% | 70.4ms | 3.1% | 70.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6739` |
| 2.9% | 66.7ms | 2.9% | 66.7ms | `parse` | `[native code]` |
| 2.4% | 55.3ms | 2.4% | 55.3ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:219` |
| 2.1% | 48.5ms | 6.3% | 142.2ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6226` |
| 2.0% | 46.0ms | 7.2% | 163.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7306` |
| 1.7% | 38.5ms | 1.7% | 38.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 1.5% | 34.8ms | 2.6% | 59.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6593` |
| 1.5% | 33.7ms | 2.0% | 46.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 1.4% | 31.7ms | 3.8% | 86.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` |
| 1.3% | 31.0ms | 1.3% | 31.0ms | `push` | `[native code]` |
| 1.3% | 29.8ms | 1.3% | 29.8ms | `has` | `[native code]` |
| 1.1% | 26.4ms | 1.1% | 26.4ms | `set` | `[native code]` |
| 1.1% | 26.0ms | 1.1% | 26.0ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:215` |
| 1.0% | 22.9ms | 1.8% | 41.7ms | `anonymous` | `[native code]` |
| 0.9% | 21.8ms | 2.8% | 63.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7044` |
| 0.9% | 20.5ms | 0.9% | 20.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6617` |
| 0.9% | 20.4ms | 0.9% | 20.4ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:156` |
| 0.8% | 18.2ms | 5.2% | 118.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7040` |
| 0.7% | 17.9ms | 0.7% | 17.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` |
| 0.7% | 16.5ms | 0.7% | 16.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6563` |
| 0.7% | 15.7ms | 0.7% | 15.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.6% | 13.5ms | 0.6% | 13.5ms | `next` | `[native code]` |
| 0.5% | 12.9ms | 0.5% | 12.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7174` |
| 0.5% | 12.8ms | 0.5% | 12.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7105` |
| 0.5% | 12.4ms | 9.1% | 204.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7233` |
| 0.5% | 12.2ms | 0.5% | 12.2ms | `areAllSegmentsUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:32` |
| 0.5% | 12.0ms | 1.9% | 43.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6568` |
| 0.4% | 10.7ms | 0.4% | 10.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` |
| 0.4% | 9.5ms | 0.5% | 11.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6606` |
| 0.4% | 9.2ms | 0.7% | 16.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` |
| 0.4% | 9.1ms | 0.4% | 9.1ms | `get` | `[native code]` |
| 0.4% | 9.1ms | 0.4% | 9.1ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:207` |
| 0.4% | 9.1ms | 0.4% | 9.1ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 8.9ms | 3.4% | 76.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 0.3% | 8.6ms | 0.3% | 8.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7199` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.3% | 7.6ms | 0.3% | 7.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1134` |
| 0.3% | 7.3ms | 0.3% | 7.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6983` |
| 0.3% | 6.8ms | 0.3% | 6.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.2% | 6.0ms | 0.5% | 12.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6577` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7277` |
| 0.2% | 5.6ms | 8.4% | 189.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` |
| 0.2% | 5.6ms | 0.6% | 13.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6566` |
| 0.2% | 5.2ms | 0.2% | 5.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1093` |
| 0.2% | 5.2ms | 0.2% | 5.2ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6317` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.1% | 4.2ms | 0.5% | 11.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6629` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7200` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4272` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6564` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:211` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4386` |
| 0.1% | 3.0ms | 0.6% | 14.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7276` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7151` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:866` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1098` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7214` |
| 0.1% | 2.6ms | 0.2% | 5.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7142` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6222` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4280` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4339` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4464` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4334` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6740` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:243` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4659` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7212` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3991` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:186` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:529` |
| 0.0% | 1.6ms | 0.5% | 12.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` |
| 0.0% | 1.6ms | 0.2% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6576` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6535` |
| 0.0% | 1.5ms | 0.4% | 9.3ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:246` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `encodeInto` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isInitialized` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:23` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `defineProperty` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `create` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4361` |
| 0.0% | 1.5ms | 0.6% | 13.7ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:157` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5219` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4351` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `byteLength` | `[native code]` |
| 0.0% | 1.4ms | 0.1% | 3.0ms | `some` | `[native code]` |
| 0.0% | 1.4ms | 0.2% | 5.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6578` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5863` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:155` |
| 0.0% | 1.4ms | 0.1% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7206` |
| 0.0% | 1.3ms | 100.0% | 2.24s | `parseModule` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:115` |
| 0.0% | 1.3ms | 0.2% | 4.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7088` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `FFIBuilder` | `bun:ffi` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6723` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5220` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `currentSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4500` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4381` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6574` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4281` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `decode` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 2.24s | 0.0% | 1.3ms | `parseModule` | `[native code]` |
| 100.0% | 2.24s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 99.8% | 2.23s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.8% | 2.23s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 95.5% | 2.14s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7522` |
| 88.5% | 1.98s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 12.1% | 271.3ms | 11.8% | 266.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 9.1% | 204.4ms | 0.5% | 12.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7233` |
| 8.8% | 199.2ms | 8.7% | 195.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7011` |
| 8.4% | 189.8ms | 0.2% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` |
| 7.9% | 177.0ms | 7.1% | 159.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7085` |
| 7.7% | 174.2ms | 4.5% | 101.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6626` |
| 7.2% | 163.4ms | 2.0% | 46.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7306` |
| 7.1% | 161.2ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 6.7% | 150.1ms | 5.5% | 123.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6567` |
| 6.3% | 142.2ms | 2.1% | 48.5ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6226` |
| 5.2% | 118.1ms | 0.8% | 18.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7040` |
| 4.6% | 104.1ms | 4.5% | 102.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6591` |
| 3.8% | 86.0ms | 1.4% | 31.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` |
| 3.8% | 85.9ms | 3.8% | 85.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7223` |
| 3.6% | 82.5ms | 3.6% | 82.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 3.4% | 76.6ms | 0.3% | 8.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 3.2% | 73.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 3.1% | 71.5ms | 3.1% | 71.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 3.1% | 70.4ms | 3.1% | 70.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6739` |
| 2.9% | 66.7ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 2.9% | 66.7ms | 2.9% | 66.7ms | `parse` | `[native code]` |
| 2.8% | 63.4ms | 0.9% | 21.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7044` |
| 2.6% | 59.6ms | 1.5% | 34.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6593` |
| 2.4% | 55.3ms | 2.4% | 55.3ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:219` |
| 2.0% | 46.8ms | 1.5% | 33.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 1.9% | 43.0ms | 0.5% | 12.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6568` |
| 1.8% | 41.7ms | 1.0% | 22.9ms | `anonymous` | `[native code]` |
| 1.8% | 40.3ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.7% | 38.9ms | 0.0% | 0us | `require` | `[native code]` |
| 1.7% | 38.5ms | 1.7% | 38.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 1.3% | 31.0ms | 1.3% | 31.0ms | `push` | `[native code]` |
| 1.3% | 29.8ms | 1.3% | 29.8ms | `has` | `[native code]` |
| 1.1% | 26.4ms | 1.1% | 26.4ms | `set` | `[native code]` |
| 1.1% | 26.0ms | 1.1% | 26.0ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:215` |
| 0.9% | 20.5ms | 0.9% | 20.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6617` |
| 0.9% | 20.4ms | 0.9% | 20.4ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:156` |
| 0.8% | 18.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7000` |
| 0.7% | 17.9ms | 0.7% | 17.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` |
| 0.7% | 17.1ms | 0.0% | 0us | `isConsecutive` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:88` |
| 0.7% | 17.1ms | 0.0% | 0us | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:171` |
| 0.7% | 16.5ms | 0.7% | 16.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6563` |
| 0.7% | 16.4ms | 0.4% | 9.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` |
| 0.7% | 15.7ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1538` |
| 0.7% | 15.7ms | 0.7% | 15.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.6% | 14.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7276` |
| 0.6% | 13.7ms | 0.0% | 1.5ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:157` |
| 0.6% | 13.6ms | 0.2% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6566` |
| 0.6% | 13.5ms | 0.6% | 13.5ms | `next` | `[native code]` |
| 0.5% | 13.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.5% | 12.9ms | 0.5% | 12.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7174` |
| 0.5% | 12.8ms | 0.5% | 12.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7105` |
| 0.5% | 12.6ms | 0.0% | 1.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` |
| 0.5% | 12.5ms | 0.2% | 6.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6577` |
| 0.5% | 12.2ms | 0.5% | 12.2ms | `areAllSegmentsUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:32` |
| 0.5% | 11.7ms | 0.1% | 4.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6629` |
| 0.5% | 11.2ms | 0.4% | 9.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6606` |
| 0.4% | 10.9ms | 0.0% | 0us | `get nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4425` |
| 0.4% | 10.7ms | 0.4% | 10.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` |
| 0.4% | 9.3ms | 0.0% | 1.5ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:246` |
| 0.4% | 9.1ms | 0.4% | 9.1ms | `get` | `[native code]` |
| 0.4% | 9.1ms | 0.4% | 9.1ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:207` |
| 0.4% | 9.1ms | 0.4% | 9.1ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 8.7ms | 0.0% | 0us | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:244` |
| 0.3% | 8.6ms | 0.3% | 8.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7199` |
| 0.3% | 8.1ms | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1195` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.3% | 7.6ms | 0.3% | 7.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1134` |
| 0.3% | 7.3ms | 0.3% | 7.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6983` |
| 0.3% | 6.8ms | 0.3% | 6.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 5.8ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.2% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7277` |
| 0.2% | 5.7ms | 0.1% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7142` |
| 0.2% | 5.2ms | 0.2% | 5.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1093` |
| 0.2% | 5.2ms | 0.2% | 5.2ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6317` |
| 0.2% | 5.1ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6578` |
| 0.2% | 4.9ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6576` |
| 0.2% | 4.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.2% | 4.8ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` |
| 0.2% | 4.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7201` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7038` |
| 0.1% | 4.4ms | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6202` |
| 0.1% | 4.4ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7200` |
| 0.1% | 3.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7521` |
| 0.1% | 3.3ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.1% | 3.3ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4357` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 3.3ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4272` |
| 0.1% | 3.2ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6598` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6564` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:211` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4386` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7151` |
| 0.1% | 3.0ms | 0.0% | 1.4ms | `some` | `[native code]` |
| 0.1% | 2.9ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7206` |
| 0.1% | 2.9ms | 0.0% | 0us | `get declarations` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2630` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:866` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 0.1% | 2.9ms | 0.0% | 0us | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1010` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1098` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.1% | 2.7ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7214` |
| 0.1% | 2.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6409` |
| 0.1% | 2.7ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5449` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6222` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4280` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4339` |
| 0.0% | 1.8ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.8ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` |
| 0.0% | 1.8ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 1.7ms | 0.0% | 0us | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4287` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4464` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4334` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:243` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6740` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4659` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7212` |
| 0.0% | 1.7ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7514` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3991` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:186` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7197` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:529` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5218` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6535` |
| 0.0% | 1.5ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.0% | 1.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `encodeInto` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isInitialized` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:23` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7209` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `defineProperty` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `create` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4361` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5219` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `byteLength` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4351` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7087` |
| 0.0% | 1.4ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5863` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:155` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getFfi` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:71` |
| 0.0% | 1.3ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1507` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:147` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:115` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7088` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `FFIBuilder` | `bun:ffi` |
| 0.0% | 1.3ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.0% | 1.3ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.0% | 1.3ms | 0.0% | 0us | `dlopen` | `bun:ffi:351` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6723` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5220` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6970` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `currentSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4500` |
| 0.0% | 1.2ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6601` |
| 0.0% | 1.2ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3905` |
| 0.0% | 1.2ms | 0.0% | 0us | `reportIfUnreachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:184` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4381` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6574` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4281` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `decode` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7517` |
| 0.0% | 1.0ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |

## Function Details

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` | Self: 11.8% (266.3ms) | Total: 12.1% (271.3ms) | Samples: 177

**Called by:**
- `runPlugins` (180)

**Calls:**
- `_resolveHandlers` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7011` | Self: 8.7% (195.1ms) | Total: 8.8% (199.2ms) | Samples: 128

**Called by:**
- `runPlugins` (131)

**Calls:**
- `_resolveHandlers` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7085` | Self: 7.1% (159.4ms) | Total: 7.9% (177.0ms) | Samples: 104

**Called by:**
- `runPlugins` (115)

**Calls:**
- `has` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6567` | Self: 5.5% (123.7ms) | Total: 6.7% (150.1ms) | Samples: 82

**Called by:**
- `runPlugins` (99)

**Calls:**
- `set` (17)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6591` | Self: 4.5% (102.9ms) | Total: 4.6% (104.1ms) | Samples: 68

**Called by:**
- `walkNodes` (25)
- `walkNodes` (20)
- `walkNodes` (17)
- `walkNodes` (7)

**Calls:**
- `get` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6626` | Self: 4.5% (101.3ms) | Total: 7.7% (174.2ms) | Samples: 68

**Called by:**
- `walkNodes` (48)
- `walkNodes` (45)
- `walkNodes` (17)
- `walkNodes` (7)

**Calls:**
- `_dispatchSeg` (48)
- `segment` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7223` | Self: 3.8% (85.9ms) | Total: 3.8% (85.9ms) | Samples: 58

**Called by:**
- `runPlugins` (58)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` | Self: 3.6% (82.5ms) | Total: 3.6% (82.5ms) | Samples: 55

**Called by:**
- `runPlugins` (55)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` | Self: 3.1% (71.5ms) | Total: 3.1% (71.5ms) | Samples: 47

**Called by:**
- `runPlugins` (47)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6739` | Self: 3.1% (70.4ms) | Total: 3.1% (70.4ms) | Samples: 47

**Called by:**
- `runPlugins` (47)

### `parse`
`[native code]` | Self: 2.9% (66.7ms) | Total: 2.9% (66.7ms) | Samples: 44

**Called by:**
- `parseSource` (44)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:219` | Self: 2.4% (55.3ms) | Total: 2.4% (55.3ms) | Samples: 37

**Called by:**
- `_dispatchSeg` (37)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6226` | Self: 2.1% (48.5ms) | Total: 6.3% (142.2ms) | Samples: 33

**Called by:**
- `_fireCfgEvents` (48)
- `_fireCfgEvents` (34)
- `_fireCfgEvents` (9)
- `_fireCfgEvents` (4)

**Calls:**
- `onCodePathSegmentStart` (37)
- `onCodePathSegmentEnd` (17)
- `onUnreachableCodePathSegmentStart` (6)
- `onUnreachableCodePathSegmentEnd` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7306` | Self: 2.0% (46.0ms) | Total: 7.2% (163.4ms) | Samples: 31

**Called by:**
- `runPlugins` (109)

**Calls:**
- `_fireCfgEvents` (22)
- `_fireCfgEvents` (17)
- `_fireCfgEvents` (16)
- `_fireCfgEvents` (12)
- `_fireCfgEvents` (7)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` | Self: 1.7% (38.5ms) | Total: 1.7% (38.5ms) | Samples: 24

**Called by:**
- `runPlugins` (24)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6593` | Self: 1.5% (34.8ms) | Total: 2.6% (59.6ms) | Samples: 24

**Called by:**
- `walkNodes` (19)
- `walkNodes` (12)
- `walkNodes` (8)
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` | Self: 1.5% (33.7ms) | Total: 2.0% (46.8ms) | Samples: 22

**Called by:**
- `walkNodes` (16)
- `walkNodes` (14)
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (9)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` | Self: 1.4% (31.7ms) | Total: 3.8% (86.0ms) | Samples: 20

**Called by:**
- `walkNodes` (22)
- `walkNodes` (22)
- `walkNodes` (10)
- `walkNodes` (2)

**Calls:**
- `_dispatchSeg` (34)
- `segment` (1)
- `_dispatchSeg` (1)

### `push`
`[native code]` | Self: 1.3% (31.0ms) | Total: 1.3% (31.0ms) | Samples: 20

**Called by:**
- `walkNodes` (20)

### `has`
`[native code]` | Self: 1.3% (29.8ms) | Total: 1.3% (29.8ms) | Samples: 19

**Called by:**
- `walkNodes` (11)
- `walkNodes` (7)
- `walkNodes` (1)

### `set`
`[native code]` | Self: 1.1% (26.4ms) | Total: 1.1% (26.4ms) | Samples: 17

**Called by:**
- `walkNodes` (17)

### `onCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:215` | Self: 1.1% (26.0ms) | Total: 1.1% (26.0ms) | Samples: 17

**Called by:**
- `_dispatchSeg` (17)

### `anonymous`
`[native code]` | Self: 1.0% (22.9ms) | Total: 1.8% (41.7ms) | Samples: 15

**Called by:**
- `require` (26)
- `bound require` (1)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7044` | Self: 0.9% (21.8ms) | Total: 2.8% (63.4ms) | Samples: 14

**Called by:**
- `runPlugins` (42)

**Calls:**
- `_fireCfgEvents` (17)
- `_fireCfgEvents` (7)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6617` | Self: 0.9% (20.5ms) | Total: 0.9% (20.5ms) | Samples: 13

**Called by:**
- `walkNodes` (9)
- `walkNodes` (3)
- `walkNodes` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:156` | Self: 0.9% (20.4ms) | Total: 0.9% (20.4ms) | Samples: 14

**Called by:**
- `_invokeFused` (14)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7040` | Self: 0.8% (18.2ms) | Total: 5.2% (118.1ms) | Samples: 12

**Called by:**
- `runPlugins` (78)

**Calls:**
- `_invokeFused` (51)
- `nodeView` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_invokeFused` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` | Self: 0.7% (17.9ms) | Total: 0.7% (17.9ms) | Samples: 12

**Called by:**
- `runPlugins` (12)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6563` | Self: 0.7% (16.5ms) | Total: 0.7% (16.5ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` | Self: 0.7% (15.7ms) | Total: 0.7% (15.7ms) | Samples: 10

**Called by:**
- `_fireCfgEvents` (8)
- `walkNodes` (1)
- `walkNodes` (1)

### `next`
`[native code]` | Self: 0.6% (13.5ms) | Total: 0.6% (13.5ms) | Samples: 9

**Called by:**
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7174` | Self: 0.5% (12.9ms) | Total: 0.5% (12.9ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7105` | Self: 0.5% (12.8ms) | Total: 0.5% (12.8ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7233` | Self: 0.5% (12.4ms) | Total: 9.1% (204.4ms) | Samples: 8

**Called by:**
- `runPlugins` (136)

**Calls:**
- `_fireCfgEvents` (48)
- `_fireCfgEvents` (22)
- `_fireCfgEvents` (20)
- `_fireCfgEvents` (14)
- `_fireCfgEvents` (8)
- `_fireCfgEvents` (8)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)

### `areAllSegmentsUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:32` | Self: 0.5% (12.2ms) | Total: 0.5% (12.2ms) | Samples: 8

**Called by:**
- `reportIfUnreachable` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6568` | Self: 0.5% (12.0ms) | Total: 1.9% (43.0ms) | Samples: 8

**Called by:**
- `runPlugins` (28)

**Calls:**
- `push` (20)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` | Self: 0.4% (10.7ms) | Total: 0.4% (10.7ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6606` | Self: 0.4% (9.5ms) | Total: 0.5% (11.2ms) | Samples: 6

**Called by:**
- `walkNodes` (7)

**Calls:**
- `onCodePathStart` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` | Self: 0.4% (9.2ms) | Total: 0.7% (16.4ms) | Samples: 6

**Called by:**
- `_fireCfgEvents` (4)
- `walkNodes` (4)
- `_nodesFromRange` (2)
- `walkNodes` (1)

**Calls:**
- `_computeNodeType` (3)
- `_computeNodeType` (2)

### `get`
`[native code]` | Self: 0.4% (9.1ms) | Total: 0.4% (9.1ms) | Samples: 6

**Called by:**
- `walkNodes` (5)
- `_fireCfgEvents` (1)

### `onUnreachableCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:207` | Self: 0.4% (9.1ms) | Total: 0.4% (9.1ms) | Samples: 6

**Called by:**
- `_dispatchSeg` (6)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.4% (9.1ms) | Total: 0.4% (9.1ms) | Samples: 6

**Called by:**
- `walkNodes` (3)
- `walkNodes` (3)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` | Self: 0.3% (8.9ms) | Total: 3.4% (76.6ms) | Samples: 6

**Called by:**
- `walkNodes` (51)

**Calls:**
- `reportIfUnreachable` (14)
- `reportIfUnreachable` (11)
- `VariableDeclaration` (6)
- `VariableDeclaration` (6)
- `reportIfUnreachable` (5)
- `reportIfUnreachable` (1)
- `reportIfUnreachable` (1)
- `VariableDeclaration` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7199` | Self: 0.3% (8.6ms) | Total: 0.3% (8.6ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.3% (7.7ms) | Total: 0.3% (7.7ms) | Samples: 5

**Called by:**
- `walkNodes` (3)
- `_fireCfgEvents` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1134` | Self: 0.3% (7.6ms) | Total: 0.3% (7.6ms) | Samples: 5

**Called by:**
- `getTokenBefore` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6983` | Self: 0.3% (7.3ms) | Total: 0.3% (7.3ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.3% (6.8ms) | Total: 0.3% (6.8ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6577` | Self: 0.2% (6.0ms) | Total: 0.5% (12.5ms) | Samples: 4

**Called by:**
- `runPlugins` (8)

**Calls:**
- `next` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (5.8ms) | Total: 0.2% (5.8ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7277` | Self: 0.2% (5.7ms) | Total: 0.2% (5.7ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` | Self: 0.2% (5.6ms) | Total: 8.4% (189.8ms) | Samples: 4

**Called by:**
- `runPlugins` (124)

**Calls:**
- `_fireCfgEvents` (45)
- `_fireCfgEvents` (25)
- `_fireCfgEvents` (19)
- `_fireCfgEvents` (10)
- `_fireCfgEvents` (9)
- `_fireCfgEvents` (7)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6566` | Self: 0.2% (5.6ms) | Total: 0.6% (13.6ms) | Samples: 4

**Called by:**
- `runPlugins` (9)

**Calls:**
- `get` (5)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1093` | Self: 0.2% (5.2ms) | Total: 0.2% (5.2ms) | Samples: 3

**Called by:**
- `_makeToken` (3)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6317` | Self: 0.2% (5.2ms) | Total: 0.2% (5.2ms) | Samples: 3

**Called by:**
- `walkNodes` (2)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6629` | Self: 0.1% (4.2ms) | Total: 0.5% (11.7ms) | Samples: 3

**Called by:**
- `walkNodes` (5)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (4)
- `_dispatchSeg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7200` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4272` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6564` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (1)
- `walkNodes` (1)

### `onUnreachableCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:211` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `_dispatchSeg` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4386` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `get nextSegments` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7276` | Self: 0.1% (3.0ms) | Total: 0.6% (14.0ms) | Samples: 2

**Called by:**
- `runPlugins` (9)

**Calls:**
- `has` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7151` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:866` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `get declarations` (2)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_computeNodeType` (2)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1098` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7214` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7142` | Self: 0.1% (2.6ms) | Total: 0.2% (5.7ms) | Samples: 2

**Called by:**
- `runPlugins` (4)

**Calls:**
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6222` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4280` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4339` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4464` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `codepath` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4334` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6740` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:243` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4659` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7212` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3991` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:186` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:529` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` | Self: 0.0% (1.6ms) | Total: 0.5% (12.6ms) | Samples: 1

**Called by:**
- `walkNodes` (8)

**Calls:**
- `get nextSegments` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6576` | Self: 0.0% (1.6ms) | Total: 0.2% (4.9ms) | Samples: 1

**Called by:**
- `runPlugins` (3)

**Calls:**
- `next` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `fn` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6535` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:246` | Self: 0.0% (1.5ms) | Total: 0.4% (9.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (6)

**Calls:**
- `reportIfUnreachable` (4)
- `reportIfUnreachable` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `isInitialized`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:23` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `some` (1)

### `defineProperty`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `create`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4361` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:157` | Self: 0.0% (1.5ms) | Total: 0.6% (13.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (5)
- `VariableDeclaration` (4)

**Calls:**
- `areAllSegmentsUnreachable` (8)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5219` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `codepath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4351` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `byteLength`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `some`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `VariableDeclaration` (2)

**Calls:**
- `isInitialized` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6578` | Self: 0.0% (1.4ms) | Total: 0.2% (5.1ms) | Samples: 1

**Called by:**
- `runPlugins` (4)

**Calls:**
- `next` (3)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5863` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:155` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `VariableDeclaration` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7206` | Self: 0.0% (1.4ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `create` (1)

### `parseModule`
`[native code]` | Self: 0.0% (1.3ms) | Total: 100.0% (2.24s) | Samples: 1

**Called by:**
- `async (anonymous)` (1478)

**Calls:**
- `(anonymous)` (1475)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `TokenType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:115` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` | Self: 0.0% (1.3ms) | Total: 0.2% (4.8ms) | Samples: 1

**Called by:**
- `runPlugins` (3)

**Calls:**
- `invokeMethodFnHandlers` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7088` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `FFIBuilder`
`bun:ffi` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `dlopen` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6561` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6723` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5220` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `currentSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4500` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `report` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4381` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6574` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4281` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `decode`
`[native code]` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `get source` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (1)

**Calls:**
- `_tryLoad` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.5% (13.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (9)

**Calls:**
- `bound require` (9)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6202` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `walkNodes` (3)

**Calls:**
- `_runSelectorList` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7197` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `nodeLhs` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6601` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `currentSegments` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7514` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `reset` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (3)

**Calls:**
- `fn` (1)
- `fn` (1)
- `fn` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (2.24s) | Samples: 0

**Calls:**
- `parseModule` (1478)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.7% (38.9ms) | Samples: 0

**Called by:**
- `bound require` (26)

**Calls:**
- `anonymous` (26)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 3.2% (73.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (47)

**Calls:**
- `parseSource` (44)
- `parseSource` (2)
- `parseSource` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 7.1% (161.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (106)

**Calls:**
- `runPlugins` (103)
- `runPlugins` (2)
- `runPlugins` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1538` | Self: 0.0% (0us) | Total: 0.7% (15.7ms) | Samples: 0

**Called by:**
- `isConsecutive` (10)

**Calls:**
- `_makeToken` (5)
- `_makeToken` (5)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1010` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `_nodeViewRaw` (2)

**Calls:**
- `source` (2)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:244` | Self: 0.0% (0us) | Total: 0.3% (8.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (6)

**Calls:**
- `get declarations` (2)
- `some` (2)
- `_nodesFromRange` (2)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `bound require` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3905` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `reportIfUnreachable` (1)

**Calls:**
- `_execReport` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7522` | Self: 0.0% (0us) | Total: 95.5% (2.14s) | Samples: 0

**Called by:**
- `async (anonymous)` (1310)
- `async (anonymous)` (103)

**Calls:**
- `walkNodes` (180)
- `walkNodes` (136)
- `walkNodes` (131)
- `walkNodes` (124)
- `walkNodes` (115)
- `walkNodes` (109)
- `walkNodes` (99)
- `walkNodes` (78)
- `walkNodes` (58)
- `walkNodes` (55)
- `walkNodes` (47)
- `walkNodes` (47)
- `walkNodes` (42)
- `walkNodes` (28)
- `walkNodes` (24)
- `walkNodes` (12)
- `walkNodes` (12)
- `walkNodes` (11)
- `walkNodes` (9)
- `walkNodes` (9)
- `walkNodes` (9)
- `walkNodes` (8)
- `walkNodes` (8)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
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

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `_encodeSource` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7038` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `invokeSelectorHandlers` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.2% (5.8ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4357` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `esquery` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.8% (2.23s) | Samples: 0

**Called by:**
- `(anonymous)` (1475)

**Calls:**
- `async (anonymous)` (1311)
- `async (anonymous)` (106)
- `async (anonymous)` (47)
- `async (anonymous)` (9)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.2% (4.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.2% (5.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7000` | Self: 0.0% (0us) | Total: 0.8% (18.5ms) | Samples: 0

**Called by:**
- `runPlugins` (12)

**Calls:**
- `getDFSEvents` (7)
- `getDFSEvents` (4)
- `getDFSEvents` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7521` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `buildVisitorMap` (2)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `decode` (1)

### `get nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4425` | Self: 0.0% (0us) | Total: 0.4% (10.9ms) | Samples: 0

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
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.8% (2.23s) | Samples: 0

**Called by:**
- `parseModule` (1475)

**Calls:**
- `async (anonymous)` (1475)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:147` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `TokenType` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6409` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildSelectorPlan` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6598` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `codepath` (1)
- `codepath` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 1.8% (40.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (9)
- `patchAstUtils` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `esquery` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `_getFfi` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `_getFfiSelector` (1)
- `(anonymous)` (1)
- `async (anonymous)` (1)

**Calls:**
- `require` (26)
- `anonymous` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 2.9% (66.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (44)

**Calls:**
- `parse` (44)

### `isConsecutive`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:88` | Self: 0.0% (0us) | Total: 0.7% (17.1ms) | Samples: 0

**Called by:**
- `reportIfUnreachable` (11)

**Calls:**
- `getTokenBefore` (10)
- `getTokenBefore` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1507` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isConsecutive` (1)

**Calls:**
- `_getFfi` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7517` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `get source` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:184` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7209` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `defineProperty` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7201` | Self: 0.0% (0us) | Total: 0.2% (4.6ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadBinding` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5449` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_getFfiSelector` (1)
- `_getFfiSelector` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1195` | Self: 0.0% (0us) | Total: 0.3% (8.1ms) | Samples: 0

**Called by:**
- `getTokenBefore` (5)

**Calls:**
- `_getJsxTextTokFlags` (3)
- `_getJsxTextTokFlags` (2)

### `_getFfi`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:71` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getTokenBefore` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7087` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `byteLength` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `get declarations`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2630` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `VariableDeclaration` (2)

**Calls:**
- `_nodesFromRange` (2)

### `dlopen`
`bun:ffi:351` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `FFIBuilder` (1)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `VariableDeclaration` (2)

**Calls:**
- `_nodeViewRaw` (2)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5218` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_runSelectorList` (1)

**Calls:**
- `(anonymous)` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 88.5% (1.98s) | Samples: 0

**Called by:**
- `async (anonymous)` (1311)

**Calls:**
- `runPlugins` (1310)
- `runPlugins` (1)

### `reportIfUnreachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js:171` | Self: 0.0% (0us) | Total: 0.7% (17.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (11)

**Calls:**
- `isConsecutive` (11)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `isAvailable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6970` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `has` (1)

### `codepath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4287` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `CfgCodePath` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 80.6% | 1.80s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 9.3% | 209.8ms | `[native code]` |
| 6.1% | 137.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unreachable.js` |
| 3.7% | 83.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | `bun:ffi` |
