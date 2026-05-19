ZIG ?= /Users/ericsan/.local/share/zigup/master/files/zig
LINK_FLAGS :=

.PHONY: test test-unit test-linter test-recovery test-config test-fuzz test-js test-borrow-check borrow-check test-all build build-conformance test-conformance run napi ezlint submodules

test: test-unit test-linter test-recovery test-config test-borrow-check

# Run the borrow-check rules' own unit tests (cheap, fast — under 5s).
test-borrow-check:
	$(ZIG) test zbc/main.zig $(LINK_FLAGS)

# Layer 1 (annotation hygiene) + Layer 2 (escape analysis) on every
# .zig file under src/.  Exit non-zero on any finding — wires into CI
# as a single command.  Verbose mode: EZ_BORROW_VERBOSE=1 make borrow-check
borrow-check:
	@find src -name '*.zig' -print0 | xargs -0 $(ZIG) run zbc/main.zig --
	@find src -name '*.zig' -print0 | xargs -0 $(ZIG) run zbc/main.zig -- --escape
	@echo "borrow-check: clean ✓"

test-unit:
	$(ZIG) test src/root.zig $(LINK_FLAGS)

test-linter:
	$(ZIG) test --dep ez -Mroot=tests/linter_test.zig -Mez=src/root.zig $(LINK_FLAGS)

test-recovery:
	$(ZIG) test --dep ez -Mroot=tests/error_recovery_test.zig -Mez=src/root.zig $(LINK_FLAGS)

test-config:
	$(ZIG) test --dep ez -Mroot=tests/config_integration_test.zig -Mez=src/root.zig $(LINK_FLAGS)

test-fuzz:
	$(ZIG) test --dep ez -Mroot=tests/fuzz_test.zig -Mez=src/root.zig $(LINK_FLAGS) -ffuzz

test-js: napi
	node tests/test_lint_batch.js

build-conformance:
	@mkdir -p zig-out/bin
	@$(ZIG) build-exe --dep ez -Mroot=tests/conformance/parser_tests_runner.zig -Mez=src/root.zig -femit-bin=zig-out/bin/parser_tests_runner $(LINK_FLAGS)
	@$(ZIG) build-exe --dep ez -Mroot=tests/conformance/test262_runner.zig -Mez=src/root.zig -femit-bin=zig-out/bin/test262_runner $(LINK_FLAGS)
	@$(ZIG) build-exe --dep ez -Mroot=tests/conformance/babel_runner.zig -Mez=src/root.zig -femit-bin=zig-out/bin/babel_runner $(LINK_FLAGS)
	@$(ZIG) build-exe --dep ez -Mroot=tests/conformance/typescript_runner.zig -Mez=src/root.zig -femit-bin=zig-out/bin/typescript_runner $(LINK_FLAGS)

test-conformance: build-conformance napi
	@echo ""
	@echo "Parser Conformance"
	@echo "────────────────────────────────────────────────────────────"
	@./zig-out/bin/test262_runner tests/conformance/test262/test/language --compact
	@./zig-out/bin/parser_tests_runner tests/conformance/test262-parser-tests --compact
	@./zig-out/bin/babel_runner tests/conformance/babel/packages/babel-parser/test/fixtures --compact
	@./zig-out/bin/typescript_runner tests/conformance/typescript/tests/cases/conformance --compact
	@echo ""


test-differential: build napi
	bun tests/differential/run.js

differential-baseline: build napi
	bun tests/differential/run.js --save-baseline

test-e2e: build
	bash tests/e2e/run.sh

test-all: test test-fuzz test-js test-e2e test-differential test-conformance

build:
	@mkdir -p zig-out/bin
	$(ZIG) build-exe src/main.zig -O ReleaseFast -femit-bin=zig-out/bin/ez $(LINK_FLAGS)

napi:
	zig build napi

# ezlint: standalone CLI binary built by `bun build --compile`.
# Bun is bundled into the binary itself — no runtime Bun/Node dependency at
# install time.  Inputs: src/bun/lint.js (entry) + src/bun/lint-worker.js
# (worker — listed as a second entry so Bun follows it into the bundle even
# though `new URL("./lint-worker.js", import.meta.url)` is the runtime spawn).
# `--packages=bundle` inlines node_modules deps; src/bun/recommended-rules.js
# uses static requires so the rule modules + transitive deps come along.
#
# `--bytecode` enables JSC's bytecode cache for the bundled scripts.  A/B
# tested on bench/fixtures/typescript.js (8.7MB):
#   without --bytecode:  1365ms wall (single file), 1652ms (4 files)
#   with --bytecode:      788ms wall (single file), 1207ms (4 files)
# Trade: binary grows from 79MB → 167MB (+88MB for the cache).  Worth it
# for a CLI tool — the perf wins are 35-40% across both modes and beat
# even `bun run` from source (~860ms single-file).
EZ_BUN_TARGET ?= bun-darwin-arm64

# Regenerate src/bun/recommended-rules.js from the ESLint core rules dir.
# Run after an ESLint upgrade that adds/removes rules.  Output is a
# committed file (machine-generated but in-tree so it builds without
# extra steps); ezlint depends on it being current.
ezlint-rules:
	bun tools/gen-bundled-rules.js

ezlint: napi
	@mkdir -p dist
	bun build --compile --bytecode --packages=bundle --target=$(EZ_BUN_TARGET) \
	  ./src/bun/lint.js ./src/bun/lint-worker.js \
	  --outfile=dist/ezlint
	@ls -lh dist/ezlint

submodules:
	git submodule update --init --depth 1

run: build
	./zig-out/bin/ez $(ARGS)
