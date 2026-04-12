ZIG ?= /Users/ericsan/.local/share/zigup/0.16.0-dev.3028+a85495ca2/files/zig
LINK_FLAGS :=

.PHONY: test test-unit test-linter test-recovery test-config test-fuzz test-js test-all build build-conformance test-conformance run napi submodules

test: test-unit test-linter test-recovery test-config

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
	@echo "ESLint Rule Conformance"
	@echo "────────────────────────────────────────────────────────────"
	@node tests/conformance/eslint_runner.js
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

submodules:
	git submodule update --init --depth 1

run: build
	./zig-out/bin/ez $(ARGS)
