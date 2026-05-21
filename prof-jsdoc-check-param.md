# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 800.2ms | 453 | 1.0ms | 574 |

**Top 10:** `anonymous` 29.4%, `parse` 27.9%, `(anonymous)` 8.4%, `(anonymous)` 8.1%, `(anonymous)` 8.0%, `(anonymous)` 1.5%, `CfgGraph` 1.2%, `AstView` 0.9%, `toLocaleLowerCase` 0.6%, `AstView` 0.5%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 29.4% | 235.3ms | 100.0% | 1.49s | `anonymous` | `[native code]` |
| 27.9% | 223.2ms | 27.9% | 223.2ms | `parse` | `[native code]` |
| 8.4% | 67.4ms | 8.4% | 67.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:3` |
| 8.1% | 65.1ms | 8.1% | 65.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301190` |
| 8.0% | 64.4ms | 8.0% | 64.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 1.5% | 12.2ms | 1.5% | 12.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 1.2% | 9.6ms | 1.2% | 9.6ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` |
| 0.9% | 7.4ms | 0.9% | 7.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.6% | 5.1ms | 0.6% | 5.1ms | `toLocaleLowerCase` | `[native code]` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.4% | 3.3ms | 0.4% | 3.3ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.3% | 2.9ms | 0.5% | 4.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.3% | 2.5ms | 0.3% | 2.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301164` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `createBaseFor` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290047` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:398` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `every` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33670` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197801` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `getEnumNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:9106` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `getUint32` | `[native code]` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `defineProperty` | `[native code]` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `Set` | `[native code]` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192362` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:239381` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8499` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `toEslintCreate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `defineProperties` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90396` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188434` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `clone` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/estraverse/estraverse.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190509` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:4` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:43428` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232340` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isPropertyDescriptor` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301184` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316915` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_recomposeAuthority` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `setName` | `node:fs:616` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `evaluate` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `getBaseIntrinsic2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137111` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `buildForbidRuleDefinition` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186605` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293717` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `keys` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180335` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58290` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174979` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172437` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:3` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `sort` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `fillUsage` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91366` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:109204` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `::bunternal::` | `internal:validators` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200301` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `docsUrl` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:131381` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `repeat` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `encodeInto` | `[native code]` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `RegExp` | `[native code]` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `regExpSplitFast` | `[native code]` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `join` | `[native code]` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102525` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170624` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `__toESM` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:13` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170915` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `getPolyfill` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `enumeratePropertyNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162690` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 1.49s | 29.4% | 235.3ms | `anonymous` | `[native code]` |
| 100.0% | 1.47s | 0.0% | 0us | `bound require` | `[native code]` |
| 100.0% | 1.46s | 0.0% | 0us | `require` | `[native code]` |
| 100.0% | 1.36s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` |
| 66.2% | 529.7ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` |
| 66.2% | 529.7ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 66.2% | 529.7ms | 0.0% | 0us | `bundleRulesFor` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` |
| 66.2% | 529.7ms | 0.0% | 0us | `_loadBundle` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` |
| 31.7% | 253.7ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 31.7% | 253.7ms | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 31.3% | 250.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 27.9% | 223.2ms | 27.9% | 223.2ms | `parse` | `[native code]` |
| 27.5% | 220.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 14.2% | 113.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313106` |
| 12.1% | 96.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173278` |
| 11.7% | 93.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172574` |
| 11.7% | 93.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173250` |
| 11.5% | 92.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172432` |
| 11.0% | 88.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` |
| 11.0% | 88.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172350` |
| 11.0% | 88.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171770` |
| 11.0% | 88.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171549` |
| 11.0% | 88.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171395` |
| 8.8% | 71.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313098` |
| 8.8% | 71.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168171` |
| 8.8% | 71.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168347` |
| 8.6% | 68.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` |
| 8.4% | 67.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` |
| 8.4% | 67.4ms | 8.4% | 67.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:3` |
| 8.4% | 67.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` |
| 8.4% | 67.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` |
| 8.1% | 65.1ms | 8.1% | 65.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301190` |
| 8.0% | 64.4ms | 8.0% | 64.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 5.3% | 43.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337694` |
| 5.1% | 41.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290029` |
| 4.2% | 33.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` |
| 4.2% | 33.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293431` |
| 3.6% | 29.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 3.5% | 28.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313125` |
| 2.7% | 22.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` |
| 2.6% | 21.5ms | 0.0% | 0us | `map` | `[native code]` |
| 2.4% | 19.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` |
| 2.3% | 18.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` |
| 2.2% | 18.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` |
| 2.2% | 18.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 2.1% | 16.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173277` |
| 2.0% | 16.5ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 2.0% | 16.5ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 1.7% | 14.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` |
| 1.6% | 13.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` |
| 1.6% | 13.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 1.5% | 12.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` |
| 1.5% | 12.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` |
| 1.5% | 12.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` |
| 1.5% | 12.2ms | 1.5% | 12.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 1.4% | 11.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 1.3% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` |
| 1.3% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` |
| 1.3% | 10.8ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 1.2% | 10.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` |
| 1.2% | 10.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` |
| 1.2% | 10.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301100` |
| 1.2% | 10.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` |
| 1.2% | 10.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` |
| 1.2% | 9.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 1.2% | 9.6ms | 1.2% | 9.6ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` |
| 1.1% | 8.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` |
| 1.0% | 8.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` |
| 1.0% | 8.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` |
| 1.0% | 8.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` |
| 1.0% | 8.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301142` |
| 0.9% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277070` |
| 0.9% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277094` |
| 0.9% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289692` |
| 0.9% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` |
| 0.9% | 7.4ms | 0.9% | 7.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.9% | 7.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` |
| 0.8% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.8% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.8% | 6.5ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.8% | 6.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.8% | 6.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276523` |
| 0.7% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` |
| 0.7% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312910` |
| 0.7% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` |
| 0.7% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` |
| 0.6% | 5.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295642` |
| 0.6% | 5.1ms | 0.6% | 5.1ms | `toLocaleLowerCase` | `[native code]` |
| 0.6% | 5.1ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295622` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.5% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138699` |
| 0.5% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313032` |
| 0.5% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301178` |
| 0.5% | 4.6ms | 0.3% | 2.9ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.5% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` |
| 0.5% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` |
| 0.5% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110317` |
| 0.4% | 3.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312925` |
| 0.4% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.4% | 3.4ms | 0.0% | 0us | `replace` | `[native code]` |
| 0.4% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295624` |
| 0.4% | 3.4ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301138` |
| 0.4% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301173` |
| 0.4% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.4% | 3.3ms | 0.4% | 3.3ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.4% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290133` |
| 0.4% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` |
| 0.4% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` |
| 0.4% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:242050` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290082` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313079` |
| 0.3% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` |
| 0.3% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` |
| 0.3% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` |
| 0.3% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` |
| 0.3% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313084` |
| 0.3% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` |
| 0.3% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.3% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.3% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152207` |
| 0.3% | 2.5ms | 0.3% | 2.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301164` |
| 0.3% | 2.5ms | 0.0% | 0us | `generatorResume` | `[native code]` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215280` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215829` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289485` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `createBaseFor` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215933` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215648` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290047` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:6` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201839` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182109` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182101` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182066` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190007` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190002` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201879` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289677` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:264193` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:13` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261167` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260470` |
| 0.2% | 1.7ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260568` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260360` |
| 0.2% | 1.7ms | 0.0% | 0us | `_objectSpread` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260206` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260291` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261101` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289664` |
| 0.2% | 1.7ms | 0.0% | 0us | `replaceXRanges` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:389` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` |
| 0.2% | 1.7ms | 0.0% | 0us | `parseRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:135` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:398` |
| 0.2% | 1.7ms | 0.0% | 0us | `satisfies` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/functions/satisfies.js:6` |
| 0.2% | 1.7ms | 0.0% | 0us | `parseComparator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:264` |
| 0.2% | 1.7ms | 0.0% | 0us | `Range` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:42` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:49` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313241` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:11` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:283793` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:284119` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/backward-token-comment-cursor.js:12` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:283864` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289722` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289705` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280759` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280815` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:4871` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `every` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 1.7ms | 0.0% | 0us | `_Version` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:4823` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.2% | 1.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:47` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33670` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290297` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185528` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201861` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289549` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232177` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201916` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197830` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197801` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197838` |
| 0.2% | 1.7ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:227497` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228544` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228442` |
| 0.2% | 1.7ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:227518` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289536` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228067` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228703` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:227894` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178974` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178991` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201821` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `getEnumNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178664` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290121` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:9106` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301188` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `getUint32` | `[native code]` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:184205` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:184176` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201852` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `defineProperty` | `[native code]` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:184215` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:248073` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `Set` | `[native code]` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:248019` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289608` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169413` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173238` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295625` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295654` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201890` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192362` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192405` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192396` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289637` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254651` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254632` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:239381` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289564` |
| 0.2% | 1.7ms | 0.0% | 0us | `getNodeSystem` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8288` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8678` |
| 0.2% | 1.7ms | 0.0% | 0us | `isFileSystemCaseSensitive` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8495` |
| 0.2% | 1.7ms | 0.0% | 0us | `swapCase` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8498` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8499` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8673` |
| 0.2% | 1.6ms | 0.0% | 0us | `checkVueTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293242` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295556` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `toEslintCreate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:559` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:41` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:30` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` |
| 0.2% | 1.6ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `internal:streams/duplex` | `internal:streams/duplex:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `node:tty` | `node:tty:6` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` |
| 0.2% | 1.6ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:98921` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12342` |
| 0.2% | 1.6ms | 0.0% | 0us | `internal:util/inspect` | `internal:util/inspect:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99420` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109704` |
| 0.2% | 1.6ms | 0.0% | 0us | `node:util` | `node:util:2` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99334` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313352` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290383` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48478` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48386` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48456` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48410` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `defineProperties` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313108` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173676` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173605` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201907` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90396` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91299` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271650` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:220834` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289507` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138693` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138597` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188472` |
| 0.2% | 1.6ms | 0.2% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188434` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201873` |
| 0.2% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188463` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161607` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161318` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161364` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161553` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/estraverse/estraverse.js:803` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `clone` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/estraverse/estraverse.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-scope/dist/eslint-scope.cjs:3` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:13` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201883` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190544` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190552` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190509` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138496` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276524` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290357` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:30` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:43428` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:18` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:4` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:44` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236595` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232340` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236367` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289551` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236472` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:17` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:8` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95854` |
| 0.1% | 1.5ms | 0.0% | 0us | `DefinePropertyOrThrow` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95840` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96732` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95893` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110315` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96800` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isPropertyDescriptor` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/keyword.js:4` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301184` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:29` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316915` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:30` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:4` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290217` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:74` |
| 0.1% | 1.5ms | 0.0% | 0us | `_getFullPath` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:215` |
| 0.1% | 1.5ms | 0.0% | 0us | `serialize` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:1031` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_recomposeAuthority` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.1% | 1.5ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` |
| 0.1% | 1.5ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` |
| 0.1% | 1.5ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` |
| 0.1% | 1.5ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `setName` | `node:fs:616` |
| 0.1% | 1.5ms | 0.0% | 0us | `node:fs` | `node:fs:674` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version.js:6` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:43` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224949` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289528` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224986` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201924` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `evaluate` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `moduleEvaluation` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `async loadAndEvaluateModule` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137510` |
| 0.1% | 1.5ms | 0.0% | 0us | `callBoundIntrinsic` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137268` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138509` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137493` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138272` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137799` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137945` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137616` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `getBaseIntrinsic2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137111` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137748` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137549` |
| 0.1% | 1.5ms | 0.0% | 0us | `GetIntrinsic` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137145` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137882` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313055` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164515` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164605` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164408` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `buildForbidRuleDefinition` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328693` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272046` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:19` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/ESLint.js:8` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:50` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201866` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186642` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186605` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186652` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186766` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293717` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `keys` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:242085` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289574` |
| 0.1% | 1.4ms | 0.0% | 0us | `flatIntoArrayWithCallback` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2022.js:12` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:69` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201827` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180335` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180373` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180364` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:5` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201908` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223097` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223015` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289518` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108748` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108935` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109025` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109710` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109002` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108970` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109087` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58290` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:240` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90172` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92621` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:30` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2017.js:11` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175016` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175008` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174979` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313116` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289589` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244750` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244705` |
| 0.1% | 1.4ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.1% | 1.4ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.1% | 1.4ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128029` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172437` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289651` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257120` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289738` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:287002` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172351` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212972` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322394` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201848` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:3` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:37` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:30` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:3` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:5` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:20` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:13264` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:13258` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290137` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `sort` | `[native code]` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187895` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:17` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187889` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201870` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `fillUsage` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91366` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92489` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92472` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:109204` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` |
| 0.1% | 1.3ms | 0.0% | 0us | `node:assert` | `node:assert:588` |
| 0.1% | 1.3ms | 0.0% | 0us | `node:assert/strict` | `node:assert/strict:3` |
| 0.1% | 1.3ms | 0.0% | 0us | `assign` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `::bunternal::` | `internal:validators` |
| 0.1% | 1.3ms | 0.0% | 0us | `get` | `node:assert:575` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293087` |
| 0.1% | 1.3ms | 0.0% | 0us | `deprecate` | `internal:util/deprecate:16` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200330` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200338` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200301` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201926` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:142161` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `docsUrl` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:131381` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313039` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201898` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152816` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161605` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152902` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `repeat` | `[native code]` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152793` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176120` |
| 0.1% | 1.3ms | 0.0% | 0us | `getESLintCoreRule` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174801` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313121` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289621` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:4` |
| 0.1% | 1.3ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.1% | 1.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `encodeInto` | `[native code]` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:4` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173248` |
| 0.1% | 1.2ms | 0.0% | 0us | `ContainsDetector` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217349` |
| 0.1% | 1.2ms | 0.0% | 0us | `JavaScriptFootPrint` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217443` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289690` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217513` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217672` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289491` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266354` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217349` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `RegExp` | `[native code]` |
| 0.1% | 1.2ms | 0.0% | 0us | `getFirstSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301119` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301172` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `regExpSplitFast` | `[native code]` |
| 0.1% | 1.2ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301140` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.1% | 1.2ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295626` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `join` | `[native code]` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301150` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:34` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102569` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105264` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106842` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102525` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102717` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102546` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:104239` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109709` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106429` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102554` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170624` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170731` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170653` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172342` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170663` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128070` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:99` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/esnext.js:13` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:309084` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `__toESM` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:13` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170953` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172347` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170915` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170944` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:114696` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:114364` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:114798` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:127999` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:114813` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `getPolyfill` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 1.2ms | 0.0% | 0us | `from` | `[native code]` |
| 0.1% | 1.2ms | 0.0% | 0us | `enumeratePropertyNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162704` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `enumeratePropertyNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162690` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:165314` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path.js:12` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/BlockScope.js:4` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:562` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:17` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` |

