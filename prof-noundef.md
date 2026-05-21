# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 637.5ms | 418 | 1.0ms | 172 |

**Top 10:** `walkNodes` 22.4%, `parse` 10.6%, `walkNodes` 9.3%, `commentsInRange` 7.5%, `get allSkipped` 6.4%, `get` 2.4%, `_nodeViewRaw` 2.2%, `_findLineIdx` 1.8%, `source` 1.8%, `_nodeViewRaw` 1.7%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 22.4% | 143.1ms | 29.6% | 188.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` |
| 10.6% | 68.1ms | 10.6% | 68.1ms | `parse` | `[native code]` |
| 9.3% | 59.6ms | 9.3% | 59.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 7.5% | 47.9ms | 7.5% | 47.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 6.4% | 40.9ms | 6.4% | 40.9ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` |
| 2.4% | 15.7ms | 2.4% | 15.7ms | `get` | `[native code]` |
| 2.2% | 14.4ms | 2.2% | 14.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 1.8% | 12.0ms | 1.8% | 12.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 1.8% | 11.9ms | 1.8% | 11.9ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 1.7% | 10.9ms | 2.2% | 14.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` |
| 1.6% | 10.6ms | 5.8% | 37.5ms | `anonymous` | `[native code]` |
| 1.4% | 8.9ms | 1.4% | 8.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` |
| 1.1% | 7.5ms | 1.1% | 7.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 1.1% | 7.2ms | 1.1% | 7.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 1.1% | 7.0ms | 1.1% | 7.0ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` |
| 0.9% | 6.2ms | 0.9% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` |
| 0.8% | 5.5ms | 0.8% | 5.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.7% | 4.8ms | 100.0% | 695.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2531` |
| 0.7% | 4.7ms | 0.7% | 4.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.7% | 4.7ms | 0.7% | 4.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` |
| 0.7% | 4.7ms | 0.7% | 4.7ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.7% | 4.6ms | 0.7% | 4.6ms | `push` | `[native code]` |
| 0.7% | 4.5ms | 0.7% | 4.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2496` |
| 0.6% | 4.3ms | 0.6% | 4.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.6% | 4.2ms | 0.6% | 4.2ms | `/^\s*exported\b/` | `[native code]` |
| 0.6% | 4.0ms | 0.6% | 4.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 0.5% | 3.5ms | 1.4% | 9.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.5% | 3.3ms | 0.5% | 3.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.5% | 3.2ms | 0.5% | 3.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:583` |
| 0.5% | 3.2ms | 0.5% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 3.1ms | 5.0% | 32.4ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:954` |
| 0.4% | 2.8ms | 0.4% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 0.4% | 2.7ms | 0.4% | 2.7ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.4% | 2.7ms | 0.6% | 4.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2569` |
| 0.4% | 2.6ms | 0.4% | 2.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.4% | 2.6ms | 0.4% | 2.6ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.2% | 1.7ms | 2.1% | 13.7ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:748` |
| 0.2% | 1.7ms | 0.6% | 4.3ms | `test` | `[native code]` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4049` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 1.7ms | 13.2% | 84.3ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4015` |
| 0.2% | 1.7ms | 0.7% | 4.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.2% | 1.6ms | 2.2% | 14.0ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` |
| 0.2% | 1.6ms | 1.5% | 9.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `asyncWrap` | `node:fs/promises` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:752` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4048` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.2% | 1.6ms | 100.0% | 847.5ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2869` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:902` |
| 0.2% | 1.5ms | 4.1% | 26.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `has` | `[native code]` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2493` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3003` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` |
| 0.2% | 1.4ms | 2.4% | 15.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2568` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1310` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` |
| 0.2% | 1.3ms | 3.0% | 19.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2533` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 0.2% | 1.3ms | 3.3% | 21.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.2% | 1.2ms | 0.2% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.1% | 1.2ms | 0.3% | 2.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 865.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:956` |
| 100.0% | 847.5ms | 0.2% | 1.6ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` |
| 100.0% | 695.6ms | 0.7% | 4.8ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2531` |
| 100.0% | 637.4ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 100.0% | 637.4ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 99.4% | 634.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.4% | 634.0ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 85.9% | 548.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7522` |
| 52.2% | 333.2ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 41.0% | 261.8ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 41.0% | 261.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` |
| 40.5% | 258.6ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:66` |
| 33.9% | 216.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 29.6% | 188.9ms | 22.4% | 143.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` |
| 13.2% | 84.3ms | 0.2% | 1.7ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 11.1% | 70.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 10.9% | 69.8ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 10.6% | 68.1ms | 10.6% | 68.1ms | `parse` | `[native code]` |
| 10.6% | 68.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 9.3% | 59.6ms | 9.3% | 59.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 7.5% | 47.9ms | 7.5% | 47.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 6.4% | 40.9ms | 6.4% | 40.9ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` |
| 5.8% | 37.5ms | 1.6% | 10.6ms | `anonymous` | `[native code]` |
| 5.6% | 35.8ms | 0.0% | 0us | `bound require` | `[native code]` |
| 5.0% | 32.4ms | 0.4% | 3.1ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:954` |
| 5.0% | 32.4ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2517` |
| 4.8% | 31.0ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2495` |
| 4.8% | 30.7ms | 0.0% | 0us | `require` | `[native code]` |
| 4.5% | 28.7ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` |
| 4.1% | 26.4ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 4.1% | 26.3ms | 0.2% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` |
| 3.8% | 24.3ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2465` |
| 3.8% | 24.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 3.3% | 21.2ms | 0.2% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 3.0% | 19.2ms | 0.2% | 1.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2533` |
| 2.5% | 15.9ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 2.5% | 15.9ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 2.5% | 15.9ms | 0.0% | 0us | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:905` |
| 2.4% | 15.7ms | 2.4% | 15.7ms | `get` | `[native code]` |
| 2.4% | 15.7ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 2.4% | 15.6ms | 0.2% | 1.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2568` |
| 2.2% | 14.4ms | 2.2% | 14.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 2.2% | 14.3ms | 1.7% | 10.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` |
| 2.2% | 14.3ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 2.2% | 14.0ms | 0.2% | 1.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` |
| 2.1% | 13.7ms | 0.2% | 1.7ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:748` |
| 1.8% | 12.0ms | 1.8% | 12.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 1.8% | 11.9ms | 1.8% | 11.9ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 1.5% | 9.8ms | 0.2% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 1.4% | 9.5ms | 0.5% | 3.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 1.4% | 9.5ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 1.4% | 9.5ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 1.4% | 9.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 1.4% | 8.9ms | 1.4% | 8.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` |
| 1.4% | 8.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7000` |
| 1.3% | 8.9ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 1.1% | 7.5ms | 1.1% | 7.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 1.1% | 7.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 1.1% | 7.2ms | 1.1% | 7.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 1.1% | 7.0ms | 1.1% | 7.0ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` |
| 1.0% | 6.6ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.9% | 6.2ms | 0.9% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` |
| 0.9% | 6.0ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.9% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.8% | 5.5ms | 0.8% | 5.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.7% | 4.7ms | 0.7% | 4.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.7% | 4.7ms | 0.7% | 4.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` |
| 0.7% | 4.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.7% | 4.7ms | 0.7% | 4.7ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.7% | 4.6ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` |
| 0.7% | 4.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1683` |
| 0.7% | 4.6ms | 0.7% | 4.6ms | `push` | `[native code]` |
| 0.7% | 4.5ms | 0.7% | 4.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2496` |
| 0.7% | 4.5ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.7% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.7% | 4.4ms | 0.2% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.6% | 4.3ms | 0.2% | 1.7ms | `test` | `[native code]` |
| 0.6% | 4.3ms | 0.4% | 2.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2569` |
| 0.6% | 4.3ms | 0.6% | 4.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.6% | 4.2ms | 0.6% | 4.2ms | `/^\s*exported\b/` | `[native code]` |
| 0.6% | 4.0ms | 0.6% | 4.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 0.5% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.5% | 3.3ms | 0.5% | 3.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.5% | 3.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.5% | 3.2ms | 0.5% | 3.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:583` |
| 0.5% | 3.2ms | 0.5% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.5% | 3.2ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.5% | 3.2ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:68` |
| 0.4% | 2.8ms | 0.4% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 0.4% | 2.8ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.4% | 2.7ms | 0.4% | 2.7ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.4% | 2.7ms | 0.0% | 0us | `exec` | `[native code]` |
| 0.4% | 2.6ms | 0.4% | 2.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.4% | 2.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.4% | 2.6ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` |
| 0.4% | 2.6ms | 0.4% | 2.6ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` |
| 0.3% | 2.5ms | 0.1% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.2% | 1.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4049` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 1.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7233` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 1.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.2% | 1.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4015` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `asyncWrap` | `node:fs/promises` |
| 0.2% | 1.6ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:70` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:752` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4048` |
| 0.2% | 1.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2869` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:902` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.2% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.2% | 1.5ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:50` |
| 0.2% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `has` | `[native code]` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2493` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` |
| 0.2% | 1.5ms | 0.2% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.2% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.2% | 1.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1702` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 1.4ms | 0.0% | 0us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3963` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7517` |
| 0.2% | 1.4ms | 0.0% | 0us | `SourceCode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1002` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 0.2% | 1.4ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3003` |
| 0.2% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.2% | 1.4ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2469` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` |
| 0.2% | 1.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.2% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.2% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1310` |
| 0.2% | 1.4ms | 0.0% | 0us | `hasTypeOfOperator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:19` |
| 0.2% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:71` |
| 0.2% | 1.4ms | 0.2% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 0.2% | 1.3ms | 0.2% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.2% | 1.2ms | 0.2% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.1% | 1.2ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.1% | 1.2ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |

## Function Details

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` | Self: 22.4% (143.1ms) | Total: 29.6% (188.9ms) | Samples: 95

