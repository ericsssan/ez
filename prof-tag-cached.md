# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 4.32s | 2848 | 1.0ms | 281 |

**Top 10:** `(anonymous)` 15.5%, `getUint32` 9.2%, `get type` 8.6%, `get type` 5.4%, `walkNodes` 4.6%, `getDeclaredVariables` 4.3%, `get parent` 4.3%, `init` 4.0%, `push` 4.0%, `nodeRhs` 3.4%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 15.5% | 672.7ms | 35.2% | 1.52s | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 9.2% | 401.8ms | 9.2% | 401.8ms | `getUint32` | `[native code]` |
| 8.6% | 375.7ms | 8.6% | 375.7ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 5.4% | 233.9ms | 5.4% | 233.9ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 4.6% | 199.8ms | 5.0% | 217.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 4.3% | 188.8ms | 4.3% | 188.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 4.3% | 187.8ms | 4.7% | 205.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 4.0% | 176.2ms | 7.5% | 324.9ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 4.0% | 176.0ms | 4.0% | 176.0ms | `push` | `[native code]` |
| 3.4% | 148.7ms | 3.4% | 148.7ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 2.8% | 121.0ms | 3.8% | 166.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 2.4% | 106.4ms | 2.4% | 106.4ms | `Set` | `[native code]` |
| 2.4% | 103.7ms | 2.4% | 103.7ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 2.3% | 100.5ms | 2.3% | 100.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1174` |
| 2.0% | 89.8ms | 13.5% | 584.6ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2908` |
| 1.8% | 80.2ms | 1.8% | 80.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 1.6% | 69.3ms | 1.6% | 69.3ms | `parse` | `[native code]` |
| 1.1% | 51.5ms | 1.1% | 51.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 1.1% | 48.8ms | 1.1% | 51.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 1.0% | 45.1ms | 1.0% | 45.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 0.7% | 32.5ms | 2.9% | 129.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.6% | 26.8ms | 0.6% | 30.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 0.5% | 21.7ms | 0.6% | 29.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.4% | 20.4ms | 0.4% | 20.4ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4060` |
| 0.4% | 19.6ms | 0.4% | 21.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3993` |
| 0.4% | 18.6ms | 0.7% | 32.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.4% | 18.0ms | 0.4% | 18.0ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.3% | 14.7ms | 1.5% | 69.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.3% | 14.7ms | 0.3% | 14.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.3% | 14.4ms | 0.7% | 34.2ms | `anonymous` | `[native code]` |
| 0.3% | 13.8ms | 0.3% | 13.8ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.3% | 13.4ms | 0.3% | 13.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3990` |
| 0.2% | 12.0ms | 0.2% | 12.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4010` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.2% | 11.3ms | 40.3% | 1.74s | `some` | `[native code]` |
| 0.2% | 11.2ms | 0.2% | 11.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.2% | 11.2ms | 1.0% | 45.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.2% | 10.2ms | 0.2% | 10.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.2% | 10.0ms | 0.2% | 10.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.2% | 9.2ms | 0.2% | 12.6ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.2% | 9.1ms | 2.6% | 115.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.2% | 9.1ms | 0.6% | 27.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.2% | 8.8ms | 0.2% | 10.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.2% | 8.7ms | 0.2% | 8.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.1% | 8.5ms | 0.2% | 10.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.1% | 8.3ms | 0.1% | 8.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3985` |
| 0.1% | 8.0ms | 0.2% | 12.9ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.1% | 7.7ms | 0.3% | 15.3ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3887` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.1% | 7.5ms | 1.6% | 69.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.1% | 7.4ms | 0.2% | 10.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.1% | 7.0ms | 27.8% | 1.20s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.1% | 6.2ms | 2.4% | 104.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.1% | 5.8ms | 0.1% | 8.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.1% | 5.6ms | 36.7% | 1.58s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.1% | 5.4ms | 0.1% | 5.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.1% | 5.0ms | 4.3% | 189.5ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.9ms | 0.2% | 10.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.1% | 4.7ms | 0.3% | 17.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.1% | 4.7ms | 0.1% | 7.6ms | `map` | `[native code]` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.5ms | 0.1% | 6.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 4.4ms | 0.1% | 7.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2783` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1221` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `test` | `[native code]` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 3.9ms | 0.2% | 9.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.3ms | 0.1% | 6.7ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `set` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.0% | 3.1ms | 0.3% | 14.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.0% | 3.0ms | 0.5% | 25.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.0% | 3.0ms | 100.0% | 8.59s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.0% | 2.8ms | 0.0% | 4.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4248` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `charCodeAt` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `setName` | `node:fs:616` |
| 0.0% | 1.7ms | 0.1% | 7.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.0% | 1.7ms | 0.0% | 3.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.7ms | 0.1% | 8.0ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2811` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.1% | 6.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1284` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` |
| 0.0% | 1.6ms | 0.1% | 7.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.6ms | 0.1% | 7.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1989` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:449` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `has` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 4.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6645` |
| 0.0% | 1.5ms | 0.1% | 7.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1226` |
| 0.0% | 1.5ms | 0.2% | 10.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` |
| 0.0% | 1.5ms | 0.3% | 14.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.0% | 1.4ms | 0.0% | 3.1ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6707` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:429` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1675` |
| 0.0% | 1.4ms | 0.1% | 6.1ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1787` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `dlopen` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 2.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `create` | `[native code]` |
| 0.0% | 1.3ms | 0.3% | 14.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` |
| 0.0% | 1.3ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `slice` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:796` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1227` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `decode` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 8.59s | 0.0% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 4.32s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 100.0% | 4.32s | 0.0% | 0us | `parseModule` | `[native code]` |
| 99.9% | 4.31s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.9% | 4.31s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 97.8% | 4.22s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` |
| 92.7% | 4.00s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 90.1% | 3.89s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 90.1% | 3.89s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` |
| 88.1% | 3.80s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 40.3% | 1.74s | 0.2% | 11.3ms | `some` | `[native code]` |
| 36.7% | 1.58s | 0.1% | 5.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 35.2% | 1.52s | 15.5% | 672.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 27.8% | 1.20s | 0.1% | 7.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 22.4% | 971.0ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 22.3% | 966.7ms | 0.0% | 0us | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 22.3% | 966.7ms | 0.0% | 0us | `forEach` | `[native code]` |
| 21.3% | 923.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 20.2% | 873.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 19.5% | 845.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 13.5% | 584.6ms | 2.0% | 89.8ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2908` |
| 9.2% | 401.8ms | 9.2% | 401.8ms | `getUint32` | `[native code]` |
| 8.6% | 375.7ms | 8.6% | 375.7ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 7.5% | 324.9ms | 4.0% | 176.2ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 5.4% | 233.9ms | 5.4% | 233.9ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 5.2% | 225.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 5.0% | 217.8ms | 4.6% | 199.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 4.7% | 205.1ms | 4.3% | 187.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 4.3% | 189.5ms | 0.1% | 5.0ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 4.3% | 188.8ms | 4.3% | 188.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 4.0% | 176.0ms | 4.0% | 176.0ms | `push` | `[native code]` |
| 3.8% | 166.2ms | 2.8% | 121.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 3.4% | 148.7ms | 3.4% | 148.7ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 2.9% | 129.1ms | 0.7% | 32.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 2.6% | 115.6ms | 0.2% | 9.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 2.4% | 106.4ms | 2.4% | 106.4ms | `Set` | `[native code]` |
| 2.4% | 104.5ms | 0.1% | 6.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 2.4% | 103.7ms | 2.4% | 103.7ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 2.3% | 100.5ms | 2.3% | 100.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1174` |
| 1.9% | 83.1ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` |
| 1.9% | 83.1ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 1.8% | 80.2ms | 1.8% | 80.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 1.6% | 72.0ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 1.6% | 71.4ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` |
| 1.6% | 69.5ms | 0.1% | 7.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 1.6% | 69.3ms | 1.6% | 69.3ms | `parse` | `[native code]` |
| 1.5% | 69.0ms | 0.3% | 14.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 1.5% | 67.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 1.1% | 51.6ms | 1.1% | 48.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 1.1% | 51.5ms | 1.1% | 51.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 1.0% | 45.4ms | 0.2% | 11.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 1.0% | 45.1ms | 1.0% | 45.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 0.9% | 40.5ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 0.8% | 38.6ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 0.8% | 35.6ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.8% | 35.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.8% | 34.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.7% | 34.2ms | 0.3% | 14.4ms | `anonymous` | `[native code]` |
| 0.7% | 32.1ms | 0.4% | 18.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.7% | 30.6ms | 0.0% | 0us | `require` | `[native code]` |
| 0.6% | 30.1ms | 0.6% | 26.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 0.6% | 29.2ms | 0.5% | 21.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.6% | 27.0ms | 0.2% | 9.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.6% | 26.6ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` |
| 0.5% | 25.1ms | 0.0% | 3.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.4% | 21.0ms | 0.4% | 19.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3993` |
| 0.4% | 20.4ms | 0.4% | 20.4ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4060` |
| 0.4% | 19.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` |
| 0.4% | 18.0ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.4% | 18.0ms | 0.4% | 18.0ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.4% | 17.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` |
| 0.3% | 17.0ms | 0.1% | 4.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.3% | 16.9ms | 0.0% | 0us | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.3% | 15.4ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 0.3% | 15.3ms | 0.1% | 7.7ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3887` |
| 0.3% | 15.3ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4066` |
| 0.3% | 15.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 0.3% | 14.7ms | 0.3% | 14.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.3% | 14.6ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.3% | 14.5ms | 0.0% | 3.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 0.3% | 14.2ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.3% | 13.8ms | 0.3% | 13.8ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.3% | 13.4ms | 0.3% | 13.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3990` |
| 0.2% | 12.9ms | 0.1% | 8.0ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.2% | 12.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` |
| 0.2% | 12.6ms | 0.2% | 9.2ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.2% | 12.0ms | 0.2% | 12.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4010` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.2% | 11.2ms | 0.2% | 11.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.2% | 11.2ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` |
| 0.2% | 10.9ms | 0.1% | 4.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.2% | 10.7ms | 0.0% | 1.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 0.2% | 10.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.2% | 10.5ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 0.2% | 10.5ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 0.2% | 10.4ms | 0.2% | 8.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.2% | 10.2ms | 0.1% | 7.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.2% | 10.2ms | 0.1% | 8.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.2% | 10.2ms | 0.2% | 10.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.2% | 10.0ms | 0.2% | 10.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.2% | 9.9ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.2% | 9.6ms | 0.0% | 3.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.2% | 8.7ms | 0.2% | 8.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.1% | 8.3ms | 0.1% | 8.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3985` |
| 0.1% | 8.3ms | 0.1% | 5.8ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.1% | 8.0ms | 0.0% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.1% | 7.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.1% | 7.8ms | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.1% | 7.7ms | 0.0% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.1% | 7.6ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` |
| 0.1% | 7.6ms | 0.1% | 4.7ms | `map` | `[native code]` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.1% | 7.5ms | 0.1% | 4.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.1% | 7.5ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.1% | 7.2ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.1% | 6.7ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.1% | 6.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.1% | 6.7ms | 0.0% | 3.3ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 6.4ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.1% | 6.1ms | 0.0% | 1.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.1% | 6.1ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.1% | 6.1ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.1% | 6.1ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.1% | 6.0ms | 0.1% | 4.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 5.7ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.1% | 5.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1679` |
| 0.1% | 5.5ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.1% | 5.4ms | 0.1% | 5.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.8ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2783` |
| 0.0% | 4.2ms | 0.0% | 1.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.0% | 4.1ms | 0.0% | 2.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1221` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `test` | `[native code]` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 3.9ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.0% | 3.9ms | 0.0% | 0us | `exec` | `[native code]` |
| 0.0% | 3.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 3.3ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` |
| 0.0% | 3.3ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 3.3ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1336` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `set` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.0% | 3.1ms | 0.0% | 1.4ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.0% | 3.1ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.0% | 3.0ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` |
| 0.0% | 3.0ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.0% | 3.0ms | 0.0% | 1.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 2.9ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.0% | 2.9ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 2.6ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` |
| 0.0% | 2.6ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.0% | 2.6ms | 0.0% | 1.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4248` |
| 0.0% | 2.4ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.0% | 2.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.7ms | 0.0% | 0us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `charCodeAt` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:fs` | `node:fs:649` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `setName` | `node:fs:616` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2811` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1284` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 1.6ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` |
| 0.0% | 1.6ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 1.6ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4038` |
| 0.0% | 1.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.0% | 1.6ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1989` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` |
| 0.0% | 1.6ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:449` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `has` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6645` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1226` |
| 0.0% | 1.5ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2164` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` |
| 0.0% | 1.5ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.5ms | 0.0% | 0us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1755` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6707` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:429` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1675` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1787` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4299` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `dlopen` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 1.4ms | 0.0% | 0us | `tryParse` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` |
| 0.0% | 1.4ms | 0.0% | 0us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` |
| 0.0% | 1.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.4ms | 0.0% | 0us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7467` |
| 0.0% | 1.4ms | 0.0% | 0us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 1.3ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` |
| 0.0% | 1.3ms | 0.0% | 0us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `create` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `slice` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:796` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1698` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1227` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.0% | 1.1ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.0% | 1.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `decode` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |

