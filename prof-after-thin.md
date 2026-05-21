# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 4.83s | 3177 | 1.0ms | 284 |

**Top 10:** `(anonymous)` 14.6%, `getUint32` 8.4%, `get type` 7.5%, `get _tag` 6.9%, `get type` 6.1%, `get parent` 5.5%, `walkNodes` 3.9%, `getDeclaredVariables` 3.7%, `push` 3.5%, `init` 3.2%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 14.6% | 707.5ms | 34.9% | 1.68s | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 8.4% | 409.8ms | 8.4% | 409.8ms | `getUint32` | `[native code]` |
| 7.5% | 365.7ms | 7.5% | 365.7ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 6.9% | 335.4ms | 6.9% | 335.4ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 6.1% | 294.8ms | 6.1% | 294.8ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 5.5% | 267.1ms | 5.7% | 278.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 3.9% | 189.9ms | 4.7% | 230.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 3.7% | 181.3ms | 3.7% | 182.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 3.5% | 172.9ms | 3.5% | 172.9ms | `push` | `[native code]` |
| 3.2% | 158.2ms | 5.5% | 269.1ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 2.5% | 121.4ms | 2.5% | 121.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 2.4% | 116.5ms | 2.4% | 116.5ms | `Set` | `[native code]` |
| 2.3% | 113.2ms | 2.3% | 113.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 2.2% | 110.9ms | 2.2% | 110.9ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 2.2% | 108.0ms | 2.2% | 108.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 2.1% | 104.9ms | 3.0% | 148.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 1.4% | 69.1ms | 12.0% | 580.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 1.4% | 68.8ms | 1.4% | 68.8ms | `parse` | `[native code]` |
| 1.0% | 51.0ms | 1.0% | 51.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 1.0% | 49.1ms | 1.0% | 49.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.8% | 43.3ms | 7.6% | 370.9ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.7% | 35.7ms | 0.7% | 36.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 0.7% | 35.0ms | 0.7% | 37.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.6% | 33.3ms | 2.7% | 132.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.5% | 28.6ms | 0.5% | 28.6ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.4% | 19.4ms | 0.5% | 25.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.3% | 18.0ms | 0.3% | 18.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.3% | 16.8ms | 0.6% | 31.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.3% | 16.0ms | 0.3% | 16.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 0.3% | 15.8ms | 0.3% | 15.8ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.3% | 15.4ms | 0.9% | 45.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.3% | 15.1ms | 0.3% | 15.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.2% | 14.2ms | 39.4% | 1.90s | `some` | `[native code]` |
| 0.2% | 14.1ms | 0.2% | 14.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.2% | 13.5ms | 1.1% | 56.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.2% | 12.7ms | 0.7% | 37.2ms | `anonymous` | `[native code]` |
| 0.2% | 12.4ms | 0.2% | 12.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.2% | 12.3ms | 0.3% | 17.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 11.5ms | 0.2% | 11.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.2% | 11.4ms | 0.2% | 11.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.2% | 11.4ms | 0.3% | 15.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.2% | 11.0ms | 0.2% | 12.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.2% | 10.8ms | 0.2% | 10.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 10.4ms | 0.3% | 14.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.2% | 10.4ms | 0.3% | 16.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.1% | 9.6ms | 0.3% | 19.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.1% | 9.2ms | 0.1% | 9.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.1% | 8.2ms | 31.5% | 1.52s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.1% | 8.0ms | 2.5% | 124.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.1% | 8.0ms | 0.8% | 39.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.1% | 7.8ms | 0.5% | 27.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.1% | 7.7ms | 0.3% | 14.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.1% | 7.3ms | 0.2% | 10.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.1% | 7.1ms | 3.9% | 189.0ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 7.1ms | 0.1% | 8.4ms | `test` | `[native code]` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 6.3ms | 0.4% | 19.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.1% | 6.2ms | 0.3% | 15.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.1% | 6.1ms | 1.6% | 78.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.1% | 5.8ms | 0.3% | 17.1ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3888` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.1% | 4.8ms | 0.2% | 11.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.0% | 4.8ms | 36.4% | 1.76s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `slice` | `[native code]` |
| 0.0% | 4.5ms | 1.6% | 79.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.0% | 3.2ms | 0.1% | 5.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 3.2ms | 1.4% | 69.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.1ms | 0.2% | 10.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2146` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 2.9ms | 26.7% | 1.29s | `forEach` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get` | `[native code]` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.8ms | 0.0% | 3.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:701` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 1.7ms | 0.3% | 14.9ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` |
| 0.0% | 1.7ms | 0.1% | 4.9ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` |
| 0.0% | 1.6ms | 0.0% | 3.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.0% | 1.6ms | 0.1% | 6.1ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.6ms | 0.0% | 3.4ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `byteLength` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6436` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.1% | 6.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:793` |
| 0.0% | 1.4ms | 0.2% | 9.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 2.8ms | `readdirSync` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `encodeInto` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.0% | 1.4ms | 18.4% | 892.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2600` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1514` |
| 0.0% | 1.3ms | 0.2% | 13.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 0.0% | 1.3ms | 0.7% | 37.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.0% | 1.3ms | 0.0% | 3.0ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4684` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get expressions` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3027` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.2ms | 0.0% | 2.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3827` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:534` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` |
| 0.0% | 1.2ms | 0.0% | 2.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1022` |
| 0.0% | 1.2ms | 0.0% | 2.6ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1989` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 9.29s | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 4.83s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 99.9% | 4.83s | 0.0% | 0us | `parseModule` | `[native code]` |
| 99.8% | 4.82s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.8% | 4.82s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 98.0% | 4.73s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` |
| 93.0% | 4.49s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 91.1% | 4.40s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 91.1% | 4.40s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` |
| 89.3% | 4.31s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 39.4% | 1.90s | 0.2% | 14.2ms | `some` | `[native code]` |
| 36.4% | 1.76s | 0.0% | 4.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 34.9% | 1.68s | 14.6% | 707.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 31.5% | 1.52s | 0.1% | 8.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 26.9% | 1.30s | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 26.7% | 1.29s | 0.0% | 2.9ms | `forEach` | `[native code]` |
| 26.7% | 1.29s | 0.0% | 0us | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 25.3% | 1.22s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 18.4% | 892.5ms | 0.0% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 17.7% | 859.4ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 12.0% | 580.7ms | 1.4% | 69.1ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 8.4% | 409.8ms | 8.4% | 409.8ms | `getUint32` | `[native code]` |
| 7.6% | 370.9ms | 0.8% | 43.3ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 7.5% | 365.7ms | 7.5% | 365.7ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 6.9% | 335.4ms | 6.9% | 335.4ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 6.1% | 294.8ms | 6.1% | 294.8ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 5.7% | 278.3ms | 5.5% | 267.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 5.5% | 269.1ms | 3.2% | 158.2ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 4.9% | 240.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 4.7% | 230.3ms | 3.9% | 189.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 3.9% | 189.0ms | 0.1% | 7.1ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 3.7% | 182.7ms | 3.7% | 181.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 3.5% | 172.9ms | 3.5% | 172.9ms | `push` | `[native code]` |
| 3.0% | 148.3ms | 2.1% | 104.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 2.7% | 132.9ms | 0.6% | 33.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 2.5% | 124.5ms | 0.1% | 8.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 2.5% | 121.4ms | 2.5% | 121.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 2.4% | 116.5ms | 2.4% | 116.5ms | `Set` | `[native code]` |
| 2.3% | 113.2ms | 2.3% | 113.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 2.2% | 110.9ms | 2.2% | 110.9ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 2.2% | 108.0ms | 2.2% | 108.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 1.7% | 84.0ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` |
| 1.7% | 84.0ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 1.6% | 79.5ms | 0.0% | 4.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 1.6% | 78.7ms | 0.1% | 6.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 1.5% | 74.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 1.4% | 69.9ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.4% | 68.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 1.4% | 68.8ms | 1.4% | 68.8ms | `parse` | `[native code]` |
| 1.3% | 66.2ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` |
| 1.1% | 56.0ms | 0.2% | 13.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 1.0% | 51.0ms | 1.0% | 51.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 1.0% | 49.1ms | 1.0% | 49.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.9% | 45.3ms | 0.3% | 15.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.8% | 39.0ms | 0.1% | 8.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.7% | 37.8ms | 0.7% | 35.0ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.7% | 37.2ms | 0.2% | 12.7ms | `anonymous` | `[native code]` |
| 0.7% | 37.1ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 0.7% | 36.9ms | 0.7% | 35.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 0.7% | 34.9ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.6% | 32.5ms | 0.0% | 0us | `require` | `[native code]` |
| 0.6% | 31.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.6% | 31.1ms | 0.3% | 16.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.6% | 30.4ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 0.5% | 28.6ms | 0.5% | 28.6ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.5% | 27.5ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 0.5% | 27.1ms | 0.1% | 7.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.5% | 25.5ms | 0.4% | 19.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.4% | 19.6ms | 0.1% | 6.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.3% | 19.0ms | 0.1% | 9.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.3% | 18.0ms | 0.3% | 18.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.3% | 17.1ms | 0.1% | 5.8ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3888` |
| 0.3% | 17.1ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.3% | 17.0ms | 0.2% | 12.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.3% | 16.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` |
| 0.3% | 16.2ms | 0.2% | 10.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.3% | 16.0ms | 0.3% | 16.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 0.3% | 15.8ms | 0.2% | 11.4ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 15.8ms | 0.3% | 15.8ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.3% | 15.6ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.3% | 15.1ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.3% | 15.1ms | 0.3% | 15.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.3% | 15.0ms | 0.1% | 6.2ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.3% | 14.9ms | 0.0% | 1.7ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.3% | 14.8ms | 0.2% | 10.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.3% | 14.5ms | 0.1% | 7.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.2% | 14.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` |
| 0.2% | 14.1ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 0.2% | 14.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.2% | 14.1ms | 0.2% | 14.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.2% | 13.7ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 0.2% | 12.7ms | 0.2% | 11.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.2% | 12.4ms | 0.2% | 12.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.2% | 12.4ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` |
| 0.2% | 12.0ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 0.2% | 12.0ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 11.6ms | 0.1% | 4.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.2% | 11.5ms | 0.2% | 11.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.2% | 11.4ms | 0.2% | 11.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.2% | 11.1ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` |
| 0.2% | 10.8ms | 0.2% | 10.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 10.5ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.2% | 10.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.2% | 10.2ms | 0.1% | 7.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.2% | 10.1ms | 0.0% | 3.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 0.2% | 9.8ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.1% | 9.2ms | 0.1% | 9.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.1% | 8.5ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` |
| 0.1% | 8.4ms | 0.1% | 7.1ms | `test` | `[native code]` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.1% | 7.8ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.1% | 7.6ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.1% | 6.1ms | 0.0% | 1.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.1% | 6.0ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` |
| 0.1% | 6.0ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` |
| 0.1% | 6.0ms | 0.0% | 0us | `map` | `[native code]` |
| 0.1% | 5.9ms | 0.0% | 3.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.1% | 4.9ms | 0.0% | 1.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 4.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` |
| 0.0% | 4.7ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `slice` | `[native code]` |
| 0.0% | 4.4ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.0% | 4.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 4.3ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 4.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.0% | 4.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.0% | 4.1ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 3.4ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 3.4ms | 0.0% | 1.6ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.0% | 3.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.0% | 3.2ms | 0.0% | 1.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.0% | 3.2ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 3.2ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` |
| 0.0% | 3.2ms | 0.0% | 0us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 3.2ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.1ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.0% | 3.0ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.0% | 3.0ms | 0.0% | 1.3ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 3.0ms | 0.0% | 0us | `exec` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2146` |
| 0.0% | 3.0ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 2.9ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` |
| 0.0% | 2.9ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.0% | 2.9ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 1.4ms | `readdirSync` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.0% | 2.6ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 2.6ms | 0.0% | 1.2ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 2.6ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` |
| 0.0% | 2.6ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2164` |
| 0.0% | 2.5ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.0% | 2.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.0% | 2.5ms | 0.0% | 1.2ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3827` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 2.3ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 2.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:701` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 1.7ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.0% | 1.7ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7179` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.0% | 1.6ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.6ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:658` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `byteLength` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6436` |
| 0.0% | 1.5ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` |
| 0.0% | 1.5ms | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:793` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 1.4ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3140` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.0% | 1.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` |
| 0.0% | 1.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `encodeInto` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.0% | 1.4ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2600` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1514` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4684` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 1.3ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` |
| 0.0% | 1.2ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:513` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get expressions` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3027` |
| 0.0% | 1.2ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:534` |
| 0.0% | 1.2ms | 0.0% | 0us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3426` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1022` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` |
| 0.0% | 1.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1989` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |

## Function Details

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 14.6% (707.5ms) | Total: 34.9% (1.68s) | Samples: 461

**Called by:**
- `some` (1106)

**Calls:**
- `get type` (218)
- `get type` (176)
- `get parent` (174)
- `get parent` (71)
- `get parent` (5)
- `get parent` (1)

### `getUint32`
`[native code]` | Self: 8.4% (409.8ms) | Total: 8.4% (409.8ms) | Samples: 274

**Called by:**
- `init` (265)
- `_isChainNode` (8)
- `get init` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 7.5% (365.7ms) | Total: 7.5% (365.7ms) | Samples: 239

**Called by:**
- `(anonymous)` (218)
- `isForInOfRef` (4)
- `getRhsNode` (3)
- `isForInOfRef` (3)
- `(anonymous)` (2)
- `collectUnusedVariables` (2)
- `(anonymous)` (2)
- `collectUnusedVariables` (2)
- `isForInOfRef` (2)
- `isReadForItself` (1)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 6.9% (335.4ms) | Total: 6.9% (335.4ms) | Samples: 222

**Called by:**
- `init` (217)
- `get parent` (2)
- `get parent` (2)
- `_findDefNode` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 6.1% (294.8ms) | Total: 6.1% (294.8ms) | Samples: 193

**Called by:**
- `(anonymous)` (176)
- `isForInOfRef` (4)
- `isForInOfRef` (3)
- `isReadForItself` (2)
- `(anonymous)` (2)
- `isReadForItself` (2)
- `collectUnusedVariables` (1)
- `getRhsNode` (1)
- `collectUnusedVariables` (1)
- `isForInOfRef` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 5.5% (267.1ms) | Total: 5.7% (278.3ms) | Samples: 176

**Called by:**
- `(anonymous)` (174)
- `_buildReference` (8)
- `_findDefNode` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` | Self: 3.9% (189.9ms) | Total: 4.7% (230.3ms) | Samples: 125

