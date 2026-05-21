# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.51s | 1604 | 1.0ms | 536 |

**Top 10:** `_nodeViewRaw` 17.4%, `getAncestorsFor` 16.5%, `(anonymous)` 10.7%, `anonymous` 9.5%, `parse` 8.7%, `walkNodes` 3.4%, `getOwnPropertyDescriptor` 3.3%, `getAncestorsFor` 2.5%, `source` 2.4%, `walkNodes` 2.2%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 17.4% | 439.8ms | 17.4% | 439.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` |
| 16.5% | 416.4ms | 33.5% | 842.8ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6553` |
| 10.7% | 271.2ms | 42.5% | 1.07s | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 9.5% | 241.3ms | 100.0% | 2.88s | `anonymous` | `[native code]` |
| 8.7% | 219.9ms | 8.7% | 219.9ms | `parse` | `[native code]` |
| 3.4% | 86.7ms | 4.0% | 102.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7777` |
| 3.3% | 84.6ms | 3.3% | 84.6ms | `getOwnPropertyDescriptor` | `[native code]` |
| 2.5% | 65.0ms | 2.5% | 65.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6565` |
| 2.4% | 60.7ms | 2.4% | 60.7ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 2.2% | 57.6ms | 65.4% | 1.64s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7578` |
| 2.1% | 54.1ms | 51.2% | 1.29s | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 2.0% | 50.4ms | 38.3% | 964.7ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6617` |
| 1.4% | 37.0ms | 1.4% | 37.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4061` |
| 1.4% | 36.8ms | 1.4% | 36.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4050` |
| 1.2% | 31.3ms | 10.5% | 264.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4172` |
| 1.1% | 28.5ms | 1.1% | 28.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7715` |
| 0.9% | 23.1ms | 0.9% | 23.1ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4114` |
| 0.8% | 22.5ms | 0.8% | 22.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4183` |
| 0.8% | 21.9ms | 0.9% | 23.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7552` |
| 0.8% | 21.1ms | 0.8% | 21.1ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 0.6% | 16.2ms | 0.6% | 16.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.5% | 13.9ms | 0.5% | 13.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.5% | 13.8ms | 0.5% | 13.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7817` |
| 0.4% | 10.7ms | 12.4% | 313.1ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6658` |
| 0.4% | 10.6ms | 0.4% | 10.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.3% | 9.6ms | 0.3% | 9.6ms | `defineProperty` | `[native code]` |
| 0.3% | 9.1ms | 4.3% | 109.3ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4122` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:827` |
| 0.2% | 7.5ms | 12.9% | 327.0ms | `_compile` | `[native code]` |
| 0.2% | 7.4ms | 0.2% | 7.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7748` |
| 0.2% | 7.0ms | 0.2% | 7.0ms | `decode` | `[native code]` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7542` |
| 0.2% | 5.8ms | 2.6% | 66.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:801` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7716` |
| 0.1% | 3.6ms | 0.1% | 3.6ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6534` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6968` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `encodeInto` | `[native code]` |
| 0.1% | 3.1ms | 0.2% | 6.2ms | `readFileSync` | `[native code]` |
| 0.1% | 2.9ms | 0.1% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7752` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `create` | `[native code]` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js:35` |
| 0.0% | 2.0ms | 0.0% | 2.0ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4478` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getContextualType.js:30` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6331` |
| 0.0% | 1.8ms | 0.1% | 3.5ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6804` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3664` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:8` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_normalizeIPv6` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:815` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:30` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/configs/flat/base.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1109` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4166` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/get-intrinsic/index.js:188` |
| 0.0% | 1.6ms | 0.1% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7647` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:805` |
| 0.0% | 1.6ms | 3.9% | 98.7ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:8` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7750` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `replaceGTE0` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:482` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-type-exports.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:8` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6550` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/gatherLogicalOperands.js:30` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js:30` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4101` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `node:crypto` | `node:crypto:2` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/builtinSymbolLikes.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:8` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `regExpSplitFast` | `[native code]` |
| 0.0% | 1.4ms | 0.1% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7747` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `byteLength` | `[native code]` |
| 0.0% | 1.4ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7846` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-member-access.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createScanner` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:8` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RegExp` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/List.js:616` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-boolean-literal-compare.js:8` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getTypeName.js:8` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:19` |
| 0.0% | 1.3ms | 0.1% | 4.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:30` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `forEach` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:8` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:9561` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6807` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6563` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-useless-default-assignment.js:8` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:52` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/patternCapture.js:1` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 2.88s | 9.5% | 241.3ms | `anonymous` | `[native code]` |
| 100.0% | 2.85s | 0.0% | 0us | `bound require` | `[native code]` |
| 100.0% | 2.84s | 0.0% | 0us | `require` | `[native code]` |
| 86.6% | 2.18s | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 86.4% | 2.17s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 74.6% | 1.87s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 74.2% | 1.86s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8063` |
| 65.4% | 1.64s | 2.2% | 57.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7578` |
| 51.2% | 1.29s | 2.1% | 54.1ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 42.5% | 1.07s | 10.7% | 271.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 38.3% | 964.7ms | 2.0% | 50.4ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6617` |
| 33.5% | 842.8ms | 16.5% | 416.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6553` |
| 17.4% | 439.8ms | 17.4% | 439.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` |
| 13.5% | 339.9ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 13.5% | 339.9ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 13.3% | 335.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 12.9% | 327.0ms | 0.2% | 7.5ms | `_compile` | `[native code]` |
| 12.8% | 324.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:7` |
| 12.8% | 324.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` |
| 12.8% | 322.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:134` |
| 12.7% | 320.9ms | 0.0% | 0us | `_installCjsSubstitutes` | `/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:77` |
| 12.4% | 313.1ms | 0.4% | 10.7ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6658` |
| 10.8% | 272.7ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6619` |
| 10.5% | 264.6ms | 1.2% | 31.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4172` |
| 9.0% | 226.6ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 8.7% | 219.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 8.7% | 219.9ms | 8.7% | 219.9ms | `parse` | `[native code]` |
| 4.6% | 116.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:40` |
| 4.3% | 109.3ms | 0.3% | 9.1ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4122` |
| 4.3% | 108.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:32` |
| 4.3% | 108.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:51` |
| 4.3% | 108.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/hasOverloadSignatures.js:5` |
| 4.0% | 102.0ms | 3.4% | 86.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7777` |
| 3.9% | 98.7ms | 0.0% | 1.6ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 3.3% | 84.6ms | 3.3% | 84.6ms | `getOwnPropertyDescriptor` | `[native code]` |
| 3.0% | 76.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:23` |
| 3.0% | 76.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:30` |
| 3.0% | 76.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:37` |
| 3.0% | 76.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:4` |
| 2.9% | 73.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:39` |
| 2.7% | 68.0ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` |
| 2.7% | 68.0ms | 0.0% | 0us | `loadPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:95` |
| 2.6% | 66.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/index.js:5` |
| 2.6% | 66.5ms | 0.2% | 5.8ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:801` |
| 2.5% | 65.0ms | 2.5% | 65.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6565` |
| 2.5% | 63.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:65` |
| 2.4% | 60.7ms | 2.4% | 60.7ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 1.6% | 40.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/export.js:2` |
| 1.4% | 37.0ms | 1.4% | 37.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4061` |
| 1.4% | 36.8ms | 1.4% | 36.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4050` |
| 1.4% | 36.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/builder.js:19` |
| 1.3% | 35.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/visitor.js:2` |
| 1.3% | 33.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:12` |
| 1.1% | 28.5ms | 1.1% | 28.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7715` |
| 1.0% | 26.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-typos.js:9` |
| 0.9% | 25.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:42` |
| 0.9% | 25.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:27` |
| 0.9% | 23.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.9% | 23.7ms | 0.8% | 21.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7552` |
| 0.9% | 23.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` |
| 0.9% | 23.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/TypeOrValueSpecifier.js:42` |
| 0.9% | 23.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInFile.js:7` |
| 0.9% | 23.1ms | 0.9% | 23.1ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4114` |
| 0.8% | 22.5ms | 0.8% | 22.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4183` |
| 0.8% | 21.1ms | 0.8% | 21.1ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 0.8% | 20.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` |
| 0.7% | 19.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` |
| 0.7% | 17.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` |
| 0.7% | 17.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.7% | 17.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:38` |
| 0.6% | 16.2ms | 0.6% | 16.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.5% | 14.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` |
| 0.5% | 14.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` |
| 0.5% | 13.9ms | 0.5% | 13.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.5% | 13.8ms | 0.5% | 13.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7817` |
| 0.5% | 13.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` |
| 0.5% | 12.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` |
| 0.5% | 12.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` |
| 0.5% | 12.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` |
| 0.5% | 12.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` |
| 0.4% | 12.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.4% | 10.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` |
| 0.4% | 10.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` |
| 0.4% | 10.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` |
| 0.4% | 10.6ms | 0.4% | 10.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.3% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.3% | 9.6ms | 0.3% | 9.6ms | `defineProperty` | `[native code]` |
| 0.3% | 9.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/utility.js:32` |
| 0.3% | 9.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.3% | 8.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` |
| 0.3% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` |
| 0.3% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:827` |
| 0.2% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` |
| 0.2% | 7.4ms | 0.2% | 7.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7748` |
| 0.2% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.2% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` |
| 0.2% | 7.0ms | 0.2% | 7.0ms | `decode` | `[native code]` |
| 0.2% | 7.0ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.2% | 6.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:18` |
| 0.2% | 6.3ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.2% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.2% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.2% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.2% | 6.2ms | 0.1% | 3.1ms | `readFileSync` | `[native code]` |
| 0.2% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7542` |
| 0.2% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:31` |
| 0.2% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:8` |
| 0.2% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-unused-state.js:15` |
| 0.2% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/componentUtil.js:3` |
| 0.2% | 5.9ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8055` |
| 0.1% | 4.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 0.1% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:9` |
| 0.1% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/object.fromentries/index.js:6` |
| 0.1% | 4.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7539` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/typed.js:27` |
| 0.1% | 4.7ms | 0.0% | 0us | `get` | `node:assert:70` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/doctrine.js:897` |
| 0.1% | 4.7ms | 0.0% | 0us | `node:assert` | `node:assert:588` |
| 0.1% | 4.7ms | 0.0% | 0us | `assign` | `[native code]` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/typed.js:1303` |
| 0.1% | 4.7ms | 0.0% | 0us | `loadAssertionError` | `node:assert:28` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/doctrine.js:18` |
| 0.1% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:5` |
| 0.1% | 4.4ms | 0.1% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7752` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:6` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` |
| 0.1% | 4.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:30` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:33` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:38` |
| 0.1% | 4.3ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7747` |
| 0.1% | 4.3ms | 0.0% | 0us | `getESLintCoreRule` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getESLintCoreRule.js:7` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7716` |
| 0.1% | 4.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:34` |
| 0.1% | 3.6ms | 0.1% | 3.6ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6534` |
| 0.1% | 3.5ms | 0.0% | 1.8ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6804` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6968` |
| 0.1% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/resolve/index.js:1` |
| 0.1% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/propTypes.js:12` |
| 0.1% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/version.js:11` |
| 0.1% | 3.3ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `encodeInto` | `[native code]` |
| 0.1% | 3.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.1% | 3.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:114` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain.js:5` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/jsx.js:7` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/elementType.js:1` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:19` |
| 0.1% | 3.2ms | 0.0% | 0us | `map` | `[native code]` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/object.groupby/index.js:6` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:3` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/object.fromentries/implementation.js:3` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:8` |
| 0.1% | 2.9ms | 0.0% | 0us | `internal:util/colors` | `internal:util/colors:24` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array-includes/implementation.js:3` |
| 0.1% | 2.9ms | 0.0% | 0us | `refresh` | `internal:util/colors:18` |
| 0.1% | 2.9ms | 0.0% | 0us | `get WriteStream` | `node:fs:583` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array-includes/index.js:8` |
| 0.1% | 2.9ms | 0.0% | 0us | `internal:assert/assertion_error` | `internal:assert/assertion_error:2` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` |
| 0.1% | 2.9ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7647` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `create` | `[native code]` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` |
| 0.1% | 2.8ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8058` |
| 0.1% | 2.7ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7846` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js:35` |
| 0.1% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:67` |
| 0.0% | 2.0ms | 0.0% | 2.0ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4478` |
| 0.0% | 2.0ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/resolve/lib/async.js:13` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:94` |
| 0.0% | 1.8ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6040` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getContextualType.js:37` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:21` |
| 0.0% | 1.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7125` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2015.js:15` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6331` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getContextualType.js:30` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:9` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/builder.js:18` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/predicates.js:8` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isUnsafeAssignment.js:39` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/predicates.js:52` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/predicates.js:30` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:28` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/baseTypeUtils.js:38` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:20` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:49` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2024.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:82` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1505` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3664` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/object.groupby/implementation.js:8` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:46` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-no-literals.js:13` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-scope/dist/eslint-scope.cjs:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/wrap-iife.js:15` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:22` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/dot-notation.js:12` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/dot-notation.js:41` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:20` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:128` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:41` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/CreateDataProperty.js:7` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/object.fromentries/implementation.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/CreateDataPropertyOrThrow.js:6` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:44` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:18` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:8` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-parameters.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:81` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-parameters.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-parameters.js:38` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:28` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:5` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:7` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 1.7ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 1.7ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:906` |
| 0.0% | 1.7ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 1.7ms | 0.0% | 0us | `getFullPath` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:209` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 1.7ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 1.7ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_normalizeIPv6` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:815` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:39` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:103` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/configs/flat/base.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/configs/flat/all.js:19` |
| 0.0% | 1.7ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4230` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1109` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/lib/index.js:19` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/lib/values/expressions/index.js:68` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/lib/values/index.js:28` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/lib/getPropValue.js:9` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4166` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:45` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:152258` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:5` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/get-intrinsic/index.js:188` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/array-includes/index.js:5` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/set-function-length/index.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/call-bind/index.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:26` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/types/dist/index.js:21` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:805` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:38` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:58` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-promise/rules/no-return-wrap.js:10` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:8` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:38` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:78` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:85` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:104` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:9` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7750` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-unused-state.js:14` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-no-comment-textnodes.js:11` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/report.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/message.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `satisfies` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/functions/satisfies.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `Range` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:42` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` |
| 0.0% | 1.6ms | 0.0% | 0us | `parseRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:139` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `replaceGTE0` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:482` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:138` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:14` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-return.js:39` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array.prototype.flatmap/shim.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array.prototype.flatmap/index.js:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/propTypes.js:7` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:10` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2025/CreateIteratorFromClosure.js:10` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:12` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-iterator-helpers/Iterator.prototype.map/index.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-iterator-helpers/Iterator.prototype.map/implementation.js:7` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:31` |
| 0.0% | 1.5ms | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:84` |
| 0.0% | 1.5ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `asyncWrap` | `node:fs/promises:150` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/isArrayMethodCallWithPredicate.js:39` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/isArrayMethodCallWithPredicate.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/isArrayMethodCallWithPredicate.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:33` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:50` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:17` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-type-exports.js:38` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-type-exports.js:5` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-type-exports.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:113` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:43` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:8` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:30` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6550` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/resolve/lib/async.js:10` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:131` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array-includes/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/define-properties/index.js:14` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/gatherLogicalOperands.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:43` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/gatherLogicalOperands.js:40` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:76` |
| 0.0% | 1.5ms | 0.0% | 0us | `_installCjsSubstitutes` | `/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:73` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:118` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js:37` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/string.prototype.matchall/implementation.js:18` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/string.prototype.matchall/index.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-indent.js:34` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/doctrine/lib/doctrine.js:897` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/doctrine/lib/doctrine.js:18` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/builder.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/array-includes/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4101` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:21` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array-includes/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:26` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/get-intrinsic/index.js:55` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/set-function-length/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/call-bind/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-module-utils/hash.js:10` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:10` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `node:crypto` | `node:crypto:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-module-utils/resolve.js:10` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/core/importType.js:125` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/builtinSymbolLikes.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:18` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/builtinSymbolLikes.js:45` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/builtinSymbolLikes.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:38` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:49` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:55` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/file-report.js:13` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:44` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/ranges/subset.js:73` |
| 0.0% | 1.4ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:21` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `regExpSplitFast` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `bound resolve` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-iterator-helpers/Iterator.from/implementation.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-iterator-helpers/Iterator.from/index.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:11` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2025/Call.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2025/GetIteratorFlattenable.js:7` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/ast.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:46` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2019.js:10` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:57` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `byteLength` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `internal:streams/duplex` | `internal:streams/duplex:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:88` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-member-access.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-member-access.js:37` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-member-access.js:30` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createScanner` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:33198` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2024/CreateDataProperty.js:7` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/object.groupby/implementation.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2024/CreateDataPropertyOrThrow.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2024/OrdinaryDefineOwnProperty.js:11` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RegExp` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:37` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `createToken` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:49` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:91` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:193` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:4` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/List.js:616` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:74` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-boolean-literal-compare.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-boolean-literal-compare.js:38` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-boolean-literal-compare.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:72` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getTypeName.js:38` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getTypeName.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getTypeName.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:24` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8062` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4624` |
| 0.0% | 1.4ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.4ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.4ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:19` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:49` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/find-up/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config-loader.js:14` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-escape.js:10` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/GetIterator.js:12` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/AsyncFromSyncIteratorContinuation.js:14` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/CreateAsyncFromSyncIterator.js:10` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:73` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-condition.js:40` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `forEach` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:136` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:38` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2025/ToNumber.js:10` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2025/ToIntegerOrInfinity.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6901` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5918` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:42` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:65` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6143` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:9561` |
| 0.0% | 1.3ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6846` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-duplicate-type-constituents.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-duplicate-type-constituents.js:38` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:37` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-duplicate-type-constituents.js:30` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6807` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/comment-parser/lib/parser/index.cjs:13` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/comment-parser/lib/index.cjs:27` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:5` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-restricted-imports.js:10` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-restricted-imports.js:41` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:123` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:15` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:4` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6563` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/array-includes/index.js:8` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2025/ToNumber.js:9` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/is-symbol/index.js:6` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-to-primitive/es2015.js:8` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2025/ToIntegerOrInfinity.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/array-includes/implementation.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2025/ToPrimitive.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-useless-default-assignment.js:38` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-useless-default-assignment.js:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:97` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-useless-default-assignment.js:8` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:133` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/builder.js:15` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/object.groupby/index.js:9` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:113` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:24` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/prop-types/index.js:9` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/init-declarations.js:6` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-typos.js:8` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:52` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/visitor.js:7` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/patternCapture.js:1` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-restricted-imports.js:7` |

