# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.92s | 1924 | 1.0ms | 267 |

**Top 10:** `(anonymous)` 18.3%, `get parent` 6.7%, `walkNodes` 6.2%, `init` 5.8%, `getDeclaredVariables` 5.6%, `push` 5.5%, `nodeRhs` 4.1%, `Set` 3.5%, `getDeclaredVariables` 3.5%, `get parent` 3.5%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 18.3% | 536.4ms | 28.2% | 826.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 6.7% | 196.0ms | 8.0% | 235.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 6.2% | 182.3ms | 7.4% | 217.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 5.8% | 172.0ms | 10.1% | 295.6ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` |
| 5.6% | 165.5ms | 5.7% | 166.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 5.5% | 161.3ms | 5.5% | 161.3ms | `push` | `[native code]` |
| 4.1% | 120.4ms | 4.1% | 120.4ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 3.5% | 104.2ms | 3.5% | 104.2ms | `Set` | `[native code]` |
| 3.5% | 102.7ms | 4.5% | 132.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 3.5% | 102.7ms | 3.5% | 102.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1177` |
| 2.3% | 69.2ms | 2.6% | 78.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 2.3% | 68.6ms | 2.3% | 68.6ms | `parse` | `[native code]` |
| 1.8% | 55.0ms | 1.9% | 56.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 1.7% | 51.3ms | 1.7% | 51.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 1.6% | 49.6ms | 1.6% | 49.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 1.1% | 33.0ms | 1.5% | 46.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 1.0% | 29.8ms | 1.0% | 29.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 0.9% | 28.4ms | 4.1% | 122.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.8% | 26.1ms | 0.8% | 26.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` |
| 0.7% | 22.5ms | 0.7% | 22.5ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.7% | 20.7ms | 0.7% | 22.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.6% | 18.9ms | 0.6% | 18.9ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4066` |
| 0.5% | 16.9ms | 0.5% | 16.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.5% | 15.2ms | 0.5% | 15.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.5% | 14.8ms | 0.8% | 26.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.4% | 14.1ms | 0.4% | 14.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.4% | 13.9ms | 0.4% | 13.9ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.4% | 13.4ms | 0.4% | 13.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.4% | 13.0ms | 4.0% | 117.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.4% | 12.7ms | 0.4% | 12.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3987` |
| 0.4% | 12.6ms | 0.5% | 15.6ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3889` |
| 0.4% | 12.4ms | 1.8% | 54.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.4% | 12.3ms | 0.4% | 12.3ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 12.1ms | 0.5% | 14.8ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.4% | 11.7ms | 1.6% | 49.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.3% | 10.6ms | 34.6% | 1.01s | `some` | `[native code]` |
| 0.3% | 10.6ms | 0.5% | 15.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.3% | 10.5ms | 19.1% | 560.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.3% | 10.4ms | 0.4% | 11.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.3% | 10.1ms | 31.2% | 914.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.3% | 9.9ms | 0.4% | 13.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.3% | 9.8ms | 0.4% | 12.3ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 9.3ms | 0.3% | 9.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.3% | 9.2ms | 0.3% | 9.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.3% | 9.2ms | 0.3% | 9.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.3% | 9.1ms | 0.3% | 10.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.3% | 8.8ms | 0.3% | 8.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.2% | 8.6ms | 0.2% | 8.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.2% | 8.4ms | 1.0% | 30.3ms | `anonymous` | `[native code]` |
| 0.2% | 7.6ms | 0.7% | 21.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.2% | 7.6ms | 0.2% | 7.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 6.9ms | 0.2% | 6.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `test` | `[native code]` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.2% | 6.3ms | 0.7% | 20.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1224` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4016` |
| 0.2% | 6.1ms | 0.3% | 9.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 6.1ms | 0.3% | 10.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 6.0ms | 0.4% | 12.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.2% | 5.9ms | 100.0% | 6.74s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.1% | 5.2ms | 0.1% | 5.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 0.1% | 4.9ms | 0.2% | 6.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `getUint32` | `[native code]` |
| 0.1% | 4.5ms | 0.4% | 13.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4254` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.1% | 3.8ms | 0.1% | 3.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4044` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.2ms | 4.5% | 132.9ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:534` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.1% | 2.9ms | 0.6% | 17.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` |
| 0.0% | 2.9ms | 0.6% | 19.1ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` |
| 0.0% | 2.8ms | 0.1% | 4.5ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 2.8ms | 0.1% | 4.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4014` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3098` |
| 0.0% | 1.8ms | 0.2% | 6.3ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` |
| 0.0% | 1.7ms | 12.1% | 354.1ms | `forEach` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:707` |
| 0.0% | 1.7ms | 0.1% | 3.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 1.7ms | 27.5% | 805.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.0% | 1.7ms | 0.1% | 3.0ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5984` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1229` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2674` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3968` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1276` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.6ms | 0.5% | 17.0ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.0% | 1.6ms | 3.8% | 111.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.0% | 1.5ms | 0.1% | 2.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6500` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `set` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 2.9ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 1.5ms | 0.1% | 2.9ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1748` |
| 0.0% | 1.4ms | 1.2% | 35.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.0% | 1.4ms | 82.2% | 2.40s | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:770` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `slice` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.1% | 3.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` |
| 0.0% | 1.4ms | 0.1% | 5.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1682` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `wordsRegexp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` |
| 0.0% | 1.4ms | 0.0% | 2.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1297` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1386` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1186` |
| 0.0% | 1.2ms | 0.1% | 2.9ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.0% | 1.2ms | 0.1% | 4.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `node:events` | `node:events:163` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `extraMethodData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:695` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 6.74s | 0.2% | 5.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 2.92s | 0.0% | 0us | `parseModule` | `[native code]` |
| 100.0% | 2.92s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 99.8% | 2.92s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 99.8% | 2.92s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 96.8% | 2.83s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` |
| 88.8% | 2.59s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 85.4% | 2.50s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` |
| 85.4% | 2.50s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 82.2% | 2.40s | 0.0% | 1.4ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 34.6% | 1.01s | 0.3% | 10.6ms | `some` | `[native code]` |
| 31.2% | 914.4ms | 0.3% | 10.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 28.2% | 826.2ms | 18.3% | 536.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 27.5% | 805.5ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 26.6% | 778.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 19.1% | 560.6ms | 0.3% | 10.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 12.3% | 360.2ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 12.1% | 354.1ms | 0.0% | 0us | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 12.1% | 354.1ms | 0.0% | 1.7ms | `forEach` | `[native code]` |
| 10.5% | 309.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 10.1% | 295.6ms | 5.8% | 172.0ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` |
| 8.0% | 236.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 8.0% | 235.5ms | 6.7% | 196.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 7.4% | 217.2ms | 6.2% | 182.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 5.7% | 166.8ms | 5.6% | 165.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 5.5% | 161.3ms | 5.5% | 161.3ms | `push` | `[native code]` |
| 4.5% | 132.9ms | 0.1% | 3.2ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 4.5% | 132.8ms | 3.5% | 102.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 4.1% | 122.0ms | 0.9% | 28.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 4.1% | 120.4ms | 4.1% | 120.4ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 4.0% | 117.2ms | 0.4% | 13.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 3.8% | 111.9ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 3.5% | 104.2ms | 3.5% | 104.2ms | `Set` | `[native code]` |
| 3.5% | 102.7ms | 3.5% | 102.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1177` |
| 3.1% | 90.8ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` |
| 3.1% | 90.8ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.6% | 78.5ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 2.6% | 78.2ms | 2.3% | 69.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 2.5% | 74.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 2.4% | 72.3ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` |
| 2.3% | 68.6ms | 2.3% | 68.6ms | `parse` | `[native code]` |
| 2.3% | 68.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 1.9% | 56.6ms | 1.8% | 55.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 1.8% | 54.2ms | 0.4% | 12.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 1.7% | 51.3ms | 1.7% | 51.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 1.6% | 49.6ms | 1.6% | 49.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 1.6% | 49.3ms | 0.4% | 11.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 1.5% | 46.4ms | 1.1% | 33.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 1.2% | 37.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 1.2% | 35.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 1.0% | 30.8ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.0% | 30.3ms | 0.2% | 8.4ms | `anonymous` | `[native code]` |
| 1.0% | 30.0ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 1.0% | 29.8ms | 1.0% | 29.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 0.9% | 27.8ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.8% | 26.3ms | 0.5% | 14.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.8% | 26.1ms | 0.0% | 0us | `require` | `[native code]` |
| 0.8% | 26.1ms | 0.8% | 26.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` |
| 0.8% | 25.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.7% | 22.5ms | 0.7% | 22.5ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.7% | 22.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.7% | 22.3ms | 0.7% | 20.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.7% | 21.5ms | 0.2% | 7.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.7% | 20.8ms | 0.2% | 6.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.6% | 19.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` |
| 0.6% | 19.1ms | 0.0% | 2.9ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.6% | 18.9ms | 0.6% | 18.9ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4066` |
| 0.6% | 18.0ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` |
| 0.6% | 17.8ms | 0.1% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` |
| 0.5% | 17.0ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.5% | 16.9ms | 0.5% | 16.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.5% | 15.6ms | 0.4% | 12.6ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3889` |
| 0.5% | 15.6ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4072` |
| 0.5% | 15.4ms | 0.3% | 10.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.5% | 15.2ms | 0.5% | 15.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.5% | 14.8ms | 0.4% | 12.1ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.4% | 14.1ms | 0.4% | 14.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.4% | 13.9ms | 0.1% | 4.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.4% | 13.9ms | 0.4% | 13.9ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.4% | 13.4ms | 0.4% | 13.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.4% | 13.2ms | 0.3% | 9.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.4% | 12.7ms | 0.4% | 12.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3987` |
| 0.4% | 12.4ms | 0.2% | 6.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.4% | 12.3ms | 0.3% | 9.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.4% | 12.3ms | 0.4% | 12.3ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 12.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` |
| 0.4% | 11.8ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 0.4% | 11.8ms | 0.3% | 10.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.3% | 11.6ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 0.3% | 11.5ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 0.3% | 11.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.3% | 10.9ms | 0.2% | 6.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.3% | 10.5ms | 0.3% | 9.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.3% | 10.3ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.3% | 9.3ms | 0.3% | 9.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.3% | 9.2ms | 0.3% | 9.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.3% | 9.2ms | 0.3% | 9.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.3% | 9.1ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.3% | 9.1ms | 0.2% | 6.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.3% | 9.0ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` |
| 0.3% | 8.8ms | 0.3% | 8.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.2% | 8.6ms | 0.2% | 8.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.2% | 8.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.2% | 7.6ms | 0.2% | 7.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 6.9ms | 0.2% | 6.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `test` | `[native code]` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.2% | 6.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.2% | 6.4ms | 0.1% | 4.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.2% | 6.3ms | 0.0% | 1.8ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1224` |
| 0.2% | 6.2ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.2% | 6.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4016` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 5.9ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.2% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.2% | 5.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.1% | 5.8ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` |
| 0.1% | 5.8ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1682` |
| 0.1% | 5.2ms | 0.1% | 5.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `getUint32` | `[native code]` |
| 0.1% | 4.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.1% | 4.5ms | 0.0% | 2.8ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.1% | 4.5ms | 0.0% | 2.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 4.4ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 4.4ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` |
| 0.1% | 4.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4254` |
| 0.1% | 4.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.1% | 4.1ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.1% | 3.8ms | 0.1% | 3.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.1% | 3.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` |
| 0.1% | 3.4ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4044` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1702` |
| 0.1% | 3.2ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 0.1% | 3.2ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 0.1% | 3.2ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 3.1ms | 0.0% | 1.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:534` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.1% | 3.0ms | 0.0% | 1.7ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.1% | 2.9ms | 0.0% | 1.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.1% | 2.9ms | 0.0% | 1.5ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 2.9ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` |
| 0.1% | 2.9ms | 0.0% | 1.5ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.1% | 2.9ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` |
| 0.0% | 2.9ms | 0.0% | 1.5ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 2.8ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 2.7ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4014` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3098` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:707` |
| 0.0% | 1.7ms | 0.0% | 0us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3930` |
| 0.0% | 1.7ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` |
| 0.0% | 1.7ms | 0.0% | 0us | `SourceCode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1002` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `exec` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.0% | 1.7ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 1.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` |
| 0.0% | 1.7ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.7ms | 0.0% | 0us | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1790` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5984` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1229` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2674` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 1.6ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:634` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3968` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1276` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.6ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.0% | 1.6ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6500` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `set` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` |
| 0.0% | 1.4ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1748` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:770` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `slice` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3982` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `wordsRegexp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1297` |
| 0.0% | 1.4ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` |
| 0.0% | 1.3ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 1.3ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` |
| 0.0% | 1.3ms | 0.0% | 0us | `replace` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.0% | 1.3ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1386` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.0% | 1.2ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1186` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `node:events` | `node:events:163` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `_nodeMods` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:929` |
| 0.0% | 1.2ms | 0.0% | 0us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2669` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `extraMethodData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:695` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1339` |

## Function Details

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 18.3% (536.4ms) | Total: 28.2% (826.2ms) | Samples: 353

**Called by:**
- `some` (541)

**Calls:**
- `get parent` (126)
- `get parent` (54)
- `get parent` (3)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` | Self: 6.7% (196.0ms) | Total: 8.0% (235.5ms) | Samples: 129