**Called by:**
- `runPlugins` (125)

**Calls:**
- `get allSkipped` (27)
- `get allSkipped` (3)

### `parse`
`[native code]` | Self: 10.6% (68.1ms) | Total: 10.6% (68.1ms) | Samples: 45

**Called by:**
- `parseSource` (45)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` | Self: 9.3% (59.6ms) | Total: 9.3% (59.6ms) | Samples: 39

**Called by:**
- `runPlugins` (39)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` | Self: 7.5% (47.9ms) | Total: 7.5% (47.9ms) | Samples: 32

**Called by:**
- `_precomputeScopes` (32)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` | Self: 6.4% (40.9ms) | Total: 6.4% (40.9ms) | Samples: 27

**Called by:**
- `walkNodes` (27)

### `get`
`[native code]` | Self: 2.4% (15.7ms) | Total: 2.4% (15.7ms) | Samples: 10

**Called by:**
- `_buildScopeRefsAndThrough` (8)
- `_buildScopeRefsAndThrough` (1)
- `_ensureDeclSymIndex` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 2.2% (14.4ms) | Total: 2.2% (14.4ms) | Samples: 9

**Called by:**
- `nodeView` (4)
- `_buildReference` (3)
- `get body` (1)
- `_nodesFromRange` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` | Self: 1.8% (12.0ms) | Total: 1.8% (12.0ms) | Samples: 8