## Function Details

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` | Self: 17.4% (439.8ms) | Total: 17.4% (439.8ms) | Samples: 290

**Called by:**
- `getAncestorsFor` (276)
- `invokeSelectorHandlers` (14)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6553` | Self: 16.5% (416.4ms) | Total: 33.5% (842.8ms) | Samples: 273

**Called by:**
- `_runSelectorList` (554)

**Calls:**
- `_nodeViewRaw` (276)
- `_nodeViewRaw` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 10.7% (271.2ms) | Total: 42.5% (1.07s) | Samples: 181

**Called by:**
- `(anonymous)` (532)
- `_runSelectorList` (182)

**Calls:**
- `(anonymous)` (532)
- `(anonymous)` (1)

### `anonymous`
`[native code]` | Self: 9.5% (241.3ms) | Total: 100.0% (2.88s) | Samples: 156

**Called by:**
- `require` (1459)
- `bound require` (6)
- `loadAssertionError` (3)
- `internal:assert/assertion_error` (2)
- `get WriteStream` (2)
- `bound resolve` (1)
- `node:stream` (1)
- `node:fs` (1)
- `internal:streams/duplex` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/compose` (1)
- `internal:fs/streams` (1)
- `internal:streams/pipeline` (1)

**Calls:**
- `(anonymous)` (162)
- `(anonymous)` (162)
- `(anonymous)` (161)
- `(anonymous)` (43)
- `(anonymous)` (41)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (15)
- `(anonymous)` (15)
- `(anonymous)` (15)
- `(anonymous)` (13)
- `(anonymous)` (13)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `node:assert` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `internal:assert/assertion_error` (2)
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
- `internal:util/colors` (2)
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
- `node:fs/promises` (1)
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
- `internal:streams/pipeline` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:stream` (1)
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
- `internal:streams/operators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/duplex` (1)
- `(anonymous)` (1)
- `node:crypto` (1)
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
- `internal:fs/streams` (1)
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
- `internal:streams/compose` (1)
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
- `node:fs` (1)
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
- `node:stream` (1)
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

