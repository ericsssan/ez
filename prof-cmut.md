# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.82s | 1823 | 1.0ms | 511 |

**Top 10:** `getAncestorsFor` 19.0%, `_nodeViewRaw` 13.4%, `parse` 7.7%, `anonymous` 6.7%, `nodeLhs` 4.1%, `_nodeViewRaw` 3.8%, `walkNodes` 3.2%, `_identAt` 2.8%, `(anonymous)` 2.5%, `getAncestorsFor` 2.3%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 19.0% | 536.5ms | 46.1% | 1.30s | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6542` |
| 13.4% | 380.3ms | 13.4% | 380.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 7.7% | 218.4ms | 7.7% | 218.4ms | `parse` | `[native code]` |
| 6.7% | 189.4ms | 100.0% | 3.13s | `anonymous` | `[native code]` |
| 4.1% | 118.5ms | 4.1% | 118.5ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 3.8% | 107.9ms | 3.8% | 107.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4157` |
| 3.2% | 91.6ms | 66.4% | 1.87s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7765` |
| 2.8% | 79.9ms | 3.0% | 86.4ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:796` |
| 2.5% | 73.3ms | 2.5% | 73.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:5` |
| 2.3% | 67.4ms | 2.3% | 67.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` |
| 2.1% | 59.5ms | 3.4% | 96.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7566` |
| 2.0% | 58.5ms | 2.0% | 58.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` |
| 1.9% | 54.2ms | 2.0% | 56.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 1.7% | 50.0ms | 1.8% | 53.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` |
| 1.7% | 49.9ms | 1.7% | 49.9ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6553` |
| 1.6% | 45.7ms | 54.3% | 1.53s | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6683` |
| 1.4% | 40.1ms | 52.8% | 1.49s | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6590` |
| 1.3% | 37.5ms | 1.3% | 37.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.1% | 32.7ms | 9.0% | 256.0ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` |
| 1.1% | 32.0ms | 1.1% | 32.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` |
| 1.0% | 30.0ms | 1.0% | 30.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.9% | 26.3ms | 0.9% | 26.3ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.7% | 21.2ms | 0.7% | 21.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4109` |
| 0.6% | 16.9ms | 0.6% | 16.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` |
| 0.4% | 13.9ms | 0.4% | 13.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4045` |
| 0.4% | 13.6ms | 0.4% | 13.6ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 0.4% | 13.4ms | 0.4% | 13.4ms | `create` | `[native code]` |
| 0.4% | 13.4ms | 9.0% | 256.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` |
| 0.4% | 12.9ms | 0.4% | 12.9ms | `defineProperty` | `[native code]` |
| 0.4% | 12.6ms | 4.5% | 129.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4202` |
| 0.4% | 12.2ms | 0.4% | 12.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` |
| 0.4% | 11.8ms | 0.4% | 11.8ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` |
| 0.3% | 10.9ms | 0.3% | 10.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` |
| 0.3% | 10.7ms | 0.3% | 10.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.3% | 9.8ms | 0.3% | 9.8ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 9.2ms | 0.3% | 9.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` |
| 0.3% | 9.0ms | 0.3% | 9.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` |
| 0.3% | 8.5ms | 0.3% | 8.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` |
| 0.2% | 7.5ms | 0.2% | 7.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3659` |
| 0.2% | 6.3ms | 0.2% | 6.3ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 6.0ms | 0.5% | 14.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7738` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4083` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `decode` | `[native code]` |
| 0.2% | 6.0ms | 4.6% | 132.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.9ms | 0.2% | 5.9ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` |
| 0.2% | 5.9ms | 0.2% | 7.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6546` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.2% | 5.6ms | 0.2% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7633` |
| 0.1% | 4.7ms | 0.3% | 10.8ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `set` | `[native code]` |
| 0.1% | 4.4ms | 0.7% | 21.8ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6591` |
| 0.1% | 4.0ms | 0.1% | 4.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:8` |
| 0.1% | 4.0ms | 0.4% | 11.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6551` |
| 0.1% | 3.2ms | 0.3% | 8.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7736` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.1ms | 0.2% | 7.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6547` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `RegExp` | `[native code]` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6932` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7741` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1397` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7704` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` |
| 0.0% | 2.5ms | 0.1% | 3.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4081` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `replace` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `createRule` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/RuleCreator.js:29` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeFlagUtils.js:3` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4191` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `stringify` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:20` |
| 0.0% | 1.7ms | 9.1% | 257.6ms | `_compile` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `regExpMatchFast` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:8` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isIncludedInstanceMethod` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:114` |
| 0.0% | 1.6ms | 0.1% | 3.3ms | `readFileSync` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `hasObservableSideEffectsForRegExpSplit` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/visitor-keys.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2105` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `test` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:165589` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `__export` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `popContext` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:100` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ez_ffi_dispatch` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4461` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:76` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6549` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInPackageDeclarationFile.js:30` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7728` |
| 0.0% | 1.4ms | 90.4% | 2.55s | `(anonymous)` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createNodeFactory` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:8` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/return-await.js:13` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:8` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6926` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-template-expression.js:30` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6651` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:42212` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-dupe-class-members.js:7` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.3ms | 0.2% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `node:child_process` | `node:child_process:996` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Object` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `encodeInto` | `[native code]` |
| 0.0% | 1.2ms | 0.1% | 3.7ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4098` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-return.js:30` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:3` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1401` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6620` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getConstraintInfo.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `dlopen` | `[native code]` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/checkNullishAndReport.js:30` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 3.13s | 6.7% | 189.4ms | `anonymous` | `[native code]` |
| 100.0% | 3.12s | 0.0% | 0us | `bound require` | `[native code]` |
| 100.0% | 3.11s | 0.0% | 0us | `require` | `[native code]` |
| 90.4% | 2.55s | 0.0% | 1.4ms | `(anonymous)` | `[native code]` |
| 90.4% | 2.55s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 80.0% | 2.26s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 79.6% | 2.24s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8051` |
| 66.4% | 1.87s | 3.2% | 91.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7765` |
| 54.3% | 1.53s | 1.6% | 45.7ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6683` |
| 52.8% | 1.49s | 1.4% | 40.1ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6590` |
| 46.1% | 1.30s | 19.0% | 536.5ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6542` |
| 13.4% | 380.3ms | 13.4% | 380.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 9.5% | 269.6ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 9.5% | 269.6ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 9.4% | 266.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 9.1% | 257.6ms | 0.0% | 1.7ms | `_compile` | `[native code]` |
| 9.0% | 256.5ms | 0.4% | 13.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` |
| 9.0% | 256.0ms | 1.1% | 32.7ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` |
| 8.9% | 254.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` |
| 8.9% | 252.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:134` |
| 8.9% | 252.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:7` |
| 8.9% | 252.4ms | 0.0% | 0us | `_installCjsSubstitutes` | `/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:77` |
| 7.8% | 222.2ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 7.7% | 218.4ms | 7.7% | 218.4ms | `parse` | `[native code]` |
| 7.7% | 218.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 4.6% | 132.6ms | 0.2% | 6.0ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` |
| 4.5% | 129.7ms | 0.4% | 12.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4202` |
| 4.1% | 118.5ms | 4.1% | 118.5ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 3.9% | 110.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:40` |
| 3.8% | 107.9ms | 3.8% | 107.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4157` |
| 3.8% | 107.7ms | 0.0% | 0us | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 3.7% | 106.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:32` |
| 3.7% | 106.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/hasOverloadSignatures.js:5` |
| 3.6% | 102.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:51` |
| 3.5% | 99.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:27` |
| 3.4% | 97.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:42` |
| 3.4% | 96.6ms | 2.1% | 59.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7566` |
| 3.4% | 96.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/TypeOrValueSpecifier.js:42` |
| 3.4% | 96.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInFile.js:7` |
| 3.4% | 96.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` |
| 3.3% | 93.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` |
| 3.0% | 86.4ms | 2.8% | 79.9ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:796` |
| 2.9% | 83.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` |
| 2.9% | 83.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` |
| 2.9% | 83.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` |
| 2.5% | 73.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:37` |
| 2.5% | 73.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:30` |
| 2.5% | 73.3ms | 2.5% | 73.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:5` |
| 2.5% | 71.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:39` |
| 2.3% | 67.4ms | 2.3% | 67.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` |
| 2.3% | 67.0ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` |
| 2.3% | 67.0ms | 0.0% | 0us | `loadPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:95` |
| 2.3% | 65.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/index.js:5` |
| 2.2% | 63.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:65` |
| 2.0% | 58.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:38` |
| 2.0% | 58.5ms | 2.0% | 58.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` |
| 2.0% | 56.6ms | 1.9% | 54.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 1.9% | 55.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` |
| 1.8% | 53.5ms | 1.7% | 50.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` |
| 1.7% | 49.9ms | 1.7% | 49.9ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6553` |
| 1.4% | 42.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:19` |
| 1.4% | 42.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/eslint/FlatESLint.js:8` |
| 1.4% | 42.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/ESLint.js:4` |
| 1.4% | 40.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:12` |
| 1.3% | 37.5ms | 1.3% | 37.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.1% | 32.0ms | 1.1% | 32.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` |
| 1.0% | 30.0ms | 1.0% | 30.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 1.0% | 29.6ms | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` |
| 0.9% | 26.3ms | 0.9% | 26.3ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.8% | 24.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.7% | 21.8ms | 0.1% | 4.4ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6591` |
| 0.7% | 21.2ms | 0.7% | 21.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4109` |
| 0.6% | 19.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.6% | 19.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` |
| 0.6% | 17.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` |
| 0.6% | 16.9ms | 0.6% | 16.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` |
| 0.5% | 14.9ms | 0.2% | 6.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7738` |
| 0.5% | 14.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7834` |
| 0.4% | 13.9ms | 0.4% | 13.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4045` |
| 0.4% | 13.6ms | 0.4% | 13.6ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 0.4% | 13.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` |
| 0.4% | 13.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` |
| 0.4% | 13.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` |
| 0.4% | 13.4ms | 0.4% | 13.4ms | `create` | `[native code]` |
| 0.4% | 13.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` |
| 0.4% | 13.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.4% | 13.1ms | 0.0% | 0us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6754` |
| 0.4% | 13.1ms | 0.0% | 0us | `FunctionExpression:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:167` |
| 0.4% | 13.1ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` |
| 0.4% | 12.9ms | 0.4% | 12.9ms | `defineProperty` | `[native code]` |
| 0.4% | 12.2ms | 0.4% | 12.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` |
| 0.4% | 12.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.4% | 11.9ms | 0.1% | 4.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` |
| 0.4% | 11.8ms | 0.4% | 11.8ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` |
| 0.4% | 11.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` |
| 0.4% | 11.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` |
| 0.4% | 11.5ms | 0.0% | 0us | `exitFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:146` |
| 0.3% | 10.9ms | 0.3% | 10.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` |
| 0.3% | 10.8ms | 0.1% | 4.7ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 0.3% | 10.7ms | 0.3% | 10.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.3% | 10.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7670` |
| 0.3% | 9.8ms | 0.0% | 0us | `getOpeningParenOfParams` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getFunctionHeadLoc.js:26` |
| 0.3% | 9.8ms | 0.0% | 0us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1490` |
| 0.3% | 9.8ms | 0.0% | 0us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getFunctionHeadLoc.js:142` |
| 0.3% | 9.8ms | 0.3% | 9.8ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 9.2ms | 0.3% | 9.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` |
| 0.3% | 9.0ms | 0.3% | 9.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` |
| 0.3% | 9.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.3% | 8.9ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6792` |
| 0.3% | 8.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` |
| 0.3% | 8.8ms | 0.1% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7736` |
| 0.3% | 8.5ms | 0.3% | 8.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` |
| 0.2% | 8.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` |
| 0.2% | 8.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.2% | 7.7ms | 0.1% | 3.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6547` |
| 0.2% | 7.6ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` |
| 0.2% | 7.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8043` |
| 0.2% | 7.5ms | 0.2% | 7.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` |
| 0.2% | 7.5ms | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5687` |
| 0.2% | 7.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` |
| 0.2% | 7.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` |
| 0.2% | 7.4ms | 0.2% | 5.9ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6546` |
| 0.2% | 7.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.2% | 7.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.2% | 7.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` |
| 0.2% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` |
| 0.2% | 7.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7527` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.2% | 6.6ms | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3659` |
| 0.2% | 6.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1500` |
| 0.2% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` |
| 0.2% | 6.3ms | 0.2% | 6.3ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4083` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `decode` | `[native code]` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.9ms | 0.2% | 5.9ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.2% | 5.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` |
| 0.2% | 5.6ms | 0.2% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7633` |
| 0.1% | 5.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:31` |
| 0.1% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` |
| 0.1% | 4.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6494` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `set` | `[native code]` |
| 0.1% | 4.7ms | 0.0% | 0us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6112` |
| 0.1% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.1% | 4.6ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.1% | 4.0ms | 0.1% | 4.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:8` |
| 0.1% | 4.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:30` |
| 0.1% | 4.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:58` |
| 0.1% | 4.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:38` |
| 0.1% | 3.9ms | 0.0% | 2.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` |
| 0.1% | 3.7ms | 0.0% | 1.2ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4098` |
| 0.1% | 3.5ms | 0.0% | 0us | `stringify` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:50` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` |
| 0.1% | 3.5ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` |
| 0.1% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.1% | 3.5ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` |
| 0.1% | 3.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8050` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6551` |
| 0.1% | 3.3ms | 0.0% | 1.6ms | `readFileSync` | `[native code]` |
| 0.1% | 3.3ms | 0.0% | 0us | `map` | `[native code]` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:20` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `RegExp` | `[native code]` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:4` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:192` |
| 0.1% | 3.0ms | 0.0% | 0us | `createToken` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:49` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6932` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7741` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1397` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.0% | 2.8ms | 0.0% | 0us | `filter` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7704` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:114` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain.js:5` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:67` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:42212` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4081` |
| 0.0% | 2.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.0% | 2.4ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5918` |
| 0.0% | 2.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6889` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.8ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:126` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:20` |
| 0.0% | 1.8ms | 0.0% | 0us | `wordsRegexp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.8ms | 0.0% | 0us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3982` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `replace` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `createRule` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/RuleCreator.js:29` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:12` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-generic-constructors.js:16` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:41` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:52` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/containsAllTypesByName.js:39` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:19` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeFlagUtils.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeFlagUtils.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeFlagUtils.js:39` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:26` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/rule-tester.js:31` |
| 0.0% | 1.7ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:295` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `stringify` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:20` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4191` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:42` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:65` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/keyword.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:29` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:18` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:23` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/cli-engine/lint-result-cache.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `regExpMatchFast` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` |
| 0.0% | 1.7ms | 0.0% | 0us | `_normalizeIPv6` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:812` |
| 0.0% | 1.7ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 1.7ms | 0.0% | 0us | `getFullPath` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:209` |
| 0.0% | 1.7ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:906` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2025.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:91` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:5` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:tty` | `node:tty:6` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/duplex` | `internal:streams/duplex:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:103` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:43` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/comment-parser/lib/index.cjs:27` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/comment-parser/lib/parser/index.cjs:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:5` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:31` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:45` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:8` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:53` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:30` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isIncludedInstanceMethod` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:114` |
| 0.0% | 1.6ms | 0.0% | 0us | `exitFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:144` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7731` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` |
| 0.0% | 1.6ms | 0.0% | 0us | `satisfies` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/functions/satisfies.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `[Symbol.split]` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `parseRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:154` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `hasObservableSideEffectsForRegExpSplit` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `Range` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:42` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:154` |
| 0.0% | 1.6ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:21` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-enum-comparison.js:39` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:86` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:47` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-string-starts-ends-with.js:5` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:132` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:37` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/visitor-keys.js:84` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/visitor-keys.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/index.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getFunctionHeadLoc.js:134` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2105` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:7` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Visitor.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:17` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/BlockScope.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:94` |
| 0.0% | 1.6ms | 0.0% | 0us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4366` |
| 0.0% | 1.6ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4619` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `test` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:21` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/explicit-function-return-type.js:5` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `mapDefined` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:2610` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:165589` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:165588` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:18` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:38` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `__export` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:135` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7767` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `popContext` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:100` |
| 0.0% | 1.5ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4940` |
| 0.0% | 1.5ms | 0.0% | 0us | `FunctionDeclaration:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:161` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2020.js:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:53` |
| 0.0% | 1.5ms | 0.0% | 0us | `dispatch` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:388` |
| 0.0% | 1.5ms | 0.0% | 0us | `ez_ffi_dispatch (ez.node)` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ez_ffi_dispatch` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6914` |
| 0.0% | 1.5ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6791` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:40` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:30` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:98` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-exponentiation-operator.js:14` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:32` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:18` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4461` |
| 0.0% | 1.4ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.0% | 1.4ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6834` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:38` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:78` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:67` |
| 0.0% | 1.4ms | 0.0% | 0us | `flatIntoArrayWithCallback` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:75` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:76` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:136` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:3` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6549` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInPackageDeclarationFile.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/TypeOrValueSpecifier.js:44` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInPackageDeclarationFile.js:37` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7728` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-promises.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-promises.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-promises.js:38` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:57` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:41` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-empty-object-type.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:73` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:119` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:16` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createNodeFactory` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:29337` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:51` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:74` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:109` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-segment.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-state.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ffiBufPtr` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:87` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6910` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `_getFfi` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:327` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/index.js:16` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:187204` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:129` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/return-await.js:13` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/definition/index.js:25` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/scan.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/utils.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:27` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-restricted-imports.js:7` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:91` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:37` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:30` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6926` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/baseTypeUtils.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/baseTypeUtils.js:40` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/baseTypeUtils.js:8` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-template-expression.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-template-expression.js:38` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:76` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-argument.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-argument.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:82` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-argument.js:38` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6655` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6651` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:81` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:71` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:10` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-dupe-class-members.js:7` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:35` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:15` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7240` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:74` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `node:child_process` | `node:child_process:996` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:37` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:55` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:31` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Object` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:24` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `encodeInto` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 1.3ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/naming-convention.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:28` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/naming-convention-utils/index.js:6` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:41` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-return.js:36` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-return.js:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:89` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:8` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:37` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:23` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:33` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:38` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-restricted-imports.js:10` |
| 0.0% | 1.2ms | 0.0% | 0us | `getESLintCoreRule` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getESLintCoreRule.js:7` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-restricted-imports.js:41` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1401` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6620` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:26` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `async loadAndEvaluateModule` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1509` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:15` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:42` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getConstraintInfo.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getConstraintInfo.js:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/needsToBeAwaited.js:40` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getConstraintInfo.js:37` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:115` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `dlopen` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.0% | 1.2ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:130` |
| 0.0% | 1.2ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:41` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/checkNullishAndReport.js:39` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/checkNullishAndReport.js:30` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |

## Function Details

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6542` | Self: 19.0% (536.5ms) | Total: 46.1% (1.30s) | Samples: 353