**Called by:**
- `(anonymous)` (126)
- `_buildReference` (16)
- `_findDefNode` (7)
- `_computeIsStrict` (3)
- `isForInOfRef` (2)
- `_findDefNode` (1)

**Calls:**
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (3)
- `nodeView` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` | Self: 6.2% (182.3ms) | Total: 7.4% (217.2ms) | Samples: 118

**Called by:**
- `runPlugins` (141)

**Calls:**
- `get allSkipped` (15)
- `get allSkipped` (8)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` | Self: 5.8% (172.0ms) | Total: 10.1% (295.6ms) | Samples: 114

**Called by:**
- `(anonymous)` (193)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `nodeRhs` (79)
- `nodeRhs` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` | Self: 5.6% (165.5ms) | Total: 5.7% (166.8ms) | Samples: 110

**Called by:**
- `isAfterLastUsedArg` (111)

**Calls:**
- `get` (1)

### `push`
`[native code]` | Self: 5.5% (161.3ms) | Total: 5.5% (161.3ms) | Samples: 106

**Called by:**
- `getDeclaredVariables` (61)
- `getDeclaredVariables` (24)
- `getDeclaredVariables` (21)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 4.1% (120.4ms) | Total: 4.1% (120.4ms) | Samples: 79

**Called by:**
- `init` (79)

### `Set`
`[native code]` | Self: 3.5% (104.2ms) | Total: 3.5% (104.2ms) | Samples: 69

**Called by:**
- `getDeclaredVariables` (69)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 3.5% (102.7ms) | Total: 4.5% (132.8ms) | Samples: 68

**Called by:**
- `isAfterLastUsedArg` (89)

**Calls:**
- `push` (21)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1177` | Self: 3.5% (102.7ms) | Total: 3.5% (102.7ms) | Samples: 66

