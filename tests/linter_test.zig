const std = @import("std");
const testing = std.testing;
const sx3lint = @import("sx3lint");
const Lexer = sx3lint.Lexer;
const Parser = sx3lint.Parser;
const SemanticAnalyzer = sx3lint.semantic.SemanticAnalyzer;
const linter = sx3lint.linter;
const LintDiagnostic = sx3lint.lint_context.LintDiagnostic;

// ── Test helpers ────────────────────────────────────────────

fn lintSource(source: []const u8) ![]const LintDiagnostic {
    const allocator = testing.allocator;

    var tokens = try Lexer.tokenize(allocator, source);
    defer tokens.deinit(allocator);

    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);

    var sem = try SemanticAnalyzer.analyze(allocator, &tree);
    defer sem.deinit(allocator);

    return linter.lint(allocator, &tree, &sem);
}

fn expectRule(diagnostics: []const LintDiagnostic, rule_name: []const u8) !void {
    for (diagnostics) |d| {
        if (std.mem.eql(u8, d.rule_name, rule_name)) return;
    }
    std.debug.print("Expected rule '{s}' to fire, but it didn't. Got {d} diagnostic(s):\n", .{ rule_name, diagnostics.len });
    for (diagnostics) |d| {
        std.debug.print("  - {s}: {s}\n", .{ d.rule_name, d.message });
    }
    return error.TestExpectedEqual;
}

fn expectNoRule(diagnostics: []const LintDiagnostic, rule_name: []const u8) !void {
    for (diagnostics) |d| {
        if (std.mem.eql(u8, d.rule_name, rule_name)) {
            std.debug.print("Expected rule '{s}' NOT to fire, but it did: {s}\n", .{ rule_name, d.message });
            return error.TestExpectedEqual;
        }
    }
}

fn countRule(diagnostics: []const LintDiagnostic, rule_name: []const u8) usize {
    var n: usize = 0;
    for (diagnostics) |d| {
        if (std.mem.eql(u8, d.rule_name, rule_name)) n += 1;
    }
    return n;
}

// ── no-debugger ─────────────────────────────────────────────

test "no-debugger: flags debugger statement" {
    const diags = try lintSource("debugger;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-debugger");
}

test "no-debugger: clean code" {
    const diags = try lintSource("var x = 1;");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-debugger");
}

// ── no-empty ────────────────────────────────────────────────

test "no-empty: flags empty block" {
    const diags = try lintSource("if (true) {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-empty");
}

test "no-empty: non-empty block is fine" {
    const diags = try lintSource("if (true) { var x = 1; }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-empty");
}

// ── no-extra-semi ───────────────────────────────────────────

test "no-extra-semi: flags standalone semicolon" {
    const diags = try lintSource(";");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-extra-semi");
}

test "no-extra-semi: normal statement is fine" {
    const diags = try lintSource("var x = 1;");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-extra-semi");
}

// ── no-dupe-keys ────────────────────────────────────────────

test "no-dupe-keys: flags duplicate object keys" {
    const diags = try lintSource("var obj = { a: 1, b: 2, a: 3 };");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-dupe-keys");
}

test "no-dupe-keys: unique keys are fine" {
    const diags = try lintSource("var obj = { a: 1, b: 2, c: 3 };");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-dupe-keys");
}

// ── no-dupe-args ────────────────────────────────────────────

test "no-dupe-args: flags duplicate params" {
    const diags = try lintSource("function foo(a, b, a) {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-dupe-args");
}

test "no-dupe-args: unique params are fine" {
    const diags = try lintSource("function foo(a, b, c) {}");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-dupe-args");
}

// ── no-sparse-arrays ────────────────────────────────────────

test "no-sparse-arrays: flags array holes" {
    const diags = try lintSource("var arr = [1,,3];");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-sparse-arrays");
}

test "no-sparse-arrays: dense array is fine" {
    const diags = try lintSource("var arr = [1, 2, 3];");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-sparse-arrays");
}

// ── no-unreachable ──────────────────────────────────────────

test "no-unreachable: flags code after return" {
    const diags = try lintSource(
        \\function foo() {
        \\    return 1;
        \\    var x = 2;
        \\}
    );
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unreachable");
}