**Called by:**
- `_runSelectorList` (864)

**Calls:**
- `_nodeViewRaw` (245)
- `nodeView` (85)
- `_nodeViewRaw` (70)
- `_nodeViewRaw` (40)
- `nodeView` (36)
- `nodeView` (25)
- `nodeView` (10)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 13.4% (380.3ms) | Total: 13.4% (380.3ms) | Samples: 255

**Called by:**
- `getAncestorsFor` (245)
- `invokeSelectorHandlers` (10)

### `parse`
`[native code]` | Self: 7.7% (218.4ms) | Total: 7.7% (218.4ms) | Samples: 142

**Called by:**
- `parseSource` (142)

### `anonymous`
`[native code]` | Self: 6.7% (189.4ms) | Total: 100.0% (3.13s) | Samples: 123

**Called by:**
- `require` (1275)
- `bound require` (4)
- `internal:streams/pipeline` (1)
- `node:stream` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/compose` (1)
- `node:tty` (1)
- `internal:fs/streams` (1)
- `node:fs` (1)
- `internal:streams/duplex` (1)

**Calls:**
- `(anonymous)` (117)
- `(anonymous)` (116)
- `(anonymous)` (116)
- `(anonymous)` (44)
- `(anonymous)` (43)
- `(anonymous)` (36)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (26)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (20)
- `(anonymous)` (18)
- `(anonymous)` (17)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (14)
- `(anonymous)` (12)
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
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/operators` (1)
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
- `internal:streams/duplex` (1)
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
- `node:child_process` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (1)
- `node:stream` (1)
- `(anonymous)` (1)
- `node:tty` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 4.1% (118.5ms) | Total: 4.1% (118.5ms) | Samples: 78