**Called by:**
- `(anonymous)` (54)
- `getRhsNode` (5)
- `isReadForItself` (1)
- `_computeVarDefs` (1)
- `isForInOfRef` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `_buildReference` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 2.3% (69.2ms) | Total: 2.6% (78.2ms) | Samples: 47

**Called by:**
- `(anonymous)` (53)

**Calls:**
- `get parent` (5)
- `get parent` (1)

### `parse`
`[native code]` | Self: 2.3% (68.6ms) | Total: 2.3% (68.6ms) | Samples: 45

**Called by:**
- `parseSource` (45)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` | Self: 1.8% (55.0ms) | Total: 1.9% (56.6ms) | Samples: 37

**Called by:**
- `isAfterLastUsedArg` (36)
- `isAfterLastUsedArg` (2)

**Calls:**
- `set` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` | Self: 1.7% (51.3ms) | Total: 1.7% (51.3ms) | Samples: 33

**Called by:**
- `_precomputeScopes` (33)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` | Self: 1.6% (49.6ms) | Total: 1.6% (49.6ms) | Samples: 33

**Called by:**
- `runPlugins` (33)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` | Self: 1.1% (33.0ms) | Total: 1.5% (46.4ms) | Samples: 21

**Called by:**
- `isAfterLastUsedArg` (30)