test "no-unreachable: code before return is fine" {
    const diags = try lintSource(
        \\function foo() {
        \\    var x = 2;
        \\    return x;
        \\}
    );
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-unreachable");
}

// ── no-unsafe-negation ──────────────────────────────────────

test "no-unsafe-negation: flags !a instanceof b" {
    const diags = try lintSource("var x = !a instanceof Array;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unsafe-negation");
}

test "no-unsafe-negation: normal instanceof is fine" {
    const diags = try lintSource("var x = a instanceof Array;");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-unsafe-negation");
}

// ── use-isnan ───────────────────────────────────────────────

test "use-isnan: flags comparison with NaN" {
    const diags = try lintSource("var x = 1; if (x === NaN) {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "use-isnan");
}

test "use-isnan: Number.isNaN is fine" {
    const diags = try lintSource("var x = 1; if (x === 0) {}");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "use-isnan");
}

// ── valid-typeof ────────────────────────────────────────────

test "valid-typeof: flags invalid typeof string" {
    const diags = try lintSource("if (typeof x === \"strig\") {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "valid-typeof");
}

test "valid-typeof: valid typeof string is fine" {
    const diags = try lintSource("if (typeof x === \"string\") {}");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "valid-typeof");
}

// ── no-unused-vars ──────────────────────────────────────────

test "no-unused-vars: flags unused variable" {
    const diags = try lintSource("let x = 1;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unused-vars");
}

test "no-unused-vars: used variable is fine" {
    const diags = try lintSource("let x = 1; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-unused-vars");
}

test "no-unused-vars: underscore prefix is fine" {
    const diags = try lintSource("let _unused = 1;");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-unused-vars");
}

// ── no-undef ────────────────────────────────────────────────

test "no-undef: flags undefined variable" {
    const diags = try lintSource("console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-undef");
}

test "no-undef: declared variable is fine" {
    const diags = try lintSource("let x = 1; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-undef");
}

test "no-undef: known globals are fine" {
    const diags = try lintSource("console.log(undefined);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-undef");
}

// ── no-constant-condition ───────────────────────────────────

test "no-constant-condition: flags if(true)" {
    const diags = try lintSource("if (true) { var x = 1; }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-constant-condition");
}

test "no-constant-condition: variable condition is fine" {
    const diags = try lintSource("var x = 1; if (x) { var y = 2; }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-constant-condition");
}

// ── no-func-assign ──────────────────────────────────────────

test "no-func-assign: flags function reassignment" {
    const diags = try lintSource("function foo() {} foo = 1;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-func-assign");
}

test "no-func-assign: calling function is fine" {
    const diags = try lintSource("function foo() {} foo();");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-func-assign");
}

// ── no-self-assign ──────────────────────────────────────────

test "no-self-assign: flags x = x" {
    const diags = try lintSource("var x = 1; x = x;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-self-assign");
}

test "no-self-assign: normal assignment is fine" {
    const diags = try lintSource("var x = 1; var y = 2; x = y;");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-self-assign");
}

// ── no-self-compare ─────────────────────────────────────────

test "no-self-compare: flags x === x" {
    const diags = try lintSource("var x = 1; if (x === x) {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-self-compare");
}

test "no-self-compare: different vars is fine" {
    const diags = try lintSource("var x = 1; var y = 2; if (x === y) {}");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-self-compare");
}

// ── no-const-assign ─────────────────────────────────────────

test "no-const-assign: flags const reassignment" {
    const diags = try lintSource("const x = 1; x = 2;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-const-assign");
}

test "no-const-assign: let reassignment is fine" {
    const diags = try lintSource("let x = 1; x = 2;");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-const-assign");
}

// ── no-loss-of-precision ────────────────────────────────────

test "no-loss-of-precision: flags unsafe integer" {
    const diags = try lintSource("var x = 9007199254740993;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-loss-of-precision");
}

test "no-loss-of-precision: safe integer is fine" {
    const diags = try lintSource("var x = 42;");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-loss-of-precision");
}

// ── Clean code ──────────────────────────────────────────────