**Called by:**
- `nodeView` (77)
- `getAncestorsFor` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4157` | Self: 3.8% (107.9ms) | Total: 3.8% (107.9ms) | Samples: 72

**Called by:**
- `getAncestorsFor` (70)
- `walkNodes` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7765` | Self: 3.2% (91.6ms) | Total: 66.4% (1.87s) | Samples: 61

**Called by:**
- `runPlugins` (1244)

**Calls:**
- `invokeSelectorHandlers` (1006)
- `invokeSelectorHandlers` (166)
- `invokeSelectorHandlers` (10)
- `invokeSelectorHandlers` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:796` | Self: 2.8% (79.9ms) | Total: 3.0% (86.4ms) | Samples: 53

**Called by:**
- `_computeIdentifierName` (57)

**Calls:**
- `get source` (3)
- `get source` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:5` | Self: 2.5% (73.3ms) | Total: 2.5% (73.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` | Self: 2.3% (67.4ms) | Total: 2.3% (67.4ms) | Samples: 44

**Called by:**
- `_runSelectorList` (44)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7566` | Self: 2.1% (59.5ms) | Total: 3.4% (96.6ms) | Samples: 40

**Called by:**
- `runPlugins` (65)

**Calls:**
- `invokeSelectorHandlers` (11)
- `invokeSelectorHandlers` (10)
- `invokeSelectorHandlers` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` | Self: 2.0% (58.5ms) | Total: 2.0% (58.5ms) | Samples: 39

**Called by:**
- `getAncestorsFor` (36)
- `invokeSelectorHandlers` (2)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` | Self: 1.9% (54.2ms) | Total: 2.0% (56.6ms) | Samples: 37

**Called by:**
- `runPlugins` (39)

**Calls:**
- `_resolveHandlers` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` | Self: 1.7% (50.0ms) | Total: 1.8% (53.5ms) | Samples: 34

**Called by:**
- `runPlugins` (36)

**Calls:**
- `_resolveHandlers` (2)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6553` | Self: 1.7% (49.9ms) | Total: 1.7% (49.9ms) | Samples: 34

**Called by:**
- `_runSelectorList` (34)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6683` | Self: 1.6% (45.7ms) | Total: 54.3% (1.53s) | Samples: 30

**Called by:**
- `walkNodes` (1006)
- `walkNodes` (11)

**Calls:**
- `_runSelectorList` (970)
- `_runSelectorList` (13)
- `_runSelectorList` (4)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6590` | Self: 1.4% (40.1ms) | Total: 52.8% (1.49s) | Samples: 27

**Called by:**
- `invokeSelectorHandlers` (970)
- `invokeSelectorHandlers` (19)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `getAncestorsFor` (864)
- `getAncestorsFor` (44)
- `getAncestorsFor` (34)
- `getAncestorsFor` (8)
- `getAncestorsFor` (5)
- `getAncestorsFor` (5)
- `getAncestorsFor` (2)
- `getAncestorsFor` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.3% (37.5ms) | Total: 1.3% (37.5ms) | Samples: 25

**Called by:**
- `getAncestorsFor` (25)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` | Self: 1.1% (32.7ms) | Total: 9.0% (256.0ms) | Samples: 22

**Called by:**
- `walkNodes` (166)
- `walkNodes` (4)

**Calls:**
- `_nodeViewRaw` (128)
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (6)
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` | Self: 1.1% (32.0ms) | Total: 1.1% (32.0ms) | Samples: 22

**Called by:**
- `runPlugins` (22)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 1.0% (30.0ms) | Total: 1.0% (30.0ms) | Samples: 20

**Called by:**
- `_nodeViewRaw` (20)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.9% (26.3ms) | Total: 0.9% (26.3ms) | Samples: 17

**Called by:**
- `_nodeViewRaw` (17)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4109` | Self: 0.7% (21.2ms) | Total: 0.7% (21.2ms) | Samples: 14

**Called by:**
- `_nodeViewRaw` (14)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` | Self: 0.6% (16.9ms) | Total: 0.6% (16.9ms) | Samples: 11

**Called by:**
- `getAncestorsFor` (10)
- `invokeSelectorHandlers` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4045` | Self: 0.4% (13.9ms) | Total: 0.4% (13.9ms) | Samples: 10

**Called by:**
- `_nodeViewRaw` (10)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` | Self: 0.4% (13.6ms) | Total: 0.4% (13.6ms) | Samples: 9

**Called by:**
- `_computeIdentifierName` (9)

### `create`
`[native code]` | Self: 0.4% (13.4ms) | Total: 0.4% (13.4ms) | Samples: 9

**Called by:**
- `walkNodes` (5)
- `walkNodes` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` | Self: 0.4% (13.4ms) | Total: 9.0% (256.5ms) | Samples: 9

**Called by:**
- `invokeSelectorHandlers` (128)
- `getAncestorsFor` (40)
- `invokeMethodFnHandlers` (1)
- `get value` (1)
- `walkNodes` (1)

**Calls:**
- `_NodeView_LR` (88)
- `_NodeView` (20)
- `_NodeView_LR` (17)
- `_NodeView_LR` (14)
- `_NodeView` (10)
- `_NodeView` (6)
- `_NodeView_LRN` (4)
- `_NodeView_LRN` (2)
- `_NodeView` (1)

### `defineProperty`
`[native code]` | Self: 0.4% (12.9ms) | Total: 0.4% (12.9ms) | Samples: 9

**Called by:**
- `walkNodes` (5)
- `walkNodes` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4202` | Self: 0.4% (12.6ms) | Total: 4.5% (129.7ms) | Samples: 8

**Called by:**
- `getAncestorsFor` (85)

**Calls:**
- `nodeLhs` (77)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` | Self: 0.4% (12.2ms) | Total: 0.4% (12.2ms) | Samples: 8

**Called by:**
- `_runSelectorList` (8)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` | Self: 0.4% (11.8ms) | Total: 0.4% (11.8ms) | Samples: 8

**Called by:**
- `_NodeView_LR` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` | Self: 0.3% (10.9ms) | Total: 0.3% (10.9ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.3% (10.7ms) | Total: 0.3% (10.7ms) | Samples: 7

**Called by:**
- `(anonymous)` (6)
- `(anonymous)` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (9.8ms) | Total: 0.3% (9.8ms) | Samples: 6

**Called by:**
- `_runSelectorList` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` | Self: 0.3% (9.2ms) | Total: 0.3% (9.2ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` | Self: 0.3% (9.0ms) | Total: 0.3% (9.0ms) | Samples: 6

**Called by:**
- `_nodeViewRaw` (6)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` | Self: 0.3% (8.5ms) | Total: 0.3% (8.5ms) | Samples: 6

**Called by:**
- `invokeSelectorHandlers` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` | Self: 0.2% (7.5ms) | Total: 0.2% (7.5ms) | Samples: 5

**Called by:**
- `fn` (5)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` | Self: 0.2% (6.6ms) | Total: 0.2% (6.6ms) | Samples: 4

**Called by:**
- `_makeToken` (4)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3659` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `get value` (4)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (6.3ms) | Total: 0.2% (6.3ms) | Samples: 4

**Called by:**
- `invokeSelectorHandlers` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7738` | Self: 0.2% (6.0ms) | Total: 0.5% (14.9ms) | Samples: 4

**Called by:**
- `runPlugins` (10)

**Calls:**
- `defineProperty` (5)
- `Object` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4083` | Self: 0.2% (6.0ms) | Total: 0.2% (6.0ms) | Samples: 4

**Called by:**
- `_nodeViewRaw` (4)

### `decode`
`[native code]` | Self: 0.2% (6.0ms) | Total: 0.2% (6.0ms) | Samples: 4

**Called by:**
- `get source` (4)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` | Self: 0.2% (6.0ms) | Total: 4.6% (132.6ms) | Samples: 4

**Called by:**
- `_nodeViewRaw` (88)

**Calls:**
- `_computeIdentifierName` (71)
- `_computeIdentifierName` (8)
- `_computeIdentifierName` (3)
- `_computeIdentifierName` (2)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (6.0ms) | Total: 0.2% (6.0ms) | Samples: 4

**Called by:**
- `walkNodes` (2)
- `walkNodes` (2)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` | Self: 0.2% (5.9ms) | Total: 0.2% (5.9ms) | Samples: 4

**Called by:**
- `_computeIdentifierName` (4)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6546` | Self: 0.2% (5.9ms) | Total: 0.2% (7.4ms) | Samples: 4

**Called by:**
- `_runSelectorList` (5)

**Calls:**
- `nodeLhs` (1)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 0.2% (5.8ms) | Total: 0.2% (5.8ms) | Samples: 4

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7633` | Self: 0.2% (5.6ms) | Total: 0.2% (5.6ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` | Self: 0.1% (4.7ms) | Total: 0.3% (10.8ms) | Samples: 3

**Called by:**
- `runPlugins` (4)
- `_identAt` (3)

**Calls:**
- `decode` (4)

### `set`
`[native code]` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `_ensureTagCaches` (3)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6591` | Self: 0.1% (4.4ms) | Total: 0.7% (21.8ms) | Samples: 3

**Called by:**
- `invokeSelectorHandlers` (13)
- `invokeSelectorHandlers` (1)

**Calls:**
- `fn` (6)
- `fn` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:8` | Self: 0.1% (4.0ms) | Total: 0.1% (4.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` | Self: 0.1% (4.0ms) | Total: 0.4% (11.9ms) | Samples: 3

**Called by:**
- `runPlugins` (8)

**Calls:**
- `create` (5)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6551` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `_runSelectorList` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7736` | Self: 0.1% (3.2ms) | Total: 0.3% (8.8ms) | Samples: 2

**Called by:**
- `runPlugins` (6)

**Calls:**
- `create` (4)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `getFirstToken` (2)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `_NodeView_LR` (2)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6547` | Self: 0.1% (3.1ms) | Total: 0.2% (7.7ms) | Samples: 2

**Called by:**
- `_runSelectorList` (5)

**Calls:**
- `get value` (2)
- `get value` (1)

### `RegExp`
`[native code]` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `createToken` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6932` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7741` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1397` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `getAncestorsFor` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7704` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` | Self: 0.0% (2.5ms) | Total: 0.1% (3.9ms) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `defineProperty` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4081` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` | Self: 0.0% (2.4ms) | Total: 0.0% (2.4ms) | Samples: 2

**Called by:**
- `_computeIdentifierName` (2)

### `replace`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `wordsRegexp` (1)

### `createRule`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/RuleCreator.js:29` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeFlagUtils.js:3` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4191` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `stringify`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:20` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `stringify` (1)

### `_compile`
`[native code]` | Self: 0.0% (1.7ms) | Total: 9.1% (257.6ms) | Samples: 1

**Called by:**
- `_installCjsSubstitutes` (116)
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (46)
- `(anonymous)` (38)
- `(anonymous)` (25)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `regExpMatchFast`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_normalizeIPv6` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeIdentifierName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_identAt` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:8` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isIncludedInstanceMethod`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:114` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `exitFunction` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.1% (3.3ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `hasObservableSideEffectsForRegExpSplit`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `[Symbol.split]` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/visitor-keys.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2105` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getAncestorsFor` (1)

### `test`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_isSelector` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:165589` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `mapDefined` (1)

### `__export`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `popContext`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:100` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `FunctionDeclaration:exit` (1)

### `ez_ffi_dispatch`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `ez_ffi_dispatch (ez.node)` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4461` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:76` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `filter` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6549` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInPackageDeclarationFile.js:30` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7728` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (1.4ms) | Total: 90.4% (2.55s) | Samples: 1

**Called by:**
- `processTicksAndRejections` (1696)

**Calls:**
- `_lintSourceOne` (1503)
- `_lintSourceOne` (145)
- `async _resolveConfigImpl` (45)
- `_lintSourceOne` (1)
- `async loadAndEvaluateModule` (1)

### `createNodeFactory`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_getFfi` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:8` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/return-await.js:13` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:8` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6926` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-template-expression.js:30` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6651` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:42212` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `filter` (1)
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-dupe-class-members.js:7` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `Uint8Array`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` | Self: 0.0% (1.3ms) | Total: 0.2% (7.6ms) | Samples: 1

**Called by:**
- `runPlugins` (5)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_invokeFused` (1)

### `node:child_process`
`node:child_process:996` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `Object`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4098` | Self: 0.0% (1.2ms) | Total: 0.1% (3.7ms) | Samples: 1

**Called by:**
- `_NodeView_LR` (3)

**Calls:**
- `source` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-return.js:30` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:3` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1401` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6620` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `linkAndEvaluateModule`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `async loadAndEvaluateModule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getConstraintInfo.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/checkNullishAndReport.js:30` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/needsToBeAwaited.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:115` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` | Self: 0.0% (0us) | Total: 0.4% (13.4ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:91` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `filter`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4619` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_isSelector` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 7.8% (222.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (145)

**Calls:**
- `parseSource` (142)
- `parseSource` (2)
- `parseSource` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4940` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `FunctionDeclaration:exit` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:114` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` | Self: 0.0% (0us) | Total: 1.9% (55.5ms) | Samples: 0

**Called by:**
- `anonymous` (36)

**Calls:**
- `bound require` (36)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` | Self: 0.0% (0us) | Total: 0.4% (11.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` | Self: 0.0% (0us) | Total: 0.2% (7.4ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.2% (8.4ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:81` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInPackageDeclarationFile.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7767` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_invokeFused` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6889` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildSelectorPlan` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:12` | Self: 0.0% (0us) | Total: 1.4% (40.2ms) | Samples: 0

**Called by:**
- `anonymous` (26)

**Calls:**
- `bound require` (26)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6792` | Self: 0.0% (0us) | Total: 0.3% (8.9ms) | Samples: 0

**Called by:**
- `walkNodes` (6)

**Calls:**
- `get value` (4)
- `get value` (1)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 80.0% (2.26s) | Samples: 0

**Called by:**
- `(anonymous)` (1503)

**Calls:**
- `runPlugins` (1496)
- `runPlugins` (5)
- `runPlugins` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:4` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (1)

**Calls:**
- `_tryLoad` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 7.7% (218.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (142)

**Calls:**
- `parse` (142)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/definition/index.js:25` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-restricted-imports.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:71` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` | Self: 0.0% (0us) | Total: 2.9% (83.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `bound require` (1)

### `stringify`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:50` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `stringify` (1)
- `_addSchema` (1)

**Calls:**
- `stringify` (1)
- `stringify` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 90.4% (2.55s) | Samples: 0

**Calls:**
- `(anonymous)` (1696)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.6% (19.1ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:132` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4366` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:33` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:29337` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `createNodeFactory` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-promises.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:154` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:187204` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7527` | Self: 0.0% (0us) | Total: 0.2% (7.0ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `getDFSEvents` (2)
- `getDFSEvents` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:91` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5918` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_getFfiSelector` (1)
- `_getFfiSelector` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:86` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8050` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/scan.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:42` | Self: 0.0% (0us) | Total: 3.4% (97.8ms) | Samples: 0

**Called by:**
- `anonymous` (17)

**Calls:**
- `bound require` (17)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/index.js:5` | Self: 0.0% (0us) | Total: 2.3% (65.6ms) | Samples: 0

**Called by:**
- `anonymous` (44)

**Calls:**
- `bound require` (44)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:32` | Self: 0.0% (0us) | Total: 3.7% (106.0ms) | Samples: 0

**Called by:**
- `anonymous` (22)

**Calls:**
- `bound require` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:30` | Self: 0.0% (0us) | Total: 0.1% (4.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:40` | Self: 0.0% (0us) | Total: 3.9% (110.3ms) | Samples: 0

**Called by:**
- `_compile` (25)

**Calls:**
- `bound require` (25)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:98` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:78` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.8% (24.9ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `addMetaSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addSchema` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6494` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_ensureTagCaches` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `patchAstUtils` (3)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` | Self: 0.0% (0us) | Total: 0.2% (6.6ms) | Samples: 0

**Called by:**
- `getFirstToken` (4)

**Calls:**
- `_getJsxTextTokFlags` (4)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `Range` (1)
- `parseRange` (1)

**Calls:**
- `parseRange` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:30` | Self: 0.0% (0us) | Total: 2.5% (73.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1509` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `FunctionExpression:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:167` | Self: 0.0% (0us) | Total: 0.4% (13.1ms) | Samples: 0

**Called by:**
- `invokeHandlersWithNode` (8)

**Calls:**
- `exitFunction` (7)
- `exitFunction` (1)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `resolveIds` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:74` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:327` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/comment-parser/lib/index.cjs:27` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` | Self: 0.0% (0us) | Total: 1.0% (29.6ms) | Samples: 0

**Called by:**
- `walkNodes` (10)
- `walkNodes` (10)

**Calls:**
- `_runSelectorList` (19)
- `_runSelectorList` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (3.12s) | Samples: 0

**Called by:**
- `(anonymous)` (125)
- `(anonymous)` (117)
- `(anonymous)` (116)
- `(anonymous)` (46)
- `loadPlugin` (45)
- `(anonymous)` (44)
- `(anonymous)` (43)
- `(anonymous)` (38)
- `(anonymous)` (36)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (26)
- `(anonymous)` (25)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (20)
- `(anonymous)` (18)
- `(anonymous)` (17)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (16)
- `(anonymous)` (14)
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
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `patchAstUtils` (3)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `getESLintCoreRule` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (1275)
- `anonymous` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8043` | Self: 0.0% (0us) | Total: 0.2% (7.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `get source` (4)
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `[Symbol.split]` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7240` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `Uint8Array` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6754` | Self: 0.0% (0us) | Total: 0.4% (13.1ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (8)

**Calls:**
- `FunctionExpression:exit` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/comment-parser/lib/parser/index.cjs:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `loadPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:95` | Self: 0.0% (0us) | Total: 2.3% (67.0ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (45)

**Calls:**
- `bound require` (45)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInFile.js:7` | Self: 0.0% (0us) | Total: 3.4% (96.4ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-string-starts-ends-with.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:73` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-segment.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 9.5% (269.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (127)

**Calls:**
- `(anonymous)` (125)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

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
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:75` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `filter` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:295` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `stringify` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6655` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` | Self: 0.0% (0us) | Total: 3.4% (96.4ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` | Self: 0.0% (0us) | Total: 0.2% (7.4ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `getFullPath` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:135` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:130` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `isAvailable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getESLintCoreRule`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getESLintCoreRule.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `satisfies` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 9.4% (266.1ms) | Samples: 0

**Called by:**
- `parseModule` (125)

**Calls:**
- `bound require` (125)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/naming-convention-utils/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/baseTypeUtils.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/ESLint.js:4` | Self: 0.0% (0us) | Total: 1.4% (42.0ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `bound require` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeFlagUtils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `exitFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:144` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `FunctionExpression:exit` (1)

**Calls:**
- `isIncludedInstanceMethod` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:57` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

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

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6910` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_ffiBufPtr` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:55` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `createToken`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:49` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-template-expression.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` | Self: 0.0% (0us) | Total: 0.3% (8.8ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:38` | Self: 0.0% (0us) | Total: 2.0% (58.9ms) | Samples: 0

**Called by:**
- `_compile` (38)

**Calls:**
- `bound require` (38)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Visitor.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `addMetaSchema` (2)

**Calls:**
- `_addSchema` (1)
- `_addSchema` (1)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getFunctionHeadLoc.js:134` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `exitFunction` (1)

**Calls:**
- `get decorators` (1)

### `getFullPath`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:209` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` | Self: 0.0% (0us) | Total: 3.3% (93.4ms) | Samples: 0

**Called by:**
- `anonymous` (14)

**Calls:**
- `bound require` (14)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:126` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` | Self: 0.0% (0us) | Total: 0.2% (5.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `mapDefined`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:2610` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js:38` | Self: 0.0% (0us) | Total: 0.1% (4.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` | Self: 0.0% (0us) | Total: 0.2% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:7` | Self: 0.0% (0us) | Total: 8.9% (252.4ms) | Samples: 0

**Called by:**
- `anonymous` (116)

**Calls:**
- `bound require` (116)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3982` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `wordsRegexp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:154` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `Comparator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:192` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-exponentiation-operator.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:136` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:47` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (7.2ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/utils.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `flatIntoArrayWithCallback`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_getFfi`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ffiBufPtr` (1)

**Calls:**
- `isAvailable` (1)

### `internal:streams/duplex`
`internal:streams/duplex:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` | Self: 0.0% (0us) | Total: 0.4% (11.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 9.5% (269.6ms) | Samples: 0

**Calls:**
- `parseModule` (127)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/BlockScope.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` | Self: 0.0% (0us) | Total: 2.3% (67.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (45)

**Calls:**
- `loadPlugin` (45)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:52` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (3.11s) | Samples: 0

**Called by:**
- `bound require` (1275)

**Calls:**
- `anonymous` (1275)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:32` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:27` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-restricted-imports.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/rule-tester.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:23` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/visitor-keys.js:84` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/baseTypeUtils.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:129` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `satisfies`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/functions/satisfies.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.4% (13.4ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6914` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `dispatch` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/explicit-function-return-type.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `ez_ffi_dispatch (ez.node)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `dispatch` (1)

**Calls:**
- `ez_ffi_dispatch` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:19` | Self: 0.0% (0us) | Total: 1.4% (42.0ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `bound require` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/naming-convention.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/getSourceFileOfNode.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `wordsRegexp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `buildUnicodeData` (1)

**Calls:**
- `replace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:35` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/eslint/FlatESLint.js:8` | Self: 0.0% (0us) | Total: 1.4% (42.0ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `bound require` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/cli-engine/lint-result-cache.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/TypeOrValueSpecifier.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `dispatch`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:388` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `ez_ffi_dispatch (ez.node)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getConstraintInfo.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/isTypeReadonly.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-return.js:36` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:109` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/keyword.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/raw-plugin.js:65` | Self: 0.0% (0us) | Total: 2.2% (63.8ms) | Samples: 0

**Called by:**
- `anonymous` (43)

**Calls:**
- `bound require` (43)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-empty-object-type.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:165588` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `mapDefined` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:67` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:58` | Self: 0.0% (0us) | Total: 0.1% (4.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2020.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:51` | Self: 0.0% (0us) | Total: 3.6% (102.5ms) | Samples: 0

**Called by:**
- `anonymous` (20)

**Calls:**
- `bound require` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-type-assertion.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.2% (8.4ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1490` | Self: 0.0% (0us) | Total: 0.3% (9.8ms) | Samples: 0

**Called by:**
- `getOpeningParenOfParams` (6)

**Calls:**
- `_makeToken` (4)
- `_makeToken` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/containsAllTypesByName.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js:67` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-argument.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:51` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6834` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_runSelectorList` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain.js:5` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` | Self: 0.0% (0us) | Total: 0.6% (17.9ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1500` | Self: 0.0% (0us) | Total: 0.2% (6.4ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (4)

**Calls:**
- `get loc` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:119` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `[Symbol.split]`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `Comparator` (1)

**Calls:**
- `hasObservableSideEffectsForRegExpSplit` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-includes.js:39` | Self: 0.0% (0us) | Total: 2.5% (71.3ms) | Samples: 0

**Called by:**
- `_compile` (46)

**Calls:**
- `bound require` (46)

### `(anonymous)`
`/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:23` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` | Self: 0.0% (0us) | Total: 8.9% (254.0ms) | Samples: 0

**Called by:**
- `anonymous` (117)

**Calls:**
- `bound require` (117)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeFlagUtils.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-promises.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_installCjsSubstitutes`
`/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:77` | Self: 0.0% (0us) | Total: 8.9% (252.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (116)

**Calls:**
- `_compile` (116)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.4% (13.4ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/baseTypeUtils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:26` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/analyzeChain.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/index.js:20` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.6% (19.1ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5687` | Self: 0.0% (0us) | Total: 0.2% (7.5ms) | Samples: 0

**Called by:**
- `_runSelectorList` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.4% (12.0ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/TypeOrValueSpecifier.js:42` | Self: 0.0% (0us) | Total: 3.4% (96.4ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` | Self: 0.0% (0us) | Total: 2.9% (83.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:65` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:89` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7834` | Self: 0.0% (0us) | Total: 0.5% (14.6ms) | Samples: 0

**Called by:**
- `runPlugins` (9)

**Calls:**
- `invokeMethodFnHandlers` (8)
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` | Self: 0.0% (0us) | Total: 0.2% (6.3ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/hasOverloadSignatures.js:5` | Self: 0.0% (0us) | Total: 3.7% (106.0ms) | Samples: 0

**Called by:**
- `anonymous` (22)

**Calls:**
- `bound require` (22)

### `(anonymous)`
`/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:5` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_compile` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/checkNullishAndReport.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` | Self: 0.0% (0us) | Total: 2.9% (83.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-argument.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/index.js:27` | Self: 0.0% (0us) | Total: 3.5% (99.4ms) | Samples: 0

**Called by:**
- `anonymous` (18)

**Calls:**
- `bound require` (18)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/consistent-generic-constructors.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createRule` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.0% (0us) | Total: 3.8% (107.7ms) | Samples: 0

**Called by:**
- `_NodeView_LR` (71)

**Calls:**
- `_identAt` (57)
- `_resolveUnicodeEscapes` (9)
- `_identAt` (4)
- `_identAt` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-enum-comparison.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

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
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-state.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.2% (7.2ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `__export` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getConstraintInfo.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-promises.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_ffiBufPtr`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:87` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfi` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `exitFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:146` | Self: 0.0% (0us) | Total: 0.4% (11.5ms) | Samples: 0

**Called by:**
- `FunctionExpression:exit` (7)

**Calls:**
- `getFunctionHeadLoc` (6)
- `getFunctionHeadLoc` (1)

### `_normalizeIPv6`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:812` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parse` (1)

**Calls:**
- `regExpMatchFast` (1)

### `FunctionDeclaration:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js:161` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `popContext` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7670` | Self: 0.0% (0us) | Total: 0.3% (10.4ms) | Samples: 0

**Called by:**
- `runPlugins` (7)

**Calls:**
- `invokeMethodFnHandlers` (6)
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.2% (7.2ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-argument.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.3% (9.0ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` | Self: 0.0% (0us) | Total: 0.4% (13.4ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `buildUnicodeData` (1)

### `getOpeningParenOfParams`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getFunctionHeadLoc.js:26` | Self: 0.0% (0us) | Total: 0.3% (9.8ms) | Samples: 0

**Called by:**
- `getFunctionHeadLoc` (6)

**Calls:**
- `getFirstToken` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7731` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:37` | Self: 0.0% (0us) | Total: 2.5% (73.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` | Self: 0.0% (0us) | Total: 0.4% (13.1ms) | Samples: 0

**Called by:**
- `walkNodes` (8)

**Calls:**
- `invokeHandlersWithNode` (8)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getFunctionHeadLoc.js:142` | Self: 0.0% (0us) | Total: 0.3% (9.8ms) | Samples: 0

**Called by:**
- `exitFunction` (6)

**Calls:**
- `getOpeningParenOfParams` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-restricted-imports.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:103` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:94` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist/index.cjs.cjs:31` | Self: 0.0% (0us) | Total: 0.1% (5.2ms) | Samples: 0

**Called by:**
- `_compile` (3)

**Calls:**
- `_compile` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:26` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.4% (13.4ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8051` | Self: 0.0% (0us) | Total: 79.6% (2.24s) | Samples: 0

**Called by:**
- `_lintSourceOne` (1496)

**Calls:**
- `walkNodes` (1244)
- `walkNodes` (65)
- `walkNodes` (39)
- `walkNodes` (36)
- `walkNodes` (22)
- `walkNodes` (10)
- `walkNodes` (9)
- `walkNodes` (8)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (3)
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

### `node:tty`
`node:tty:6` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2025.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/lib-overrides.js:134` | Self: 0.0% (0us) | Total: 8.9% (252.4ms) | Samples: 0

**Called by:**
- `anonymous` (116)

**Calls:**
- `_installCjsSubstitutes` (116)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6791` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6112` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `walkNodes` (3)

**Calls:**
- `set` (3)

### `async loadAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `linkAndEvaluateModule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/index.js:82` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 42.5% | 1.20s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 35.9% | 1.01s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 16.7% | 473.7ms | `[native code]` |
| 2.5% | 73.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js` |
| 0.6% | 17.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.1% | 4.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-misused-spread.js` |
| 0.1% | 3.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/class-methods-use-this.js` |
| 0.0% | 1.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/RuleCreator.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeFlagUtils.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/misc.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/visitor-keys.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/unbound-method.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/type-utils/dist/typeOrValueSpecifiers/typeDeclaredInPackageDeclarationFile.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/return-await.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-unary-minus.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unnecessary-template-expression.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-dupe-class-members.js` |
| 0.0% | 1.3ms | `node:child_process` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-meaningless-void-operator.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-unsafe-return.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/no-confusing-void-expression.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/util/getConstraintInfo.js` |
| 0.0% | 1.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/eslint-plugin/dist/rules/prefer-optional-chain-utils/checkNullishAndReport.js` |
