# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.69s | 1112 | 1.0ms | 382 |

**Top 10:** `parse` 12.8%, `walkNodes` 7.7%, `_drainAndReport` 6.3%, `copyDataProperties` 5.4%, `generatorResume` 5.2%, `_resolveUnicodeEscapes` 4.1%, `anonymous` 3.9%, `(anonymous)` 3.6%, `(anonymous)` 2.4%, `(anonymous)` 2.2%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 12.8% | 217.3ms | 12.8% | 217.3ms | `parse` | `[native code]` |
| 7.7% | 132.1ms | 67.4% | 1.14s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` |
| 6.3% | 108.2ms | 6.3% | 108.2ms | `_drainAndReport` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:87` |
| 5.4% | 93.1ms | 5.4% | 93.1ms | `copyDataProperties` | `[native code]` |
| 5.2% | 88.3ms | 66.5% | 1.12s | `generatorResume` | `[native code]` |
| 4.1% | 70.5ms | 4.1% | 70.5ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 3.9% | 67.3ms | 23.6% | 401.7ms | `anonymous` | `[native code]` |
| 3.6% | 62.0ms | 50.9% | 865.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:73` |
| 2.4% | 41.3ms | 2.4% | 41.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:175` |
| 2.2% | 37.9ms | 2.2% | 37.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:173` |
| 2.0% | 34.3ms | 2.0% | 34.3ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:126` |
| 1.9% | 33.8ms | 1.9% | 33.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` |
| 1.9% | 33.0ms | 33.0% | 560.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:174` |
| 1.7% | 29.4ms | 1.7% | 29.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` |
| 1.7% | 28.8ms | 1.7% | 28.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 1.6% | 28.3ms | 12.2% | 207.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4142` |
| 1.4% | 23.7ms | 1.4% | 23.7ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:141` |
| 1.4% | 23.7ms | 1.4% | 25.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` |
| 1.3% | 23.2ms | 1.3% | 23.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` |
| 1.2% | 21.7ms | 1.2% | 21.7ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4087` |
| 1.2% | 21.6ms | 1.2% | 21.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` |
| 1.2% | 21.3ms | 1.2% | 21.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 1.1% | 18.8ms | 100.0% | 1.80s | `(anonymous)` | `[native code]` |
| 1.0% | 18.4ms | 1.0% | 18.4ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:124` |
| 1.0% | 17.0ms | 1.0% | 17.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:72` |
| 0.8% | 13.9ms | 38.7% | 656.8ms | `_drainAndReport` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:88` |
| 0.7% | 13.2ms | 0.7% | 13.2ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.6% | 11.5ms | 0.6% | 11.5ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4089` |
| 0.6% | 10.6ms | 6.4% | 109.4ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.6% | 10.6ms | 3.1% | 53.0ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1915` |
| 0.6% | 10.3ms | 0.6% | 10.3ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` |
| 0.5% | 9.5ms | 0.5% | 9.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 9.3ms | 0.5% | 9.3ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:139` |
| 0.5% | 8.9ms | 0.5% | 8.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` |
| 0.5% | 8.9ms | 0.5% | 8.9ms | `defineProperty` | `[native code]` |
| 0.4% | 8.0ms | 0.4% | 8.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` |
| 0.4% | 7.9ms | 0.4% | 7.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` |
| 0.4% | 7.7ms | 0.4% | 7.7ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` |
| 0.4% | 7.6ms | 0.5% | 9.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4155` |
| 0.3% | 6.4ms | 0.3% | 6.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4436` |
| 0.3% | 6.1ms | 5.1% | 87.1ms | `parseModule` | `[native code]` |
| 0.3% | 5.5ms | 0.3% | 5.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7623` |
| 0.2% | 5.0ms | 0.6% | 11.1ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:27` |
| 0.2% | 4.6ms | 0.2% | 4.6ms | `decode` | `[native code]` |
| 0.2% | 4.5ms | 52.2% | 886.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4940` |
| 0.2% | 4.5ms | 0.3% | 6.0ms | `test` | `[native code]` |
| 0.2% | 4.4ms | 0.2% | 4.4ms | `create` | `[native code]` |
| 0.2% | 4.4ms | 0.7% | 12.1ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:156` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `moduleDeclarationInstantiation` | `[native code]` |
| 0.2% | 4.1ms | 0.2% | 4.1ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` |
| 0.2% | 4.1ms | 0.2% | 4.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` |
| 0.2% | 4.0ms | 0.4% | 6.9ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` |
| 0.2% | 3.9ms | 62.4% | 1.05s | `next` | `[native code]` |
| 0.2% | 3.6ms | 0.2% | 3.6ms | `slice` | `[native code]` |
| 0.2% | 3.4ms | 0.3% | 6.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:155` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `toLocaleLowerCase` | `[native code]` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4074` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` |
| 0.1% | 3.0ms | 0.7% | 12.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:624` |
| 0.1% | 3.0ms | 0.7% | 12.0ms | `evaluate` | `[native code]` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7456` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 2.9ms | 0.3% | 5.5ms | `exec` | `[native code]` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` |
| 0.1% | 2.8ms | 4.2% | 72.7ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:93` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:91` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:52` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` |
| 0.1% | 2.7ms | 0.2% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:668` |
| 0.1% | 2.6ms | 8.5% | 145.6ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:69` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7741` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `get` | `[native code]` |
| 0.1% | 2.5ms | 0.2% | 4.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` |
| 0.1% | 2.5ms | 0.3% | 5.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:625` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:714` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.8ms | 2.9% | 49.3ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` |
| 0.1% | 1.7ms | 0.4% | 8.0ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-context.js:26` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `getPropertyName` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1284` |
| 0.1% | 1.7ms | 2.6% | 44.7ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/acorn-jsx/xhtml.js:1` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `split` | `/Users/ericsan/node_modules/change-case/dist/index.js:20` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:914` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4927` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2390` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `@lazy` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `createToken` | `/Users/ericsan/node_modules/semver/internal/re.js:46` |
| 0.0% | 1.6ms | 28.8% | 489.4ms | `bound require` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1213` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 3.7% | 63.5ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:25` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` |
| 0.0% | 1.5ms | 1.0% | 17.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7745` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:74` |
| 0.0% | 1.5ms | 0.1% | 3.0ms | `readdirSync` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:867` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2643` |
| 0.0% | 1.5ms | 0.2% | 4.2ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:58` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `node:child_process` | `node:child_process:10` |
| 0.0% | 1.4ms | 1.0% | 17.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` |
| 0.0% | 1.4ms | 0.2% | 4.4ms | `(anonymous)` | `/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs:1` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RegExp` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:817` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7729` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_scopeForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:896` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7704` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1809` |
| 0.0% | 1.3ms | 0.4% | 7.8ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2481` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7687` |
| 0.0% | 1.3ms | 0.8% | 15.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1212` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | 0.1% | 2.6ms | `readFileSync` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:94` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1408` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:81` |
| 0.0% | 1.3ms | 4.9% | 84.0ms | `isPropertyThen` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:17` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `resolve` | `[native code]` |
| 0.0% | 1.2ms | 0.1% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` |
| 0.0% | 1.2ms | 7.5% | 127.6ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getStreamOptions` | `internal:fs/streams` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8023` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `dlopen` | `[native code]` |
| 0.0% | 1.2ms | 0.1% | 2.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2358` |
| 0.0% | 1.2ms | 0.2% | 4.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `encodeInto` | `[native code]` |
| 0.0% | 1.2ms | 0.5% | 8.7ms | `canBeConsideredConst` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:577` |
| 0.0% | 1.2ms | 0.2% | 4.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2357` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1927` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7524` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 1.80s | 1.1% | 18.8ms | `(anonymous)` | `[native code]` |
| 92.6% | 1.57s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 79.1% | 1.34s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 78.5% | 1.33s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8051` |
| 67.4% | 1.14s | 7.7% | 132.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` |
| 66.5% | 1.12s | 5.2% | 88.3ms | `generatorResume` | `[native code]` |
| 62.4% | 1.05s | 0.2% | 3.9ms | `next` | `[native code]` |
| 52.2% | 886.7ms | 0.2% | 4.5ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4940` |
| 50.9% | 865.0ms | 3.6% | 62.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:73` |
| 38.7% | 656.8ms | 0.8% | 13.9ms | `_drainAndReport` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:88` |
| 33.0% | 560.5ms | 1.9% | 33.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:174` |
| 28.8% | 489.4ms | 0.0% | 1.6ms | `bound require` | `[native code]` |
| 28.4% | 482.0ms | 0.0% | 0us | `require` | `[native code]` |
| 23.6% | 401.7ms | 3.9% | 67.3ms | `anonymous` | `[native code]` |
| 13.4% | 227.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 12.8% | 217.3ms | 12.8% | 217.3ms | `parse` | `[native code]` |
| 12.8% | 217.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 12.2% | 207.9ms | 1.6% | 28.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4142` |
| 8.5% | 145.6ms | 0.1% | 2.6ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:69` |
| 7.5% | 127.6ms | 0.0% | 1.2ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` |
| 6.4% | 109.4ms | 0.6% | 10.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 6.3% | 108.2ms | 6.3% | 108.2ms | `_drainAndReport` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:87` |
| 6.3% | 107.0ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` |
| 6.3% | 107.0ms | 0.0% | 0us | `loadPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:95` |
| 5.6% | 95.5ms | 0.0% | 0us | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4083` |
| 5.4% | 93.1ms | 5.4% | 93.1ms | `copyDataProperties` | `[native code]` |
| 5.1% | 87.1ms | 0.3% | 6.1ms | `parseModule` | `[native code]` |
| 4.9% | 84.0ms | 0.0% | 0us | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:28` |
| 4.9% | 84.0ms | 0.0% | 1.3ms | `isPropertyThen` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:17` |
| 4.2% | 72.7ms | 0.1% | 2.8ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:93` |
| 4.1% | 70.5ms | 4.1% | 70.5ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 3.7% | 63.5ms | 0.0% | 1.6ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` |
| 3.1% | 53.0ms | 0.6% | 10.6ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1915` |
| 3.0% | 51.0ms | 0.0% | 0us | `getStringIfConstant` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1234` |
| 3.0% | 51.0ms | 0.0% | 0us | `getStaticValue` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1201` |
| 2.9% | 49.3ms | 0.1% | 1.8ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` |
| 2.6% | 44.7ms | 0.1% | 1.7ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` |
| 2.4% | 41.3ms | 2.4% | 41.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:175` |
| 2.3% | 40.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/unsupported-api.js:14` |
| 2.3% | 39.2ms | 0.0% | 0us | `Identifier` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:887` |
| 2.3% | 39.2ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 2.3% | 39.2ms | 0.0% | 0us | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` |
| 2.3% | 39.2ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1028` |
| 2.2% | 37.9ms | 2.2% | 37.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:173` |
| 2.1% | 36.0ms | 0.0% | 0us | `moduleEvaluation` | `[native code]` |
| 2.0% | 34.3ms | 2.0% | 34.3ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:126` |
| 1.9% | 33.8ms | 1.9% | 33.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` |
| 1.9% | 33.0ms | 0.0% | 0us | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:57` |
| 1.7% | 29.4ms | 1.7% | 29.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` |
| 1.7% | 29.0ms | 0.0% | 0us | `MemberExpression` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:964` |
| 1.7% | 28.9ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2019` |
| 1.7% | 28.8ms | 1.7% | 28.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 1.5% | 26.5ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2192` |
| 1.4% | 25.1ms | 1.4% | 23.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` |
| 1.4% | 23.7ms | 1.4% | 23.7ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:141` |
| 1.3% | 23.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:44` |
| 1.3% | 23.2ms | 1.3% | 23.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` |
| 1.2% | 21.9ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 1.2% | 21.7ms | 1.2% | 21.7ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4087` |
| 1.2% | 21.6ms | 1.2% | 21.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` |
| 1.2% | 21.3ms | 1.2% | 21.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 1.0% | 18.4ms | 1.0% | 18.4ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:124` |
| 1.0% | 18.4ms | 0.0% | 0us | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` |
| 1.0% | 18.3ms | 0.0% | 0us | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:53` |
| 1.0% | 17.9ms | 0.0% | 0us | `getPropertyName` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1276` |
| 1.0% | 17.7ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7745` |
| 1.0% | 17.6ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` |
| 1.0% | 17.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/index.js:3` |
| 1.0% | 17.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 1.0% | 17.0ms | 1.0% | 17.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:72` |
| 0.9% | 16.9ms | 0.0% | 0us | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3145` |
| 0.9% | 16.9ms | 0.0% | 0us | `getPropertyName` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1278` |
| 0.9% | 16.5ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.8% | 15.1ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1212` |
| 0.8% | 14.5ms | 0.0% | 0us | `link` | `[native code]` |
| 0.8% | 13.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.8% | 13.6ms | 0.0% | 0us | `map` | `[native code]` |
| 0.7% | 13.2ms | 0.7% | 13.2ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.7% | 12.4ms | 0.1% | 3.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:624` |
| 0.7% | 12.1ms | 0.2% | 4.4ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:156` |
| 0.7% | 12.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.7% | 12.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:19` |
| 0.7% | 12.0ms | 0.1% | 3.0ms | `evaluate` | `[native code]` |
| 0.7% | 11.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.6% | 11.7ms | 0.0% | 0us | `getPropertyName` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1265` |
| 0.6% | 11.5ms | 0.6% | 11.5ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4089` |
| 0.6% | 11.4ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` |
| 0.6% | 11.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.6% | 11.1ms | 0.2% | 5.0ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:27` |
| 0.6% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/index.js:2` |
| 0.6% | 10.3ms | 0.6% | 10.3ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` |
| 0.5% | 9.5ms | 0.5% | 9.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 9.4ms | 0.4% | 7.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4155` |
| 0.5% | 9.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/default-config.js:37` |
| 0.5% | 9.3ms | 0.5% | 9.3ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:139` |
| 0.5% | 9.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.5% | 9.0ms | 0.0% | 0us | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:60` |
| 0.5% | 8.9ms | 0.5% | 8.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` |
| 0.5% | 8.9ms | 0.5% | 8.9ms | `defineProperty` | `[native code]` |
| 0.5% | 8.7ms | 0.0% | 0us | `Identifier` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:896` |
| 0.5% | 8.7ms | 0.0% | 1.2ms | `canBeConsideredConst` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:577` |
| 0.4% | 8.0ms | 0.4% | 8.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` |
| 0.4% | 8.0ms | 0.1% | 1.7ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` |
| 0.4% | 7.9ms | 0.4% | 7.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` |
| 0.4% | 7.8ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.4% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.4% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.4% | 7.7ms | 0.4% | 7.7ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` |
| 0.4% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/targets-parser.js:2` |
| 0.4% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/compat.js:7` |
| 0.4% | 7.3ms | 0.0% | 0us | `CallExpression` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:811` |
| 0.4% | 7.3ms | 0.0% | 0us | `getElementValues` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:539` |
| 0.4% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.4% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:15` |
| 0.4% | 6.9ms | 0.2% | 4.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` |
| 0.3% | 6.4ms | 0.3% | 6.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4436` |
| 0.3% | 6.4ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.3% | 6.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8043` |
| 0.3% | 6.2ms | 0.2% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` |
| 0.3% | 6.0ms | 0.2% | 4.5ms | `test` | `[native code]` |
| 0.3% | 6.0ms | 0.0% | 0us | `isEffectivelyConst` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:587` |
| 0.3% | 6.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7738` |
| 0.3% | 5.9ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:917` |
| 0.3% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/index.js:8` |
| 0.3% | 5.8ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.3% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.3% | 5.6ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2348` |
| 0.3% | 5.5ms | 0.3% | 5.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7623` |
| 0.3% | 5.5ms | 0.1% | 2.9ms | `exec` | `[native code]` |
| 0.3% | 5.4ms | 0.1% | 2.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:625` |
| 0.2% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:14` |
| 0.2% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:1` |
| 0.2% | 4.6ms | 0.2% | 4.6ms | `decode` | `[native code]` |
| 0.2% | 4.6ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 0.2% | 4.6ms | 0.0% | 0us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3110` |
| 0.2% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.2% | 4.5ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:828` |
| 0.2% | 4.5ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` |
| 0.2% | 4.4ms | 0.2% | 4.4ms | `create` | `[native code]` |
| 0.2% | 4.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs:1` |
| 0.2% | 4.3ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` |
| 0.2% | 4.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7527` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `moduleDeclarationInstantiation` | `[native code]` |
| 0.2% | 4.3ms | 0.0% | 0us | `linkAndEvaluateModule` | `[native code]` |
| 0.2% | 4.3ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 0.2% | 4.3ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1697` |
| 0.2% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/default-config.js:12` |
| 0.2% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.2% | 4.2ms | 0.0% | 1.5ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:58` |
| 0.2% | 4.1ms | 0.2% | 4.1ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` |
| 0.2% | 4.1ms | 0.2% | 4.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` |
| 0.2% | 4.0ms | 0.1% | 2.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` |
| 0.2% | 4.0ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2357` |
| 0.2% | 3.6ms | 0.2% | 3.6ms | `slice` | `[native code]` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:155` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `toLocaleLowerCase` | `[native code]` |
| 0.1% | 3.2ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/node_modules/change-case/dist/index.js:68` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4074` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` |
| 0.1% | 3.0ms | 0.0% | 1.5ms | `readdirSync` | `[native code]` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7456` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/rules.js:3` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:9` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:3` |
| 0.1% | 2.9ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` |
| 0.1% | 2.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` |
| 0.1% | 2.8ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.1% | 2.8ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:851` |
| 0.1% | 2.8ms | 0.0% | 0us | `parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1212` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:22` |
| 0.1% | 2.8ms | 0.0% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 2.7ms | 0.0% | 0us | `get ReadStream` | `node:fs:573` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:91` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:9` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:8` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:52` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:668` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7741` |
| 0.1% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.1% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/index.js:11` |
| 0.1% | 2.6ms | 0.0% | 1.3ms | `readFileSync` | `[native code]` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `get` | `[native code]` |
| 0.1% | 2.5ms | 0.0% | 0us | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` |
| 0.1% | 2.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.1% | 2.5ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2358` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:714` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:24` |
| 0.1% | 1.7ms | 0.0% | 0us | `node:assert` | `node:assert:588` |
| 0.1% | 1.7ms | 0.0% | 0us | `node:assert/strict` | `node:assert/strict:3` |
| 0.1% | 1.7ms | 0.0% | 0us | `assign` | `[native code]` |
| 0.1% | 1.7ms | 0.0% | 0us | `get` | `node:assert:70` |
| 0.1% | 1.7ms | 0.0% | 0us | `loadAssertionError` | `node:assert:28` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:48` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.1% | 1.7ms | 0.0% | 0us | `performProxyObjectGet` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-context.js:26` |
| 0.1% | 1.7ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1123` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` |
| 0.1% | 1.7ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4230` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `getPropertyName` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1284` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:20` |
| 0.1% | 1.7ms | 0.0% | 0us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4143` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/change-case/dist/index.js:181` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:98` |
| 0.1% | 1.7ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:55` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:104` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/interpreter/finite-automaton/index.js:9` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:14` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/espree/dist/espree.cjs:4` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/acorn-jsx/xhtml.js:1` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:15` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/acorn-jsx/index.js:3` |
| 0.1% | 1.7ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/node_modules/change-case/dist/index.js:60` |
| 0.1% | 1.7ms | 0.0% | 0us | `splitPrefixSuffix` | `/Users/ericsan/node_modules/change-case/dist/index.js:205` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:71` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `split` | `/Users/ericsan/node_modules/change-case/dist/index.js:20` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:914` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3007` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4927` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2390` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:23` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `node:path` | `node:path:2` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `@lazy` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:fs/glob` | `internal:fs/glob:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1963` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:16` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/internal/re.js:222` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:4` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `createToken` | `/Users/ericsan/node_modules/semver/internal/re.js:46` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1213` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `Literal` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:937` |
| 0.0% | 1.6ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1401` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:7` |
| 0.0% | 1.6ms | 0.0% | 0us | `getPropertyName` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1267` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:28` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7736` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:25` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:9` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/index.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7615` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` |
| 0.0% | 1.5ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4587` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:74` |
| 0.0% | 1.5ms | 0.0% | 0us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8050` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:70` |
| 0.0% | 1.5ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` |
| 0.0% | 1.5ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:53` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:867` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2643` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `node:child_process` | `node:child_process:10` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/parser/index.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:13` |
| 0.0% | 1.4ms | 0.0% | 0us | `e` | `/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs:1` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RegExp` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:817` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_scopeForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:896` |
| 0.0% | 1.4ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2046` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7729` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/compat.js:4` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1717` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/optimizer/index.js:11` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/optimizer/transforms/index.js:16` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:10` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7704` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:42` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/cast.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/cast.js:327` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/type-check/lib/index.js:16` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/type-check/lib/index.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/prelude-ls/lib/index.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `AssignmentExpression` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:681` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1809` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/index.js:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6494` |
| 0.0% | 1.3ms | 0.0% | 0us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:util` | `node:util:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/node.js:6` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7687` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2481` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/classes/comparator.js:143` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `Identifier` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:902` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3000` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/duplex` | `internal:streams/duplex:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2139` |
| 0.0% | 1.3ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1720` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2197` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1408` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:94` |
| 0.0% | 1.3ms | 0.0% | 0us | `getPropertyName` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1279` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:81` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `resolve` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.0% | 1.2ms | 0.0% | 0us | `createDebug` | `/Users/ericsan/node_modules/debug/src/common.js:117` |
| 0.0% | 1.2ms | 0.0% | 0us | `WriteStream` | `internal:fs/streams:200` |
| 0.0% | 1.2ms | 0.0% | 0us | `useColors` | `/Users/ericsan/node_modules/debug/src/node.js:158` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getStreamOptions` | `internal:fs/streams` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8023` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:5` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `dlopen` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.2ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.2ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/locate-path/index.js:5` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/find-up/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config-loader.js:14` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:29` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/keyword.js:5` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/definition_schema.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:12` |
| 0.0% | 1.2ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `encodeInto` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1927` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7524` |