test "clean code produces no diagnostics" {
    const diags = try lintSource(
        \\function greet(name) {
        \\    console.log(name);
        \\}
        \\greet("hello");
    );
    defer testing.allocator.free(diags);
    try testing.expectEqual(@as(usize, 0), diags.len);
}

// ── Fixture files ───────────────────────────────────────────

test "fixture: no_debugger" {
    const source = @embedFile("fixtures/lint/no_debugger.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-debugger");
}

test "fixture: no_empty" {
    const source = @embedFile("fixtures/lint/no_empty.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-empty");
    try testing.expect(countRule(diags, "no-empty") >= 2);
}

test "fixture: no_dupe_keys" {
    const source = @embedFile("fixtures/lint/no_dupe_keys.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-dupe-keys");
}

test "fixture: no_sparse_arrays" {
    const source = @embedFile("fixtures/lint/no_sparse_arrays.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-sparse-arrays");
}

test "fixture: no_unreachable" {
    const source = @embedFile("fixtures/lint/no_unreachable.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unreachable");
}

test "fixture: no_unused_vars" {
    const source = @embedFile("fixtures/lint/no_unused_vars.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unused-vars");
}

test "fixture: no_const_assign" {
    const source = @embedFile("fixtures/lint/no_const_assign.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-const-assign");
}

test "fixture: no_constant_condition" {
    const source = @embedFile("fixtures/lint/no_constant_condition.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-constant-condition");
}

test "fixture: no_loss_of_precision" {
    const source = @embedFile("fixtures/lint/no_loss_of_precision.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-loss-of-precision");
}

test "fixture: clean code" {
    const source = @embedFile("fixtures/lint/clean.js");
    const diags = try lintSource(source);
    defer testing.allocator.free(diags);
    try testing.expectEqual(@as(usize, 0), diags.len);
}

// ── Multiple rules on same source ───────────────────────────

test "multiple rules fire on combined source" {
    const diags = try lintSource(
        \\debugger;
        \\var x = 1;
        \\;
    );
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-debugger");
    try expectRule(diags, "no-extra-semi");
    try expectRule(diags, "no-unused-vars");
}

test "no-import-assign: flags import reassignment" {
    // Note: import declarations are only valid in modules, but the parser
    // accepts them anyway. The semantic analysis will still produce the
    // correct symbol bindings.
    const diags = try lintSource("import { foo } from 'bar'; foo = 1;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-import-assign");
}

// ── v0.4 Correctness Rules ──────────────────────────────────

// ── for-direction ───────────────────────────────────────────

test "for-direction: flags wrong update direction" {
    const diags = try lintSource("for (let i = 0; i < 10; i--) {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "for-direction");
}

test "for-direction: correct update direction is fine" {
    const diags = try lintSource("for (let i = 0; i < 10; i++) {}");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "for-direction");
}

// ── getter-return ───────────────────────────────────────────

test "getter-return: flags getter without return" {
    const diags = try lintSource("let obj = { get x() {} };");
    defer testing.allocator.free(diags);
    try expectRule(diags, "getter-return");
}

test "getter-return: getter with return is fine" {
    const diags = try lintSource("let obj = { get x() { return 1; } };");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "getter-return");
}

// ── no-async-promise-executor ───────────────────────────────

test "no-async-promise-executor: flags async executor" {
    const diags = try lintSource("let p = new Promise(async function(resolve) { resolve(1); });");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-async-promise-executor");
}

test "no-async-promise-executor: sync executor is fine" {
    const diags = try lintSource("let p = new Promise(function(resolve) { resolve(1); });");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-async-promise-executor");
}

// ── no-compare-neg-zero ─────────────────────────────────────

test "no-compare-neg-zero: flags comparison with -0" {
    const diags = try lintSource("let x = 1; if (x === -0) {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-compare-neg-zero");
}

test "no-compare-neg-zero: comparison with 0 is fine" {
    const diags = try lintSource("let x = 1; if (x === 0) {}");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-compare-neg-zero");
}

// ── no-dupe-class-members ───────────────────────────────────

test "no-dupe-class-members: flags duplicate methods" {
    const diags = try lintSource("class Foo { bar() {} bar() {} }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-dupe-class-members");
}

