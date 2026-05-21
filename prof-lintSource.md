# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 4.93s | 3261 | 1.0ms | 268 |

**Top 10:** `parse` 26.3%, `_buildScopeRefsAndThrough` 7.8%, `_identAt` 4.8%, `_buildScopeRefsAndThrough` 4.5%, `walkNodes` 4.4%, `_nodeViewRaw` 4.3%, `source` 3.4%, `_resolveUnicodeEscapes` 3.3%, `_nodeViewRaw` 3.0%, `get` 1.9%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 26.3% | 1.30s | 26.3% | 1.30s | `parse` | `[native code]` |
| 7.8% | 385.9ms | 8.2% | 405.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` |
| 4.8% | 241.0ms | 4.8% | 241.0ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` |
| 4.5% | 223.7ms | 4.7% | 235.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2569` |
| 4.4% | 219.5ms | 4.9% | 242.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` |
| 4.3% | 214.0ms | 4.3% | 214.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 3.4% | 169.3ms | 3.4% | 169.3ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 3.3% | 165.1ms | 3.3% | 165.1ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 3.0% | 152.9ms | 6.0% | 301.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` |
| 1.9% | 96.0ms | 1.9% | 96.0ms | `get` | `[native code]` |
| 1.4% | 73.6ms | 2.0% | 99.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 1.3% | 68.5ms | 1.3% | 68.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` |
| 1.2% | 61.5ms | 1.4% | 70.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 1.1% | 56.3ms | 6.7% | 331.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 1.1% | 55.3ms | 1.1% | 55.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.0% | 50.7ms | 1.0% | 50.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.0% | 49.6ms | 1.0% | 49.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 0.9% | 49.2ms | 0.9% | 49.2ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.8% | 43.4ms | 0.8% | 43.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.8% | 41.0ms | 0.8% | 41.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 0.7% | 38.8ms | 0.7% | 38.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.7% | 36.4ms | 0.7% | 36.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2444` |
| 0.7% | 36.4ms | 0.7% | 36.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.6% | 34.0ms | 3.2% | 162.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.6% | 32.3ms | 0.6% | 33.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.6% | 30.1ms | 0.6% | 30.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4015` |
| 0.6% | 29.7ms | 0.6% | 29.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2746` |
| 0.5% | 27.5ms | 0.5% | 27.5ms | `set` | `[native code]` |
| 0.5% | 26.6ms | 0.9% | 46.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.5% | 26.0ms | 1.6% | 79.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.5% | 25.0ms | 0.5% | 25.0ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 24.9ms | 11.2% | 555.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2465` |
| 0.4% | 22.7ms | 0.4% | 22.7ms | `push` | `[native code]` |
| 0.4% | 21.8ms | 0.4% | 21.8ms | `has` | `[native code]` |
| 0.4% | 21.6ms | 0.4% | 21.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 0.4% | 21.6ms | 0.4% | 21.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.4% | 21.3ms | 0.4% | 21.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.4% | 19.9ms | 11.4% | 566.9ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 0.3% | 19.0ms | 0.3% | 19.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.3% | 17.6ms | 0.3% | 17.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` |
| 0.3% | 17.0ms | 0.3% | 18.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.3% | 16.1ms | 3.8% | 189.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.3% | 15.7ms | 0.3% | 15.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.3% | 15.0ms | 0.3% | 15.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` |
| 0.2% | 14.7ms | 0.2% | 14.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.2% | 14.4ms | 0.2% | 14.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` |
| 0.2% | 13.9ms | 0.8% | 44.3ms | `anonymous` | `[native code]` |
| 0.2% | 12.5ms | 11.7% | 581.1ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:954` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` |
| 0.2% | 11.9ms | 6.0% | 299.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.2% | 11.9ms | 0.2% | 11.9ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2496` |
| 0.2% | 11.6ms | 9.4% | 464.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2495` |
| 0.2% | 11.4ms | 0.2% | 11.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4017` |
| 0.2% | 11.1ms | 0.2% | 11.1ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 11.1ms | 100.0% | 12.11s | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2531` |
| 0.2% | 10.6ms | 1.4% | 73.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.2% | 10.5ms | 0.2% | 10.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.2% | 10.0ms | 10.0% | 496.4ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` |
| 0.1% | 9.5ms | 0.1% | 9.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.1% | 9.4ms | 0.1% | 9.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.1% | 8.9ms | 6.5% | 323.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2533` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.1% | 8.8ms | 0.1% | 8.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4018` |
| 0.1% | 8.7ms | 0.1% | 8.7ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:907` |
| 0.1% | 8.5ms | 0.1% | 8.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.1% | 8.0ms | 0.1% | 8.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4014` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:866` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4016` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:902` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4020` |
| 0.1% | 7.5ms | 0.1% | 8.8ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.1% | 7.5ms | 0.1% | 7.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.1% | 7.2ms | 0.1% | 8.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2469` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` |
| 0.1% | 6.5ms | 0.5% | 28.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` |
| 0.1% | 6.4ms | 0.1% | 8.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `decode` | `[native code]` |
| 0.1% | 6.2ms | 1.3% | 68.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `encodeInto` | `[native code]` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4007` |
| 0.1% | 6.0ms | 0.1% | 7.6ms | `test` | `[native code]` |
| 0.1% | 6.0ms | 0.3% | 15.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.1% | 5.8ms | 0.6% | 31.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2578` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2523` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` |
| 0.0% | 4.6ms | 2.8% | 140.0ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.0% | 4.6ms | 0.2% | 10.4ms | `exec` | `[native code]` |
| 0.0% | 4.6ms | 0.7% | 38.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2030` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` |
| 0.0% | 3.4ms | 100.0% | 15.07s | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.0% | 3.1ms | 0.0% | 4.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` |
| 0.0% | 3.1ms | 7.2% | 357.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2537` |
| 0.0% | 3.1ms | 2.8% | 139.8ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.0% | 3.0ms | 6.1% | 305.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2568` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `/^\s*globals?\b/` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.0% | 2.8ms | 0.4% | 21.6ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.0% | 2.6ms | 3.4% | 170.3ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:748` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `fill` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `existsSync` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:795` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `slice` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:20` |
| 0.0% | 1.7ms | 0.2% | 12.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2530` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2019` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4048` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2433` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` |
| 0.0% | 1.6ms | 0.1% | 6.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5921` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4957` |
| 0.0% | 1.5ms | 6.1% | 305.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.1% | 9.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_samePluginSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4165` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4784` |
| 0.0% | 1.5ms | 0.1% | 5.4ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2573` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4773` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:584` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.0% | 1.4ms | 100.0% | 15.24s | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:956` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.4ms | 0.1% | 6.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2033` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4021` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2520` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2028` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `computeGlobals` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:300` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `max` | `[native code]` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:436` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 15.24s | 0.0% | 1.4ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:956` |
| 100.0% | 15.07s | 0.0% | 3.4ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` |
| 100.0% | 12.11s | 0.2% | 11.1ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2531` |
| 72.9% | 3.60s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 72.7% | 3.59s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7522` |
| 65.3% | 3.22s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:66` |
| 65.3% | 3.22s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 65.3% | 3.22s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` |
| 26.6% | 1.31s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 26.3% | 1.30s | 26.3% | 1.30s | `parse` | `[native code]` |
| 26.3% | 1.30s | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 11.7% | 581.1ms | 0.2% | 12.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:954` |
| 11.7% | 581.1ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2517` |
| 11.4% | 566.9ms | 0.4% | 19.9ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 11.2% | 555.4ms | 0.5% | 24.9ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2465` |
| 10.0% | 496.4ms | 0.2% | 10.0ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` |
| 9.4% | 464.7ms | 0.2% | 11.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2495` |
| 8.2% | 405.4ms | 7.8% | 385.9ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` |
| 7.2% | 357.0ms | 0.0% | 3.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 6.7% | 331.6ms | 1.1% | 56.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 6.5% | 323.7ms | 0.1% | 8.9ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2533` |
| 6.1% | 305.7ms | 0.0% | 3.0ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2568` |
| 6.1% | 305.6ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 6.0% | 301.0ms | 3.0% | 152.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` |
| 6.0% | 299.2ms | 0.2% | 11.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 4.9% | 242.9ms | 4.4% | 219.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` |
| 4.8% | 241.0ms | 4.8% | 241.0ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` |
| 4.7% | 235.5ms | 4.5% | 223.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2569` |
| 4.3% | 214.0ms | 4.3% | 214.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 3.8% | 189.1ms | 0.3% | 16.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 3.4% | 170.3ms | 0.0% | 2.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:748` |
| 3.4% | 169.3ms | 3.4% | 169.3ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 3.3% | 165.1ms | 3.3% | 165.1ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 3.2% | 162.4ms | 0.6% | 34.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 2.9% | 147.5ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` |
| 2.9% | 145.9ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 2.9% | 145.9ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 2.9% | 145.9ms | 0.0% | 0us | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:905` |
| 2.8% | 140.0ms | 0.0% | 4.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 2.8% | 139.8ms | 0.0% | 3.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 2.3% | 115.1ms | 0.0% | 0us | `name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` |
| 2.0% | 99.6ms | 1.4% | 73.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 1.9% | 96.0ms | 1.9% | 96.0ms | `get` | `[native code]` |
| 1.9% | 95.0ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 1.8% | 91.2ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 1.6% | 79.8ms | 0.5% | 26.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 1.5% | 77.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1683` |
| 1.4% | 73.6ms | 0.2% | 10.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 1.4% | 71.1ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` |
| 1.4% | 70.7ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 1.4% | 70.5ms | 1.2% | 61.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 1.3% | 68.5ms | 1.3% | 68.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` |
| 1.3% | 68.2ms | 0.1% | 6.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 1.1% | 55.3ms | 1.1% | 55.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.0% | 50.7ms | 1.0% | 50.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.0% | 49.6ms | 1.0% | 49.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 0.9% | 49.2ms | 0.9% | 49.2ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.9% | 46.5ms | 0.5% | 26.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.9% | 46.0ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.8% | 44.3ms | 0.2% | 13.9ms | `anonymous` | `[native code]` |
| 0.8% | 43.4ms | 0.8% | 43.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.8% | 41.0ms | 0.0% | 0us | `require` | `[native code]` |
| 0.8% | 41.0ms | 0.8% | 41.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 0.7% | 38.8ms | 0.7% | 38.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.7% | 38.4ms | 0.0% | 4.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.7% | 36.4ms | 0.7% | 36.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2444` |
| 0.7% | 36.4ms | 0.7% | 36.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.7% | 35.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.6% | 33.9ms | 0.6% | 32.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.6% | 31.0ms | 0.1% | 5.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.6% | 30.1ms | 0.6% | 30.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4015` |
| 0.6% | 29.7ms | 0.6% | 29.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2746` |
| 0.5% | 28.3ms | 0.1% | 6.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` |
| 0.5% | 27.5ms | 0.5% | 27.5ms | `set` | `[native code]` |
| 0.5% | 25.0ms | 0.5% | 25.0ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 23.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.4% | 22.7ms | 0.4% | 22.7ms | `push` | `[native code]` |
| 0.4% | 21.8ms | 0.4% | 21.8ms | `has` | `[native code]` |
| 0.4% | 21.6ms | 0.4% | 21.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 0.4% | 21.6ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.4% | 21.6ms | 0.0% | 2.8ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.4% | 21.6ms | 0.4% | 21.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.4% | 21.3ms | 0.4% | 21.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.4% | 21.0ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.3% | 19.0ms | 0.3% | 19.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.3% | 18.7ms | 0.3% | 17.0ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.3% | 17.6ms | 0.3% | 17.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` |
| 0.3% | 15.9ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.3% | 15.9ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.3% | 15.7ms | 0.3% | 15.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.3% | 15.4ms | 0.1% | 6.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.3% | 15.0ms | 0.3% | 15.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` |
| 0.2% | 14.7ms | 0.2% | 14.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.2% | 14.4ms | 0.2% | 14.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` |
| 0.2% | 13.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7000` |
| 0.2% | 12.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 0.2% | 12.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 0.2% | 12.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` |
| 0.2% | 12.5ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` |
| 0.2% | 11.9ms | 0.2% | 11.9ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2496` |
| 0.2% | 11.4ms | 0.2% | 11.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4017` |
| 0.2% | 11.1ms | 0.2% | 11.1ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 10.5ms | 0.2% | 10.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.2% | 10.4ms | 0.0% | 4.6ms | `exec` | `[native code]` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.1% | 9.5ms | 0.1% | 9.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.1% | 9.4ms | 0.0% | 1.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.1% | 9.4ms | 0.1% | 9.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 0.1% | 9.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.1% | 8.8ms | 0.1% | 8.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4018` |
| 0.1% | 8.8ms | 0.1% | 7.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.1% | 8.7ms | 0.1% | 8.7ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:907` |
| 0.1% | 8.5ms | 0.1% | 8.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.1% | 8.4ms | 0.1% | 7.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2469` |
| 0.1% | 8.0ms | 0.1% | 6.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.1% | 8.0ms | 0.1% | 8.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4014` |
| 0.1% | 7.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:866` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4016` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:902` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4020` |
| 0.1% | 7.6ms | 0.1% | 6.0ms | `test` | `[native code]` |
| 0.1% | 7.5ms | 0.1% | 7.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.1% | 7.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.1% | 6.8ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `decode` | `[native code]` |
| 0.1% | 6.3ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 0.1% | 6.3ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` |
| 0.1% | 6.2ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `encodeInto` | `[native code]` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4007` |
| 0.1% | 6.1ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.1% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.1% | 6.0ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.1% | 5.8ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.1% | 5.4ms | 0.0% | 1.5ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2578` |
| 0.1% | 4.9ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7514` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2523` |
| 0.0% | 4.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.0% | 4.4ms | 0.0% | 3.1ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` |
| 0.0% | 4.3ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.0% | 4.3ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2030` |
| 0.0% | 3.8ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.0% | 3.5ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2537` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.0% | 3.0ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5894` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `/^\s*globals?\b/` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.0% | 2.7ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `fill` | `[native code]` |
| 0.0% | 2.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7502` |
| 0.0% | 1.8ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.0% | 1.8ms | 0.0% | 0us | `existsSync` | `node:fs:273` |
| 0.0% | 1.8ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` |
| 0.0% | 1.8ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:77` |
| 0.0% | 1.8ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` |
| 0.0% | 1.8ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` |
| 0.0% | 1.8ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:43` |
| 0.0% | 1.8ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` |
| 0.0% | 1.8ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:85` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `existsSync` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:37` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:795` |
| 0.0% | 1.8ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1387` |
| 0.0% | 1.8ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `slice` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:20` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2530` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2019` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.0% | 1.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4048` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2433` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` |
| 0.0% | 1.6ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2606` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5921` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5900` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4957` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` |
| 0.0% | 1.6ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1333` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:20` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2536` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4784` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_samePluginSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4165` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5564` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2573` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4773` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:584` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2033` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4021` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7517` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2520` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2028` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.0% | 1.2ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` |
| 0.0% | 1.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.0% | 1.2ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.0% | 1.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1481` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.0% | 1.2ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:291` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `computeGlobals` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:300` |
| 0.0% | 1.2ms | 0.0% | 0us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:53` |
| 0.0% | 1.2ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `max` | `[native code]` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:436` |
| 0.0% | 1.0ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |

## Function Details

### `parse`
`[native code]` | Self: 26.3% (1.30s) | Total: 26.3% (1.30s) | Samples: 861

**Called by:**
- `parseSource` (861)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` | Self: 7.8% (385.9ms) | Total: 8.2% (405.4ms) | Samples: 256