## Function Details

### `anonymous`
`[native code]` | Self: 29.4% (235.3ms) | Total: 100.0% (1.49s) | Samples: 160

**Called by:**
- `require` (758)
- `bound require` (7)
- `node:assert/strict` (1)
- `node:stream` (1)
- `internal:util/inspect` (1)
- `node:tty` (1)
- `internal:streams/duplex` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/compose` (1)
- `node:util` (1)
- `internal:fs/streams` (1)
- `internal:streams/pipeline` (1)

**Calls:**
- `(anonymous)` (46)
- `(anonymous)` (38)
- `(anonymous)` (27)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (20)
- `(anonymous)` (18)
- `(anonymous)` (15)
- `(anonymous)` (13)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (10)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `node:assert` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:assert/strict` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `internal:streams/pipeline` (1)
- `node:util` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:stream` (1)
- `internal:util/inspect` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:tty` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `parse`
`[native code]` | Self: 27.9% (223.2ms) | Total: 27.9% (223.2ms) | Samples: 145

**Called by:**
- `parseSource` (143)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:3` | Self: 8.4% (67.4ms) | Total: 8.4% (67.4ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301190` | Self: 8.1% (65.1ms) | Total: 8.1% (65.1ms) | Samples: 10

**Called by:**
- `anonymous` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 8.0% (64.4ms) | Total: 8.0% (64.4ms) | Samples: 42