## Function Details

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 15.5% (672.7ms) | Total: 35.2% (1.52s) | Samples: 445

**Called by:**
- `some` (1003)

**Calls:**
- `get type` (228)
- `get type` (145)
- `get parent` (121)
- `get parent` (61)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `getUint32`
`[native code]` | Self: 9.2% (401.8ms) | Total: 9.2% (401.8ms) | Samples: 267

**Called by:**
- `init` (261)
- `_isChainNode` (5)
- `get left` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 8.6% (375.7ms) | Total: 8.6% (375.7ms) | Samples: 247

**Called by:**
- `(anonymous)` (228)
- `isForInOfRef` (4)
- `collectUnusedVariables` (3)
- `isForInOfRef` (3)
- `getRhsNode` (2)
- `collectUnusedVariables` (2)
- `isReadForItself` (1)
- `(anonymous)` (1)
- `isReadForItself` (1)
- `isForInOfRef` (1)
- `_computeIsStrict` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 5.4% (233.9ms) | Total: 5.4% (233.9ms) | Samples: 153

**Called by:**
- `(anonymous)` (145)
- `collectUnusedVariables` (2)
- `isReadForItself` (1)
- `collectUnusedVariables` (1)
- `isReadForItself` (1)
- `getRhsNode` (1)
- `isForInOfRef` (1)
- `_buildReference` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` | Self: 4.6% (199.8ms) | Total: 5.0% (217.8ms) | Samples: 133

**Called by:**
- `runPlugins` (145)

**Calls:**
- `get allSkipped` (9)
- `get allSkipped` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` | Self: 4.3% (188.8ms) | Total: 4.3% (188.8ms) | Samples: 122