**Called by:**
- `runPlugins` (152)

**Calls:**
- `get allSkipped` (19)
- `get allSkipped` (8)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` | Self: 3.7% (181.3ms) | Total: 3.7% (182.7ms) | Samples: 119

**Called by:**
- `isAfterLastUsedArg` (120)

**Calls:**
- `get` (1)

### `push`
`[native code]` | Self: 3.5% (172.9ms) | Total: 3.5% (172.9ms) | Samples: 112

**Called by:**
- `getDeclaredVariables` (62)
- `getDeclaredVariables` (29)
- `getDeclaredVariables` (20)
- `getDeclaredVariables` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` | Self: 3.2% (158.2ms) | Total: 5.5% (269.1ms) | Samples: 105

**Called by:**
- `(anonymous)` (177)
- `(anonymous)` (1)

**Calls:**
- `nodeRhs` (73)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 2.5% (121.4ms) | Total: 2.5% (121.4ms) | Samples: 81

**Called by:**
- `(anonymous)` (71)
- `isReadForItself` (5)
- `isForInOfRef` (2)
- `isForInOfRef` (1)
- `collectUnusedVariables` (1)
- `_buildReference` (1)

### `Set`
`[native code]` | Self: 2.4% (116.5ms) | Total: 2.4% (116.5ms) | Samples: 75