### `parse`
`[native code]` | Self: 8.7% (219.9ms) | Total: 8.7% (219.9ms) | Samples: 145

**Called by:**
- `parseSource` (145)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7777` | Self: 3.4% (86.7ms) | Total: 4.0% (102.0ms) | Samples: 57

**Called by:**
- `runPlugins` (67)

**Calls:**
- `invokeSelectorHandlers` (10)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 3.3% (84.6ms) | Total: 3.3% (84.6ms) | Samples: 7

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6565` | Self: 2.5% (65.0ms) | Total: 2.5% (65.0ms) | Samples: 44

**Called by:**
- `_runSelectorList` (44)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` | Self: 2.4% (60.7ms) | Total: 2.4% (60.7ms) | Samples: 38

**Called by:**
- `_identAt` (38)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7578` | Self: 2.2% (57.6ms) | Total: 65.4% (1.64s) | Samples: 38

**Called by:**
- `runPlugins` (1083)

**Calls:**
- `invokeSelectorHandlers` (841)
- `invokeSelectorHandlers` (204)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` | Self: 2.1% (54.1ms) | Total: 51.2% (1.29s) | Samples: 35

**Called by:**
- `walkNodes` (841)
- `walkNodes` (10)

**Calls:**
- `_runSelectorList` (635)
- `_runSelectorList` (181)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6617` | Self: 2.0% (50.4ms) | Total: 38.3% (964.7ms) | Samples: 33

