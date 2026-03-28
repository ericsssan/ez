ZIG ?= /Users/ericsan/.local/share/zigup/0.16.0-dev.2637+6a9510c0e/files/zig
SYSROOT := /Library/Developer/CommandLineTools/SDKs/MacOSX15.4.sdk
LINK_FLAGS := --sysroot $(SYSROOT) -fno-lld

.PHONY: test test-unit test-linter test-recovery test-config test-fuzz test-js test-all build build-conformance test-conformance run napi submodules

test: test-unit test-linter test-recovery test-config

test-unit:
	$(ZIG) test src/root.zig $(LINK_FLAGS)

test-linter:
	$(ZIG) test --dep sx3lint -Mroot=tests/linter_test.zig -Msx3lint=src/root.zig $(LINK_FLAGS)

test-recovery:
	$(ZIG) test --dep sx3lint -Mroot=tests/error_recovery_test.zig -Msx3lint=src/root.zig $(LINK_FLAGS)

test-config:
	$(ZIG) test --dep sx3lint -Mroot=tests/config_integration_test.zig -Msx3lint=src/root.zig $(LINK_FLAGS)

test-fuzz:
	$(ZIG) test --dep sx3lint -Mroot=tests/fuzz_test.zig -Msx3lint=src/root.zig $(LINK_FLAGS) -ffuzz

test-js: napi
	node js/test/test.js
	node js/test/plugin-contract.js

build-conformance:
	@mkdir -p zig-out/bin
	@$(ZIG) build-exe --dep sx3lint -Mroot=tests/conformance/parser_tests_runner.zig -Msx3lint=src/root.zig -femit-bin=zig-out/bin/parser_tests_runner $(LINK_FLAGS)
	@$(ZIG) build-exe --dep sx3lint -Mroot=tests/conformance/test262_runner.zig -Msx3lint=src/root.zig -femit-bin=zig-out/bin/test262_runner $(LINK_FLAGS)

test-conformance: build-conformance
	@./zig-out/bin/test262_runner tests/conformance/test262/test/language
	@echo ""
	@./zig-out/bin/parser_tests_runner tests/conformance/test262-parser-tests

test-differential: build napi
	node tests/differential/run.js

test-e2e: build
	bash tests/e2e/run.sh

test-all: test test-fuzz test-js test-e2e test-differential test-conformance

build:
	@mkdir -p zig-out/bin
	$(ZIG) build-exe src/main.zig -femit-bin=zig-out/bin/sx3lint $(LINK_FLAGS)

napi:
	@mkdir -p zig-out/lib
	$(ZIG) build-lib src/napi.zig -dynamic -femit-bin=zig-out/lib/libsx3lint.dylib -fallow-shlib-undefined $(LINK_FLAGS)
	cp zig-out/lib/libsx3lint.dylib zig-out/lib/sx3lint.node

submodules:
	git submodule update --init --depth 1

run: build
	./zig-out/bin/sx3lint $(ARGS)