**Called by:**
- `getDeclaredVariables` (75)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` | Self: 2.3% (113.2ms) | Total: 2.3% (113.2ms) | Samples: 76

**Called by:**
- `init` (76)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` | Self: 2.2% (110.9ms) | Total: 2.2% (110.9ms) | Samples: 73

**Called by:**
- `init` (73)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` | Self: 2.2% (108.0ms) | Total: 2.2% (108.0ms) | Samples: 70

**Called by:**
- `isAfterLastUsedArg` (67)
- `isAfterLastUsedArg` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 2.1% (104.9ms) | Total: 3.0% (148.3ms) | Samples: 71

**Called by:**
- `isAfterLastUsedArg` (100)

**Calls:**
- `push` (29)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 1.4% (69.1ms) | Total: 12.0% (580.7ms) | Samples: 46

**Called by:**
- `(anonymous)` (382)
- `(anonymous)` (3)
- `(anonymous)` (3)

**Calls:**
- `getUint32` (265)
- `nodeLhs` (76)
- `nodeLhs` (1)

### `parse`
`[native code]` | Self: 1.4% (68.8ms) | Total: 1.4% (68.8ms) | Samples: 47

**Called by:**
- `parseSource` (47)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` | Self: 1.0% (51.0ms) | Total: 1.0% (51.0ms) | Samples: 34