**Called by:**
- `_ensureRefsThrough` (268)

**Calls:**
- `get` (12)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` | Self: 4.8% (241.0ms) | Total: 4.8% (241.0ms) | Samples: 160

**Called by:**
- `get name` (120)
- `name` (40)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2569` | Self: 4.5% (223.7ms) | Total: 4.7% (235.5ms) | Samples: 146

**Called by:**
- `_ensureRefsThrough` (154)

**Calls:**
- `get` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` | Self: 4.4% (219.5ms) | Total: 4.9% (242.9ms) | Samples: 146

**Called by:**
- `runPlugins` (161)

**Calls:**
- `get allSkipped` (8)
- `get allSkipped` (7)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` | Self: 4.3% (214.0ms) | Total: 4.3% (214.0ms) | Samples: 141

**Called by:**
- `get parent` (54)
- `_buildReference` (51)
- `nodeView` (27)
- `_buildScope` (9)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` | Self: 3.4% (169.3ms) | Total: 3.4% (169.3ms) | Samples: 111

**Called by:**
- `_identAt` (110)
- `get name` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 3.3% (165.1ms) | Total: 3.3% (165.1ms) | Samples: 111

**Called by:**
- `get name` (73)
- `name` (38)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` | Self: 3.0% (152.9ms) | Total: 6.0% (301.0ms) | Samples: 102