**Called by:**
- `isAfterLastUsedArg` (122)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` | Self: 4.3% (187.8ms) | Total: 4.7% (205.1ms) | Samples: 125

**Called by:**
- `(anonymous)` (121)
- `_buildReference` (9)
- `collectUnusedVariables` (3)
- `_findDefNode` (2)
- `_computeVarDefs` (1)

**Calls:**
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `nodeView` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 4.0% (176.2ms) | Total: 7.5% (324.9ms) | Samples: 116

**Called by:**
- `(anonymous)` (214)
- `(anonymous)` (2)

**Calls:**
- `nodeRhs` (100)

### `push`
`[native code]` | Self: 4.0% (176.0ms) | Total: 4.0% (176.0ms) | Samples: 112

**Called by:**
- `getDeclaredVariables` (62)
- `getDeclaredVariables` (29)
- `getDeclaredVariables` (21)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` | Self: 3.4% (148.7ms) | Total: 3.4% (148.7ms) | Samples: 100

**Called by:**
- `init` (100)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 2.8% (121.0ms) | Total: 3.8% (166.2ms) | Samples: 80

**Called by:**
- `isAfterLastUsedArg` (109)

**Calls:**
- `push` (29)

### `Set`
`[native code]` | Self: 2.4% (106.4ms) | Total: 2.4% (106.4ms) | Samples: 71