**Called by:**
- `runPlugins` (34)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 1.0% (49.1ms) | Total: 1.0% (49.1ms) | Samples: 33

**Called by:**
- `_precomputeScopes` (33)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.8% (43.3ms) | Total: 7.6% (370.9ms) | Samples: 28

**Called by:**
- `(anonymous)` (242)
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `get _tag` (217)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` | Self: 0.7% (35.7ms) | Total: 0.7% (36.9ms) | Samples: 24

**Called by:**
- `isAfterLastUsedArg` (25)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.7% (35.0ms) | Total: 0.7% (37.8ms) | Samples: 22

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `get parent` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.6% (33.3ms) | Total: 2.7% (132.9ms) | Samples: 21

**Called by:**
- `isAfterLastUsedArg` (84)

**Calls:**
- `push` (62)
- `get references` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` | Self: 0.5% (28.6ms) | Total: 0.5% (28.6ms) | Samples: 19

**Called by:**
- `walkNodes` (19)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` | Self: 0.4% (19.4ms) | Total: 0.5% (25.5ms) | Samples: 11

**Called by:**
- `isAfterLastUsedArg` (15)

**Calls:**
- `defs` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.3% (18.0ms) | Total: 0.3% (18.0ms) | Samples: 12

**Called by:**
- `collectUnusedVariables` (12)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.3% (16.8ms) | Total: 0.6% (31.1ms) | Samples: 11

**Called by:**
- `isAfterLastUsedArg` (21)

**Calls:**
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` | Self: 0.3% (16.0ms) | Total: 0.3% (16.0ms) | Samples: 11