**Called by:**
- `invokeSelectorHandlers` (635)

**Calls:**
- `getAncestorsFor` (554)
- `getAncestorsFor` (44)
- `getAncestorsFor` (2)
- `getAncestorsFor` (1)
- `getAncestorsFor` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4061` | Self: 1.4% (37.0ms) | Total: 1.4% (37.0ms) | Samples: 24

**Called by:**
- `_nodeViewRaw` (24)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4050` | Self: 1.4% (36.8ms) | Total: 1.4% (36.8ms) | Samples: 24

**Called by:**
- `_nodeViewRaw` (24)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4172` | Self: 1.2% (31.3ms) | Total: 10.5% (264.6ms) | Samples: 21

**Called by:**
- `invokeSelectorHandlers` (172)

**Calls:**
- `_NodeView_LR` (70)
- `_NodeView` (24)
- `_NodeView` (24)
- `_NodeView_LR` (15)
- `_NodeView_LR` (11)
- `_NodeView` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7715` | Self: 1.1% (28.5ms) | Total: 1.1% (28.5ms) | Samples: 19

**Called by:**
- `runPlugins` (19)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4114` | Self: 0.9% (23.1ms) | Total: 0.9% (23.1ms) | Samples: 15

**Called by:**
- `_nodeViewRaw` (15)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4183` | Self: 0.8% (22.5ms) | Total: 0.8% (22.5ms) | Samples: 15