**Called by:**
- `getDeclaredVariables` (71)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` | Self: 2.4% (103.7ms) | Total: 2.4% (103.7ms) | Samples: 68

**Called by:**
- `init` (67)
- `nodeView` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1174` | Self: 2.3% (100.5ms) | Total: 2.3% (100.5ms) | Samples: 66

**Called by:**
- `(anonymous)` (61)
- `isReadForItself` (2)
- `getRhsNode` (1)
- `isForInOfRef` (1)
- `collectUnusedVariables` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2908` | Self: 2.0% (89.8ms) | Total: 13.5% (584.6ms) | Samples: 60

**Called by:**
- `(anonymous)` (387)
- `(anonymous)` (1)

**Calls:**
- `getUint32` (261)
- `nodeLhs` (67)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` | Self: 1.8% (80.2ms) | Total: 1.8% (80.2ms) | Samples: 53

**Called by:**
- `isAfterLastUsedArg` (51)
- `isAfterLastUsedArg` (2)

### `parse`
`[native code]` | Self: 1.6% (69.3ms) | Total: 1.6% (69.3ms) | Samples: 46

**Called by:**
- `parseSource` (45)
- `tryParse` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 1.1% (51.5ms) | Total: 1.1% (51.5ms) | Samples: 34

**Called by:**
- `_precomputeScopes` (34)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 1.1% (48.8ms) | Total: 1.1% (51.6ms) | Samples: 33

**Called by:**
- `(anonymous)` (35)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` | Self: 1.0% (45.1ms) | Total: 1.0% (45.1ms) | Samples: 30

**Called by:**
- `runPlugins` (30)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.7% (32.5ms) | Total: 2.9% (129.1ms) | Samples: 21

**Called by:**
- `isAfterLastUsedArg` (83)

**Calls:**
- `push` (62)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` | Self: 0.6% (26.8ms) | Total: 0.6% (30.1ms) | Samples: 18

**Called by:**
- `isAfterLastUsedArg` (20)

**Calls:**
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.5% (21.7ms) | Total: 0.6% (29.2ms) | Samples: 14

**Called by:**
- `isAfterLastUsedArg` (19)

**Calls:**
- `_buildVariable` (3)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4060` | Self: 0.4% (20.4ms) | Total: 0.4% (20.4ms) | Samples: 13

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (2)
- `getRhsNode` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3993` | Self: 0.4% (19.6ms) | Total: 0.4% (21.0ms) | Samples: 12

**Called by:**
- `_buildReference` (9)
- `get parent` (2)
- `_nodesFromRange` (1)
- `_computeVarDefs` (1)