## Function Details

### `parse`
`[native code]` | Self: 12.8% (217.3ms) | Total: 12.8% (217.3ms) | Samples: 141

**Called by:**
- `parseSource` (141)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` | Self: 7.7% (132.1ms) | Total: 67.4% (1.14s) | Samples: 87

**Called by:**
- `runPlugins` (751)

**Calls:**
- `_invokeFused` (571)
- `_nodeViewRaw` (78)
- `_nodeViewRaw` (9)
- `nodeView` (4)
- `_invokeFused` (1)
- `_invokeFused` (1)

### `_drainAndReport`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:87` | Self: 6.3% (108.2ms) | Total: 6.3% (108.2ms) | Samples: 71

**Called by:**
- `(anonymous)` (71)

### `copyDataProperties`
`[native code]` | Self: 5.4% (93.1ms) | Total: 5.4% (93.1ms) | Samples: 61

**Called by:**
- `isMethodCall` (31)
- `create` (28)
- `isMemberExpression` (2)

### `generatorResume`
`[native code]` | Self: 5.2% (88.3ms) | Total: 66.5% (1.12s) | Samples: 56

**Called by:**
- `next` (694)
- `(anonymous)` (32)
- `_drainAndReport` (18)

**Calls:**
- `(anonymous)` (370)
- `getNodes` (95)
- `getNodes` (57)
- `getNodes` (48)
- `(anonymous)` (27)
- `getNodes` (23)
- `getNodes` (23)
- `getNodes` (16)
- `getNodes` (11)
- `getNodes` (8)
- `getNodes` (7)
- `getNodes` (1)
- `getNodes` (1)
- `getNodes` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` | Self: 4.1% (70.5ms) | Total: 4.1% (70.5ms) | Samples: 45

**Called by:**
- `_computeIdentifierName` (45)

### `anonymous`
`[native code]` | Self: 3.9% (67.3ms) | Total: 23.6% (401.7ms) | Samples: 44

**Called by:**
- `require` (248)
- `bound require` (3)
- `get ReadStream` (2)
- `loadAssertionError` (1)
- `node:assert/strict` (1)
- `node:stream` (1)
- `node:fs` (1)
- `node:fs/promises` (1)
- `internal:fs/glob` (1)
- `internal:streams/duplex` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/compose` (1)
- `node:util` (1)
- `internal:streams/pipeline` (1)
- `internal:fs/streams` (1)