**Called by:**
- `_buildReference` (71)
- `get parent` (62)
- `nodeView` (58)
- `_buildScope` (7)
- `_nodesFromRange` (1)

**Calls:**
- `_computeNodeType` (36)
- `_computeNodeType` (34)
- `_computeNodeType` (25)
- `_computeNodeType` (2)

### `get`
`[native code]` | Self: 1.9% (96.0ms) | Total: 1.9% (96.0ms) | Samples: 63

**Called by:**
- `_ensureDeclSymIndex` (41)
- `_buildScopeRefsAndThrough` (12)
- `_buildScopeRefsAndThrough` (8)
- `_ensureDeclSymIndex` (1)
- `_buildScopeVarsAndSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 1.4% (73.6ms) | Total: 2.0% (99.6ms) | Samples: 47

**Called by:**
- `_buildScopeVarsAndSet` (64)

**Calls:**
- `set` (17)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` | Self: 1.3% (68.5ms) | Total: 1.3% (68.5ms) | Samples: 45

**Called by:**
- `_buildReference` (20)
- `get parent` (17)
- `nodeView` (4)
- `_nodesFromRange` (3)
- `_buildScope` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 1.2% (61.5ms) | Total: 1.4% (70.5ms) | Samples: 39

**Called by:**
- `_buildScopeRefsAndThrough` (26)
- `_buildScopeRefsAndThrough` (19)