test "no-dupe-class-members: unique methods are fine" {
    const diags = try lintSource("class Foo { bar() {} baz() {} }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-dupe-class-members");
}

// ── no-duplicate-case ───────────────────────────────────────

test "no-duplicate-case: flags duplicate case values" {
    const diags = try lintSource("let x = 1; switch(x) { case 1: break; case 1: break; }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-duplicate-case");
}

test "no-duplicate-case: unique case values are fine" {
    const diags = try lintSource("let x = 1; switch(x) { case 1: break; case 2: break; }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-duplicate-case");
}

// ── no-empty-pattern ────────────────────────────────────────

test "no-empty-pattern: flags empty destructuring" {
    const diags = try lintSource("let {} = foo;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-empty-pattern");
}

test "no-empty-pattern: non-empty destructuring is fine" {
    const diags = try lintSource("let {a} = foo; console.log(a);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-empty-pattern");
}

// ── no-ex-assign ────────────────────────────────────────────

test "no-ex-assign: flags catch parameter reassignment" {
    const diags = try lintSource("try { foo(); } catch(e) { e = 1; }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-ex-assign");
}

test "no-ex-assign: using catch parameter is fine" {
    const diags = try lintSource("try { foo(); } catch(e) { console.log(e); }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-ex-assign");
}

// ── no-fallthrough ──────────────────────────────────────────

test "no-fallthrough: flags case without break" {
    const diags = try lintSource("let x = 1; switch(x) { case 1: foo(); case 2: bar(); break; }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-fallthrough");
}

test "no-fallthrough: case with break is fine" {
    const diags = try lintSource("let x = 1; switch(x) { case 1: foo(); break; case 2: bar(); break; }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-fallthrough");
}

// ── no-new-symbol ───────────────────────────────────────────

test "no-new-symbol: flags new Symbol()" {
    const diags = try lintSource("let s = new Symbol();");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-new-symbol");
}

test "no-new-symbol: Symbol() call is fine" {
    const diags = try lintSource("let s = Symbol('foo'); console.log(s);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-new-symbol");
}

// ── no-obj-calls ────────────────────────────────────────────

test "no-obj-calls: flags calling Math as function" {
    const diags = try lintSource("let x = Math(); console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-obj-calls");
}

test "no-obj-calls: Math.random() is fine" {
    const diags = try lintSource("let x = Math.random(); console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-obj-calls");
}

// ── no-prototype-builtins ───────────────────────────────────

test "no-prototype-builtins: flags direct hasOwnProperty call" {
    const diags = try lintSource("foo.hasOwnProperty('bar');");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-prototype-builtins");
}

test "no-prototype-builtins: Object.prototype.hasOwnProperty.call is fine" {
    const diags = try lintSource("Object.prototype.hasOwnProperty.call(foo, 'bar');");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-prototype-builtins");
}

// ── no-setter-return ────────────────────────────────────────

test "no-setter-return: flags return in setter" {
    const diags = try lintSource("let obj = { set x(val) { return val; } };");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-setter-return");
}

test "no-setter-return: setter without return is fine" {
    const diags = try lintSource("let obj = { set x(val) { this._x = val; } };");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-setter-return");
}

// ── no-template-curly-in-string ─────────────────────────────

test "no-template-curly-in-string: flags template syntax in regular string" {
    const diags = try lintSource(
        \\let name = "world";
        \\let x = "Hello ${name}";
        \\console.log(x);
    );
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-template-curly-in-string");
}

test "no-template-curly-in-string: plain string is fine" {
    const diags = try lintSource("let x = \"hello\"; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-template-curly-in-string");
}

// ── no-useless-catch ────────────────────────────────────────

test "no-useless-catch: flags catch that only rethrows" {
    const diags = try lintSource("try { foo(); } catch(e) { throw e; }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-useless-catch");
}

test "no-useless-catch: catch that wraps error is fine" {
    const diags = try lintSource("try { foo(); } catch(e) { throw new Error(e); }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-useless-catch");
}

// ── v0.4 Suspicious Rules ───────────────────────────────────

// ── eqeqeq ─────────────────────────────────────────────────