**Calls:**
- `(anonymous)` (15)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `node:assert` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/duplex` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:stream` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:child_process` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:fs/glob` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/compose` (1)
- `internal:fs/streams` (1)
- `node:util` (1)
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
- `internal:streams/pipeline` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:stream` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs/promises` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:path` (1)
- `internal:streams/operators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:73` | Self: 3.6% (62.0ms) | Total: 50.9% (865.0ms) | Samples: 41

**Called by:**
- `_invokeFused` (568)

**Calls:**
- `_drainAndReport` (432)
- `_drainAndReport` (71)
- `(anonymous)` (24)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:175` | Self: 2.4% (41.3ms) | Total: 2.4% (41.3ms) | Samples: 27

**Called by:**
- `generatorResume` (27)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:173` | Self: 2.2% (37.9ms) | Total: 2.2% (37.9ms) | Samples: 24

**Called by:**
- `(anonymous)` (24)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:126` | Self: 2.0% (34.3ms) | Total: 2.0% (34.3ms) | Samples: 23

**Called by:**
- `generatorResume` (23)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` | Self: 1.9% (33.8ms) | Total: 1.9% (33.8ms) | Samples: 22

**Called by:**
- `runPlugins` (22)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:174` | Self: 1.9% (33.0ms) | Total: 33.0% (560.5ms) | Samples: 22

**Called by:**
- `generatorResume` (370)

**Calls:**
- `next` (292)
- `generatorResume` (32)
- `getNodes` (12)
- `getNodes` (6)
- `getNodes` (2)
- `getNodes` (2)
- `getNodes` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` | Self: 1.7% (29.4ms) | Total: 1.7% (29.4ms) | Samples: 20