**Calls:**
- `defs` (8)
- `get defs` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` | Self: 1.0% (29.8ms) | Total: 1.0% (29.8ms) | Samples: 19

**Called by:**
- `isAfterLastUsedArg` (19)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.9% (28.4ms) | Total: 4.1% (122.0ms) | Samples: 19

**Called by:**
- `isAfterLastUsedArg` (80)

**Calls:**
- `push` (61)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` | Self: 0.8% (26.1ms) | Total: 0.8% (26.1ms) | Samples: 17

**Called by:**
- `get parent` (8)
- `_buildReference` (4)
- `_nodesFromRange` (2)
- `_computeVarDefs` (1)
- `(anonymous)` (1)
- `get body` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` | Self: 0.7% (22.5ms) | Total: 0.7% (22.5ms) | Samples: 15

**Called by:**
- `walkNodes` (15)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.7% (20.7ms) | Total: 0.7% (22.3ms) | Samples: 14

**Called by:**
- `get parent` (8)
- `_buildReference` (4)
- `_buildScope` (2)
- `get body` (1)

**Calls:**
- `_getTypeProto` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4066` | Self: 0.6% (18.9ms) | Total: 0.6% (18.9ms) | Samples: 13

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` | Self: 0.5% (16.9ms) | Total: 0.5% (16.9ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` | Self: 0.5% (15.2ms) | Total: 0.5% (15.2ms) | Samples: 10

**Called by:**
- `isAfterLastUsedArg` (10)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.5% (14.8ms) | Total: 0.8% (26.3ms) | Samples: 10

**Called by:**
- `isAfterLastUsedArg` (18)

**Calls:**
- `_buildVariable` (6)
- `_buildVariable` (2)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.4% (14.1ms) | Total: 0.4% (14.1ms) | Samples: 9

**Called by:**
- `getRhsNode` (9)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` | Self: 0.4% (13.9ms) | Total: 0.4% (13.9ms) | Samples: 9

**Called by:**
- `commentsInRange` (6)
- `commentsInRange` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` | Self: 0.4% (13.4ms) | Total: 0.4% (13.4ms) | Samples: 9

**Called by:**
- `getDeclaredVariables` (6)
- `_buildScopeVarsAndSet` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.4% (13.0ms) | Total: 4.0% (117.2ms) | Samples: 9