test "eqeqeq: flags loose equality" {
    const diags = try lintSource("let x = 1; if (x == 1) {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "eqeqeq");
}

test "eqeqeq: strict equality is fine" {
    const diags = try lintSource("let x = 1; if (x === 1) {}");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "eqeqeq");
}

// ── no-cond-assign ──────────────────────────────────────────

test "no-cond-assign: flags assignment in condition" {
    const diags = try lintSource("let x = 0; if (x = 1) { console.log(x); }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-cond-assign");
}

test "no-cond-assign: comparison in condition is fine" {
    const diags = try lintSource("let x = 1; if (x === 1) { console.log(x); }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-cond-assign");
}

// ── no-delete-var ───────────────────────────────────────────

test "no-delete-var: flags deleting a variable" {
    const diags = try lintSource("let x = 1; delete x;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-delete-var");
}

test "no-delete-var: deleting object property is fine" {
    const diags = try lintSource("let obj = {}; delete obj.x; console.log(obj);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-delete-var");
}

// ── no-eval ─────────────────────────────────────────────────

test "no-eval: flags eval call" {
    const diags = try lintSource("eval('code');");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-eval");
}

test "no-eval: non-eval function call is fine" {
    const diags = try lintSource("foo('code');");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-eval");
}

// ── no-implied-eval ─────────────────────────────────────────

test "no-implied-eval: flags setTimeout with string" {
    const diags = try lintSource("setTimeout(\"alert('hi')\", 100);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-implied-eval");
}

test "no-implied-eval: setTimeout with function is fine" {
    const diags = try lintSource("setTimeout(function() { foo(); }, 100);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-implied-eval");
}

// ── no-new-wrappers ─────────────────────────────────────────

test "no-new-wrappers: flags new String()" {
    const diags = try lintSource("let s = new String('hello'); console.log(s);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-new-wrappers");
}

test "no-new-wrappers: String() without new is fine" {
    const diags = try lintSource("let s = String('hello'); console.log(s);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-new-wrappers");
}

// ── no-redeclare ────────────────────────────────────────────

test "no-redeclare: flags duplicate let declaration" {
    const diags = try lintSource("let x = 1; let x = 2; console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-redeclare");
}

test "no-redeclare: different names are fine" {
    const diags = try lintSource("let x = 1; let y = 2; console.log(x, y);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-redeclare");
}

// ── no-shadow-restricted-names ──────────────────────────────

test "no-shadow-restricted-names: flags shadowing undefined" {
    const diags = try lintSource("let undefined = 1; console.log(undefined);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-shadow-restricted-names");
}

test "no-shadow-restricted-names: normal variable name is fine" {
    const diags = try lintSource("let x = 1; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-shadow-restricted-names");
}

// ── no-unsafe-finally ───────────────────────────────────────

test "no-unsafe-finally: flags return in finally" {
    const diags = try lintSource("try { foo(); } finally { return; }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unsafe-finally");
}

test "no-unsafe-finally: normal finally is fine" {
    const diags = try lintSource("try { foo(); } finally { bar(); }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-unsafe-finally");
}

// ── no-void ─────────────────────────────────────────────────

test "no-void: flags void operator" {
    const diags = try lintSource("void 0;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-void");
}

test "no-void: normal expression is fine" {
    const diags = try lintSource("let x = 0; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-void");
}

// ── no-with ─────────────────────────────────────────────────

test "no-with: flags with statement" {
    const diags = try lintSource("with (obj) { foo(); }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-with");
}

test "no-with: property access is fine" {
    const diags = try lintSource("let x = obj.foo; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-with");
}

// ── require-yield ───────────────────────────────────────────