**Called by:**
- `_nodeViewRaw` (20)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` | Self: 1.7% (28.8ms) | Total: 1.7% (28.8ms) | Samples: 19

**Called by:**
- `runPlugins` (19)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4142` | Self: 1.6% (28.3ms) | Total: 12.2% (207.9ms) | Samples: 18

**Called by:**
- `walkNodes` (78)
- `get arguments` (26)
- `get key` (11)
- `isMethodCall` (9)
- `get parent` (5)
- `_nodesFromRange` (3)
- `isMemberExpression` (3)
- `get body` (1)
- `walkNodes` (1)

**Calls:**
- `_NodeView_LR` (71)
- `_NodeView` (20)
- `_NodeView_LR` (15)
- `_NodeView_LR` (8)
- `_NodeView` (2)
- `_NodeView` (2)
- `_NodeView_LRN` (1)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:141` | Self: 1.4% (23.7ms) | Total: 1.4% (23.7ms) | Samples: 16

**Called by:**
- `generatorResume` (16)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` | Self: 1.4% (23.7ms) | Total: 1.4% (25.1ms) | Samples: 16

**Called by:**
- `runPlugins` (17)

**Calls:**
- `_resolveHandlers` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` | Self: 1.3% (23.2ms) | Total: 1.3% (23.2ms) | Samples: 16

**Called by:**
- `_computeIdentifierName` (16)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4087` | Self: 1.2% (21.7ms) | Total: 1.2% (21.7ms) | Samples: 15

**Called by:**
- `_nodeViewRaw` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` | Self: 1.2% (21.6ms) | Total: 1.2% (21.6ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 1.2% (21.3ms) | Total: 1.2% (21.3ms) | Samples: 14

**Called by:**
- `walkNodes` (9)
- `parent` (1)
- `get body` (1)
- `_buildScope` (1)
- `getPropertyName` (1)
- `isMethodCall` (1)

### `(anonymous)`
`[native code]` | Self: 1.1% (18.8ms) | Total: 100.0% (1.80s) | Samples: 13

**Called by:**
- `processTicksAndRejections` (1029)
- `(anonymous)` (84)
- `require` (71)
- `useColors` (1)
- `bound require` (1)

**Calls:**
- `_lintSourceOne` (883)
- `_lintSourceOne` (145)
- `(anonymous)` (84)
- `parseModule` (46)
- `moduleEvaluation` (8)
- `linkAndEvaluateModule` (3)
- `_lintSourceOne` (1)
- `dlopen` (1)
- `WriteStream` (1)
- `resolve` (1)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:124` | Self: 1.0% (18.4ms) | Total: 1.0% (18.4ms) | Samples: 12