**Called by:**
- `isAfterLastUsedArg` (78)

**Calls:**
- `Set` (69)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3987` | Self: 0.4% (12.7ms) | Total: 0.4% (12.7ms) | Samples: 8

**Called by:**
- `get parent` (3)
- `(anonymous)` (2)
- `_computeVariableSynthRefs` (1)
- `getRhsNode` (1)
- `(anonymous)` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3889` | Self: 0.4% (12.6ms) | Total: 0.5% (15.6ms) | Samples: 8

**Called by:**
- `nodeViewChain` (10)

**Calls:**
- `getUint32` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.4% (12.4ms) | Total: 1.8% (54.2ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (22)
- `Program:exit` (13)

**Calls:**
- `get` (24)
- `get` (2)
- `get` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.4% (12.3ms) | Total: 0.4% (12.3ms) | Samples: 8

**Called by:**
- `walkNodes` (8)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.4% (12.1ms) | Total: 0.5% (14.8ms) | Samples: 8

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` | Self: 0.4% (11.7ms) | Total: 1.6% (49.3ms) | Samples: 8

**Called by:**
- `isAfterLastUsedArg` (32)

**Calls:**
- `push` (24)

### `some`
`[native code]` | Self: 0.3% (10.6ms) | Total: 34.6% (1.01s) | Samples: 7

**Called by:**
- `collectUnusedVariables` (541)
- `isUsedVariable` (82)
- `collectUnusedVariables` (35)
- `isAfterLastUsedArg` (8)

**Calls:**
- `(anonymous)` (541)
- `(anonymous)` (75)
- `(anonymous)` (16)
- `(anonymous)` (15)
- `(anonymous)` (8)
- `(anonymous)` (4)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.3% (10.6ms) | Total: 0.5% (15.4ms) | Samples: 7

**Called by:**
- `getScope` (10)

**Calls:**
- `test` (2)
- `/^\s*exported\b/` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.3% (10.5ms) | Total: 19.1% (560.6ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (366)
- `Program:exit` (4)

**Calls:**
- `isUsedVariable` (237)
- `isUsedVariable` (88)
- `some` (35)
- `isUsedVariable` (2)
- `isUsedVariable` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.3% (10.4ms) | Total: 0.4% (11.8ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `get eslintUsed` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.3% (10.1ms) | Total: 31.2% (914.4ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (600)

**Calls:**
- `some` (541)
- `get references` (44)
- `get references` (7)
- `get references` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.3% (9.9ms) | Total: 0.4% (13.2ms) | Samples: 6

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `get parent` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.3% (9.8ms) | Total: 0.4% (12.3ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `getDeclaredVariables` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` | Self: 0.3% (9.3ms) | Total: 0.3% (9.3ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` | Self: 0.3% (9.2ms) | Total: 0.3% (9.2ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` | Self: 0.3% (9.2ms) | Total: 0.3% (9.2ms) | Samples: 6

**Called by:**
- `isAfterLastUsedArg` (6)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.3% (9.1ms) | Total: 0.3% (10.5ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `get parent` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` | Self: 0.3% (8.8ms) | Total: 0.3% (8.8ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` | Self: 0.2% (8.6ms) | Total: 0.2% (8.6ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `anonymous`
`[native code]` | Self: 0.2% (8.4ms) | Total: 1.0% (30.3ms) | Samples: 6

**Called by:**
- `require` (18)
- `bound require` (2)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:events` (1)
- `(anonymous)` (1)
- `node:fs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.2% (7.6ms) | Total: 0.7% (21.5ms) | Samples: 5

**Called by:**
- `forEach` (14)

**Calls:**
- `nodeViewChain` (7)
- `nodeViewChain` (1)
- `init` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (7.6ms) | Total: 0.2% (7.6ms) | Samples: 5

**Called by:**
- `(anonymous)` (3)
- `collectUnusedVariables` (1)
- `_buildReference` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` | Self: 0.2% (6.9ms) | Total: 0.2% (6.9ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `test`
`[native code]` | Self: 0.2% (6.6ms) | Total: 0.2% (6.6ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_precomputeScopes` (2)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.2% (6.3ms) | Total: 0.7% (20.8ms) | Samples: 4

**Called by:**
- `forEach` (14)

**Calls:**
- `nodeViewChain` (6)
- `_nodeViewRaw` (2)
- `nodeViewChain` (1)
- `init` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1224` | Self: 0.2% (6.2ms) | Total: 0.2% (6.2ms) | Samples: 4

**Called by:**
- `(anonymous)` (2)
- `isReadForItself` (1)
- `getRhsNode` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4016` | Self: 0.2% (6.2ms) | Total: 0.2% (6.2ms) | Samples: 4

**Called by:**
- `get parent` (2)
- `_buildScope` (1)
- `_computeVarDefs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (6.1ms) | Total: 0.3% (9.1ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` | Self: 0.2% (6.1ms) | Total: 0.3% (10.9ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `get parent` (1)
- `_computeVarDefs` (1)
- `(anonymous)` (1)
- `_nodesFromRange` (1)

**Calls:**
- `_computeNodeType` (2)
- `_computeNodeType` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.2% (6.0ms) | Total: 0.2% (6.0ms) | Samples: 4

**Called by:**
- `isUsedVariable` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.2% (6.0ms) | Total: 0.4% (12.4ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `isFunction` (2)
- `get parent` (1)
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.2% (5.9ms) | Total: 100.0% (6.74s) | Samples: 4

**Called by:**
- `collectUnusedVariables` (2886)
- `Program:exit` (1567)

**Calls:**
- `collectUnusedVariables` (2886)
- `collectUnusedVariables` (600)
- `collectUnusedVariables` (533)
- `collectUnusedVariables` (366)
- `collectUnusedVariables` (22)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (7)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (4)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` | Self: 0.1% (5.2ms) | Total: 0.1% (5.2ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (2)
- `collectUnusedVariables` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.1% (4.9ms) | Total: 0.2% (6.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get parent` (1)

### `getUint32`
`[native code]` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `_isChainNode` (2)
- `get right` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.1% (4.5ms) | Total: 0.4% (13.9ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (7)
- `(anonymous)` (2)

**Calls:**
- `_computeVariableSynthRefs` (4)
- `_computeVariableSynthRefs` (2)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4254` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `isAfterLastUsedArg` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 0.1% (3.8ms) | Total: 0.1% (3.8ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4044` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `get parent` (2)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (3.2ms) | Total: 4.5% (132.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (88)

**Calls:**
- `some` (82)
- `get references` (3)
- `get references` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:534` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `init` (2)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `getScope` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` | Self: 0.1% (2.9ms) | Total: 0.6% (17.8ms) | Samples: 2

**Called by:**
- `_buildScope` (8)
- `_buildReference` (4)

**Calls:**
- `_computeIsStrict` (6)
- `_computeIsStrict` (4)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (2.9ms) | Total: 0.6% (19.1ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (8)
- `collectUnusedVariables` (3)
- `get identifiers` (1)
- `isAfterLastUsedArg` (1)

**Calls:**
- `_computeVarDefs` (7)
- `_computeVarDefs` (3)
- `_computeVarDefs` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (2.8ms) | Total: 0.1% (4.5ms) | Samples: 2

**Called by:**
- `_computeVariableSynthRefs` (3)

**Calls:**
- `_computeVarScope` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `getRhsNode` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.0% (2.8ms) | Total: 0.1% (4.5ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4014` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `get parent` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3098` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` | Self: 0.0% (1.8ms) | Total: 0.2% (6.3ms) | Samples: 1

**Called by:**
- `get references` (4)

**Calls:**
- `scope` (3)

### `forEach`
`[native code]` | Self: 0.0% (1.7ms) | Total: 12.1% (354.1ms) | Samples: 1

**Called by:**
- `getFunctionDefinitions` (233)

**Calls:**
- `(anonymous)` (204)
- `(anonymous)` (14)
- `(anonymous)` (14)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:707` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `SourceCode` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` | Self: 0.0% (1.7ms) | Total: 0.1% (3.2ms) | Samples: 1

**Called by:**
- `_ensureChildren` (2)

**Calls:**
- `_buildScope` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `exec` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.7ms) | Total: 27.5% (805.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (533)

**Calls:**
- `isAfterLastUsedArg` (515)
- `isAfterLastUsedArg` (8)
- `isAfterLastUsedArg` (8)
- `isAfterLastUsedArg` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isInsideOfStorableFunction` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (1.7ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)
- `getDeclaredVariables` (1)

**Calls:**
- `_computeVarDefs` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5984` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1229` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `scope` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2674` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3968` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1276` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (1.6ms) | Total: 0.5% (17.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `isInLoop` (9)
- `isInLoop` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.0% (1.6ms) | Total: 3.8% (111.9ms) | Samples: 1

**Called by:**
- `some` (75)

**Calls:**
- `getRhsNode` (53)
- `getRhsNode` (11)
- `getRhsNode` (3)
- `getRhsNode` (2)
- `getRhsNode` (2)
- `getRhsNode` (2)
- `getRhsNode` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` | Self: 0.0% (1.5ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `get references` (2)

**Calls:**
- `_nodeViewRaw` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6500` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `set`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (1.5ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `report` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` | Self: 0.0% (1.5ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `_symName` (2)

**Calls:**
- `slice` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1748` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isForInOfRef` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (1.4ms) | Total: 1.2% (35.4ms) | Samples: 1

**Called by:**
- `get` (23)

**Calls:**
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (1.4ms) | Total: 82.2% (2.40s) | Samples: 1

**Called by:**
- `_invokeFused` (1585)

**Calls:**
- `collectUnusedVariables` (1567)
- `collectUnusedVariables` (13)
- `collectUnusedVariables` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:770` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `slice`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` | Self: 0.0% (1.4ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_nodeViewRaw` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1682` | Self: 0.0% (1.4ms) | Total: 0.1% (5.8ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `_nodesFromRange` (3)

### `wordsRegexp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `buildUnicodeData` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` | Self: 0.0% (1.4ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)
- `_buildScopeChildren` (1)

**Calls:**
- `get value` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1297` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `replace` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isUsedVariable` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1386` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1186` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (1.2ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get right` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get references` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (1.2ms) | Total: 0.1% (4.1ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get kind` (1)
- `get kind` (1)

### `node:events`
`node:events:163` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `extraMethodData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:695` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_nodeMods` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get name` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2669` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `_nodeMods` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.2% (8.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (6)

**Calls:**
- `bound require` (6)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isUnusedExpression` (2)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (0us) | Total: 85.4% (2.50s) | Samples: 0

**Called by:**
- `runPlugins` (1647)

**Calls:**
- `_invokeFused` (1647)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.0% (0us) | Total: 0.9% (27.8ms) | Samples: 0

**Called by:**
- `get references` (19)

**Calls:**
- `_buildScope` (11)
- `_buildScope` (4)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 0.3% (11.5ms) | Samples: 0

**Called by:**
- `some` (8)

**Calls:**
- `get references` (6)
- `get references` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.8% (2.92s) | Samples: 0

**Called by:**
- `parseModule` (1922)

**Calls:**
- `async (anonymous)` (1922)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` | Self: 0.0% (0us) | Total: 96.8% (2.83s) | Samples: 0

**Called by:**
- `async (anonymous)` (1708)
- `async (anonymous)` (156)

**Calls:**
- `walkNodes` (1647)
- `walkNodes` (141)
- `walkNodes` (33)
- `walkNodes` (11)
- `walkNodes` (8)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` | Self: 0.0% (0us) | Total: 85.4% (2.50s) | Samples: 0

**Called by:**
- `walkNodes` (1647)

**Calls:**
- `Program:exit` (1585)
- `Program:exit` (59)
- `Program:exit` (2)
- `Program:exit` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.0% (0us) | Total: 0.3% (10.3ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (7)

**Calls:**
- `get parent` (7)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 3.1% (90.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (59)

**Calls:**
- `getScope` (59)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (0us) | Total: 12.1% (354.1ms) | Samples: 0

**Called by:**
- `isUsedVariable` (233)

**Calls:**
- `forEach` (233)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 88.8% (2.59s) | Samples: 0

**Called by:**
- `async (anonymous)` (1708)

**Calls:**
- `runPlugins` (1708)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` | Self: 0.0% (0us) | Total: 0.6% (18.0ms) | Samples: 0

**Called by:**
- `get references` (12)

**Calls:**
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:634` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `isInside` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInsideOfStorableFunction` (1)
- `isInsideOfStorableFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `_buildReference` (2)
- `_buildScope` (1)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 2.6% (78.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (44)
- `(anonymous)` (6)
- `isUsedVariable` (3)

**Calls:**
- `_buildReference` (20)
- `_buildReference` (19)
- `_buildReference` (12)
- `_buildReference` (1)
- `_buildReference` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 0.8% (25.4ms) | Samples: 0

**Called by:**
- `some` (16)

**Calls:**
- `isForInOfRef` (8)
- `isForInOfRef` (4)
- `isForInOfRef` (2)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `replace`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `(anonymous)` (1)

### `SourceCode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1002` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `RuleContext` (1)

**Calls:**
- `_getSharedCaches` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `exec` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 0.3% (11.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `some` (8)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `_execReport` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `_buildScope` (4)

**Calls:**
- `get parent` (3)
- `get parent` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1790` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `getUint32` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `defs` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get name` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `get body` (3)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get identifiers` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.8% (2.92s) | Samples: 0

**Called by:**
- `(anonymous)` (1922)

**Calls:**
- `async (anonymous)` (1708)
- `async (anonymous)` (157)
- `async (anonymous)` (48)
- `async (anonymous)` (6)
- `async (anonymous)` (1)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `AstView` (2)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4072` | Self: 0.0% (0us) | Total: 0.5% (15.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `_isChainNode` (10)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1339` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `_identAt` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (0us) | Total: 0.2% (6.2ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (3)
- `_findLineIdx` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.3% (9.1ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (6)

**Calls:**
- `_findLineIdx` (6)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 2.5% (74.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (48)

**Calls:**
- `parseSource` (45)
- `parseSource` (2)
- `parseSource` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (26.1ms) | Samples: 0

**Called by:**
- `bound require` (18)

**Calls:**
- `anonymous` (18)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1702` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (2.92s) | Samples: 0

**Calls:**
- `parseModule` (1924)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` | Self: 0.0% (0us) | Total: 0.6% (19.7ms) | Samples: 0

**Called by:**
- `_buildReference` (11)
- `_buildScope` (2)

**Calls:**
- `_buildScope` (8)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` | Self: 0.0% (0us) | Total: 0.3% (11.6ms) | Samples: 0

**Called by:**
- `defs` (7)
- `get defs` (1)

**Calls:**
- `_findDefNode` (7)
- `_findDefNode` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3930` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `SourceCode` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3982` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `wordsRegexp` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `get` (2)

**Calls:**
- `_buildScopeChildren` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 2.3% (68.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (45)

**Calls:**
- `parse` (45)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 1.0% (30.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (6)
- `patchAstUtils` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `async (anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (18)
- `anonymous` (2)
- `(anonymous)` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 12.3% (360.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (237)

**Calls:**
- `getFunctionDefinitions` (233)
- `getFunctionDefinitions` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 0.2% (5.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `defs` (3)
- `get defs` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `replace` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 0.7% (22.4ms) | Samples: 0

**Called by:**
- `some` (15)

**Calls:**
- `isReadForItself` (10)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `RuleContext` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadBinding` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `defs` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_ensureChildren` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 26.6% (778.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (515)

**Calls:**
- `getDeclaredVariables` (111)
- `getDeclaredVariables` (89)
- `getDeclaredVariables` (80)
- `getDeclaredVariables` (78)
- `getDeclaredVariables` (36)
- `getDeclaredVariables` (32)
- `getDeclaredVariables` (30)
- `getDeclaredVariables` (19)
- `getDeclaredVariables` (18)
- `getDeclaredVariables` (10)
- `getDeclaredVariables` (6)
- `getDeclaredVariables` (3)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (2.92s) | Samples: 0

**Called by:**
- `async (anonymous)` (1924)

**Calls:**
- `(anonymous)` (1922)
- `(anonymous)` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` | Self: 0.0% (0us) | Total: 0.4% (11.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (8)

**Calls:**
- `_ensureDeclSymIndex` (6)
- `_ensureDeclSymIndex` (2)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (2)

**Calls:**
- `_buildSymNameCache` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 10.5% (309.9ms) | Samples: 0

**Called by:**
- `forEach` (204)

**Calls:**
- `init` (193)
- `nodeViewChain` (8)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_nodeMods`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:929` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `get kind` (1)

**Calls:**
- `extraMethodData` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` | Self: 0.0% (0us) | Total: 2.4% (72.3ms) | Samples: 0

**Called by:**
- `getScope` (47)

**Calls:**
- `commentsInRange` (33)
- `commentsInRange` (6)
- `commentsInRange` (4)
- `commentsInRange` (3)
- `commentsInRange` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 1.2% (37.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (24)

**Calls:**
- `_ensureVarsSet` (23)
- `_ensureVarsSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `test` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (0us) | Total: 1.0% (30.0ms) | Samples: 0

**Called by:**
- `get references` (20)

**Calls:**
- `get parent` (16)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` | Self: 0.0% (0us) | Total: 3.1% (90.8ms) | Samples: 0

**Called by:**
- `Program:exit` (59)

**Calls:**
- `_precomputeScopes` (47)
- `_precomputeScopes` (10)
- `_precomputeScopes` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `buildUnicodeData` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (1)

**Calls:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` | Self: 0.0% (0us) | Total: 0.2% (6.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (4)

**Calls:**
- `_buildVariable` (3)
- `_buildVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` | Self: 0.0% (0us) | Total: 0.3% (9.0ms) | Samples: 0

**Called by:**
- `_buildScope` (6)

**Calls:**
- `get body` (4)
- `get body` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 8.0% (236.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (157)

**Calls:**
- `runPlugins` (156)
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` | Self: 0.0% (0us) | Total: 0.4% (12.1ms) | Samples: 0

**Called by:**
- `runPlugins` (8)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.2% (6.4ms) | Samples: 0

**Called by:**
- `some` (4)

**Calls:**
- `isSelfReference` (4)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 31.7% | 928.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 28.2% | 827.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 26.7% | 783.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 12.8% | 375.9ms | `[native code]` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.2ms | `node:events` |