**Calls:**
- `create` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` | Self: 0.4% (18.6ms) | Total: 0.7% (32.1ms) | Samples: 11

**Called by:**
- `isAfterLastUsedArg` (19)

**Calls:**
- `defs` (7)
- `get defs` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.4% (18.0ms) | Total: 0.4% (18.0ms) | Samples: 12

**Called by:**
- `getRhsNode` (12)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.3% (14.7ms) | Total: 1.5% (69.0ms) | Samples: 10

**Called by:**
- `collectUnusedVariables` (33)
- `Program:exit` (13)

**Calls:**
- `get` (27)
- `get` (7)
- `get` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` | Self: 0.3% (14.7ms) | Total: 0.3% (14.7ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `anonymous`
`[native code]` | Self: 0.3% (14.4ms) | Total: 0.7% (34.2ms) | Samples: 10

**Called by:**
- `require` (22)
- `bound require` (2)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` | Self: 0.3% (13.8ms) | Total: 0.3% (13.8ms) | Samples: 9

**Called by:**
- `walkNodes` (9)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3990` | Self: 0.3% (13.4ms) | Total: 0.3% (13.4ms) | Samples: 9

**Called by:**
- `get parent` (3)
- `get body` (2)
- `_computeVarDefs` (2)
- `_buildReference` (1)
- `_nodesFromRange` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4010` | Self: 0.2% (12.0ms) | Total: 0.2% (12.0ms) | Samples: 8

**Called by:**
- `get parent` (4)
- `_buildReference` (2)
- `_nodesFromRange` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` | Self: 0.2% (11.8ms) | Total: 0.2% (11.8ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `some`
`[native code]` | Self: 0.2% (11.3ms) | Total: 40.3% (1.74s) | Samples: 7

**Called by:**
- `collectUnusedVariables` (1003)
- `isUsedVariable` (116)
- `collectUnusedVariables` (19)
- `isAfterLastUsedArg` (10)

**Calls:**
- `(anonymous)` (1003)
- `(anonymous)` (69)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (9)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` | Self: 0.2% (11.2ms) | Total: 0.2% (11.2ms) | Samples: 7

**Called by:**
- `isAfterLastUsedArg` (7)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` | Self: 0.2% (11.2ms) | Total: 1.0% (45.4ms) | Samples: 7

**Called by:**
- `isAfterLastUsedArg` (28)

**Calls:**
- `push` (21)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` | Self: 0.2% (10.2ms) | Total: 0.2% (10.2ms) | Samples: 7

**Called by:**
- `isAfterLastUsedArg` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` | Self: 0.2% (10.1ms) | Total: 0.2% (10.1ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` | Self: 0.2% (10.0ms) | Total: 0.2% (10.0ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.2% (9.2ms) | Total: 0.2% (12.6ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `getDeclaredVariables` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.2% (9.1ms) | Total: 2.6% (115.6ms) | Samples: 6

**Called by:**
- `isAfterLastUsedArg` (77)

**Calls:**
- `Set` (71)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (9.1ms) | Total: 0.6% (27.0ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (18)

**Calls:**
- `get type` (3)
- `get parent` (3)
- `get type` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.2% (9.1ms) | Total: 0.2% (9.1ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.2% (8.8ms) | Total: 0.2% (10.4ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `get eslintUsed` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` | Self: 0.2% (8.7ms) | Total: 0.2% (8.7ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (6)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.1% (8.5ms) | Total: 0.2% (10.2ms) | Samples: 5

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get type` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3985` | Self: 0.1% (8.3ms) | Total: 0.1% (8.3ms) | Samples: 6

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.1% (8.0ms) | Total: 0.2% (12.9ms) | Samples: 5

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `get type` (2)
- `get type` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `isReadForItself` (4)
- `getRhsNode` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3887` | Self: 0.1% (7.7ms) | Total: 0.3% (15.3ms) | Samples: 5

**Called by:**
- `nodeViewChain` (10)

**Calls:**
- `getUint32` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.1% (7.5ms) | Total: 1.6% (69.5ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (36)
- `(anonymous)` (6)
- `isUsedVariable` (3)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_buildReference` (17)
- `_buildReference` (10)
- `_buildReference` (10)
- `_buildReference` (2)
- `_buildReference` (1)
- `_buildReference` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.1% (7.4ms) | Total: 0.2% (10.2ms) | Samples: 5

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get type` (1)
- `get type` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.1% (7.2ms) | Total: 0.1% (7.2ms) | Samples: 5

**Called by:**
- `commentsInRange` (3)
- `commentsInRange` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.1% (7.0ms) | Total: 27.8% (1.20s) | Samples: 5

**Called by:**
- `collectUnusedVariables` (796)
- `Program:exit` (3)

**Calls:**
- `isUsedVariable` (645)
- `isUsedVariable` (125)
- `some` (19)
- `isUsedVariable` (4)
- `isUsedVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.1% (6.2ms) | Total: 2.4% (104.5ms) | Samples: 4

**Called by:**
- `some` (69)

**Calls:**
- `getRhsNode` (35)
- `getRhsNode` (12)
- `getRhsNode` (8)
- `getRhsNode` (4)
- `getRhsNode` (3)
- `getRhsNode` (2)
- `getRhsNode` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.1% (5.8ms) | Total: 0.1% (8.3ms) | Samples: 4

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get type` (1)
- `get type` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.1% (5.6ms) | Total: 36.7% (1.58s) | Samples: 4

**Called by:**
- `collectUnusedVariables` (1047)

**Calls:**
- `some` (1003)
- `get references` (36)
- `get references` (3)
- `get references` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` | Self: 0.1% (5.4ms) | Total: 0.1% (5.4ms) | Samples: 4

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (5.0ms) | Total: 4.3% (189.5ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (125)

**Calls:**
- `some` (116)
- `get references` (3)
- `get references` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (1)
- `_computeVarDefs` (1)
- `collectUnusedVariables` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.1% (4.9ms) | Total: 0.2% (10.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get type` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.1% (4.7ms) | Total: 0.3% (17.0ms) | Samples: 3

**Called by:**
- `forEach` (11)

**Calls:**
- `nodeViewChain` (2)
- `get type` (2)
- `nodeViewChain` (1)
- `init` (1)
- `get type` (1)
- `_nodeViewRaw` (1)

### `map`
`[native code]` | Self: 0.1% (4.7ms) | Total: 0.1% (7.6ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (5)

**Calls:**
- `(anonymous)` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (3)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `commentsInRange` (2)
- `commentsInRange` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.1% (4.5ms) | Total: 0.1% (6.0ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `get type` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (3)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.1% (4.4ms) | Total: 0.1% (7.5ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (5)

**Calls:**
- `set` (2)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `isUsedVariable` (3)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2783` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 2

**Called by:**
- `get defs` (1)
- `defs` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `isUsedVariable` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1221` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `getRhsNode` (1)
- `_buildReference` (1)
- `collectUnusedVariables` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `test`
`[native code]` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (3.9ms) | Total: 0.0% (3.9ms) | Samples: 3

**Called by:**
- `exec` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.0% (3.9ms) | Total: 0.2% (9.6ms) | Samples: 3

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get type` (3)
- `get type` (1)

### `eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `isUsedVariable` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `get parent` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.0% (3.3ms) | Total: 0.1% (6.7ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `eslintUsed` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `set`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` | Self: 0.0% (3.1ms) | Total: 0.3% (14.5ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (10)

**Calls:**
- `_ensureDeclSymIndex` (6)
- `_ensureDeclSymIndex` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (3.0ms) | Total: 0.5% (25.1ms) | Samples: 2

**Called by:**
- `forEach` (17)

**Calls:**
- `_nodeViewRaw` (5)
- `nodeViewChain` (4)
- `get type` (2)
- `init` (2)
- `nodeViewChain` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (3.0ms) | Total: 100.0% (8.59s) | Samples: 2

**Called by:**
- `collectUnusedVariables` (3143)
- `Program:exit` (2491)

**Calls:**
- `collectUnusedVariables` (3143)
- `collectUnusedVariables` (1047)
- `collectUnusedVariables` (796)
- `collectUnusedVariables` (567)
- `collectUnusedVariables` (33)
- `collectUnusedVariables` (18)
- `collectUnusedVariables` (7)
- `collectUnusedVariables` (5)
- `collectUnusedVariables` (5)
- `collectUnusedVariables` (5)
- `collectUnusedVariables` (4)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `get references` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` | Self: 0.0% (2.8ms) | Total: 0.0% (4.1ms) | Samples: 2

**Called by:**
- `_ensureChildren` (3)

**Calls:**
- `_buildScope` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `collectUnusedVariables` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `isReadForItself` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `getScope` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4248` | Self: 0.0% (2.4ms) | Total: 0.0% (2.4ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `charCodeAt`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_identAt` (1)

### `setName`
`node:fs:616` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `node:fs` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (1.7ms) | Total: 0.1% (7.5ms) | Samples: 1

**Called by:**
- `getScope` (5)

**Calls:**
- `test` (3)
- `/^\s*exported\b/` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.0% (1.7ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isRead` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.0% (1.7ms) | Total: 0.1% (8.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (3)
- `(anonymous)` (2)

**Calls:**
- `_computeVariableSynthRefs` (2)
- `_computeVariableSynthRefs` (2)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2811` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `scope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (1.7ms) | Total: 0.1% (6.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `nodeViewChain` (2)
- `get right` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1284` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeVarScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (1.6ms) | Total: 0.1% (7.2ms) | Samples: 1

**Called by:**
- `some` (5)

**Calls:**
- `isReadRef` (3)
- `isRead` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (1.6ms) | Total: 0.1% (7.8ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `isFunction` (1)
- `isFunction` (1)
- `get parent` (1)
- `isFunction` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1989` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:449` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `has`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.0% (1.6ms) | Total: 0.0% (4.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get parent` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6645` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.0% (1.5ms) | Total: 0.1% (7.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `get type` (2)
- `get type` (1)
- `get parent` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get name` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1226` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` | Self: 0.0% (1.5ms) | Total: 0.2% (10.7ms) | Samples: 1

**Called by:**
- `defs` (6)
- `get defs` (1)

**Calls:**
- `_findDefNode` (4)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.0% (1.5ms) | Total: 0.3% (14.6ms) | Samples: 1

**Called by:**
- `get references` (10)

**Calls:**
- `_buildScope` (7)
- `_buildScope` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (1.4ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_ensureVarsSet` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6707` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:429` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1675` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.0% (1.4ms) | Total: 0.1% (6.1ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (4)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1787` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` | Self: 0.0% (1.4ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `get references` (2)

**Calls:**
- `get type` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `get end`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `create`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (1.3ms) | Total: 0.3% (14.2ms) | Samples: 1

**Called by:**
- `some` (9)

**Calls:**
- `get references` (6)
- `get references` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` | Self: 0.0% (1.3ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `map` (2)

**Calls:**
- `get name` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `slice`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `_symName` (2)

**Calls:**
- `slice` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:796` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get body` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1227` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `some` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get references` (1)

### `decode`
`[native code]` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `get source` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.2% (9.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `bound require` (7)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (5)

**Calls:**
- `map` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2164` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.2% (10.7ms) | Samples: 0

**Called by:**
- `some` (7)

**Calls:**
- `isSelfReference` (6)
- `isSelfReference` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` | Self: 0.0% (0us) | Total: 1.9% (83.1ms) | Samples: 0

**Called by:**
- `Program:exit` (56)

**Calls:**
- `_precomputeScopes` (48)
- `_precomputeScopes` (5)
- `_precomputeScopes` (2)
- `_precomputeScopes` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isInside` (4)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 5.2% (225.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (149)

**Calls:**
- `runPlugins` (147)
- `runPlugins` (1)
- `runPlugins` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `decode` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7467` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `buildVisitorMap` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` | Self: 0.0% (0us) | Total: 0.1% (5.7ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (3)
- `_findLineIdx` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (2)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `ensureBufferBytes` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 1.9% (83.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (56)

**Calls:**
- `getScope` (56)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1679` | Self: 0.0% (0us) | Total: 0.1% (5.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `_nodesFromRange` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` | Self: 0.0% (0us) | Total: 0.6% (26.6ms) | Samples: 0

**Called by:**
- `get references` (17)

**Calls:**
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.1% (6.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (0us) | Total: 90.1% (3.89s) | Samples: 0

**Called by:**
- `runPlugins` (2564)

**Calls:**
- `_invokeFused` (2564)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get left` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.9% (4.31s) | Samples: 0

**Called by:**
- `parseModule` (2846)

**Calls:**
- `async (anonymous)` (2846)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4066` | Self: 0.0% (0us) | Total: 0.3% (15.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `_isChainNode` (10)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` | Self: 0.0% (0us) | Total: 97.8% (4.22s) | Samples: 0

**Called by:**
- `async (anonymous)` (2640)
- `async (anonymous)` (147)

**Calls:**
- `walkNodes` (2564)
- `walkNodes` (145)
- `walkNodes` (30)
- `walkNodes` (12)
- `walkNodes` (9)
- `walkNodes` (8)
- `walkNodes` (7)
- `walkNodes` (5)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` | Self: 0.0% (0us) | Total: 90.1% (3.89s) | Samples: 0

**Called by:**
- `walkNodes` (2564)

**Calls:**
- `Program:exit` (2507)
- `Program:exit` (56)
- `Program:exit` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4299` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `describeRule` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4038` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `nodeLhs` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `get defs` (1)
- `defs` (1)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `get end` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 0.3% (15.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (10)

**Calls:**
- `some` (10)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 92.7% (4.00s) | Samples: 0

**Called by:**
- `async (anonymous)` (2640)

**Calls:**
- `runPlugins` (2640)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 0.8% (35.6ms) | Samples: 0

**Called by:**
- `some` (23)

**Calls:**
- `isForInOfRef` (7)
- `isForInOfRef` (7)
- `isForInOfRef` (6)
- `isForInOfRef` (2)
- `isForInOfRef` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `_getPlugin` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `_encodeSource` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get name` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.1% (6.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (0us) | Total: 0.3% (16.9ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (7)
- `collectUnusedVariables` (3)
- `get identifiers` (1)

**Calls:**
- `_computeVarDefs` (6)
- `_computeVarDefs` (3)
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` | Self: 0.0% (0us) | Total: 0.2% (12.7ms) | Samples: 0

**Called by:**
- `_buildScope` (6)
- `_buildReference` (2)
- `_buildScopeChildren` (1)

**Calls:**
- `_computeIsStrict` (8)
- `_computeIsStrict` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.9% (4.31s) | Samples: 0

**Called by:**
- `(anonymous)` (2846)

**Calls:**
- `async (anonymous)` (2640)
- `async (anonymous)` (149)
- `async (anonymous)` (47)
- `async (anonymous)` (7)
- `async (anonymous)` (2)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `AstView` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `get name` (1)

**Calls:**
- `charCodeAt` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` | Self: 0.0% (0us) | Total: 0.0% (3.9ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `exec` (3)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `_execReport` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `scope` (1)

**Calls:**
- `_buildScope` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get identifiers` (1)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_getPlugin` (1)

**Calls:**
- `tryParse` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `report` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 22.3% (966.7ms) | Samples: 0

**Called by:**
- `getFunctionDefinitions` (642)

**Calls:**
- `(anonymous)` (613)
- `(anonymous)` (17)
- `(anonymous)` (11)
- `(anonymous)` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1336` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `(anonymous)` (1)

**Calls:**
- `_identAt` (1)
- `_resolveUnicodeEscapes` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 1.6% (72.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (47)

**Calls:**
- `parseSource` (45)
- `parseSource` (1)
- `parseSource` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.7% (30.6ms) | Samples: 0

**Called by:**
- `bound require` (22)

**Calls:**
- `anonymous` (22)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (2)

**Calls:**
- `_buildSymNameCache` (2)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (4.32s) | Samples: 0

**Calls:**
- `parseModule` (2848)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` | Self: 0.0% (0us) | Total: 0.4% (19.7ms) | Samples: 0

**Called by:**
- `_buildReference` (7)
- `_buildScope` (7)

**Calls:**
- `_buildScope` (7)
- `_buildScope` (6)
- `_buildScope` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 88.1% (3.80s) | Samples: 0

**Called by:**
- `_invokeFused` (2507)

**Calls:**
- `collectUnusedVariables` (2491)
- `collectUnusedVariables` (13)
- `collectUnusedVariables` (3)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 0.2% (10.5ms) | Samples: 0

**Called by:**
- `get` (7)

**Calls:**
- `_buildScopeChildren` (3)
- `_buildScopeChildren` (2)
- `_buildScopeChildren` (1)
- `_buildScopeChildren` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (3.6ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `has` (1)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (3.9ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (3)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (35.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (2)
- `async (anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (22)
- `anonymous` (2)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 1.5% (67.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (45)

**Calls:**
- `parse` (45)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (0us) | Total: 20.2% (873.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (567)

**Calls:**
- `isAfterLastUsedArg` (549)
- `isAfterLastUsedArg` (10)
- `isAfterLastUsedArg` (8)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 0.1% (7.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `defs` (3)
- `get defs` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `tryParse`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_loadFromDisk` (1)

**Calls:**
- `parse` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (2)

**Calls:**
- `_computeVarScope` (1)
- `_computeVarScope` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 22.4% (971.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (645)

**Calls:**
- `getFunctionDefinitions` (642)
- `getFunctionDefinitions` (3)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `get references` (2)

**Calls:**
- `scope` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 0.8% (34.9ms) | Samples: 0

**Called by:**
- `some` (24)

**Calls:**
- `isReadForItself` (7)
- `isReadForItself` (6)
- `isReadForItself` (4)
- `isReadForItself` (3)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `get source` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)
- `getDeclaredVariables` (1)

**Calls:**
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `defs` (3)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `node:fs`
`node:fs:649` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `setName` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadBinding` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `bound require` (2)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (0us) | Total: 0.8% (38.6ms) | Samples: 0

**Called by:**
- `get` (25)
- `_ensureVarsSet` (1)

**Calls:**
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (4.32s) | Samples: 0

**Called by:**
- `async (anonymous)` (2848)

**Calls:**
- `(anonymous)` (2846)
- `(anonymous)` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 0.2% (10.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `_ensureChildren` (7)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1698` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraFnData` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 21.3% (923.2ms) | Samples: 0

**Called by:**
- `forEach` (613)

**Calls:**
- `init` (387)
- `init` (214)
- `nodeViewChain` (7)
- `nodeViewChain` (5)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 19.5% (845.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (549)

**Calls:**
- `getDeclaredVariables` (122)
- `getDeclaredVariables` (109)
- `getDeclaredVariables` (83)
- `getDeclaredVariables` (77)
- `getDeclaredVariables` (51)
- `getDeclaredVariables` (28)
- `getDeclaredVariables` (20)
- `getDeclaredVariables` (19)
- `getDeclaredVariables` (19)
- `getDeclaredVariables` (7)
- `getDeclaredVariables` (7)
- `getDeclaredVariables` (5)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `describeRule` (1)

**Calls:**
- `_loadFromDisk` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get references` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_nodeViewRaw` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 0.9% (40.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (27)

**Calls:**
- `_ensureVarsSet` (25)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.4% (18.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `isInLoop` (12)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` | Self: 0.0% (0us) | Total: 1.6% (71.4ms) | Samples: 0

**Called by:**
- `getScope` (48)

**Calls:**
- `commentsInRange` (34)
- `commentsInRange` (4)
- `commentsInRange` (4)
- `commentsInRange` (3)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (0us) | Total: 0.3% (15.3ms) | Samples: 0

**Called by:**
- `get references` (10)

**Calls:**
- `get parent` (9)
- `get parent` (1)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1755` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUint32` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `get range` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)
- `bound require` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInside` (1)
- `isInside` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.0% (0us) | Total: 0.1% (5.5ms) | Samples: 0

**Called by:**
- `get body` (4)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` | Self: 0.0% (0us) | Total: 0.2% (11.2ms) | Samples: 0

**Called by:**
- `_buildScope` (8)

**Calls:**
- `get body` (4)
- `get body` (2)
- `get body` (1)
- `get body` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` | Self: 0.0% (0us) | Total: 0.4% (17.5ms) | Samples: 0

**Called by:**
- `runPlugins` (12)

**Calls:**
- `getDFSEvents` (7)
- `getDFSEvents` (5)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (0us) | Total: 22.3% (966.7ms) | Samples: 0

**Called by:**
- `isUsedVariable` (642)

**Calls:**
- `forEach` (642)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 37.4% | 1.61s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 23.0% | 996.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 20.8% | 899.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 18.6% | 805.6ms | `[native code]` |
| 0.0% | 1.7ms | `node:fs` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