**Calls:**
- `get parent` (5)
- `get parent` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` | Self: 1.1% (56.3ms) | Total: 6.7% (331.6ms) | Samples: 38

**Called by:**
- `_buildReference` (205)
- `_computeIsStrict` (8)
- `_buildReference` (5)
- `_computeIsStrict` (1)
- `_findDefNode` (1)

**Calls:**
- `_nodeViewRaw` (62)
- `_nodeViewRaw` (54)
- `_nodeViewRaw` (17)
- `nodeView` (11)
- `_nodeViewRaw` (11)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.1% (55.3ms) | Total: 1.1% (55.3ms) | Samples: 36

**Called by:**
- `_nodeViewRaw` (36)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 1.0% (50.7ms) | Total: 1.0% (50.7ms) | Samples: 34

**Called by:**
- `_nodeViewRaw` (34)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` | Self: 1.0% (49.6ms) | Total: 1.0% (49.6ms) | Samples: 33

**Called by:**
- `_precomputeScopes` (33)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.9% (49.2ms) | Total: 0.9% (49.2ms) | Samples: 32

**Called by:**
- `_buildScopeVarsAndSet` (28)
- `exec` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.8% (43.4ms) | Total: 0.8% (43.4ms) | Samples: 29

**Called by:**
- `_buildReference` (24)
- `_computeIsStrict` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` | Self: 0.8% (41.0ms) | Total: 0.8% (41.0ms) | Samples: 27

**Called by:**
- `runPlugins` (27)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` | Self: 0.7% (38.8ms) | Total: 0.7% (38.8ms) | Samples: 25

**Called by:**
- `_nodeViewRaw` (25)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2444` | Self: 0.7% (36.4ms) | Total: 0.7% (36.4ms) | Samples: 25

**Called by:**
- `_ensureRefsThrough` (25)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 0.7% (36.4ms) | Total: 0.7% (36.4ms) | Samples: 24

**Called by:**
- `_ensureVarsSet` (24)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.6% (34.0ms) | Total: 3.2% (162.4ms) | Samples: 23

**Called by:**
- `_buildScopeRefsAndThrough` (91)
- `_buildScopeRefsAndThrough` (17)
- `get references` (1)

**Calls:**
- `_buildScope` (46)
- `_buildScope` (17)
- `_buildScope` (9)
- `_buildScope` (9)
- `_buildScope` (3)
- `_buildScope` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.6% (32.3ms) | Total: 0.6% (33.9ms) | Samples: 22

**Called by:**
- `_ensureVarsSet` (23)

**Calls:**
- `get` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4015` | Self: 0.6% (30.1ms) | Total: 0.6% (30.1ms) | Samples: 20

**Called by:**
- `get parent` (11)
- `_buildReference` (6)
- `_buildScope` (2)
- `nodeView` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2746` | Self: 0.6% (29.7ms) | Total: 0.6% (29.7ms) | Samples: 19

**Called by:**
- `_buildReference` (19)

### `set`
`[native code]` | Self: 0.5% (27.5ms) | Total: 0.5% (27.5ms) | Samples: 18

**Called by:**
- `_ensureDeclSymIndex` (17)
- `_ensureDeclSymIndex` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` | Self: 0.5% (26.6ms) | Total: 0.9% (46.5ms) | Samples: 18

**Called by:**
- `_buildScopeVarsAndSet` (31)

