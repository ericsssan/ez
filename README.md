# Sanz

A high-performance JavaScript/TypeScript parser and linter written in Zig, with a zero-copy ESLint plugin runner that lets you run any ESLint plugin without reimplementing its rules.

## Parser Conformance

| Suite | Must-parse | Must-reject | Notes |
|-------|-----------|-------------|-------|
| tc39/test262-parser-tests | 3,966/3,966 (100%) | 1,387/1,391 (99.7%) | 6 known-stale skipped |
| TypeScript | 3,466/3,466 (100%) | 583/1,009 (57.8%) | 1,432 skipped (decorators etc.) |
| Babel (JS) | 3,911/4,122 (94.9%) | 1,583/1,587 (99.7%) | 2,871 skipped (JSX/TS/proposals) |

Must-reject measures whether the parser correctly reports a parse error on invalid code. TypeScript's low must-reject score (57.8%) reflects missing TS-specific error detection — sanz parses the code without crashing but doesn't yet diagnose all TypeScript semantic/syntax violations.

## Features

- **Zig-native parser** — SIMD-accelerated lexer, arena allocation, MultiArrayList AST (struct-of-arrays layout)
- **Semantic analysis** — scope tree, symbol table, reference tracking
- **Zero-copy JS bridge** — AST is shared as a raw `ArrayBuffer`; Node.js reads it without copying or marshalling
- **ESLint plugin runner** — load any ESLint plugin via `require()` and run its rules against the sanz AST
- **ESTree-compatible node views** — named field getters (`node.test`, `node.consequent`, `node.body`, etc.), `node.parent`, `node.range`, `node.loc`
- **AST selectors** — `esquery`-style selectors in visitor keys (`"IfStatement > BlockStatement"`, `"CallExpression[callee.name='require']"`)
- **Autofix** — `--fix` applies rule-provided fixes in-place
- **Full SourceCode API** — `getText()`, `getTokenBefore/After()`, `getScope()`, `getAncestors()`

## ESLint Plugin Compatibility

Tested against current versions:

| Plugin | Rules passing |
|--------|---------------|
| `eslint` (core) | 292/292 |
| `eslint-plugin-n` | 43/43 |
| `eslint-plugin-es-x` | 208/208 |
| `eslint-plugin-import` | 45/46 |

## Quick Start

### Build the native module

```sh
zig build          # builds zig-out/lib/libsanz.{dylib,so,dll}
```

### Install JS dependencies

```sh
cd js && npm install
```

### Run lint rules

```sh
# Run all eslint core rules against a file or directory
node js/lint.js --eslint-plugin eslint src/

# Run a specific rule
node js/lint.js --eslint-plugin eslint --rule eqeqeq src/index.js

# Run a third-party plugin
node js/lint.js --eslint-plugin eslint-plugin-unicorn src/

# TypeScript-eslint plugin
node js/lint.js --eslint-plugin @typescript-eslint/eslint-plugin src/

# Multiple plugins
node js/lint.js -p eslint -p eslint-plugin-n src/

# Apply autofixes
node js/lint.js --eslint-plugin eslint --fix src/

# JSON output
node js/lint.js --eslint-plugin eslint --format=json src/ | jq .

# With a config file for rule options
node js/lint.js --eslint-plugin eslint --config .eslintrc.json src/
```

### CLI options

```
--eslint-plugin, -p <pkg>   Load ESLint plugin (repeatable)
--rule, -r <name>           Only run rules matching this name (repeatable)
--config, -c <file>         ESLint config file (.eslintrc.json) for rule options
--format=json               Output JSON array instead of text
--fix                       Apply autofixes to files (writes in place)
--help, -h                  Show help
```

## How It Works

Sanz serializes its AST into a flat `ArrayBuffer` that is shared directly with Node.js — no JSON, no copying. The JS side reads node tags, tokens, and extra data via typed array views on the same memory. ESLint plugin rules call `context.report()` as normal; sanz collects the reports and formats them.

See [DESIGN.md](DESIGN.md) for the full architecture: MultiArrayList AST layout, SIMD lexer, arena allocation, and the JS bridge protocol.

## Requirements

- Zig `0.16.0-dev` or later
- Node.js 18+ (for the JS plugin runner)

## License

MIT