**Called by:**
- `(anonymous)` (12)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:72` | Self: 1.0% (17.0ms) | Total: 1.0% (17.0ms) | Samples: 11

**Called by:**
- `_invokeFused` (11)

### `_drainAndReport`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:88` | Self: 0.8% (13.9ms) | Total: 38.7% (656.8ms) | Samples: 9

**Called by:**
- `(anonymous)` (432)

**Calls:**
- `next` (405)
- `generatorResume` (18)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.7% (13.2ms) | Total: 0.7% (13.2ms) | Samples: 9

**Called by:**
- `_buildScopeVarsAndSet` (7)
- `exec` (2)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4089` | Self: 0.6% (11.5ms) | Total: 0.6% (11.5ms) | Samples: 8

**Called by:**
- `_nodeViewRaw` (8)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 0.6% (10.6ms) | Total: 6.4% (109.4ms) | Samples: 7

**Called by:**
- `_nodeViewRaw` (71)

**Calls:**
- `_computeIdentifierName` (62)
- `_computeIdentifierName` (2)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1915` | Self: 0.6% (10.6ms) | Total: 3.1% (53.0ms) | Samples: 7

**Called by:**
- `create` (34)

**Calls:**
- `_nodeViewRaw` (26)
- `_nodeViewRaw` (1)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` | Self: 0.6% (10.3ms) | Total: 0.6% (10.3ms) | Samples: 7

**Called by:**
- `create` (5)
- `create` (2)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.5% (9.5ms) | Total: 0.5% (9.5ms) | Samples: 6

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (2)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:139` | Self: 0.5% (9.3ms) | Total: 0.5% (9.3ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` | Self: 0.5% (8.9ms) | Total: 0.5% (8.9ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `defineProperty`
`[native code]` | Self: 0.5% (8.9ms) | Total: 0.5% (8.9ms) | Samples: 6

**Called by:**
- `walkNodes` (4)
- `walkNodes` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` | Self: 0.4% (8.0ms) | Total: 0.4% (8.0ms) | Samples: 5

**Called by:**
- `walkNodes` (4)
- `get property` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` | Self: 0.4% (7.9ms) | Total: 0.4% (7.9ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` | Self: 0.4% (7.7ms) | Total: 0.4% (7.7ms) | Samples: 5

**Called by:**
- `isMethodCall` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4155` | Self: 0.4% (7.6ms) | Total: 0.5% (9.4ms) | Samples: 4

**Called by:**
- `get parent` (3)
- `parent` (1)
- `get arguments` (1)

**Calls:**
- `slice` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4436` | Self: 0.3% (6.4ms) | Total: 0.3% (6.4ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `parseModule`
`[native code]` | Self: 0.3% (6.1ms) | Total: 5.1% (87.1ms) | Samples: 4

**Called by:**
- `(anonymous)` (46)
- `async (anonymous)` (11)

**Calls:**
- `(anonymous)` (26)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (4)
- `get ReadStream` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `node:assert/strict` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7623` | Self: 0.3% (5.5ms) | Total: 0.3% (5.5ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:27` | Self: 0.2% (5.0ms) | Total: 0.6% (11.1ms) | Samples: 3

**Called by:**
- `generatorResume` (7)

**Calls:**
- `get properties` (3)
- `get properties` (1)

### `decode`
`[native code]` | Self: 0.2% (4.6ms) | Total: 0.2% (4.6ms) | Samples: 3

**Called by:**
- `get source` (3)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4940` | Self: 0.2% (4.5ms) | Total: 52.2% (886.7ms) | Samples: 3

**Called by:**
- `walkNodes` (571)
- `walkNodes` (11)

**Calls:**
- `(anonymous)` (568)
- `(anonymous)` (11)

### `test`
`[native code]` | Self: 0.2% (4.5ms) | Total: 0.3% (6.0ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `_precomputeScopes` (1)

**Calls:**
- `/^\s*exported\b/` (1)

### `create`
`[native code]` | Self: 0.2% (4.4ms) | Total: 0.2% (4.4ms) | Samples: 3

**Called by:**
- `walkNodes` (2)
- `walkNodes` (1)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:156` | Self: 0.2% (4.4ms) | Total: 0.7% (12.1ms) | Samples: 3

**Called by:**
- `generatorResume` (8)

**Calls:**
- `get parent` (3)
- `parent` (1)
- `get parent` (1)

### `moduleDeclarationInstantiation`
`[native code]` | Self: 0.2% (4.3ms) | Total: 0.2% (4.3ms) | Samples: 3

**Called by:**
- `link` (3)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` | Self: 0.2% (4.1ms) | Total: 0.2% (4.1ms) | Samples: 3

**Called by:**
- `getNodes` (2)
- `getNodes` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` | Self: 0.2% (4.1ms) | Total: 0.2% (4.1ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` | Self: 0.2% (4.0ms) | Total: 0.4% (6.9ms) | Samples: 3

**Called by:**
- `getScope` (5)

**Calls:**
- `test` (1)
- `/^\s*exported\b/` (1)

### `next`
`[native code]` | Self: 0.2% (3.9ms) | Total: 62.4% (1.05s) | Samples: 3

**Called by:**
- `_drainAndReport` (405)
- `(anonymous)` (292)

**Calls:**
- `generatorResume` (694)

### `slice`
`[native code]` | Self: 0.2% (3.6ms) | Total: 0.2% (3.6ms) | Samples: 2

**Called by:**
- `_computeIdentifierName` (1)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` | Self: 0.2% (3.4ms) | Total: 0.3% (6.2ms) | Samples: 2

**Called by:**
- `runPlugins` (4)

**Calls:**
- `create` (2)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:155` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `isMethodCall` (2)

### `toLocaleLowerCase`
`[native code]` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `map` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4074` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `_NodeView_LR` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:624` | Self: 0.1% (3.0ms) | Total: 0.7% (12.4ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (8)

**Calls:**
- `_findLineIdx` (4)
- `_findLineIdx` (2)

### `evaluate`
`[native code]` | Self: 0.1% (3.0ms) | Total: 0.7% (12.0ms) | Samples: 2

**Called by:**
- `moduleEvaluation` (8)

**Calls:**
- `(module)` (6)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `getNodes` (2)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7456` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `/^\s*exported\b/`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `test` (1)
- `_precomputeScopes` (1)

### `exec`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.3% (5.5ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:93` | Self: 0.1% (2.8ms) | Total: 4.2% (72.7ms) | Samples: 2

**Called by:**
- `generatorResume` (48)

**Calls:**
- `isMethodCall` (21)
- `isMethodCall` (14)
- `isMethodCall` (5)
- `isMemberExpression` (3)
- `isMemberExpression` (2)
- `isMethodCall` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_symName` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:91` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:52` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `getNodes` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` | Self: 0.1% (2.7ms) | Total: 0.2% (4.3ms) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_resolveHandlers` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:668` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `commentsInRange` (2)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:69` | Self: 0.1% (2.6ms) | Total: 8.5% (145.6ms) | Samples: 2

**Called by:**
- `generatorResume` (95)

**Calls:**
- `isMethodCall` (62)
- `isMethodCall` (18)
- `isMethodCall` (7)
- `isMemberExpression` (2)
- `isMethodCall` (2)
- `isMemberExpression` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7741` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `get`
`[native code]` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `_ensureDeclSymIndex` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` | Self: 0.1% (2.5ms) | Total: 0.2% (4.0ms) | Samples: 2

**Called by:**
- `map` (3)

**Calls:**
- `RegExp` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:625` | Self: 0.1% (2.5ms) | Total: 0.3% (5.4ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (2)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:714` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `get body` (1)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `getNodes` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` | Self: 0.1% (1.8ms) | Total: 2.9% (49.3ms) | Samples: 1

**Called by:**
- `getNodes` (18)
- `getNodes` (14)

**Calls:**
- `copyDataProperties` (31)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` | Self: 0.1% (1.7ms) | Total: 0.4% (8.0ms) | Samples: 1

**Called by:**
- `getNodes` (3)
- `getNodes` (2)

**Calls:**
- `_nodeViewRaw` (3)
- `get property` (1)

### `get`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-context.js:26` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `performProxyObjectGet` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `reset` (1)

### `getPropertyName`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1284` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `isPropertyThen` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` | Self: 0.1% (1.7ms) | Total: 2.6% (44.7ms) | Samples: 1

**Called by:**
- `isMethodCall` (29)

**Calls:**
- `copyDataProperties` (28)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/acorn-jsx/xhtml.js:1` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `split`
`/Users/ericsan/node_modules/change-case/dist/index.js:20` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `splitPrefixSuffix` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:914` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4927` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2390` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `@lazy`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `node:path` (1)

### `createToken`
`/Users/ericsan/node_modules/semver/internal/re.js:46` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `bound require`
`[native code]` | Self: 0.0% (1.6ms) | Total: 28.8% (489.4ms) | Samples: 1

**Called by:**
- `loadPlugin` (71)
- `(anonymous)` (26)
- `(anonymous)` (15)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `patchAstUtils` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (319)
- `anonymous` (3)
- `(anonymous)` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1213` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getNodes` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` | Self: 0.0% (1.6ms) | Total: 3.7% (63.5ms) | Samples: 1

**Called by:**
- `isMethodCall` (41)

**Calls:**
- `get arguments` (34)
- `get arguments` (5)
- `get arguments` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:25` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isMethodCall` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7745` | Self: 0.0% (1.5ms) | Total: 1.0% (17.7ms) | Samples: 1

**Called by:**
- `runPlugins` (12)

**Calls:**
- `_invokeFused` (11)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isMethodCall` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `describeRule` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:74` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isMethodCall` (1)

### `readdirSync`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `loadCoreRules` (1)
- `readdirSync` (1)

**Calls:**
- `readdirSync` (1)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:867` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getNodes` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2643` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `canBeConsideredConst` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:58` | Self: 0.0% (1.5ms) | Total: 0.2% (4.2ms) | Samples: 1

**Called by:**
- `isMethodCall` (3)

**Calls:**
- `get arguments` (2)

### `node:child_process`
`node:child_process:10` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` | Self: 0.0% (1.4ms) | Total: 1.0% (17.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (12)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (7)
- `exec` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs:1` | Self: 0.0% (1.4ms) | Total: 0.2% (4.4ms) | Samples: 1

**Called by:**
- `forEach` (2)
- `anonymous` (1)

**Calls:**
- `e` (1)
- `forEach` (1)

### `RegExp`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:817` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isEffectivelyConst` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7729` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_scopeForNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:896` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7704` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getNodes` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1809` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `AssignmentExpression` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (1.3ms) | Total: 0.4% (7.8ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `AstView` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `map` (1)

### `isCallExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isMethodCall` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2481` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7687` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1212` | Self: 0.0% (1.3ms) | Total: 0.8% (15.1ms) | Samples: 1

**Called by:**
- `getNodes` (5)
- `getNodes` (3)
- `_buildReference` (1)

**Calls:**
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.1% (2.6ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:94` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1408` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getPropertyName` (1)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:81` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `isPropertyThen`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:17` | Self: 0.0% (1.3ms) | Total: 4.9% (84.0ms) | Samples: 1

**Called by:**
- `getNodes` (57)

**Calls:**
- `getScope` (20)
- `getPropertyName` (12)
- `getPropertyName` (10)
- `getStringIfConstant` (8)
- `_buildScope` (3)
- `performProxyObjectGet` (1)
- `getPropertyName` (1)
- `getPropertyName` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get body` (1)

### `resolve`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` | Self: 0.0% (1.2ms) | Total: 0.1% (2.8ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_Variable` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` | Self: 0.0% (1.2ms) | Total: 7.5% (127.6ms) | Samples: 1

**Called by:**
- `getNodes` (62)
- `getNodes` (21)

**Calls:**
- `create` (41)
- `create` (29)
- `create` (5)
- `create` (3)
- `isCallExpression` (1)
- `create` (1)
- `create` (1)
- `create` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getNodes` (1)

### `getStreamOptions`
`internal:fs/streams` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `WriteStream` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get properties` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8023` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2358` | Self: 0.0% (1.2ms) | Total: 0.1% (2.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `get` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` | Self: 0.0% (1.2ms) | Total: 0.2% (4.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `extraFnData` (1)
- `extraFnData` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `canBeConsideredConst`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:577` | Self: 0.0% (1.2ms) | Total: 0.5% (8.7ms) | Samples: 1

**Called by:**
- `Identifier` (6)

**Calls:**
- `isEffectivelyConst` (4)
- `get kind` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2357` | Self: 0.0% (1.2ms) | Total: 0.2% (4.0ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `_buildVariable` (2)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1927` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `create` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7524` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `loadAssertionError`
`node:assert:28` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `createDebug` (1)
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:23` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/index.js:2` | Self: 0.0% (0us) | Total: 0.6% (10.8ms) | Samples: 0

**Called by:**
- `parseModule` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:20` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getPropertyName`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1267` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getNodes` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7615` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 92.6% (1.57s) | Samples: 0

**Calls:**
- `(anonymous)` (1029)

### `(anonymous)`
`/Users/ericsan/node_modules/locate-path/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (13.6ms) | Samples: 0

**Called by:**
- `(module)` (6)
- `camelCase` (2)
- `_ensureTagCaches` (1)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `toLocaleLowerCase` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:1` | Self: 0.0% (0us) | Total: 0.2% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7736` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `create` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 2.3% (39.2ms) | Samples: 0

**Called by:**
- `get` (27)

**Calls:**
- `_buildScopeVarsAndSet` (12)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `node:fs/promises`
`node:fs/promises:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/optimizer/transforms/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.3% (5.8ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` | Self: 0.0% (0us) | Total: 0.2% (4.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `test` (3)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2046` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getNodes` (1)

**Calls:**
- `_scopeForNode` (1)

### `node:path`
`node:path:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `@lazy` (1)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.8% (13.6ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `CallExpression`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:811` | Self: 0.0% (0us) | Total: 0.4% (7.3ms) | Samples: 0

**Called by:**
- `getStaticValue` (4)
- `Identifier` (1)

**Calls:**
- `getElementValues` (5)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` | Self: 0.0% (0us) | Total: 0.6% (11.4ms) | Samples: 0

**Called by:**
- `_buildScope` (8)

**Calls:**
- `get body` (3)
- `get body` (3)
- `get body` (1)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.4% (7.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:28` | Self: 0.0% (0us) | Total: 4.9% (84.0ms) | Samples: 0

**Called by:**
- `generatorResume` (57)

**Calls:**
- `isPropertyThen` (57)

### `parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1212` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `getNodes` (1)
- `getNodes` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `_getPlugin` (1)

### `node:assert`
`node:assert:588` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `assign` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 13.4% (227.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (145)

**Calls:**
- `parseSource` (141)
- `parseSource` (2)
- `parseSource` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `camelCase` (1)

### `get ReadStream`
`node:fs:573` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `anonymous` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.2% (4.9ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/parser/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:917` | Self: 0.0% (0us) | Total: 0.3% (5.9ms) | Samples: 0

**Called by:**
- `get body` (2)
- `get properties` (2)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.2% (4.6ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/optimizer/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:util`
`node:util:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `assign`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `node:assert` (1)

**Calls:**
- `get` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:851` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (2)

**Calls:**
- `_buildSymNameCache` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `createDebug`
`/Users/ericsan/node_modules/debug/src/common.js:117` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `useColors` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config-loader.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.7% (11.9ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/cast.js:327` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `getElementValues`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:539` | Self: 0.0% (0us) | Total: 0.4% (7.3ms) | Samples: 0

**Called by:**
- `CallExpression` (5)

**Calls:**
- `Identifier` (3)
- `Identifier` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 79.1% (1.34s) | Samples: 0

**Called by:**
- `(anonymous)` (883)

**Calls:**
- `runPlugins` (877)
- `runPlugins` (4)
- `runPlugins` (1)
- `runPlugins` (1)

### `camelCase`
`/Users/ericsan/node_modules/change-case/dist/index.js:60` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `splitPrefixSuffix` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 12.8% (217.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (141)

**Calls:**
- `parse` (141)

### `node:assert/strict`
`node:assert/strict:3` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:71` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/definition_schema.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/prelude-ls/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/interpreter/finite-automaton/index.js:9` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `defineProperty` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:7` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `moduleEvaluation`
`[native code]` | Self: 0.0% (0us) | Total: 2.1% (36.0ms) | Samples: 0

**Called by:**
- `moduleEvaluation` (16)
- `(anonymous)` (8)

**Calls:**
- `moduleEvaluation` (16)
- `evaluate` (8)

### `internal:fs/glob`
`internal:fs/glob:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `e` (1)

**Calls:**
- `(anonymous)` (2)

### `getPropertyName`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1265` | Self: 0.0% (0us) | Total: 0.6% (11.7ms) | Samples: 0

**Called by:**
- `getNodes` (8)

**Calls:**
- `getStringIfConstant` (8)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.7% (12.1ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `map` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1720` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.7% (12.1ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3000` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4143` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_nodesFromRange` (1)

**Calls:**
- `_computeNodeType` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` | Self: 0.0% (0us) | Total: 1.2% (21.9ms) | Samples: 0

**Called by:**
- `getScope` (15)

**Calls:**
- `commentsInRange` (8)
- `commentsInRange` (4)
- `commentsInRange` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 1.3% (23.3ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `WriteStream`
`internal:fs/streams:200` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getStreamOptions` (1)

### `get`
`node:assert:70` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `assign` (1)

**Calls:**
- `loadAssertionError` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.3% (5.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:104` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 1.0% (17.3ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:57` | Self: 0.0% (0us) | Total: 1.9% (33.0ms) | Samples: 0

**Called by:**
- `generatorResume` (23)

**Calls:**
- `getPropertyName` (8)
- `getStringIfConstant` (7)
- `_buildScope` (5)
- `getScope` (1)
- `getPropertyName` (1)
- `getScope` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/compat.js:7` | Self: 0.0% (0us) | Total: 0.4% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/classes/comparator.js:143` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7527` | Self: 0.0% (0us) | Total: 0.2% (4.3ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `getDFSEvents` (2)
- `getDFSEvents` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3145` | Self: 0.0% (0us) | Total: 0.9% (16.9ms) | Samples: 0

**Called by:**
- `getPropertyName` (11)

**Calls:**
- `_nodeViewRaw` (11)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isEffectivelyConst`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:587` | Self: 0.0% (0us) | Total: 0.3% (6.0ms) | Samples: 0

**Called by:**
- `canBeConsideredConst` (4)

**Calls:**
- `get references` (3)
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 1.0% (17.3ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/keyword.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8050` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `buildVisitorMap` (1)

### `e`
`/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs:1` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `forEach` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 28.4% (482.0ms) | Samples: 0

**Called by:**
- `bound require` (319)

**Calls:**
- `anonymous` (248)
- `(anonymous)` (71)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` | Self: 0.0% (0us) | Total: 6.3% (107.0ms) | Samples: 0

**Calls:**
- `loadPlugin` (71)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `readdirSync` (1)

### `findVariable`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` | Self: 0.0% (0us) | Total: 2.3% (39.2ms) | Samples: 0

**Called by:**
- `Identifier` (27)

**Calls:**
- `get` (27)

### `(anonymous)`
`/Users/ericsan/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:828` | Self: 0.0% (0us) | Total: 0.2% (4.5ms) | Samples: 0

**Called by:**
- `isEffectivelyConst` (3)

**Calls:**
- `_buildReference` (1)
- `_buildReference` (1)
- `_buildReference` (1)

### `Identifier`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:896` | Self: 0.0% (0us) | Total: 0.5% (8.7ms) | Samples: 0

**Called by:**
- `getElementValues` (3)
- `getStaticValue` (3)

**Calls:**
- `canBeConsideredConst` (6)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.9% (16.5ms) | Samples: 0

**Calls:**
- `parseModule` (11)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 0.3% (6.4ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `getPropertyName` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` | Self: 0.0% (0us) | Total: 0.1% (2.5ms) | Samples: 0

**Called by:**
- `getNodes` (2)

**Calls:**
- `copyDataProperties` (2)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1123` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `_getSharedCaches` (1)

### `getStaticValue`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1201` | Self: 0.0% (0us) | Total: 3.0% (51.0ms) | Samples: 0

**Called by:**
- `getStringIfConstant` (35)

**Calls:**
- `MemberExpression` (20)
- `Identifier` (5)
- `CallExpression` (4)
- `Identifier` (3)
- `Identifier` (1)
- `AssignmentExpression` (1)
- `Literal` (1)

### `Identifier`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:902` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getStaticValue` (1)

**Calls:**
- `CallExpression` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:8` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `internal:streams/duplex`
`internal:streams/duplex:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4587` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `describeRule` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `getPropertyName`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1279` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isPropertyThen` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1717` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:60` | Self: 0.0% (0us) | Total: 0.5% (9.0ms) | Samples: 0

**Called by:**
- `evaluate` (6)

**Calls:**
- `map` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.4% (7.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6494` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_ensureTagCaches` (1)

### `link`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (14.5ms) | Samples: 0

**Called by:**
- `link` (7)
- `linkAndEvaluateModule` (3)

**Calls:**
- `link` (7)
- `moduleDeclarationInstantiation` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/index.js:8` | Self: 0.0% (0us) | Total: 0.3% (5.8ms) | Samples: 0

**Called by:**
- `parseModule` (4)

**Calls:**
- `bound require` (4)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2019` | Self: 0.0% (0us) | Total: 1.7% (28.9ms) | Samples: 0

**Called by:**
- `isPropertyThen` (20)

**Calls:**
- `_precomputeScopes` (15)
- `_precomputeScopes` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.1% (2.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `_encodeSource` (1)
- `_encodeSource` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2192` | Self: 0.0% (0us) | Total: 1.5% (26.5ms) | Samples: 0

**Called by:**
- `_buildScope` (9)
- `getNodes` (5)
- `isPropertyThen` (3)
- `_buildReference` (1)

**Calls:**
- `_buildScope` (9)
- `_buildScope` (8)
- `_buildScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.0% (0us) | Total: 0.6% (11.4ms) | Samples: 0

**Called by:**
- `_buildScope` (8)

**Calls:**
- `_computeIsStrict` (8)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2197` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/find-up/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.4% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `useColors`
`/Users/ericsan/node_modules/debug/src/node.js:158` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `createDebug` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3110` | Self: 0.0% (0us) | Total: 0.2% (4.6ms) | Samples: 0

**Called by:**
- `getNodes` (3)

**Calls:**
- `_nodesFromRange` (2)
- `_nodesFromRange` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` | Self: 0.0% (0us) | Total: 1.0% (18.4ms) | Samples: 0

**Called by:**
- `getNodes` (7)
- `getNodes` (5)

**Calls:**
- `_nodeViewRaw` (9)
- `get callee` (2)
- `_nodeViewRaw` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7738` | Self: 0.0% (0us) | Total: 0.3% (6.0ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `defineProperty` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:98` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `getNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js:53` | Self: 0.0% (0us) | Total: 1.0% (18.3ms) | Samples: 0

**Called by:**
- `generatorResume` (11)

**Calls:**
- `get parent` (5)
- `get parent` (2)
- `parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get left` (1)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.2% (4.2ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `Identifier`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:887` | Self: 0.0% (0us) | Total: 2.3% (39.2ms) | Samples: 0

**Called by:**
- `MemberExpression` (20)
- `getStaticValue` (5)
- `getElementValues` (2)

**Calls:**
- `findVariable` (27)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1963` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isMemberExpression` (1)

**Calls:**
- `nodeView` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2348` | Self: 0.0% (0us) | Total: 0.3% (5.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (4)

**Calls:**
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.5% (9.4ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/targets-parser.js:2` | Self: 0.0% (0us) | Total: 0.4% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8043` | Self: 0.0% (0us) | Total: 0.3% (6.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `get source` (3)
- `reset` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` | Self: 0.0% (0us) | Total: 0.2% (4.6ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `decode` (3)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1697` | Self: 0.0% (0us) | Total: 0.2% (4.3ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `_nodesFromRange` (2)
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.5% (9.0ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/cast.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 2.3% (40.1ms) | Samples: 0

**Called by:**
- `parseModule` (26)

**Calls:**
- `bound require` (26)

### `performProxyObjectGet`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `isPropertyThen` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2139` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.2% (4.2ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3007` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `_buildScope` (1)

### `MemberExpression`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:964` | Self: 0.0% (0us) | Total: 1.7% (29.0ms) | Samples: 0

**Called by:**
- `getStaticValue` (20)

**Calls:**
- `Identifier` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:14` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.4% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `loadPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:95` | Self: 0.0% (0us) | Total: 6.3% (107.0ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (71)

**Calls:**
- `bound require` (71)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `splitPrefixSuffix`
`/Users/ericsan/node_modules/change-case/dist/index.js:205` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `camelCase` (1)

**Calls:**
- `split` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:9` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `linkAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `link` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/type-check/lib/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:24` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `camelCase`
`/Users/ericsan/node_modules/change-case/dist/index.js:68` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (1)
- `(anonymous)` (1)

**Calls:**
- `map` (2)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4083` | Self: 0.0% (0us) | Total: 5.6% (95.5ms) | Samples: 0

**Called by:**
- `_NodeView_LR` (62)

**Calls:**
- `_resolveUnicodeEscapes` (45)
- `_identAt` (16)
- `slice` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getPropertyName`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1276` | Self: 0.0% (0us) | Total: 1.0% (17.9ms) | Samples: 0

**Called by:**
- `isPropertyThen` (12)

**Calls:**
- `getStringIfConstant` (12)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/internal/re.js:222` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createToken` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1028` | Self: 0.0% (0us) | Total: 2.3% (39.2ms) | Samples: 0

**Called by:**
- `findVariable` (27)

**Calls:**
- `_ensureVarsSet` (27)

### `Literal`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:937` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getStaticValue` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/change-case/dist/index.js:181` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `toLocaleLowerCase` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/compat.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:15` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8051` | Self: 0.0% (0us) | Total: 78.5% (1.33s) | Samples: 0

**Called by:**
- `_lintSourceOne` (877)

**Calls:**
- `walkNodes` (751)
- `walkNodes` (22)
- `walkNodes` (19)
- `walkNodes` (17)
- `walkNodes` (14)
- `walkNodes` (12)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (3)
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

### `(anonymous)`
`/Users/ericsan/node_modules/debug/src/node.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/type-check/lib/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1401` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `Literal` (1)

**Calls:**
- `_rawTokenText` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4230` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getPropertyName`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1278` | Self: 0.0% (0us) | Total: 0.9% (16.9ms) | Samples: 0

**Called by:**
- `isPropertyThen` (10)
- `getNodes` (1)

**Calls:**
- `get key` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `addPolyfillToken`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:55` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `camelCase` (1)

### `AssignmentExpression`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:681` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getStaticValue` (1)

**Calls:**
- `get right` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getStringIfConstant`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:1234` | Self: 0.0% (0us) | Total: 3.0% (51.0ms) | Samples: 0

**Called by:**
- `getPropertyName` (12)
- `getPropertyName` (8)
- `isPropertyThen` (8)
- `getNodes` (7)

**Calls:**
- `getStaticValue` (35)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 33.3% | 565.2ms | `[native code]` |
| 19.3% | 328.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 19.0% | 322.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 13.3% | 226.1ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js` |
| 11.8% | 201.2ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` |
| 1.0% | 18.6ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js` |
| 0.4% | 7.2ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js` |
| 0.2% | 4.5ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js` |
| 0.1% | 2.9ms | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs` |
| 0.1% | 2.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.1% | 2.5ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js` |
| 0.1% | 1.7ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-context.js` |
| 0.1% | 1.7ms | `/Users/ericsan/node_modules/acorn-jsx/xhtml.js` |
| 0.1% | 1.7ms | `/Users/ericsan/node_modules/change-case/dist/index.js` |
| 0.0% | 1.6ms | `/Users/ericsan/node_modules/semver/internal/re.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 1.4ms | `node:child_process` |
| 0.0% | 1.4ms | `/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.2ms | `internal:fs/streams` |