**Calls:**
- `push` (13)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` | Self: 0.5% (26.0ms) | Total: 1.6% (79.8ms) | Samples: 17

**Called by:**
- `_ensureVarsSet` (52)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (28)
- `exec` (7)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.5% (25.0ms) | Total: 0.5% (25.0ms) | Samples: 17

**Called by:**
- `get name` (17)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2465` | Self: 0.5% (24.9ms) | Total: 11.2% (555.4ms) | Samples: 17

**Called by:**
- `_ensureRefsThrough` (366)

**Calls:**
- `_buildReference` (142)
- `_buildReference` (119)
- `_buildReference` (44)
- `_buildReference` (19)
- `_buildReference` (17)
- `_buildReference` (5)
- `_buildReference` (2)
- `_buildReference` (1)

### `push`
`[native code]` | Self: 0.4% (22.7ms) | Total: 0.4% (22.7ms) | Samples: 15

**Called by:**
- `_ensureDeclSymIndex` (13)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeRefsAndThrough` (1)

### `has`
`[native code]` | Self: 0.4% (21.8ms) | Total: 0.4% (21.8ms) | Samples: 14

**Called by:**
- `_ensureDeclSymIndex` (14)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` | Self: 0.4% (21.6ms) | Total: 0.4% (21.6ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` | Self: 0.4% (21.6ms) | Total: 0.4% (21.6ms) | Samples: 14

**Called by:**
- `_ensureVarsSet` (14)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 0.4% (21.3ms) | Total: 0.4% (21.3ms) | Samples: 14

**Called by:**
- `nodeView` (6)
- `_buildReference` (4)
- `get parent` (4)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.4% (19.9ms) | Total: 11.4% (566.9ms) | Samples: 13

**Called by:**
- `get` (372)
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `_buildScopeVarsAndSet` (196)
- `_buildScopeVarsAndSet` (52)
- `_buildScopeVarsAndSet` (24)
- `_buildScopeVarsAndSet` (23)
- `_buildScopeVarsAndSet` (21)
- `_buildScopeVarsAndSet` (14)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` | Self: 0.3% (19.0ms) | Total: 0.3% (19.0ms) | Samples: 13

**Called by:**
- `_buildScopeVarsAndSet` (13)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` | Self: 0.3% (17.6ms) | Total: 0.3% (17.6ms) | Samples: 13

**Called by:**
- `runPlugins` (13)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` | Self: 0.3% (17.0ms) | Total: 0.3% (18.7ms) | Samples: 11

**Called by:**
- `_symName` (12)

**Calls:**
- `slice` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.3% (16.1ms) | Total: 3.8% (189.1ms) | Samples: 11

**Called by:**
- `_buildScopeChildren` (69)
- `_buildScope` (39)
- `_buildReference` (17)
- `_precomputeScopes` (1)

**Calls:**
- `_computeIsStrict` (93)
- `_computeIsStrict` (14)
- `_computeIsStrict` (6)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` | Self: 0.3% (15.7ms) | Total: 0.3% (15.7ms) | Samples: 11

**Called by:**
- `_buildReference` (8)
- `get parent` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` | Self: 0.3% (15.0ms) | Total: 0.3% (15.0ms) | Samples: 10

**Called by:**
- `_buildReference` (7)
- `get parent` (2)
- `_nodesFromRange` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` | Self: 0.2% (14.7ms) | Total: 0.2% (14.7ms) | Samples: 10

**Called by:**
- `_buildScopeRefsAndThrough` (5)
- `_buildScopeRefsAndThrough` (3)
- `get references` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` | Self: 0.2% (14.4ms) | Total: 0.2% (14.4ms) | Samples: 10

**Called by:**
- `_buildReference` (9)
- `_buildScopeChildren` (1)

### `anonymous`
`[native code]` | Self: 0.2% (13.9ms) | Total: 0.8% (44.3ms) | Samples: 9

**Called by:**
- `require` (27)
- `bound require` (2)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:954` | Self: 0.2% (12.5ms) | Total: 11.7% (581.1ms) | Samples: 8

**Called by:**
- `_buildScopeRefsAndThrough` (382)

**Calls:**
- `_ensureVarsSet` (372)
- `_ensureVarsSet` (2)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` | Self: 0.2% (12.2ms) | Total: 0.2% (12.2ms) | Samples: 8

**Called by:**
- `walkNodes` (8)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.2% (11.9ms) | Total: 6.0% (299.2ms) | Samples: 8

**Called by:**
- `_ensureVarsSet` (196)

**Calls:**
- `_ensureDeclSymIndex` (64)
- `_ensureDeclSymIndex` (45)
- `_ensureDeclSymIndex` (31)
- `_ensureDeclSymIndex` (18)
- `_ensureDeclSymIndex` (13)
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2496` | Self: 0.2% (11.9ms) | Total: 0.2% (11.9ms) | Samples: 8

**Called by:**
- `_ensureRefsThrough` (8)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2495` | Self: 0.2% (11.6ms) | Total: 9.4% (464.7ms) | Samples: 8

**Called by:**
- `_ensureRefsThrough` (308)

**Calls:**
- `_buildReference` (94)
- `_buildReference` (91)
- `_buildReference` (80)
- `_buildReference` (26)
- `_buildReference` (4)
- `_buildReference` (3)
- `_buildReference` (1)
- `_buildReference` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4017` | Self: 0.2% (11.4ms) | Total: 0.2% (11.4ms) | Samples: 7

**Called by:**
- `_buildReference` (4)
- `get parent` (3)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (11.1ms) | Total: 0.2% (11.1ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2531` | Self: 0.2% (11.1ms) | Total: 100.0% (12.11s) | Samples: 7

**Called by:**
- `_ensureRefsThrough` (8023)

**Calls:**
- `get` (8015)
- `_ensureVarsSet` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.2% (10.6ms) | Total: 1.4% (73.6ms) | Samples: 7

**Called by:**
- `_buildScopeRefsAndThrough` (44)
- `_buildScopeRefsAndThrough` (4)

**Calls:**
- `_buildVariable` (19)
- `_buildVariable` (12)
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 0.2% (10.5ms) | Total: 0.2% (10.5ms) | Samples: 7

**Called by:**
- `_buildReference` (6)
- `get parent` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (10.1ms) | Total: 0.2% (10.1ms) | Samples: 7

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` | Self: 0.2% (10.1ms) | Total: 0.2% (10.1ms) | Samples: 7

**Called by:**
- `_buildReference` (3)
- `_buildScopeChildren` (3)
- `_buildScope` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` | Self: 0.2% (10.0ms) | Total: 10.0% (496.4ms) | Samples: 7

**Called by:**
- `_buildScopeRefsAndThrough` (169)
- `_buildScopeRefsAndThrough` (160)

**Calls:**
- `_identAt` (120)
- `_identAt` (112)
- `_resolveUnicodeEscapes` (73)
- `_identAt` (17)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` | Self: 0.1% (9.5ms) | Total: 0.1% (9.5ms) | Samples: 7

**Called by:**
- `_buildReference` (4)
- `_buildScopeVarsAndSet` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` | Self: 0.1% (9.4ms) | Total: 0.1% (9.4ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` | Self: 0.1% (8.9ms) | Total: 0.1% (8.9ms) | Samples: 6

**Called by:**
- `_ensureVarsSet` (6)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2533` | Self: 0.1% (8.9ms) | Total: 6.5% (323.7ms) | Samples: 6

**Called by:**
- `_ensureRefsThrough` (215)

**Calls:**
- `get name` (169)
- `name` (40)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` | Self: 0.1% (8.9ms) | Total: 0.1% (8.9ms) | Samples: 6

**Called by:**
- `_buildScopeChildren` (4)
- `_buildReference` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4018` | Self: 0.1% (8.8ms) | Total: 0.1% (8.8ms) | Samples: 6

**Called by:**
- `_buildReference` (3)
- `get parent` (3)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:907` | Self: 0.1% (8.7ms) | Total: 0.1% (8.7ms) | Samples: 6

**Called by:**
- `get` (6)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` | Self: 0.1% (8.5ms) | Total: 0.1% (8.5ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4014` | Self: 0.1% (8.0ms) | Total: 0.1% (8.0ms) | Samples: 5

**Called by:**
- `get parent` (4)
- `_buildReference` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:866` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `get body` (5)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` | Self: 0.1% (7.7ms) | Total: 0.1% (7.7ms) | Samples: 5

**Called by:**
- `_precomputeScopes` (5)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` | Self: 0.1% (7.7ms) | Total: 0.1% (7.7ms) | Samples: 5

**Called by:**
- `_buildReference` (3)
- `_buildScopeVarsAndSet` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4016` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `_buildReference` (5)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:902` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `get` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4020` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `_buildReference` (2)
- `get parent` (2)
- `_buildScope` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` | Self: 0.1% (7.5ms) | Total: 0.1% (8.8ms) | Samples: 5

**Called by:**
- `_buildScope` (6)

**Calls:**
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.1% (7.5ms) | Total: 0.1% (7.5ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `_buildReference` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `get parent` (3)
- `nodeView` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2469` | Self: 0.1% (7.2ms) | Total: 0.1% (8.4ms) | Samples: 5

**Called by:**
- `_ensureRefsThrough` (6)

**Calls:**
- `push` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` | Self: 0.1% (6.5ms) | Total: 0.1% (6.5ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` | Self: 0.1% (6.5ms) | Total: 0.5% (28.3ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (18)

**Calls:**
- `has` (14)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` | Self: 0.1% (6.4ms) | Total: 0.1% (8.0ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `set` (1)

### `decode`
`[native code]` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `get source` (4)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` | Self: 0.1% (6.2ms) | Total: 1.3% (68.2ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (45)

**Calls:**
- `get` (41)

### `encodeInto`
`[native code]` | Self: 0.1% (6.2ms) | Total: 0.1% (6.2ms) | Samples: 4

**Called by:**
- `_encodeSource` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4007` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `_buildScope` (1)

### `test`
`[native code]` | Self: 0.1% (6.0ms) | Total: 0.1% (7.6ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (3)
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `/^\s*globals?\b/` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` | Self: 0.1% (6.0ms) | Total: 0.3% (15.4ms) | Samples: 4

**Called by:**
- `getScope` (10)

**Calls:**
- `test` (3)
- `/^\s*exported\b/` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.1% (5.8ms) | Total: 0.6% (31.0ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (21)

**Calls:**
- `_buildVariable` (3)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2578` | Self: 0.1% (5.0ms) | Total: 0.1% (5.0ms) | Samples: 3

**Called by:**
- `_ensureRefsThrough` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_buildReference` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2523` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `_ensureRefsThrough` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `_buildReference` (3)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.0% (4.6ms) | Total: 2.8% (140.0ms) | Samples: 3

**Called by:**
- `_ensureChildren` (93)

**Calls:**
- `_buildScope` (69)
- `_buildScope` (12)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)

### `exec`
`[native code]` | Self: 0.0% (4.6ms) | Total: 0.2% (10.4ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (7)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.0% (4.6ms) | Total: 0.7% (38.4ms) | Samples: 3

**Called by:**
- `_buildScopeChildren` (12)
- `_buildReference` (9)
- `_buildScope` (4)

**Calls:**
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `_ensureChildren` (3)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `_buildScopeRefsAndThrough` (3)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2030` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` | Self: 0.0% (3.4ms) | Total: 100.0% (15.07s) | Samples: 2

**Called by:**
- `get` (9977)

**Calls:**
- `_buildScopeRefsAndThrough` (8023)
- `_buildScopeRefsAndThrough` (382)
- `_buildScopeRefsAndThrough` (366)
- `_buildScopeRefsAndThrough` (308)
- `_buildScopeRefsAndThrough` (268)
- `_buildScopeRefsAndThrough` (215)
- `_buildScopeRefsAndThrough` (204)
- `_buildScopeRefsAndThrough` (154)
- `_buildScopeRefsAndThrough` (25)
- `_buildScopeRefsAndThrough` (8)
- `_buildScopeRefsAndThrough` (6)
- `_buildScopeRefsAndThrough` (3)
- `_buildScopeRefsAndThrough` (3)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `_buildScope` (1)
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` | Self: 0.0% (3.1ms) | Total: 0.0% (4.4ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `get` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (2)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_ensureRefsThrough` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.0% (3.1ms) | Total: 7.2% (357.0ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (142)
- `_buildScopeRefsAndThrough` (94)
- `get references` (1)

**Calls:**
- `get parent` (205)
- `get parent` (24)
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2537` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_ensureRefsThrough` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.0% (3.1ms) | Total: 2.8% (139.8ms) | Samples: 2

**Called by:**
- `_buildScope` (93)

**Calls:**
- `get body` (51)
- `get body` (24)
- `get body` (16)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2568` | Self: 0.0% (3.0ms) | Total: 6.1% (305.7ms) | Samples: 2

**Called by:**
- `_ensureRefsThrough` (204)

**Calls:**
- `get name` (160)
- `name` (38)
- `get name` (3)
- `get name` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `test` (1)
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` | Self: 0.0% (2.8ms) | Total: 0.4% (21.6ms) | Samples: 2

**Called by:**
- `_buildVariable` (14)

**Calls:**
- `_buildSymNameCache` (12)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:748` | Self: 0.0% (2.6ms) | Total: 3.4% (170.3ms) | Samples: 2

**Called by:**
- `get name` (112)

**Calls:**
- `source` (110)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `_buildReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (1)
- `_buildReference` (1)

### `fill`
`[native code]` | Self: 0.0% (2.4ms) | Total: 0.0% (2.4ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `existsSync`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `existsSync` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:795` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `slice`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:20` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parseModule` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` | Self: 0.0% (1.7ms) | Total: 0.2% (12.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (8)

**Calls:**
- `get references` (5)
- `get references` (1)
- `push` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2530` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2019` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4048` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2433` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` | Self: 0.0% (1.6ms) | Total: 0.1% (6.1ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (4)

**Calls:**
- `test` (2)
- `/^\s*globals?\b/` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5921` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4957` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (1.5ms) | Total: 6.1% (305.6ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (119)
- `_buildScopeRefsAndThrough` (80)
- `get references` (1)

**Calls:**
- `_nodeViewRaw` (71)
- `_nodeViewRaw` (51)
- `_nodeViewRaw` (20)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (6)
- `nodeView` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (1.5ms) | Total: 0.1% (9.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (5)
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `_buildReference` (2)
- `_buildReference` (1)
- `_buildReference` (1)
- `_buildReference` (1)

### `_samePluginSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4165` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4784` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (1.5ms) | Total: 0.1% (5.4ms) | Samples: 1

**Called by:**
- `identifiers` (3)
- `get identifiers` (1)

**Calls:**
- `_computeVarDefs` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2573` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4773` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:584` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:956` | Self: 0.0% (1.4ms) | Total: 100.0% (15.24s) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (8015)
- `Program:exit` (2071)

**Calls:**
- `_ensureRefsThrough` (9977)
- `_ensureRefsThrough` (97)
- `_ensureRefsThrough` (6)
- `_ensureRefsThrough` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (1.4ms) | Total: 0.1% (6.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (5)

**Calls:**
- `identifiers` (3)
- `get identifiers` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2033` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4021` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2520` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2028` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `computeGlobals`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:300` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `max`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `ensureBufferBytes` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:436` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5894` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (2)

**Calls:**
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 72.9% (3.60s) | Samples: 0

**Calls:**
- `runPlugins` (2373)
- `runPlugins` (3)
- `runPlugins` (2)
- `runPlugins` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2536` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (1)

**Calls:**
- `get references` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `ensureBufferBytes` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 26.6% (1.31s) | Samples: 0

**Calls:**
- `parseSource` (861)
- `parseSource` (5)
- `parseSource` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:66` | Self: 0.0% (0us) | Total: 65.3% (3.22s) | Samples: 0

**Called by:**
- `_invokeFused` (2131)

**Calls:**
- `get` (2071)
- `getScope` (60)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `bound require` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `defs` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` | Self: 0.0% (0us) | Total: 0.4% (21.6ms) | Samples: 0

**Called by:**
- `_buildReference` (12)
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (14)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.7% (35.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (24)

**Calls:**
- `nodeView` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:85` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` | Self: 0.0% (0us) | Total: 65.3% (3.22s) | Samples: 0

**Called by:**
- `runPlugins` (2131)

**Calls:**
- `_invokeFused` (2131)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` | Self: 0.0% (0us) | Total: 65.3% (3.22s) | Samples: 0

**Called by:**
- `walkNodes` (2131)

**Calls:**
- `Program:exit` (2131)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_extractFileLevelRules` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2606` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `_buildScope` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:77` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7517` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `get source` (1)

### `existsSync`
`node:fs:273` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)

**Calls:**
- `existsSync` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` | Self: 0.0% (0us) | Total: 1.4% (71.1ms) | Samples: 0

**Called by:**
- `get body` (46)
- `get value` (1)

**Calls:**
- `nodeView` (42)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_findDefNode` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (0us) | Total: 1.4% (70.7ms) | Samples: 0

**Called by:**
- `getScope` (47)

**Calls:**
- `commentsInRange` (33)
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (3)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 0.2% (12.5ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `async (anonymous)` (8)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.1% (7.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `_encodeSource` (4)
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` | Self: 0.0% (0us) | Total: 0.1% (7.8ms) | Samples: 0

**Called by:**
- `runPlugins` (5)

**Calls:**
- `_getOrBuildPlan` (4)
- `_getOrBuildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 0.2% (12.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `async (anonymous)` (8)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `defs` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` | Self: 0.0% (0us) | Total: 2.9% (147.5ms) | Samples: 0

**Called by:**
- `_nodesFromRange` (42)
- `get body` (24)
- `get body` (16)
- `get parent` (11)
- `_buildReference` (5)

**Calls:**
- `_nodeViewRaw` (58)
- `_nodeViewRaw` (27)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `parseSource` (4)

**Calls:**
- `encodeInto` (4)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1387` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `_rawTokenText` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)

**Calls:**
- `existsSync` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `runPlugins` (3)
- `runPlugins` (1)

**Calls:**
- `decode` (4)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (41.0ms) | Samples: 0

**Called by:**
- `bound require` (27)

**Calls:**
- `anonymous` (27)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2517` | Self: 0.0% (0us) | Total: 11.7% (581.1ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (382)

**Calls:**
- `get` (382)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.3% (15.9ms) | Samples: 0

**Calls:**
- `parseModule` (10)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_encodeSource` (1)

**Calls:**
- `max` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 1.8% (91.2ms) | Samples: 0

**Called by:**
- `Program:exit` (60)

**Calls:**
- `_precomputeScopes` (47)
- `_precomputeScopes` (10)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 2.9% (145.9ms) | Samples: 0

**Called by:**
- `get` (97)

**Calls:**
- `_buildScopeChildren` (93)
- `_buildScopeChildren` (3)
- `_buildScopeChildren` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1481` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `_nodesFromRange` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.9% (46.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (8)
- `(anonymous)` (6)
- `patchAstUtils` (4)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `loadCoreRules` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (27)
- `anonymous` (2)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 26.3% (1.30s) | Samples: 0

**Called by:**
- `_lintSourceOne` (861)

**Calls:**
- `parse` (861)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7502` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `fill` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7522` | Self: 0.0% (0us) | Total: 72.7% (3.59s) | Samples: 0

**Called by:**
- `_lintSourceOne` (2373)

**Calls:**
- `walkNodes` (2131)
- `walkNodes` (161)
- `walkNodes` (27)
- `walkNodes` (14)
- `walkNodes` (13)
- `walkNodes` (8)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.1% (9.3ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1683` | Self: 0.0% (0us) | Total: 1.5% (77.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (51)

**Calls:**
- `_nodesFromRange` (46)
- `_nodesFromRange` (5)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get value` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:291` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Calls:**
- `computeGlobals` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (0us) | Total: 1.9% (95.0ms) | Samples: 0

**Called by:**
- `_buildReference` (46)
- `_buildScope` (16)

**Calls:**
- `_buildScope` (39)
- `_buildScope` (16)
- `_buildScope` (4)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `walkNodes` (4)

**Calls:**
- `_buildPlan` (2)
- `_buildPlan` (1)
- `_buildPlan` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (0us) | Total: 0.4% (23.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (16)

**Calls:**
- `nodeView` (16)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5564` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_samePluginSet` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` | Self: 0.0% (0us) | Total: 0.2% (12.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` | Self: 0.0% (0us) | Total: 2.3% (115.1ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (40)
- `_buildScopeRefsAndThrough` (38)

**Calls:**
- `_identAt` (40)
- `_resolveUnicodeEscapes` (38)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 2.9% (145.9ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (97)

**Calls:**
- `_ensureChildren` (97)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.3% (15.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)

**Calls:**
- `(anonymous)` (8)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 0.0% (3.8ms) | Samples: 0

**Called by:**
- `defs` (3)

**Calls:**
- `_findDefNode` (2)
- `_findDefNode` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.0% (0us) | Total: 0.4% (21.0ms) | Samples: 0

**Called by:**
- `_buildScope` (14)

**Calls:**
- `get parent` (8)
- `get parent` (5)
- `get parent` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1333` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `source` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5900` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_buildTemplate` (1)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:905` | Self: 0.0% (0us) | Total: 2.9% (145.9ms) | Samples: 0

**Called by:**
- `get` (97)

**Calls:**
- `get` (97)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (3)

**Calls:**
- `_findLineIdx` (3)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7000` | Self: 0.0% (0us) | Total: 0.2% (13.1ms) | Samples: 0

**Called by:**
- `runPlugins` (8)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (2)
- `getDFSEvents` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7514` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `get source` (3)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 36.1% | 1.78s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 31.9% | 1.57s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 31.8% | 1.57s | `[native code]` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