**Called by:**
- `(anonymous)` (34)
- `forEach` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 1.5% (12.2ms) | Total: 1.5% (12.2ms) | Samples: 8

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` | Self: 1.2% (9.6ms) | Total: 1.2% (9.6ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` | Self: 0.9% (7.4ms) | Total: 0.9% (7.4ms) | Samples: 5

**Called by:**
- `parseSource` (5)

### `toLocaleLowerCase`
`[native code]` | Self: 0.6% (5.1ms) | Total: 0.6% (5.1ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` | Self: 0.5% (4.7ms) | Total: 0.5% (4.7ms) | Samples: 3

**Called by:**
- `parseSource` (3)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 0.4% (3.3ms) | Total: 0.4% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` | Self: 0.3% (2.9ms) | Total: 0.5% (4.6ms) | Samples: 2

**Called by:**
- `parseSource` (3)

**Calls:**
- `getUint32` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301164` | Self: 0.3% (2.5ms) | Total: 0.3% (2.5ms) | Samples: 2

**Called by:**
- `map` (2)

### `createBaseFor`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290047` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:398` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `replace` (1)

### `every`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `_Version` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33670` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197801` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `SemVer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `parse` (1)

### `getEnumNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:9106` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getUint32`
`[native code]` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `defineProperty`
`[native code]` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `Set`
`[native code]` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192362` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:239381` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8499` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `replace` (1)

### `toEslintCreate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `checkVueTemplate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `defineProperties`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90396` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188434` | Self: 0.2% (1.6ms) | Total: 0.2% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `clone`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/estraverse/estraverse.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190509` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:4` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:43428` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232340` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isPropertyDescriptor`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `DefinePropertyOrThrow` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301184` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316915` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_recomposeAuthority`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `serialize` (1)

### `setName`
`node:fs:616` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `node:fs` (1)

### `evaluate`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `moduleEvaluation` (1)

### `getBaseIntrinsic2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137111` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `GetIntrinsic` (1)

### `buildForbidRuleDefinition`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186605` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293717` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `keys`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180335` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58290` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174979` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172437` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:3` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `sort`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `fillUsage`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91366` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:109204` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `::bunternal::`
`internal:validators` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `deprecate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200301` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `docsUrl`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:131381` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `repeat`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `encodeInto`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `RegExp`
`[native code]` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `regExpSplitFast`
`[native code]` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `getFirstSegment` (1)

### `join`
`[native code]` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102525` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170624` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `__toESM`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:13` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170915` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getPolyfill`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `enumeratePropertyNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162690` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201898` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109710` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `addMetaSchema` (1)

**Calls:**
- `_addSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173278` | Self: 0.0% (0us) | Total: 12.1% (96.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (26)

**Calls:**
- `(anonymous)` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260470` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295622` | Self: 0.0% (0us) | Total: 0.6% (5.1ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (2)
- `(anonymous)` (1)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48386` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperties` (1)

### `_Version`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:4823` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `every` (1)

### `isFileSystemCaseSensitive`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8495` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `getNodeSystem` (1)

**Calls:**
- `swapCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` | Self: 0.0% (0us) | Total: 0.9% (7.4ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `node:fs`
`node:fs:674` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `setName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92621` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:227497` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280815` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161364` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:227518` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `Comparator` (1)

**Calls:**
- `SemVer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:114813` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289551` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:assert/strict`
`node:assert/strict:3` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `internal:streams/duplex`
`internal:streams/duplex:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102554` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:34` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295556` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `checkVueTemplate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:11` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295642` | Self: 0.0% (0us) | Total: 0.6% (5.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `toLocaleLowerCase` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137799` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 1.4% (11.4ms) | Samples: 0

**Called by:**
- `parseModule` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289485` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:264193` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217672` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `_getFullPath` (1)

### `generatorResume`
`[native code]` | Self: 0.0% (0us) | Total: 0.3% (2.5ms) | Samples: 0

**Called by:**
- `from` (1)
- `enumeratePropertyNames` (1)

**Calls:**
- `enumeratePropertyNames` (1)
- `enumeratePropertyNames` (1)

### `Range`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:42` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `satisfies` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301178` | Self: 0.0% (0us) | Total: 0.5% (4.6ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152816` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290383` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170663` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` | Self: 0.0% (0us) | Total: 0.5% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/estraverse/estraverse.js:803` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `clone` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-scope/dist/eslint-scope.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:30` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` | Self: 0.0% (0us) | Total: 66.2% (529.7ms) | Samples: 0

**Calls:**
- `loadCoreRules` (282)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186766` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190002` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48456` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `replace`
`[native code]` | Self: 0.0% (0us) | Total: 0.4% (3.4ms) | Samples: 0

**Called by:**
- `map` (1)
- `swapCase` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172350` | Self: 0.0% (0us) | Total: 11.0% (88.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `(anonymous)` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289574` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:562` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 2.6% (21.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)
- `camelCase` (3)
- `Range` (1)
- `(anonymous)` (1)
- `replaceXRanges` (1)
- `parseRange` (1)
- `ContainsDetector` (1)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `parseRange` (1)
- `(anonymous)` (1)
- `parseComparator` (1)
- `(anonymous)` (1)
- `replace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102569` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.8% (6.5ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 2.7% (22.3ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `checkVueTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293242` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `toEslintCreate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 31.7% (253.7ms) | Samples: 0

**Calls:**
- `(anonymous)` (161)

### `satisfies`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/functions/satisfies.js:6` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:240` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:13` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:127999` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172342` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.3% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289738` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:227894` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Comparator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.4% (3.3ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215933` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:309084` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `__toESM` (1)

### `deprecate`
`internal:util/deprecate:16` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `::bunternal::` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109709` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280759` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201866` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228067` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260568` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99334` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201907` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161607` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173248` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257120` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236367` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289722` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` | Self: 0.0% (0us) | Total: 1.5% (12.6ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254632` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137549` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:assert`
`node:assert:588` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `assign` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `replaceXRanges`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:389` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `parseComparator` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201827` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201890` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186652` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` | Self: 0.0% (0us) | Total: 1.7% (14.1ms) | Samples: 0

**Called by:**
- `anonymous` (10)

**Calls:**
- `bound require` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` | Self: 0.0% (0us) | Total: 1.3% (10.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `from`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `generatorResume` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186642` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313084` | Self: 0.0% (0us) | Total: 0.3% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 3.6% (29.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (15)

**Calls:**
- `AstView` (5)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138597` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 31.3% (250.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (159)

**Calls:**
- `parseSource` (143)
- `parseSource` (15)
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:283864` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` | Self: 0.0% (0us) | Total: 0.7% (5.8ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `serialize`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:1031` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_getFullPath` (1)

**Calls:**
- `_recomposeAuthority` (1)

### `node:util`
`node:util:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `assign`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `node:assert` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266354` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 1.0% (8.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172432` | Self: 0.0% (0us) | Total: 11.5% (92.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (23)

**Calls:**
- `(anonymous)` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277094` | Self: 0.0% (0us) | Total: 0.9% (7.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190552` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228544` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289651` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `GetIntrinsic`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137145` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `callBoundIntrinsic` (1)

**Calls:**
- `getBaseIntrinsic2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260291` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_objectSpread` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301172` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313241` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312925` | Self: 0.0% (0us) | Total: 0.4% (3.9ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172574` | Self: 0.0% (0us) | Total: 11.7% (93.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `(anonymous)` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201861` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 27.5% (220.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (143)

**Calls:**
- `parse` (143)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185528` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99420` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:220834` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224986` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106842` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` | Self: 0.0% (0us) | Total: 1.2% (10.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90172` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188463` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217349` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `RegExp` (1)

### `callBoundIntrinsic`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137268` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `GetIntrinsic` (1)

### `swapCase`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8498` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `isFileSystemCaseSensitive` (1)

**Calls:**
- `replace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 2.2% (18.2ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/esnext.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201870` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` | Self: 0.0% (0us) | Total: 8.4% (67.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8678` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236472` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217513` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `JavaScriptFootPrint` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171395` | Self: 0.0% (0us) | Total: 11.0% (88.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `bound require` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` | Self: 0.0% (0us) | Total: 8.4% (67.4ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/keyword.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173238` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201821` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301142` | Self: 0.0% (0us) | Total: 1.0% (8.5ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `map` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:49` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260360` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276523` | Self: 0.0% (0us) | Total: 0.8% (6.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313116` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 1.3% (10.8ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `CfgGraph` (2)
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290082` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:142161` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `docsUrl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295654` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105264` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.3% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109002` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.3% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290297` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_objectSpread`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260206` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `forEach` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187889` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `addMetaSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:29` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` | Self: 0.0% (0us) | Total: 0.4% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `get`
`node:assert:575` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `assign` (1)

**Calls:**
- `deprecate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228442` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313032` | Self: 0.0% (0us) | Total: 0.5% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:30` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:13264` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182101` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138509` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:114364` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getPolyfill` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152793` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `resolveIds` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295626` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `join` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106429` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244750` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170944` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215648` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:184176` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313125` | Self: 0.0% (0us) | Total: 3.5% (28.5ms) | Samples: 0

**Called by:**
- `anonymous` (18)

**Calls:**
- `(anonymous)` (18)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201852` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (1.47s) | Samples: 0

**Called by:**
- `_loadBundle` (282)
- `(anonymous)` (46)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (15)
- `(anonymous)` (13)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `patchAstUtils` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
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
- `getESLintCoreRule` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `require` (758)
- `anonymous` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128070` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:41` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172351` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293431` | Self: 0.0% (0us) | Total: 4.2% (33.9ms) | Samples: 0

**Called by:**
- `anonymous` (23)

**Calls:**
- `bound require` (23)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:114798` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271650` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201848` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 1.0% (8.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:18` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313079` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` | Self: 0.0% (0us) | Total: 11.0% (88.4ms) | Samples: 0

**Called by:**
- `anonymous` (20)

**Calls:**
- `bound require` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` | Self: 0.0% (0us) | Total: 0.7% (5.8ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` | Self: 0.0% (0us) | Total: 0.4% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` | Self: 0.0% (0us) | Total: 0.5% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164408` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95893` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `satisfies` (1)

### `parseRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:135` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192405` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92472` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `fillUsage` (1)

### `ContainsDetector`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217349` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `JavaScriptFootPrint` (1)

**Calls:**
- `map` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:47` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `async (anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128029` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137748` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161605` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182109` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337694` | Self: 0.0% (0us) | Total: 5.3% (43.1ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `(anonymous)` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289664` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:74` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201839` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200330` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244705` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:50` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180373` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180364` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:114696` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328693` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `buildForbidRuleDefinition` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175016` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192396` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:44` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170731` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197830` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` | Self: 0.0% (0us) | Total: 2.4% (19.4ms) | Samples: 0

**Called by:**
- `anonymous` (13)

**Calls:**
- `bound require` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.4% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137616` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:43` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176120` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175008` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` | Self: 0.0% (0us) | Total: 0.9% (7.9ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171770` | Self: 0.0% (0us) | Total: 11.0% (88.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `(anonymous)` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getESLintCoreRule`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174801` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313352` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173676` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276524` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12342` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277070` | Self: 0.0% (0us) | Total: 0.9% (7.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.8% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96800` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48478` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `flatIntoArrayWithCallback`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182066` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:287002` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289677` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getFirstSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301119` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (1)

**Calls:**
- `regExpSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:4871` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_Version` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170653` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201924` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` | Self: 0.0% (0us) | Total: 1.3% (10.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168171` | Self: 0.0% (0us) | Total: 8.8% (71.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (46)

**Calls:**
- `bound require` (46)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 2.0% (16.5ms) | Samples: 0

**Calls:**
- `parseModule` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 1.6% (13.3ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108970` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (1.46s) | Samples: 0

**Called by:**
- `bound require` (758)

**Calls:**
- `anonymous` (758)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/BlockScope.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` | Self: 0.0% (0us) | Total: 8.6% (68.9ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289518` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:242050` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)
- `(anonymous)` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)
- `keys` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.8% (6.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91299` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96732` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164605` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289608` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 2.2% (18.2ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:6` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `_objectSpread` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313121` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:283793` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178974` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 1.6% (13.3ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168347` | Self: 0.0% (0us) | Total: 8.8% (71.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (46)

**Calls:**
- `(anonymous)` (46)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290121` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `addPolyfillToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301138` | Self: 0.0% (0us) | Total: 0.4% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `camelCase` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173250` | Self: 0.0% (0us) | Total: 11.7% (93.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `(anonymous)` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138699` | Self: 0.0% (0us) | Total: 0.5% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:19` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:13258` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `sort` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:17` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 31.7% (253.7ms) | Samples: 0

**Called by:**
- `processTicksAndRejections` (161)

**Calls:**
- `_lintSourceOne` (159)
- `_lintSourceOne` (1)
- `async loadAndEvaluateModule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201916` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232177` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138496` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289621` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` | Self: 0.0% (0us) | Total: 1.1% (8.8ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:284119` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` | Self: 0.0% (0us) | Total: 0.4% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190544` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295625` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/ESLint.js:8` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201926` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201883` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108935` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:99` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290357` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102717` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301150` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `camelCase` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 66.2% (529.7ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (282)

**Calls:**
- `bundleRulesFor` (282)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197838` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:242085` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212972` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289491` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289690` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293087` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108748` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version.js:6` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261167` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313039` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:184215` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295624` | Self: 0.0% (0us) | Total: 0.4% (3.4ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190007` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137493` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `callBoundIntrinsic` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:248073` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:248019` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Set` (1)

### `parseComparator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:264` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `replaceXRanges` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171549` | Self: 0.0% (0us) | Total: 11.0% (88.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `(anonymous)` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` | Self: 0.0% (0us) | Total: 2.3% (18.6ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path.js:12` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:69` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254651` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178664` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getEnumNames` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:104239` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289705` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:17` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289692` | Self: 0.0% (0us) | Total: 0.9% (7.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:30` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173277` | Self: 0.0% (0us) | Total: 2.1% (16.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137510` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152207` | Self: 0.0% (0us) | Total: 0.3% (2.6ms) | Samples: 0

**Called by:**
- `map` (1)
- `(anonymous)` (1)

**Calls:**
- `repeat` (1)
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289549` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110317` | Self: 0.0% (0us) | Total: 0.5% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170953` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201873` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172347` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138693` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161318` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137882` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `moduleEvaluation`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `async loadAndEvaluateModule` (1)

**Calls:**
- `evaluate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:5` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `DefinePropertyOrThrow`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95840` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289507` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290133` | Self: 0.0% (0us) | Total: 0.4% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:98921` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 1.2% (10.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290029` | Self: 0.0% (0us) | Total: 5.1% (41.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (26)

**Calls:**
- `(anonymous)` (26)

### `JavaScriptFootPrint`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217443` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `ContainsDetector` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2017.js:11` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `bundleRulesFor`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` | Self: 0.0% (0us) | Total: 66.2% (529.7ms) | Samples: 0

**Called by:**
- `loadCoreRules` (282)

**Calls:**
- `_loadBundle` (282)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102546` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289528` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224949` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` | Self: 0.0% (0us) | Total: 0.7% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223097` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95854` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `DefinePropertyOrThrow` (1)

### `enumeratePropertyNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162704` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `generatorResume` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:184205` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:559` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236595` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getNodeSystem`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8288` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isFileSystemCaseSensitive` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109025` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215280` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `createBaseFor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137945` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313106` | Self: 0.0% (0us) | Total: 14.2% (113.7ms) | Samples: 0

**Called by:**
- `anonymous` (38)

**Calls:**
- `(anonymous)` (38)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152902` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169413` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` | Self: 0.0% (0us) | Total: 1.2% (10.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290217` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201908` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301100` | Self: 0.0% (0us) | Total: 1.2% (10.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289637` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:8` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313098` | Self: 0.0% (0us) | Total: 8.8% (71.1ms) | Samples: 0

**Called by:**
- `anonymous` (46)

**Calls:**
- `(anonymous)` (46)

### `_loadBundle`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` | Self: 0.0% (0us) | Total: 66.2% (529.7ms) | Samples: 0

**Called by:**
- `bundleRulesFor` (282)

**Calls:**
- `bound require` (282)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322394` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313108` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223015` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 1.0% (8.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164515` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173605` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110315` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215829` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:30` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289589` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8673` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getNodeSystem` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `async (anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161553` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.8% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:165314` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `from` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228703` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 1.2% (9.8ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:20` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` | Self: 0.0% (0us) | Total: 1.5% (12.6ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272046` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109087` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:37` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178991` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301173` | Self: 0.0% (0us) | Total: 0.4% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addPolyfillToken` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313055` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290137` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` | Self: 0.0% (0us) | Total: 8.4% (67.4ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200338` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2022.js:12` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109704` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:17` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getFullPath`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:215` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `serialize` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` | Self: 0.0% (0us) | Total: 1.2% (10.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289564` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301188` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` | Self: 0.0% (0us) | Total: 1.5% (12.6ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312910` | Self: 0.0% (0us) | Total: 0.7% (5.9ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `(anonymous)` (4)

### `internal:util/inspect`
`internal:util/inspect:2` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92489` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:tty`
`node:tty:6` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48410` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `addPolyfillToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301140` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getFirstSegment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:30` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187895` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289536` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` | Self: 0.0% (0us) | Total: 100.0% (1.36s) | Samples: 0

**Called by:**
- `(anonymous)` (46)
- `(anonymous)` (46)
- `(anonymous)` (38)
- `(anonymous)` (27)
- `(anonymous)` (26)
- `(anonymous)` (26)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (18)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (46)
- `(anonymous)` (46)
- `(anonymous)` (34)
- `(anonymous)` (26)
- `(anonymous)` (26)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (12)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 4.2% (33.9ms) | Samples: 0

**Called by:**
- `anonymous` (23)

**Calls:**
- `bound require` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/backward-token-comment-cursor.js:12` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261101` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201879` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `async loadAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `moduleEvaluation` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138272` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 2.0% (16.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188472` | Self: 0.0% (0us) | Total: 0.2% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 60.3% | 483.0ms | `[native code]` |
| 23.4% | 187.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 8.4% | 67.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` |
| 3.4% | 27.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 2.3% | 18.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js` |
| 0.2% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.2% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js` |
| 0.2% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.1% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/estraverse/estraverse.js` |
| 0.1% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js` |
| 0.1% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.1% | 1.5ms | `node:fs` |
| 0.1% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js` |
| 0.1% | 1.3ms | `internal:validators` |