**Called by:**
- `invokeSelectorHandlers` (10)
- `getAncestorsFor` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7552` | Self: 0.8% (21.9ms) | Total: 0.9% (23.7ms) | Samples: 15

**Called by:**
- `runPlugins` (16)

**Calls:**
- `_resolveHandlers` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` | Self: 0.8% (21.1ms) | Total: 0.8% (21.1ms) | Samples: 14

**Called by:**
- `_computeIdentifierName` (14)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` | Self: 0.6% (16.2ms) | Total: 0.6% (16.2ms) | Samples: 11

**Called by:**
- `_nodeViewRaw` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.5% (13.9ms) | Total: 0.5% (13.9ms) | Samples: 9

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7817` | Self: 0.5% (13.8ms) | Total: 0.5% (13.8ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6658` | Self: 0.4% (10.7ms) | Total: 12.4% (313.1ms) | Samples: 7

**Called by:**
- `walkNodes` (204)

**Calls:**
- `_nodeViewRaw` (172)
- `_nodeViewRaw` (14)
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` | Self: 0.4% (10.6ms) | Total: 0.4% (10.6ms) | Samples: 7

**Called by:**
- `_nodeViewRaw` (7)

### `defineProperty`
`[native code]` | Self: 0.3% (9.6ms) | Total: 0.3% (9.6ms) | Samples: 5

**Called by:**
- `asyncWrap` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `walkNodes` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4122` | Self: 0.3% (9.1ms) | Total: 4.3% (109.3ms) | Samples: 6

**Called by:**
- `_nodeViewRaw` (70)

**Calls:**
- `_computeIdentifierName` (63)
- `_computeIdentifierName` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:827` | Self: 0.3% (7.7ms) | Total: 0.3% (7.7ms) | Samples: 5

**Called by:**
- `_computeIdentifierName` (5)

### `_compile`
`[native code]` | Self: 0.2% (7.5ms) | Total: 12.9% (327.0ms) | Samples: 5

**Called by:**
- `_installCjsSubstitutes` (160)
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (48)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (17)
- `(anonymous)` (11)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
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

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7748` | Self: 0.2% (7.4ms) | Total: 0.2% (7.4ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `decode`
`[native code]` | Self: 0.2% (7.0ms) | Total: 0.2% (7.0ms) | Samples: 5

**Called by:**
- `get source` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7542` | Self: 0.2% (6.0ms) | Total: 0.2% (6.0ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:801` | Self: 0.2% (5.8ms) | Total: 2.6% (66.5ms) | Samples: 4

**Called by:**
- `_computeIdentifierName` (42)

**Calls:**
- `source` (38)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` | Self: 0.1% (4.8ms) | Total: 0.1% (4.8ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7716` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6534` | Self: 0.1% (3.6ms) | Total: 0.1% (3.6ms) | Samples: 2

**Called by:**
- `_runSelectorList` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6968` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `encodeInto`
`[native code]` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `_encodeSource` (2)

### `readFileSync`
`[native code]` | Self: 0.1% (3.1ms) | Total: 0.2% (6.2ms) | Samples: 2

**Called by:**
- `readFileSync` (2)
- `(anonymous)` (1)
- `_installCjsSubstitutes` (1)

**Calls:**
- `readFileSync` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7752` | Self: 0.1% (2.9ms) | Total: 0.1% (4.4ms) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `defineProperty` (1)

### `create`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js:35` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `anonymous` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4478` | Self: 0.0% (2.0ms) | Total: 0.0% (2.0ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getContextualType.js:30` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6331` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6804` | Self: 0.0% (1.8ms) | Total: 0.1% (3.5ms) | Samples: 1

**Called by:**
- `walkNodes` (2)

**Calls:**
- `get value` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3664` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:8` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_normalizeIPv6`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:815` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:30` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/configs/flat/base.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1109` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `reset` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4166` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/get-intrinsic/index.js:188` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7647` | Self: 0.0% (1.6ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `esquery` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:805` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeIdentifierName` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.0% (1.6ms) | Total: 3.9% (98.7ms) | Samples: 1

**Called by:**
- `_NodeView_LR` (63)

**Calls:**
- `_identAt` (42)
- `_resolveUnicodeEscapes` (14)
- `_identAt` (5)
- `_identAt` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:8` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7750` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `replaceGTE0`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:482` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-type-exports.js:5` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:8` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6550` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/gatherLogicalOperands.js:30` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js:30` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4101` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_NodeView_LR` (1)

### `node:crypto`
`node:crypto:2` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/builtinSymbolLikes.js:5` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:8` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `regExpSplitFast`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `Comparator` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7747` | Self: 0.0% (1.4ms) | Total: 0.1% (4.3ms) | Samples: 1

**Called by:**
- `runPlugins` (3)

**Calls:**
- `create` (2)

### `byteLength`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7846` | Self: 0.0% (1.4ms) | Total: 0.1% (2.7ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-member-access.js:5` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `createScanner`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:8` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `RegExp`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `createToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/List.js:616` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-boolean-literal-compare.js:8` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getTypeName.js:8` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `Ae` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:19` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:30` | Self: 0.0% (1.3ms) | Total: 0.1% (4.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (1)

### `forEach`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:8` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:9561` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6807` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6563` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-useless-default-assignment.js:8` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:52` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/patternCapture.js:1` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `loadAssertionError`
`node:assert:28` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `get` (3)

**Calls:**
- `anonymous` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-module-utils/hash.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/builder.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:73` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Range`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `satisfies` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/object.fromentries/implementation.js:3` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `node:fs/promises`
`node:fs/promises:84` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `asyncWrap` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4624` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `g` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:4` | Self: 0.0% (0us) | Total: 3.0% (76.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `getOwnPropertyDescriptor` (2)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `regExpSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `Range` (1)
- `parseRange` (1)

**Calls:**
- `replaceGTE0` (1)
- `parseRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-iterator-helpers/Iterator.from/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.2% (6.3ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.9% (23.9ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8058` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `get source` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:42` | Self: 0.0% (0us) | Total: 0.9% (25.1ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 86.4% (2.17s) | Samples: 0

**Calls:**
- `(anonymous)` (1432)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/find-up/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:103` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/predicates.js:52` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `getFullPath` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:26` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/builder.js:19` | Self: 0.0% (0us) | Total: 1.4% (36.4ms) | Samples: 0

**Called by:**
- `anonymous` (24)

**Calls:**
- `bound require` (24)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:19` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2025/ToIntegerOrInfinity.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/report.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/CreateAsyncFromSyncIterator.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 13.3% (335.0ms) | Samples: 0

**Called by:**
- `parseModule` (169)

**Calls:**
- `bound require` (169)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:104` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/message.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:81` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:136` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/builtinSymbolLikes.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` | Self: 0.0% (0us) | Total: 0.5% (12.7ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:assert`
`node:assert:588` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `assign` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config-loader.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/componentUtil.js:3` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 9.0% (226.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (149)

**Calls:**
- `parseSource` (145)
- `parseSource` (2)
- `parseSource` (2)

### `refresh`
`internal:util/colors:18` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `internal:util/colors` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:114` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` | Self: 0.0% (0us) | Total: 0.5% (14.3ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` | Self: 0.0% (0us) | Total: 0.5% (12.7ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2025/ToNumber.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-typos.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/jsx.js:7` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:118` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/object.groupby/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` | Self: 0.0% (0us) | Total: 0.2% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `assign`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `node:assert` (3)

**Calls:**
- `get` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.2% (7.3ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/array-includes/implementation.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/core/importType.js:125` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/dot-notation.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/file-report.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/builder.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:12` | Self: 0.0% (0us) | Total: 1.3% (33.6ms) | Samples: 0

**Called by:**
- `anonymous` (22)

**Calls:**
- `bound require` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/isArrayMethodCallWithPredicate.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/resolve/lib/async.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/object.fromentries/implementation.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/ranges/subset.js:73` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `Comparator` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8062` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/GetIterator.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 8.7% (219.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (145)

**Calls:**
- `parse` (145)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-restricted-imports.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:26` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-to-primitive/es2015.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-duplicate-type-constituents.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isUnsafeAssignment.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:55` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `invokeMethodFnHandlers` (2)
- `invokeMethodFnHandlers` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 74.6% (1.87s) | Samples: 0

**Called by:**
- `(anonymous)` (1237)

**Calls:**
- `runPlugins` (1230)
- `runPlugins` (4)
- `runPlugins` (2)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` | Self: 0.0% (0us) | Total: 0.4% (10.7ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` | Self: 0.0% (0us) | Total: 0.3% (8.9ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2024/OrdinaryDefineOwnProperty.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:57` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `byteLength` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getTypeName.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.7% (17.9ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:33` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:91` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-unused-state.js:15` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `_compile` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/is-symbol/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5918` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfiSelector` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `addMetaSchema` (1)

**Calls:**
- `_addSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:7` | Self: 0.0% (0us) | Total: 12.8% (324.0ms) | Samples: 0

**Called by:**
- `anonymous` (162)

**Calls:**
- `bound require` (162)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 0.0% (2.0ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/index.js:5` | Self: 0.0% (0us) | Total: 2.6% (66.6ms) | Samples: 0

**Called by:**
- `anonymous` (43)

**Calls:**
- `bound require` (43)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:82` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:32` | Self: 0.0% (0us) | Total: 4.3% (108.5ms) | Samples: 0

**Called by:**
- `anonymous` (22)

**Calls:**
- `bound require` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/array-includes/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/lib/values/index.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/doctrine.js:18` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:40` | Self: 0.0% (0us) | Total: 4.6% (116.5ms) | Samples: 0

**Called by:**
- `_compile` (27)

**Calls:**
- `bound require` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:78` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `addMetaSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:streams/duplex`
`internal:streams/duplex:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:30` | Self: 0.0% (0us) | Total: 3.0% (76.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/CreateDataPropertyOrThrow.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `resolveIds` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/isArrayMethodCallWithPredicate.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/array-includes/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/set-function-length/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/comment-parser/lib/index.cjs:27` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:assert/assertion_error`
`internal:assert/assertion_error:2` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (2.85s) | Samples: 0

**Called by:**
- `(anonymous)` (169)
- `(anonymous)` (162)
- `(anonymous)` (162)
- `(anonymous)` (48)
- `loadPlugin` (43)
- `(anonymous)` (43)
- `(anonymous)` (41)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (17)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (15)
- `(anonymous)` (15)
- `(anonymous)` (15)
- `(anonymous)` (13)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `patchAstUtils` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `getESLintCoreRule` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
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
- `(anonymous)` (2)
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
- `_getFfiSelector` (1)
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
- `require` (1459)
- `anonymous` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-module-utils/resolve.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-useless-default-assignment.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2025/ToPrimitive.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:152258` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2024.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `encodeInto` (2)

### `loadPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:95` | Self: 0.0% (0us) | Total: 2.7% (68.0ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (44)

**Calls:**
- `bound require` (43)
- `bound resolve` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-restricted-imports.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInFile.js:7` | Self: 0.0% (0us) | Total: 0.9% (23.4ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:38` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/object.groupby/index.js:6` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:5` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `_compile` (3)

**Calls:**
- `bound require` (3)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 13.5% (339.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (172)

**Calls:**
- `(anonymous)` (169)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-parameters.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/resolve/index.js:1` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.9% (23.4ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/builtinSymbolLikes.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:9` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/ast.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` | Self: 0.0% (0us) | Total: 0.2% (6.1ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-duplicate-type-constituents.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `satisfies`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/functions/satisfies.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Range` (1)

### `getESLintCoreRule`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getESLintCoreRule.js:7` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `satisfies` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2025/ToNumber.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getContextualType.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-iterator-helpers/Iterator.prototype.map/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/typed.js:27` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/doctrine/lib/doctrine.js:897` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/array-includes/implementation.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/doctrine.js:897` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/types/dist/index.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6846` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_runSelectorList` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/wrap-iife.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:74` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:7` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:123` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `createToken`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:38` | Self: 0.0% (0us) | Total: 0.7% (17.7ms) | Samples: 0

**Called by:**
- `_compile` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-type-exports.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/utility.js:32` | Self: 0.0% (0us) | Total: 0.3% (9.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/comment-parser/lib/parser/index.cjs:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2025/ToIntegerOrInfinity.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-scope/dist/eslint-scope.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8063` | Self: 0.0% (0us) | Total: 74.2% (1.86s) | Samples: 0

**Called by:**
- `_lintSourceOne` (1230)

**Calls:**
- `walkNodes` (1083)
- `walkNodes` (67)
- `walkNodes` (19)
- `walkNodes` (16)
- `walkNodes` (9)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/prop-types/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getFullPath`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:209` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-no-comment-textnodes.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-no-literals.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` | Self: 0.0% (0us) | Total: 0.8% (20.5ms) | Samples: 0

**Called by:**
- `anonymous` (13)

**Calls:**
- `bound require` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `parseRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:139` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/baseTypeUtils.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` | Self: 0.0% (0us) | Total: 0.3% (7.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getTypeName.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/gatherLogicalOperands.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:33` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:18` | Self: 0.0% (0us) | Total: 0.2% (6.7ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/string.prototype.matchall/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/isArrayMethodCallWithPredicate.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (6.3ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/predicates.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-parameters.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/get-intrinsic/index.js:55` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6143` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:8` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6619` | Self: 0.0% (0us) | Total: 10.8% (272.7ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (181)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `(anonymous)` (182)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` | Self: 0.0% (0us) | Total: 0.5% (12.7ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/visitor.js:2` | Self: 0.0% (0us) | Total: 1.3% (35.1ms) | Samples: 0

**Called by:**
- `anonymous` (23)

**Calls:**
- `bound require` (23)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 13.5% (339.9ms) | Samples: 0

**Calls:**
- `parseModule` (172)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/builder.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` | Self: 0.0% (0us) | Total: 2.7% (68.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (44)

**Calls:**
- `loadPlugin` (44)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (2.84s) | Samples: 0

**Called by:**
- `bound require` (1459)

**Calls:**
- `anonymous` (1459)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7125` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-typos.js:9` | Self: 0.0% (0us) | Total: 1.0% (26.6ms) | Samples: 0

**Called by:**
- `_compile` (17)

**Calls:**
- `bound require` (17)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:51` | Self: 0.0% (0us) | Total: 4.3% (108.5ms) | Samples: 0

**Called by:**
- `anonymous` (22)

**Calls:**
- `bound require` (22)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.2% (6.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.2% (7.3ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `get WriteStream`
`node:fs:583` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `anonymous` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:33198` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `createScanner` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/propTypes.js:12` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6901` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildSelectorPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:34` | Self: 0.0% (0us) | Total: 0.1% (4.1ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.5% (13.5ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-parameters.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/AsyncFromSyncIteratorContinuation.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain.js:5` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:138` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/resolve/lib/async.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-member-access.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:37` | Self: 0.0% (0us) | Total: 3.0% (76.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:50` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/object.groupby/implementation.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_installCjsSubstitutes`
`/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:77` | Self: 0.0% (0us) | Total: 12.7% (320.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (160)

**Calls:**
- `_compile` (160)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6040` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `internal:util/colors`
`internal:util/colors:24` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `refresh` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/dot-notation.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `g` (1)

**Calls:**
- `Ae` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-indent.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `asyncWrap`
`node:fs/promises:150` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `node:fs/promises` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:65` | Self: 0.0% (0us) | Total: 2.5% (63.1ms) | Samples: 0

**Called by:**
- `anonymous` (41)

**Calls:**
- `bound require` (41)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-escape.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.4% (12.1ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2015.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/array.prototype.flatmap/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.7% (17.9ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:67` | Self: 0.0% (0us) | Total: 0.1% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 86.6% (2.18s) | Samples: 0

**Called by:**
- `processTicksAndRejections` (1432)
- `refresh` (2)
- `(anonymous)` (1)

**Calls:**
- `_lintSourceOne` (1237)
- `_lintSourceOne` (149)
- `async _resolveConfigImpl` (44)
- `get WriteStream` (2)
- `async (anonymous)` (1)
- `(anonymous)` (1)
- `forEach` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:58` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parse` (1)

**Calls:**
- `_e` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/doctrine/lib/doctrine.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-unused-state.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2025/CreateIteratorFromClosure.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-promise/rules/no-return-wrap.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/typed.js:1303` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/string.prototype.matchall/implementation.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1505` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2025/GetIteratorFlattenable.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:6` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `_compile` (3)

**Calls:**
- `bound require` (3)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:85` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/object.groupby/implementation.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-boolean-literal-compare.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` | Self: 0.0% (0us) | Total: 0.7% (19.4ms) | Samples: 0

**Called by:**
- `anonymous` (13)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/array-includes/index.js:8` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/version.js:11` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` | Self: 0.0% (0us) | Total: 0.4% (10.7ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:39` | Self: 0.0% (0us) | Total: 2.9% (73.4ms) | Samples: 0

**Called by:**
- `_compile` (48)

**Calls:**
- `bound require` (48)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/lib/index.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:23` | Self: 0.0% (0us) | Total: 3.0% (76.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-type-exports.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `_compile` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/array-includes/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` | Self: 0.0% (0us) | Total: 12.8% (324.0ms) | Samples: 0

**Called by:**
- `anonymous` (162)

**Calls:**
- `bound require` (162)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/predicates.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7539` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `getDFSEvents` (2)
- `getDFSEvents` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-member-access.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:46` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

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

### `(anonymous)`
`/Users/ericsan/node_modules/object.fromentries/index.js:6` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2024/CreateDataProperty.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-useless-default-assignment.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get`
`node:assert:70` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `assign` (3)

**Calls:**
- `loadAssertionError` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_installCjsSubstitutes`
`/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:73` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` | Self: 0.0% (0us) | Total: 0.2% (7.0ms) | Samples: 0

**Called by:**
- `runPlugins` (3)
- `runPlugins` (2)

**Calls:**
- `decode` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.3% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/TypeOrValueSpecifier.js:42` | Self: 0.0% (0us) | Total: 0.9% (23.4ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `bound resolve`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `loadPlugin` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:65` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-duplicate-type-constituents.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:128` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-condition.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/hasOverloadSignatures.js:5` | Self: 0.0% (0us) | Total: 4.3% (108.5ms) | Samples: 0

**Called by:**
- `anonymous` (22)

**Calls:**
- `bound require` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:5` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-iterator-helpers/Iterator.from/implementation.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-boolean-literal-compare.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/define-properties/index.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2025/Call.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` | Self: 0.0% (0us) | Total: 0.4% (10.7ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/visitor.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-iterator-helpers/Iterator.prototype.map/implementation.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/lib/getPropValue.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/lib/values/expressions/index.js:68` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/es-abstract/2024/CreateDataPropertyOrThrow.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:27` | Self: 0.0% (0us) | Total: 0.9% (25.1ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `_encodeSource` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/set-function-length/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:906` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getFullPath` (1)

**Calls:**
- `_normalizeIPv6` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/configs/flat/all.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.3% (8.0ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:8` | Self: 0.0% (0us) | Total: 0.2% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:193` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/call-bind/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/export.js:2` | Self: 0.0% (0us) | Total: 1.6% (40.9ms) | Samples: 0

**Called by:**
- `_compile` (27)

**Calls:**
- `bound require` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/rules/order.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:131` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/array-includes/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.2% (6.3ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/propTypes.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2019.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/CreateDataProperty.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.3% (9.2ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/call-bind/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` | Self: 0.0% (0us) | Total: 0.5% (14.3ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8055` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `get source` (3)
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/elementType.js:1` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:46` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:88` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/array.prototype.flatmap/shim.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-restricted-imports.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:72` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:94` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:31` | Self: 0.0% (0us) | Total: 0.2% (6.0ms) | Samples: 0

**Called by:**
- `_compile` (4)

**Calls:**
- `_compile` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.5% (12.7ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/init-declarations.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:134` | Self: 0.0% (0us) | Total: 12.8% (322.5ms) | Samples: 0

**Called by:**
- `anonymous` (161)

**Calls:**
- `_installCjsSubstitutes` (160)
- `_installCjsSubstitutes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-return.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4230` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/array-includes/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 34.2% | 860.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 29.1% | 733.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 23.2% | 585.3ms | `[native code]` |
| 10.8% | 274.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.7% | 19.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.1% | 4.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-deprecated.js` |
| 0.0% | 1.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getContextualType.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/configs/flat/base.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/get-intrinsic/index.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-type-exports.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/gatherLogicalOperands.js` |
| 0.0% | 1.4ms | `node:crypto` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/builtinSymbolLikes.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-member-access.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/List.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-boolean-literal-compare.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getTypeName.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-useless-default-assignment.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-import/lib/exportMap/patternCapture.js` |