test "require-yield: flags generator without yield" {
    const diags = try lintSource("function* gen() {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "require-yield");
}

test "require-yield: generator with yield is fine" {
    const diags = try lintSource("function* gen() { yield 1; }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "require-yield");
}

// ── no-case-declarations ────────────────────────────────────

test "no-case-declarations: flags declaration in case without block" {
    const diags = try lintSource("let x = 1; switch(x) { case 1: let y = 1; console.log(y); break; }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-case-declarations");
}

test "no-case-declarations: declaration in block within case is fine" {
    const diags = try lintSource("let x = 1; switch(x) { case 1: { let y = 1; console.log(y); } break; }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-case-declarations");
}

// ── no-sequences ────────────────────────────────────────────

test "no-sequences: flags comma operator" {
    const diags = try lintSource("let x = (1, 2); console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-sequences");
}

test "no-sequences: normal expression is fine" {
    const diags = try lintSource("let x = 1; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-sequences");
}

// ── no-throw-literal ────────────────────────────────────────

test "no-throw-literal: flags throwing a string literal" {
    const diags = try lintSource("throw 'error';");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-throw-literal");
}

test "no-throw-literal: throwing Error object is fine" {
    const diags = try lintSource("throw new Error('error');");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-throw-literal");
}

// ── v0.4 Style Rules ────────────────────────────────────────

// ── no-var ──────────────────────────────────────────────────

test "no-var: flags var declaration" {
    const diags = try lintSource("var x = 1;");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-var");
}

test "no-var: let declaration is fine" {
    const diags = try lintSource("let x = 1; x = 2;");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-var");
}

// ── prefer-const ────────────────────────────────────────────

test "prefer-const: flags let that is never reassigned" {
    const diags = try lintSource("let x = 1; console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "prefer-const");
}

test "prefer-const: let that is reassigned is fine" {
    const diags = try lintSource("let x = 1; x = 2; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "prefer-const");
}

// ── no-array-constructor ────────────────────────────────────

test "no-array-constructor: flags new Array()" {
    const diags = try lintSource("let arr = new Array(1, 2, 3); console.log(arr);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-array-constructor");
}

test "no-array-constructor: array literal is fine" {
    const diags = try lintSource("let arr = [1, 2, 3]; console.log(arr);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-array-constructor");
}

// ── no-bitwise ──────────────────────────────────────────────

test "no-bitwise: flags bitwise OR operator" {
    const diags = try lintSource("let a = 1; let b = 2; let x = a | b; console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-bitwise");
}

test "no-bitwise: logical OR is fine" {
    const diags = try lintSource("let a = 1; let b = 2; let x = a || b; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-bitwise");
}

// ── no-continue ─────────────────────────────────────────────

test "no-continue: flags continue statement" {
    const diags = try lintSource("for (let i = 0; i < 10; i++) { continue; }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-continue");
}

test "no-continue: loop without continue is fine" {
    const diags = try lintSource("for (let i = 0; i < 10; i++) { console.log(i); }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-continue");
}

// ── no-else-return ──────────────────────────────────────────

test "no-else-return: flags else after return" {
    const diags = try lintSource(
        \\function f(x) {
        \\    if (x) {
        \\        return 1;
        \\    } else {
        \\        return 2;
        \\    }
        \\}
        \\f(true);
    );
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-else-return");
}

test "no-else-return: return without else is fine" {
    const diags = try lintSource(
        \\function f(x) {
        \\    if (x) {
        \\        return 1;
        \\    }
        \\    return 2;
        \\}
        \\f(true);
    );
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-else-return");
}

// ── no-eq-null ──────────────────────────────────────────────

test "no-eq-null: flags loose null comparison" {
    const diags = try lintSource("let x = 1; if (x == null) {}");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-eq-null");
}

test "no-eq-null: strict null comparison is fine" {
    const diags = try lintSource("let x = 1; if (x === null) {}");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-eq-null");
}

// ── no-extra-boolean-cast ───────────────────────────────────

test "no-extra-boolean-cast: flags double negation in boolean context" {
    const diags = try lintSource("let x = 1; if (!!x) { console.log(x); }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-extra-boolean-cast");
}

test "no-extra-boolean-cast: simple condition is fine" {
    const diags = try lintSource("let x = 1; if (x) { console.log(x); }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-extra-boolean-cast");
}

// ── no-floating-decimal ─────────────────────────────────────

test "no-floating-decimal: flags floating decimal" {
    const diags = try lintSource("let x = .5; console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-floating-decimal");
}

test "no-floating-decimal: full decimal is fine" {
    const diags = try lintSource("let x = 0.5; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-floating-decimal");
}

// ── no-labels ───────────────────────────────────────────────

test "no-labels: flags labeled statement" {
    const diags = try lintSource("label: for (let i = 0; i < 10; i++) { console.log(i); }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-labels");
}

test "no-labels: unlabeled loop is fine" {
    const diags = try lintSource("for (let i = 0; i < 10; i++) { console.log(i); }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-labels");
}

// ── no-multi-assign ─────────────────────────────────────────

test "no-multi-assign: flags chained assignment" {
    const diags = try lintSource("let a = 1; let b = 1; a = b = 2; console.log(a, b);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-multi-assign");
}

test "no-multi-assign: single assignment is fine" {
    const diags = try lintSource("let a = 1; console.log(a);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-multi-assign");
}

// ── no-negated-condition ────────────────────────────────────

test "no-negated-condition: flags negated if with else" {
    const diags = try lintSource("let x = 1; if (!x) { a(); } else { b(); }");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-negated-condition");
}

test "no-negated-condition: non-negated condition is fine" {
    const diags = try lintSource("let x = 1; if (x) { a(); }");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-negated-condition");
}

// ── no-nested-ternary ───────────────────────────────────────

test "no-nested-ternary: flags nested ternary" {
    const diags = try lintSource("let a = true; a = !a; let x = a ? a ? 1 : 2 : 3; console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-nested-ternary");
}

test "no-nested-ternary: simple ternary is fine" {
    const diags = try lintSource("let a = true; let x = a ? 1 : 2; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-nested-ternary");
}

// ── no-new ──────────────────────────────────────────────────

test "no-new: flags new for side effects" {
    const diags = try lintSource("new Foo();");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-new");
}

test "no-new: new with assignment is fine" {
    const diags = try lintSource("let x = new Foo(); console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-new");
}

// ── no-new-func ─────────────────────────────────────────────

test "no-new-func: flags new Function()" {
    const diags = try lintSource("let fn = new Function('a', 'return a'); console.log(fn);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-new-func");
}

test "no-new-func: function expression is fine" {
    const diags = try lintSource("let fn = function(a) { return a; }; console.log(fn);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-new-func");
}

// ── no-new-object ───────────────────────────────────────────

test "no-new-object: flags new Object()" {
    const diags = try lintSource("let obj = new Object(); console.log(obj);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-new-object");
}

test "no-new-object: object literal is fine" {
    const diags = try lintSource("let obj = {}; console.log(obj);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-new-object");
}

// ── no-param-reassign ───────────────────────────────────────

test "no-param-reassign: flags parameter reassignment" {
    const diags = try lintSource("function f(x) { x = 1; console.log(x); } f(0);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-param-reassign");
}

test "no-param-reassign: using parameter without reassignment is fine" {
    const diags = try lintSource("function f(x) { let y = x; console.log(y); } f(0);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-param-reassign");
}

// ── no-plusplus ──────────────────────────────────────────────

test "no-plusplus: flags increment operator" {
    const diags = try lintSource("let x = 0; x++; console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-plusplus");
}

test "no-plusplus: compound assignment is fine" {
    const diags = try lintSource("let x = 0; x += 1; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-plusplus");
}

// ── no-return-assign ────────────────────────────────────────

test "no-return-assign: flags assignment in return" {
    const diags = try lintSource("let x = 0; function f() { return x = 1; } f();");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-return-assign");
}

test "no-return-assign: returning value is fine" {
    const diags = try lintSource("function f() { return 1; } f();");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-return-assign");
}

// ── no-unneeded-ternary ─────────────────────────────────────

test "no-unneeded-ternary: flags ternary returning true/false" {
    const diags = try lintSource("let a = 1; let x = a ? true : false; console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unneeded-ternary");
}

test "no-unneeded-ternary: ternary with different values is fine" {
    const diags = try lintSource("let a = 1; let x = a ? b : c; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "no-unneeded-ternary");
}

// ── prefer-template ─────────────────────────────────────────

test "prefer-template: flags string concatenation" {
    const diags = try lintSource("let name = 'world'; let x = 'hello' + name; console.log(x);");
    defer testing.allocator.free(diags);
    try expectRule(diags, "prefer-template");
}

test "prefer-template: no concatenation is fine" {
    const diags = try lintSource("let x = 'hello'; console.log(x);");
    defer testing.allocator.free(diags);
    try expectNoRule(diags, "prefer-template");
}