**Called by:**
- `(anonymous)` (5)
- `_buildReference` (3)
- `getRhsNode` (2)
- `isForInOfRef` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.3% (15.8ms) | Total: 0.3% (15.8ms) | Samples: 11

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` | Self: 0.3% (15.4ms) | Total: 0.9% (45.3ms) | Samples: 10

**Called by:**
- `isAfterLastUsedArg` (30)

**Calls:**
- `push` (20)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.3% (15.1ms) | Total: 0.3% (15.1ms) | Samples: 10

**Called by:**
- `getRhsNode` (10)

### `some`
`[native code]` | Self: 0.2% (14.2ms) | Total: 39.4% (1.90s) | Samples: 9

**Called by:**
- `collectUnusedVariables` (1107)
- `isUsedVariable` (113)
- `collectUnusedVariables` (15)
- `isAfterLastUsedArg` (9)

**Calls:**
- `(anonymous)` (1106)
- `(anonymous)` (51)
- `(anonymous)` (44)
- `(anonymous)` (21)
- `(anonymous)` (9)
- `(anonymous)` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.2% (14.1ms) | Total: 0.2% (14.1ms) | Samples: 9

**Called by:**
- `_buildReference` (2)
- `get parent` (2)
- `_nodesFromRange` (2)
- `(anonymous)` (1)
- `get body` (1)
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.2% (13.5ms) | Total: 1.1% (56.0ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (25)
- `Program:exit` (12)

**Calls:**
- `get` (20)
- `get` (8)

### `anonymous`
`[native code]` | Self: 0.2% (12.7ms) | Total: 0.7% (37.2ms) | Samples: 9

**Called by:**
- `require` (21)
- `bound require` (2)
- `node:fs` (2)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `node:fs` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` | Self: 0.2% (12.4ms) | Total: 0.2% (12.4ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.2% (12.3ms) | Total: 0.3% (17.0ms) | Samples: 8

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `get type` (2)
- `get type` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (11.8ms) | Total: 0.2% (11.8ms) | Samples: 8

**Called by:**
- `walkNodes` (8)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.2% (11.5ms) | Total: 0.2% (11.5ms) | Samples: 7

**Called by:**
- `commentsInRange` (5)
- `commentsInRange` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 0.2% (11.4ms) | Total: 0.2% (11.4ms) | Samples: 8

**Called by:**
- `_buildReference` (4)
- `get parent` (3)
- `_computeVarDefs` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.2% (11.4ms) | Total: 0.3% (15.8ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (11)

**Calls:**
- `getDeclaredVariables` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.2% (11.0ms) | Total: 0.2% (12.7ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `get parent` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.2% (10.8ms) | Total: 0.2% (10.8ms) | Samples: 7

**Called by:**
- `isUsedVariable` (7)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.2% (10.4ms) | Total: 0.3% (14.8ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (10)

**Calls:**
- `get type` (2)
- `get type` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (10.4ms) | Total: 0.3% (16.2ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (11)

**Calls:**
- `get type` (2)
- `get parent` (1)
- `get type` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.1% (9.6ms) | Total: 0.3% (19.0ms) | Samples: 6

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get type` (3)
- `get type` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` | Self: 0.1% (9.2ms) | Total: 0.1% (9.2ms) | Samples: 6

**Called by:**
- `isAfterLastUsedArg` (6)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.1% (8.2ms) | Total: 31.5% (1.52s) | Samples: 5

**Called by:**
- `collectUnusedVariables` (1006)
- `Program:exit` (4)

**Calls:**
- `isUsedVariable` (867)
- `isUsedVariable` (121)
- `some` (15)
- `isUsedVariable` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.1% (8.0ms) | Total: 2.5% (124.5ms) | Samples: 5

**Called by:**
- `isAfterLastUsedArg` (80)

**Calls:**
- `Set` (75)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.1% (8.0ms) | Total: 0.8% (39.0ms) | Samples: 5

**Called by:**
- `forEach` (26)

**Calls:**
- `nodeViewChain` (6)
- `init` (3)
- `get type` (2)
- `get type` (2)
- `nodeViewChain` (2)
- `init` (2)
- `_nodeViewRaw` (1)
- `init` (1)
- `get init` (1)
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.1% (7.8ms) | Total: 0.5% (27.1ms) | Samples: 6

**Called by:**
- `forEach` (20)

**Calls:**
- `nodeViewChain` (4)
- `init` (3)
- `get type` (2)
- `_nodeViewRaw` (2)
- `nodeViewChain` (1)
- `get init` (1)
- `init` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `_ensureChildren` (5)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.1% (7.7ms) | Total: 0.3% (14.5ms) | Samples: 5

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `get type` (3)
- `get type` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` | Self: 0.1% (7.7ms) | Total: 0.1% (7.7ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (5)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 0.1% (7.3ms) | Total: 0.2% (10.2ms) | Samples: 5

**Called by:**
- `_buildReference` (4)
- `_computeIsStrict` (1)
- `_findDefNode` (1)
- `_buildReference` (1)

**Calls:**
- `get _tag` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 0.1% (7.2ms) | Total: 0.1% (7.2ms) | Samples: 5

**Called by:**
- `get parent` (3)
- `_buildReference` (1)
- `_nodesFromRange` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (7.1ms) | Total: 3.9% (189.0ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (121)

**Calls:**
- `some` (113)
- `get references` (3)

### `test`
`[native code]` | Self: 0.1% (7.1ms) | Total: 0.1% (8.4ms) | Samples: 5

**Called by:**
- `_precomputeScopes` (5)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `/^\s*exported\b/` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` | Self: 0.1% (6.5ms) | Total: 0.1% (6.5ms) | Samples: 4

**Called by:**
- `isAfterLastUsedArg` (4)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.1% (6.3ms) | Total: 0.4% (19.6ms) | Samples: 4

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get type` (4)
- `get type` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` | Self: 0.1% (6.2ms) | Total: 0.1% (6.2ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.1% (6.2ms) | Total: 0.3% (15.0ms) | Samples: 4

**Called by:**
- `getScope` (10)

**Calls:**
- `test` (5)
- `/^\s*exported\b/` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.1% (6.1ms) | Total: 1.6% (78.7ms) | Samples: 4

**Called by:**
- `some` (51)

**Calls:**
- `getRhsNode` (24)
- `getRhsNode` (10)
- `getRhsNode` (9)
- `getRhsNode` (2)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3888` | Self: 0.1% (5.8ms) | Total: 0.3% (17.1ms) | Samples: 4

**Called by:**
- `nodeViewChain` (12)

**Calls:**
- `getUint32` (8)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` | Self: 0.1% (4.8ms) | Total: 0.2% (11.6ms) | Samples: 3

**Called by:**
- `_buildReference` (5)
- `(anonymous)` (1)
- `_computeVarDefs` (1)

**Calls:**
- `get _tag` (2)
- `get _tag` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.0% (4.8ms) | Total: 36.4% (1.76s) | Samples: 3

**Called by:**
- `collectUnusedVariables` (1155)

**Calls:**
- `some` (1107)
- `get references` (43)
- `get references` (1)
- `get references` (1)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `get parent` (2)
- `get parent` (1)

### `slice`
`[native code]` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `_buildSymNameCache` (2)
- `getDeclaredVariables` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (4.5ms) | Total: 1.6% (79.5ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (43)
- `(anonymous)` (6)
- `isUsedVariable` (3)

**Calls:**
- `_buildReference` (25)
- `_buildReference` (10)
- `_buildReference` (8)
- `_buildReference` (2)
- `_buildReference` (2)
- `_buildReference` (1)
- `_buildReference` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (3)

### `eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `isUsedVariable` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get references` (2)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.0% (3.2ms) | Total: 0.1% (5.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (3)
- `collectUnusedVariables` (1)

**Calls:**
- `_computeVariableSynthRefs` (2)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `get name` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (3.2ms) | Total: 1.4% (69.9ms) | Samples: 2

**Called by:**
- `some` (44)

**Calls:**
- `isForInOfRef` (12)
- `isForInOfRef` (12)
- `isForInOfRef` (11)
- `isForInOfRef` (3)
- `isForInOfRef` (2)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `getUpperFunction` (1)
- `collectUnusedVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` | Self: 0.0% (3.1ms) | Total: 0.2% (10.1ms) | Samples: 2

**Called by:**
- `defs` (6)
- `get defs` (1)

**Calls:**
- `_findDefNode` (3)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `test` (1)
- `_precomputeScopes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `exec` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2146` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `getRhsNode` (1)
- `isReadForItself` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `forEach`
`[native code]` | Self: 0.0% (2.9ms) | Total: 26.7% (1.29s) | Samples: 2

**Called by:**
- `getFunctionDefinitions` (860)

**Calls:**
- `(anonymous)` (812)
- `(anonymous)` (26)
- `(anonymous)` (20)

### `get`
`[native code]` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `getDeclaredVariables` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `get body` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.0% (2.4ms) | Total: 0.0% (2.4ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` | Self: 0.0% (1.8ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (2)

**Calls:**
- `slice` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:701` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get end`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (1.7ms) | Total: 0.3% (14.9ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (5)
- `getDeclaredVariables` (4)
- `isAfterLastUsedArg` (1)

**Calls:**
- `_computeVarDefs` (6)
- `_computeVarDefs` (2)
- `_computeVarDefs` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isForInOfRef` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.0% (1.7ms) | Total: 0.1% (4.9ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (2)
- `_buildVariable` (1)

**Calls:**
- `_buildSymNameCache` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (1.6ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get parent` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (1.6ms) | Total: 0.1% (6.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get type` (2)
- `get type` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (1.6ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_computeVarDefs` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `byteLength`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6436` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `init` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` | Self: 0.0% (1.4ms) | Total: 0.1% (6.0ms) | Samples: 1

**Called by:**
- `map` (4)

**Calls:**
- `get name` (2)
- `get name` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:793` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` | Self: 0.0% (1.4ms) | Total: 0.2% (9.8ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (6)

**Calls:**
- `_findLineIdx` (5)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeVarScope` (1)

### `readdirSync`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `readdirSync` (1)
- `loadCoreRules` (1)

**Calls:**
- `readdirSync` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getUpperFunction` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.4ms) | Total: 18.4% (892.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (582)

**Calls:**
- `isAfterLastUsedArg` (560)
- `isAfterLastUsedArg` (11)
- `isAfterLastUsedArg` (9)
- `isAfterLastUsedArg` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2600` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1514` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` | Self: 0.0% (1.3ms) | Total: 0.2% (13.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (9)

**Calls:**
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (1.3ms) | Total: 0.7% (37.1ms) | Samples: 1

**Called by:**
- `get references` (25)

**Calls:**
- `get parent` (8)
- `get parent` (5)
- `get parent` (4)
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (1.3ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `getUint32` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4684` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `fetch`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `requestFetch` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get expressions`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3027` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isUnusedExpression` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3827` | Self: 0.0% (1.2ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `report` (2)

**Calls:**
- `getLocFromIndex` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_findLine`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:534` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getLocFromIndex` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` | Self: 0.0% (1.2ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `get` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1022` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` | Self: 0.0% (1.2ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `scope` (2)

**Calls:**
- `_buildScope` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1989` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 0.2% (14.1ms) | Samples: 0

**Called by:**
- `some` (9)

**Calls:**
- `get references` (6)
- `get references` (3)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.2% (10.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `bound require` (7)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 4.9% (240.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (158)

**Calls:**
- `runPlugins` (157)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `get _tag` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` | Self: 0.0% (0us) | Total: 1.7% (84.0ms) | Samples: 0

**Called by:**
- `Program:exit` (56)

**Calls:**
- `_precomputeScopes` (44)
- `_precomputeScopes` (10)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `readdirSync` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (2)

**Calls:**
- `_findLineIdx` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (0us) | Total: 26.7% (1.29s) | Samples: 0

**Called by:**
- `isUsedVariable` (860)

**Calls:**
- `forEach` (860)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `some` (4)

**Calls:**
- `isSelfReference` (4)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (4)

**Calls:**
- `map` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2164` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get type` (1)
- `get parent` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isUnusedExpression` (1)
- `isUnusedExpression` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (1)

**Calls:**
- `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (0us) | Total: 91.1% (4.40s) | Samples: 0

**Called by:**
- `runPlugins` (2895)

**Calls:**
- `_invokeFused` (2894)
- `_invokeFused` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.0% (0us) | Total: 0.3% (15.6ms) | Samples: 0

**Called by:**
- `get references` (10)

**Calls:**
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3140` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)

**Calls:**
- `push` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.8% (4.82s) | Samples: 0

**Called by:**
- `parseModule` (3173)

**Calls:**
- `async (anonymous)` (3173)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get _tag` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` | Self: 0.0% (0us) | Total: 98.0% (4.73s) | Samples: 0

**Called by:**
- `async (anonymous)` (2957)
- `async (anonymous)` (157)

**Calls:**
- `walkNodes` (2895)
- `walkNodes` (152)
- `walkNodes` (34)
- `walkNodes` (11)
- `walkNodes` (8)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` | Self: 0.0% (0us) | Total: 0.3% (17.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (1)
- `getRhsNode` (1)

**Calls:**
- `_isChainNode` (12)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (3)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 1.7% (84.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (56)

**Calls:**
- `getScope` (56)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` | Self: 0.0% (0us) | Total: 91.1% (4.40s) | Samples: 0

**Called by:**
- `walkNodes` (2894)

**Calls:**
- `Program:exit` (2835)
- `Program:exit` (56)
- `Program:exit` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `get value` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadCoreRules` (1)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (1)

**Calls:**
- `async (anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` | Self: 0.0% (0us) | Total: 0.2% (12.4ms) | Samples: 0

**Called by:**
- `get references` (8)

**Calls:**
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `get end` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 93.0% (4.49s) | Samples: 0

**Called by:**
- `async (anonymous)` (2957)

**Calls:**
- `runPlugins` (2957)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `fetch` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `_symName` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3426` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `_findLine` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInsideOfStorableFunction` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isForInOfRef` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `_nodesFromRange` (3)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `(anonymous)` (4)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `eslintUsed` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 0.2% (14.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (9)

**Calls:**
- `some` (9)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `exec` (2)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `_execReport` (2)
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `report` (3)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (1)

**Calls:**
- `get parent` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 1.5% (74.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (49)

**Calls:**
- `parseSource` (47)
- `parseSource` (1)
- `parseSource` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `_encodeSource` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.6% (32.5ms) | Samples: 0

**Called by:**
- `bound require` (21)

**Calls:**
- `anonymous` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (4.83s) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `requestInstantiate` (1)

**Calls:**
- `parseModule` (3176)
- `async (anonymous)` (1)
- `requestFetch` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` | Self: 0.0% (0us) | Total: 0.2% (11.1ms) | Samples: 0

**Called by:**
- `_buildReference` (3)
- `_buildScopeChildren` (2)
- `_buildScope` (2)

**Calls:**
- `_computeIsStrict` (5)
- `_computeIsStrict` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.8% (4.82s) | Samples: 0

**Called by:**
- `(anonymous)` (3173)

**Calls:**
- `async (anonymous)` (2957)
- `async (anonymous)` (158)
- `async (anonymous)` (49)
- `async (anonymous)` (7)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `AstView` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` | Self: 0.0% (0us) | Total: 0.2% (14.2ms) | Samples: 0

**Called by:**
- `_buildScope` (6)
- `_buildReference` (3)

**Calls:**
- `_buildScope` (6)
- `_buildScope` (2)
- `_buildScope` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 89.3% (4.31s) | Samples: 0

**Called by:**
- `_invokeFused` (2835)

**Calls:**
- `collectUnusedVariables` (2819)
- `collectUnusedVariables` (12)
- `collectUnusedVariables` (4)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:658` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (2.3ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (0us) | Total: 100.0% (9.29s) | Samples: 0

**Called by:**
- `collectUnusedVariables` (3280)
- `Program:exit` (2819)

**Calls:**
- `collectUnusedVariables` (3280)
- `collectUnusedVariables` (1155)
- `collectUnusedVariables` (1006)
- `collectUnusedVariables` (582)
- `collectUnusedVariables` (25)
- `collectUnusedVariables` (12)
- `collectUnusedVariables` (11)
- `collectUnusedVariables` (10)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (7)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `defs` (1)

**Calls:**
- `get parent` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get body` (1)
- `get body` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 26.9% (1.30s) | Samples: 0

**Called by:**
- `collectUnusedVariables` (867)

**Calls:**
- `getFunctionDefinitions` (860)
- `getFunctionDefinitions` (7)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.0% (0us) | Total: 0.1% (7.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `get parent` (5)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `isReadForItself` (2)

**Calls:**
- `getUpperFunction` (1)
- `getUpperFunction` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `get references` (2)

**Calls:**
- `scope` (2)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:513` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `get expressions` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 0.2% (12.0ms) | Samples: 0

**Called by:**
- `get` (8)

**Calls:**
- `_buildScopeChildren` (5)
- `_buildScopeChildren` (2)
- `_buildScopeChildren` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 0.6% (31.7ms) | Samples: 0

**Called by:**
- `some` (21)

**Calls:**
- `isReadForItself` (5)
- `isReadForItself` (4)
- `isReadForItself` (3)
- `isReadForItself` (2)
- `isReadForItself` (2)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_symName` (2)

**Calls:**
- `slice` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.7% (34.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `async (anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (21)
- `anonymous` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 1.4% (68.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (47)

**Calls:**
- `parse` (47)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 0.2% (10.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `defs` (5)
- `get defs` (2)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (2)

**Calls:**
- `_computeVarScope` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 0.2% (12.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `_ensureChildren` (8)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (2.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `RuleContext` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 17.7% (859.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (560)

**Calls:**
- `getDeclaredVariables` (120)
- `getDeclaredVariables` (100)
- `getDeclaredVariables` (84)
- `getDeclaredVariables` (80)
- `getDeclaredVariables` (67)
- `getDeclaredVariables` (30)
- `getDeclaredVariables` (25)
- `getDeclaredVariables` (21)
- `getDeclaredVariables` (15)
- `getDeclaredVariables` (6)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `defs` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_identAt` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraFnData` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Calls:**
- `requestSatisfyUtil` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `byteLength` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `_ensureChildren` (2)

**Calls:**
- `_buildScope` (2)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (0us) | Total: 0.5% (27.5ms) | Samples: 0

**Called by:**
- `get` (18)

**Calls:**
- `_buildScopeVarsAndSet` (9)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 99.9% (4.83s) | Samples: 0

**Called by:**
- `async (anonymous)` (3176)

**Calls:**
- `(anonymous)` (3173)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` | Self: 0.0% (0us) | Total: 1.3% (66.2ms) | Samples: 0

**Called by:**
- `getScope` (44)

**Calls:**
- `commentsInRange` (33)
- `commentsInRange` (6)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `requestInstantiate` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 25.3% (1.22s) | Samples: 0

**Called by:**
- `forEach` (812)

**Calls:**
- `init` (382)
- `init` (242)
- `init` (177)
- `nodeViewChain` (5)
- `nodeViewChain` (4)
- `_nodeViewRaw` (1)
- `get init` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7179` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_fireCfgEvents` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get parent` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 0.6% (30.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (20)

**Calls:**
- `_ensureVarsSet` (18)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `buildUnicodeData` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.3% (15.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `isInLoop` (10)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildVariable` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `get body` (3)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get type` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` | Self: 0.0% (0us) | Total: 0.1% (8.5ms) | Samples: 0

**Called by:**
- `_buildScope` (5)

**Calls:**
- `get body` (3)
- `get body` (1)
- `get body` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` | Self: 0.0% (0us) | Total: 0.3% (16.8ms) | Samples: 0

**Called by:**
- `runPlugins` (11)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (5)
- `getDFSEvents` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `get references` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 42.9% | 2.07s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 20.4% | 988.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 19.4% | 939.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 17.0% | 826.1ms | `[native code]` |
| 0.0% | 1.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