**Called by:**
- `commentsInRange` (6)
- `commentsInRange` (2)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` | Self: 1.8% (11.9ms) | Total: 1.8% (11.9ms) | Samples: 8

**Called by:**
- `_identAt` (8)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` | Self: 1.7% (10.9ms) | Total: 2.2% (14.3ms) | Samples: 7

**Called by:**
- `nodeView` (7)
- `_buildScope` (2)

**Calls:**
- `_computeNodeType` (1)
- `_computeNodeType` (1)

### `anonymous`
`[native code]` | Self: 1.6% (10.6ms) | Total: 5.8% (37.5ms) | Samples: 7

**Called by:**
- `require` (20)
- `bound require` (3)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs/promises` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` | Self: 1.4% (8.9ms) | Total: 1.4% (8.9ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` | Self: 1.1% (7.5ms) | Total: 1.1% (7.5ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 1.1% (7.2ms) | Total: 1.1% (7.2ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` | Self: 1.1% (7.0ms) | Total: 1.1% (7.0ms) | Samples: 5

**Called by:**
- `get name` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` | Self: 0.9% (6.2ms) | Total: 0.9% (6.2ms) | Samples: 4

**Called by:**
- `nodeView` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` | Self: 0.8% (5.5ms) | Total: 0.8% (5.5ms) | Samples: 4

**Called by:**
- `get parent` (2)
- `_buildScope` (1)
- `nodeView` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2531` | Self: 0.7% (4.8ms) | Total: 100.0% (695.6ms) | Samples: 3

**Called by:**
- `_ensureRefsThrough` (455)

**Calls:**
- `get` (452)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.7% (4.7ms) | Total: 0.7% (4.7ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` | Self: 0.7% (4.7ms) | Total: 0.7% (4.7ms) | Samples: 3

**Called by:**
- `_buildScopeRefsAndThrough` (3)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.7% (4.7ms) | Total: 0.7% (4.7ms) | Samples: 3

**Called by:**
- `get name` (3)

### `push`
`[native code]` | Self: 0.7% (4.6ms) | Total: 0.7% (4.6ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `_buildScopeRefsAndThrough` (1)
- `_nodesFromRange` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2496` | Self: 0.7% (4.5ms) | Total: 0.7% (4.5ms) | Samples: 3

**Called by:**
- `_ensureRefsThrough` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.6% (4.3ms) | Total: 0.6% (4.3ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (3)

### `/^\s*exported\b/`
`[native code]` | Self: 0.6% (4.2ms) | Total: 0.6% (4.2ms) | Samples: 3

**Called by:**
- `test` (2)
- `_precomputeScopes` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 0.6% (4.0ms) | Total: 0.6% (4.0ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` | Self: 0.5% (3.5ms) | Total: 1.4% (9.5ms) | Samples: 2

**Called by:**
- `getScope` (6)

**Calls:**
- `test` (3)
- `/^\s*exported\b/` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` | Self: 0.5% (3.3ms) | Total: 0.5% (3.3ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:583` | Self: 0.5% (3.2ms) | Total: 0.5% (3.2ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.5% (3.2ms) | Total: 0.5% (3.2ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:954` | Self: 0.4% (3.1ms) | Total: 5.0% (32.4ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (22)

**Calls:**
- `_ensureVarsSet` (18)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` | Self: 0.4% (2.8ms) | Total: 0.4% (2.8ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.4% (2.7ms) | Total: 0.4% (2.7ms) | Samples: 2

**Called by:**
- `exec` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2569` | Self: 0.4% (2.7ms) | Total: 0.6% (4.3ms) | Samples: 2

**Called by:**
- `_ensureRefsThrough` (3)

**Calls:**
- `get` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 0.4% (2.6ms) | Total: 0.4% (2.6ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` | Self: 0.4% (2.6ms) | Total: 0.4% (2.6ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:748` | Self: 0.2% (1.7ms) | Total: 2.1% (13.7ms) | Samples: 1

**Called by:**
- `get name` (9)

**Calls:**
- `source` (8)

### `test`
`[native code]` | Self: 0.2% (1.7ms) | Total: 0.6% (4.3ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (3)

**Calls:**
- `/^\s*exported\b/` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4049` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.2% (1.7ms) | Total: 13.2% (84.3ms) | Samples: 1

**Called by:**
- `Program:exit` (55)

**Calls:**
- `_precomputeScopes` (46)
- `_precomputeScopes` (6)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4015` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` | Self: 0.2% (1.7ms) | Total: 0.7% (4.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `exec` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` | Self: 0.2% (1.6ms) | Total: 2.2% (14.0ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (9)

**Calls:**
- `get` (8)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.2% (1.6ms) | Total: 1.5% (9.8ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (5)
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)

### `asyncWrap`
`node:fs/promises` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `node:fs/promises` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:752` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `get name` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4048` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` | Self: 0.2% (1.6ms) | Total: 100.0% (847.5ms) | Samples: 1

**Called by:**
- `get` (555)

**Calls:**
- `_buildScopeRefsAndThrough` (455)
- `_buildScopeRefsAndThrough` (22)
- `_buildScopeRefsAndThrough` (20)
- `_buildScopeRefsAndThrough` (16)
- `_buildScopeRefsAndThrough` (13)
- `_buildScopeRefsAndThrough` (10)
- `_buildScopeRefsAndThrough` (9)
- `_buildScopeRefsAndThrough` (3)
- `_buildScopeRefsAndThrough` (3)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2869` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:902` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `get` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` | Self: 0.2% (1.5ms) | Total: 4.1% (26.3ms) | Samples: 1

**Called by:**
- `get parent` (10)
- `_buildReference` (7)

**Calls:**
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (1.5ms) | Total: 0.2% (1.5ms) | Samples: 1

**Called by:**
- `get name` (1)

### `has`
`[native code]` | Self: 0.2% (1.5ms) | Total: 0.2% (1.5ms) | Samples: 1

**Called by:**
- `loadCoreRules` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2493` | Self: 0.2% (1.5ms) | Total: 0.2% (1.5ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` | Self: 0.2% (1.5ms) | Total: 0.2% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` | Self: 0.2% (1.5ms) | Total: 0.2% (1.5ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` | Self: 0.2% (1.5ms) | Total: 0.2% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `get body` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `_nodesFromRange` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `SourceCode` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3003` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2568` | Self: 0.2% (1.4ms) | Total: 2.4% (15.6ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (10)

**Calls:**
- `get name` (6)
- `get name` (3)

### `get operator`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1310` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `hasTypeOfOperator` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` | Self: 0.2% (1.4ms) | Total: 0.2% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` | Self: 0.2% (1.3ms) | Total: 0.2% (1.3ms) | Samples: 1

**Called by:**
- `get` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (1.3ms) | Total: 0.2% (1.3ms) | Samples: 1

**Called by:**
- `get` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` | Self: 0.2% (1.3ms) | Total: 0.2% (1.3ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2533` | Self: 0.2% (1.3ms) | Total: 3.0% (19.2ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (13)

**Calls:**
- `get name` (12)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` | Self: 0.2% (1.3ms) | Total: 0.2% (1.3ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` | Self: 0.2% (1.3ms) | Total: 0.2% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` | Self: 0.2% (1.3ms) | Total: 3.3% (21.2ms) | Samples: 1

**Called by:**
- `_buildReference` (14)

**Calls:**
- `nodeView` (10)
- `_nodeViewRaw` (2)
- `nodeView` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` | Self: 0.2% (1.3ms) | Total: 0.2% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 0.2% (1.2ms) | Total: 0.2% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` | Self: 0.1% (1.2ms) | Total: 0.3% (2.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:50` | Self: 0.0% (0us) | Total: 0.2% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `has` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7233` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_fireCfgEvents` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (0us) | Total: 10.9% (69.8ms) | Samples: 0

**Called by:**
- `getScope` (46)

**Calls:**
- `commentsInRange` (32)
- `commentsInRange` (6)
- `commentsInRange` (3)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2517` | Self: 0.0% (0us) | Total: 5.0% (32.4ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (22)

**Calls:**
- `get` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.9% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (637.4ms) | Samples: 0

**Calls:**
- `parseModule` (418)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 4.8% (30.7ms) | Samples: 0

**Called by:**
- `bound require` (20)

**Calls:**
- `anonymous` (20)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.4% (634.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (416)

**Calls:**
- `async (anonymous)` (220)
- `async (anonymous)` (141)
- `async (anonymous)` (46)
- `async (anonymous)` (6)
- `async (anonymous)` (1)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` | Self: 0.0% (0us) | Total: 0.4% (2.6ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.4% (2.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `AstView` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2465` | Self: 0.0% (0us) | Total: 3.8% (24.3ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (16)

**Calls:**
- `_buildReference` (9)
- `_buildReference` (3)
- `_buildReference` (1)
- `_buildReference` (1)
- `_buildReference` (1)
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.5% (3.4ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get references` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` | Self: 0.0% (0us) | Total: 0.7% (4.6ms) | Samples: 0

**Called by:**
- `get body` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `push` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3963` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `SourceCode` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_computeVariableSynthRefs` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1702` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraFnData` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.0% (0us) | Total: 1.1% (7.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (5)

**Calls:**
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `push` (1)

### `hasTypeOfOperator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:19` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get operator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7522` | Self: 0.0% (0us) | Total: 85.9% (548.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (220)
- `async (anonymous)` (140)

**Calls:**
- `walkNodes` (171)
- `walkNodes` (125)
- `walkNodes` (39)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 11.1% (70.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (46)

**Calls:**
- `parseSource` (45)
- `parseSource` (1)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.4% (2.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 2.5% (15.9ms) | Samples: 0

**Called by:**
- `get` (10)

**Calls:**
- `_buildScopeChildren` (9)
- `_buildScopeChildren` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 33.9% (216.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (141)

**Calls:**
- `runPlugins` (140)
- `runPlugins` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 10.6% (68.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (45)

**Calls:**
- `parse` (45)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 5.6% (35.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (6)
- `patchAstUtils` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `async (anonymous)` (1)

**Calls:**
- `require` (20)
- `anonymous` (3)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 1.4% (9.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (6)

**Calls:**
- `bound require` (6)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2469` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (1)

**Calls:**
- `push` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.7% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1683` | Self: 0.0% (0us) | Total: 0.7% (4.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `_nodesFromRange` (3)

### `SourceCode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1002` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `RuleContext` (1)

**Calls:**
- `_getSharedCaches` (1)

### `node:fs/promises`
`node:fs/promises:70` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `asyncWrap` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.2% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (0us) | Total: 0.7% (4.7ms) | Samples: 0

**Called by:**
- `_buildReference` (3)

**Calls:**
- `_buildScope` (2)
- `_buildScope` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 2.5% (15.9ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (10)

**Calls:**
- `_ensureChildren` (10)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.0% (0us) | Total: 0.4% (2.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.0% (0us) | Total: 3.8% (24.3ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (9)
- `_buildScopeRefsAndThrough` (7)

**Calls:**
- `get parent` (14)
- `get parent` (1)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:956` | Self: 0.0% (0us) | Total: 100.0% (865.1ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (452)
- `Program:exit` (114)

**Calls:**
- `_ensureRefsThrough` (555)
- `_ensureRefsThrough` (10)
- `_ensureRefsThrough` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` | Self: 0.0% (0us) | Total: 41.0% (261.8ms) | Samples: 0

**Called by:**
- `runPlugins` (171)

**Calls:**
- `_invokeFused` (171)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 1.3% (8.9ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (6)

**Calls:**
- `_findLineIdx` (6)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2495` | Self: 0.0% (0us) | Total: 4.8% (31.0ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (20)

**Calls:**
- `_buildReference` (7)
- `_buildReference` (7)
- `_buildReference` (5)
- `_buildReference` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.0% (0us) | Total: 2.2% (14.3ms) | Samples: 0

**Called by:**
- `_ensureChildren` (9)

**Calls:**
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.9% (6.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (0us) | Total: 2.4% (15.7ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (7)
- `_buildScopeRefsAndThrough` (3)

**Calls:**
- `nodeView` (7)
- `_nodeViewRaw` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `_buildVariable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7000` | Self: 0.0% (0us) | Total: 1.4% (8.9ms) | Samples: 0

**Called by:**
- `runPlugins` (6)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.0% (0us) | Total: 1.0% (6.6ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (3)
- `_buildReference` (1)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (0us) | Total: 4.1% (26.4ms) | Samples: 0

**Called by:**
- `get` (18)

**Calls:**
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (637.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (418)

**Calls:**
- `(anonymous)` (416)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `get` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` | Self: 0.0% (0us) | Total: 4.5% (28.7ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (12)
- `_buildScopeRefsAndThrough` (6)
- `_buildScope` (1)

**Calls:**
- `_identAt` (9)
- `_identAt` (5)
- `_resolveUnicodeEscapes` (3)
- `_identAt` (1)
- `_identAt` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:71` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `hasTypeOfOperator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.4% (634.0ms) | Samples: 0

**Called by:**
- `parseModule` (416)

**Calls:**
- `async (anonymous)` (416)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.2% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:66` | Self: 0.0% (0us) | Total: 40.5% (258.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (169)

**Calls:**
- `get` (114)
- `getScope` (55)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js:68` | Self: 0.0% (0us) | Total: 0.5% (3.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `forEach` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.0% (0us) | Total: 1.4% (9.5ms) | Samples: 0

**Called by:**
- `_buildScope` (6)

**Calls:**
- `get body` (3)
- `get body` (1)
- `get body` (1)
- `get body` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `_buildVariable` (1)

**Calls:**
- `_buildSymNameCache` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` | Self: 0.0% (0us) | Total: 0.2% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadCoreRules` (1)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:905` | Self: 0.0% (0us) | Total: 2.5% (15.9ms) | Samples: 0

**Called by:**
- `get` (10)

**Calls:**
- `get` (10)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` | Self: 0.0% (0us) | Total: 0.5% (3.2ms) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `_buildScopeChildren` (1)

**Calls:**
- `_resolveUnicodeEscapes` (1)
- `get name` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (0us) | Total: 0.7% (4.5ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (3)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7517` | Self: 0.0% (0us) | Total: 0.2% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `RuleContext` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 52.2% (333.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (220)

**Calls:**
- `runPlugins` (220)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.5% (3.2ms) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` | Self: 0.0% (0us) | Total: 41.0% (261.8ms) | Samples: 0

**Called by:**
- `walkNodes` (171)

**Calls:**
- `Program:exit` (169)
- `Program:exit` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.0% (0us) | Total: 1.4% (9.5ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (3)
- `_buildScope` (2)
- `_buildReference` (1)

**Calls:**
- `_computeIsStrict` (6)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 55.6% | 354.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 26.1% | 166.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 17.1% | 109.4ms | `[native code]` |
| 0.2% | 1.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.2% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-undef.js` |
| 0.2% | 1.6ms | `node:fs/promises` |
| 0.2% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
