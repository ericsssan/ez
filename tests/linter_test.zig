const std = @import("std");
const testing = std.testing;
const sx3lint = @import("sx3lint");
const Lexer = sx3lint.Lexer;
const Parser = sx3lint.Parser;
const SemanticAnalyzer = sx3lint.semantic.SemanticAnalyzer;
const linter = sx3lint.linter;
const LintDiagnostic = sx3lint.lint_context.LintDiagnostic;
const RuleTester = @import("rule_tester.zig").RuleTester;

// ── Helpers (kept for fixture/multi-rule tests) ──────────────

fn lintSource(source: []const u8) ![]const LintDiagnostic {
    const allocator = testing.allocator;
    var tokens = try Lexer.tokenize(allocator, source);
    defer tokens.deinit(allocator);
    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);
    var sem = try SemanticAnalyzer.analyze(allocator, &tree);
    defer sem.deinit(allocator);
    return linter.lint(allocator, &tree, &sem, null);
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

fn countRule(diagnostics: []const LintDiagnostic, rule_name: []const u8) usize {
    var n: usize = 0;
    for (diagnostics) |d| {
        if (std.mem.eql(u8, d.rule_name, rule_name)) n += 1;
    }
    return n;
}

// ══════════════════════════════════════════════════════════════
// Correctness Rules (40)
// ══════════════════════════════════════════════════════════════

test "no-debugger" {
    try RuleTester.run(.{
        .rule = "no-debugger",
        .valid = &.{ "var x = 1;", "console.log('hello');" },
        .invalid = &.{.{ .code = "debugger;" }},
    });
}

test "no-empty" {
    try RuleTester.run(.{
        .rule = "no-empty",
        .valid = &.{"if (true) { var x = 1; }"},
        .invalid = &.{.{ .code = "if (true) {}" }},
    });
}

test "no-extra-semi" {
    try RuleTester.run(.{
        .rule = "no-extra-semi",
        .valid = &.{"var x = 1;"},
        .invalid = &.{.{ .code = ";" }},
    });
}

test "no-dupe-keys" {
    try RuleTester.run(.{
        .rule = "no-dupe-keys",
        .valid = &.{"var obj = { a: 1, b: 2, c: 3 };"},
        .invalid = &.{.{ .code = "var obj = { a: 1, b: 2, a: 3 };" }},
    });
}

test "no-dupe-args" {
    try RuleTester.run(.{
        .rule = "no-dupe-args",
        .valid = &.{"function foo(a, b, c) {}"},
        .invalid = &.{.{ .code = "function foo(a, b, a) {}" }},
    });
}

test "no-sparse-arrays" {
    try RuleTester.run(.{
        .rule = "no-sparse-arrays",
        .valid = &.{"var arr = [1, 2, 3];"},
        .invalid = &.{.{ .code = "var arr = [1,,3];" }},
    });
}

test "no-unreachable" {
    try RuleTester.run(.{
        .rule = "no-unreachable",
        .valid = &.{
            \\function foo() {
            \\    var x = 2;
            \\    return x;
            \\}
        },
        .invalid = &.{.{
            .code =
            \\function foo() {
            \\    return 1;
            \\    var x = 2;
            \\}
            ,
        }},
    });
}

test "no-unsafe-negation" {
    try RuleTester.run(.{
        .rule = "no-unsafe-negation",
        .valid = &.{"var x = a instanceof Array;"},
        .invalid = &.{.{ .code = "var x = !a instanceof Array;" }},
    });
}

test "use-isnan" {
    try RuleTester.run(.{
        .rule = "use-isnan",
        .valid = &.{"var x = 1; if (x === 0) {}"},
        .invalid = &.{.{ .code = "var x = 1; if (x === NaN) {}" }},
    });
}

test "valid-typeof" {
    try RuleTester.run(.{
        .rule = "valid-typeof",
        .valid = &.{"if (typeof x === \"string\") {}"},
        .invalid = &.{.{ .code = "if (typeof x === \"strig\") {}" }},
    });
}

test "no-unused-vars" {
    try RuleTester.run(.{
        .rule = "no-unused-vars",
        .valid = &.{
            "let x = 1; console.log(x);",
            "let _unused = 1;",
        },
        .invalid = &.{.{ .code = "let x = 1;" }},
    });
}

test "no-undef" {
    try RuleTester.run(.{
        .rule = "no-undef",
        .valid = &.{
            "let x = 1; console.log(x);",
            "console.log(undefined);",
        },
        .invalid = &.{.{ .code = "console.log(x);" }},
    });
}

test "no-constant-condition" {
    try RuleTester.run(.{
        .rule = "no-constant-condition",
        .valid = &.{"var x = 1; if (x) { var y = 2; }"},
        .invalid = &.{.{ .code = "if (true) { var x = 1; }" }},
    });
}

test "no-func-assign" {
    try RuleTester.run(.{
        .rule = "no-func-assign",
        .valid = &.{"function foo() {} foo();"},
        .invalid = &.{.{ .code = "function foo() {} foo = 1;" }},
    });
}

test "no-import-assign" {
    try RuleTester.run(.{
        .rule = "no-import-assign",
        .invalid = &.{.{ .code = "import { foo } from 'bar'; foo = 1;" }},
    });
}

test "no-self-assign" {
    try RuleTester.run(.{
        .rule = "no-self-assign",
        .valid = &.{"var x = 1; var y = 2; x = y;"},
        .invalid = &.{.{ .code = "var x = 1; x = x;" }},
    });
}

test "no-self-compare" {
    try RuleTester.run(.{
        .rule = "no-self-compare",
        .valid = &.{"var x = 1; var y = 2; if (x === y) {}"},
        .invalid = &.{.{ .code = "var x = 1; if (x === x) {}" }},
    });
}

test "no-const-assign" {
    try RuleTester.run(.{
        .rule = "no-const-assign",
        .valid = &.{"let x = 1; x = 2;"},
        .invalid = &.{.{ .code = "const x = 1; x = 2;" }},
    });
}

test "no-loss-of-precision" {
    try RuleTester.run(.{
        .rule = "no-loss-of-precision",
        .valid = &.{"var x = 42;"},
        .invalid = &.{.{ .code = "var x = 9007199254740993;" }},
    });
}

test "for-direction" {
    try RuleTester.run(.{
        .rule = "for-direction",
        .valid = &.{"for (let i = 0; i < 10; i++) {}"},
        .invalid = &.{.{ .code = "for (let i = 0; i < 10; i--) {}" }},
    });
}

test "getter-return" {
    try RuleTester.run(.{
        .rule = "getter-return",
        .valid = &.{"let obj = { get x() { return 1; } };"},
        .invalid = &.{.{ .code = "let obj = { get x() {} };" }},
    });
}

test "no-async-promise-executor" {
    try RuleTester.run(.{
        .rule = "no-async-promise-executor",
        .valid = &.{"let p = new Promise(function(resolve) { resolve(1); });"},
        .invalid = &.{.{ .code = "let p = new Promise(async function(resolve) { resolve(1); });" }},
    });
}

test "no-compare-neg-zero" {
    try RuleTester.run(.{
        .rule = "no-compare-neg-zero",
        .valid = &.{"let x = 1; if (x === 0) {}"},
        .invalid = &.{.{ .code = "let x = 1; if (x === -0) {}" }},
    });
}

test "no-dupe-class-members" {
    try RuleTester.run(.{
        .rule = "no-dupe-class-members",
        .valid = &.{"class Foo { bar() {} baz() {} }"},
        .invalid = &.{.{ .code = "class Foo { bar() {} bar() {} }" }},
    });
}

test "no-dupe-else-if" {
    try RuleTester.run(.{
        .rule = "no-dupe-else-if",
        .valid = &.{"let x = 1; let y = 2; if (x) {} else if (y) {}"},
        .invalid = &.{.{ .code = "let x = 1; if (x === 1) {} else if (x === 1) {}" }},
    });
}

test "no-duplicate-case" {
    try RuleTester.run(.{
        .rule = "no-duplicate-case",
        .valid = &.{"let x = 1; switch(x) { case 1: break; case 2: break; }"},
        .invalid = &.{.{ .code = "let x = 1; switch(x) { case 1: break; case 1: break; }" }},
    });
}

test "no-empty-pattern" {
    try RuleTester.run(.{
        .rule = "no-empty-pattern",
        .valid = &.{"let {a} = foo; console.log(a);"},
        .invalid = &.{.{ .code = "let {} = foo;" }},
    });
}

test "no-ex-assign" {
    try RuleTester.run(.{
        .rule = "no-ex-assign",
        .valid = &.{"try { foo(); } catch(e) { console.log(e); }"},
        .invalid = &.{.{ .code = "try { foo(); } catch(e) { e = 1; }" }},
    });
}

test "no-fallthrough" {
    try RuleTester.run(.{
        .rule = "no-fallthrough",
        .valid = &.{"let x = 1; switch(x) { case 1: foo(); break; case 2: bar(); break; }"},
        .invalid = &.{.{ .code = "let x = 1; switch(x) { case 1: foo(); case 2: bar(); break; }" }},
    });
}

test "no-global-assign" {
    try RuleTester.run(.{
        .rule = "no-global-assign",
        .valid = &.{"let x = 1; x = 2;"},
        .invalid = &.{
            .{ .code = "Object = null;" },
            .{ .code = "undefined = 1;" },
        },
    });
}

test "no-inner-declarations" {
    try RuleTester.run(.{
        .rule = "no-inner-declarations",
        .valid = &.{"function foo() {} foo();"},
        .invalid = &.{.{ .code = "if (true) { function foo() {} foo(); }" }},
    });
}

test "no-new-symbol" {
    try RuleTester.run(.{
        .rule = "no-new-symbol",
        .valid = &.{"let s = Symbol('foo'); console.log(s);"},
        .invalid = &.{.{ .code = "let s = new Symbol();" }},
    });
}

test "no-obj-calls" {
    try RuleTester.run(.{
        .rule = "no-obj-calls",
        .valid = &.{"let x = Math.random(); console.log(x);"},
        .invalid = &.{.{ .code = "let x = Math(); console.log(x);" }},
    });
}

test "no-prototype-builtins" {
    try RuleTester.run(.{
        .rule = "no-prototype-builtins",
        .valid = &.{"Object.prototype.hasOwnProperty.call(foo, 'bar');"},
        .invalid = &.{.{ .code = "foo.hasOwnProperty('bar');" }},
    });
}

test "no-setter-return" {
    try RuleTester.run(.{
        .rule = "no-setter-return",
        .valid = &.{"let obj = { set x(val) { this._x = val; } };"},
        .invalid = &.{.{ .code = "let obj = { set x(val) { return val; } };" }},
    });
}

test "no-template-curly-in-string" {
    try RuleTester.run(.{
        .rule = "no-template-curly-in-string",
        .valid = &.{"let x = \"hello\"; console.log(x);"},
        .invalid = &.{.{
            .code =
            \\let name = "world";
            \\let x = "Hello ${name}";
            \\console.log(x);
            ,
        }},
    });
}

test "no-this-before-super" {
    try RuleTester.run(.{
        .rule = "no-this-before-super",
        .invalid = &.{.{ .code = "class B {} class A extends B { constructor() { this.x = 1; super(); } }" }},
    });
}

test "no-useless-catch" {
    try RuleTester.run(.{
        .rule = "no-useless-catch",
        .valid = &.{"try { foo(); } catch(e) { throw new Error(e); }"},
        .invalid = &.{.{ .code = "try { foo(); } catch(e) { throw e; }" }},
    });
}

test "no-unsafe-optional-chaining" {
    try RuleTester.run(.{
        .rule = "no-unsafe-optional-chaining",
        .invalid = &.{.{ .code = "let x = (obj?.foo)();" }},
    });
}

// ══════════════════════════════════════════════════════════════
// Suspicious Rules (28)
// ══════════════════════════════════════════════════════════════

test "eqeqeq" {
    try RuleTester.run(.{
        .rule = "eqeqeq",
        .valid = &.{"let x = 1; if (x === 1) {}"},
        .invalid = &.{.{ .code = "let x = 1; if (x == 1) {}" }},
    });
}

test "no-cond-assign" {
    try RuleTester.run(.{
        .rule = "no-cond-assign",
        .valid = &.{"let x = 1; if (x === 1) { console.log(x); }"},
        .invalid = &.{.{ .code = "let x = 0; if (x = 1) { console.log(x); }" }},
    });
}

test "no-delete-var" {
    try RuleTester.run(.{
        .rule = "no-delete-var",
        .valid = &.{"let obj = {}; delete obj.x; console.log(obj);"},
        .invalid = &.{.{ .code = "let x = 1; delete x;" }},
    });
}

test "no-eval" {
    try RuleTester.run(.{
        .rule = "no-eval",
        .valid = &.{"foo('code');"},
        .invalid = &.{.{ .code = "eval('code');" }},
    });
}

test "no-implied-eval" {
    try RuleTester.run(.{
        .rule = "no-implied-eval",
        .valid = &.{"setTimeout(function() { foo(); }, 100);"},
        .invalid = &.{.{ .code = "setTimeout(\"alert('hi')\", 100);" }},
    });
}

test "no-new-wrappers" {
    try RuleTester.run(.{
        .rule = "no-new-wrappers",
        .valid = &.{"let s = String('hello'); console.log(s);"},
        .invalid = &.{.{ .code = "let s = new String('hello'); console.log(s);" }},
    });
}

test "no-redeclare" {
    try RuleTester.run(.{
        .rule = "no-redeclare",
        .valid = &.{"let x = 1; let y = 2; console.log(x, y);"},
        .invalid = &.{.{ .code = "let x = 1; let x = 2; console.log(x);" }},
    });
}

test "no-shadow-restricted-names" {
    try RuleTester.run(.{
        .rule = "no-shadow-restricted-names",
        .valid = &.{"let x = 1; console.log(x);"},
        .invalid = &.{.{ .code = "let undefined = 1; console.log(undefined);" }},
    });
}

test "no-unsafe-finally" {
    try RuleTester.run(.{
        .rule = "no-unsafe-finally",
        .valid = &.{"try { foo(); } finally { bar(); }"},
        .invalid = &.{.{ .code = "try { foo(); } finally { return; }" }},
    });
}

test "no-unused-labels" {
    try RuleTester.run(.{
        .rule = "no-unused-labels",
        .invalid = &.{.{ .code = "label: var x = 1;" }},
    });
}

test "no-void" {
    try RuleTester.run(.{
        .rule = "no-void",
        .valid = &.{"let x = 0; console.log(x);"},
        .invalid = &.{.{ .code = "void 0;" }},
    });
}

test "no-with" {
    try RuleTester.run(.{
        .rule = "no-with",
        .valid = &.{"let x = obj.foo; console.log(x);"},
        .invalid = &.{.{ .code = "with (obj) { foo(); }" }},
    });
}

test "require-yield" {
    try RuleTester.run(.{
        .rule = "require-yield",
        .valid = &.{"function* gen() { yield 1; }"},
        .invalid = &.{.{ .code = "function* gen() {}" }},
    });
}

test "no-case-declarations" {
    try RuleTester.run(.{
        .rule = "no-case-declarations",
        .valid = &.{"let x = 1; switch(x) { case 1: { let y = 1; console.log(y); } break; }"},
        .invalid = &.{.{ .code = "let x = 1; switch(x) { case 1: let y = 1; console.log(y); break; }" }},
    });
}

test "no-sequences" {
    try RuleTester.run(.{
        .rule = "no-sequences",
        .valid = &.{
            "let x = 1; console.log(x);",
            "let x = (1, 2); console.log(x);", // parenthesized is allowed (ESLint compat)
        },
        .invalid = &.{.{ .code = "var x = 1; x = 1, 2;" }},
    });
}

test "no-throw-literal" {
    try RuleTester.run(.{
        .rule = "no-throw-literal",
        .valid = &.{"throw new Error('error');"},
        .invalid = &.{.{ .code = "throw 'error';" }},
    });
}

// ══════════════════════════════════════════════════════════════
// Style Rules (30)
// ══════════════════════════════════════════════════════════════

test "no-var" {
    try RuleTester.run(.{
        .rule = "no-var",
        .valid = &.{"let x = 1; x = 2;"},
        .invalid = &.{.{ .code = "var x = 1;" }},
    });
}

test "prefer-const" {
    try RuleTester.run(.{
        .rule = "prefer-const",
        .valid = &.{"let x = 1; x = 2;"},
        .invalid = &.{.{ .code = "let x = 1; console.log(x);" }},
    });
}

test "no-array-constructor" {
    try RuleTester.run(.{
        .rule = "no-array-constructor",
        .valid = &.{"let arr = []; console.log(arr);"},
        .invalid = &.{.{ .code = "let arr = new Array(); console.log(arr);" }},
    });
}

test "no-bitwise" {
    try RuleTester.run(.{
        .rule = "no-bitwise",
        .valid = &.{"let x = 1 || 2; console.log(x);"},
        .invalid = &.{.{ .code = "let x = 1 | 2; console.log(x);" }},
    });
}

test "no-continue" {
    try RuleTester.run(.{
        .rule = "no-continue",
        .valid = &.{"for (let i = 0; i < 10; i++) { foo(); }"},
        .invalid = &.{.{ .code = "for (let i = 0; i < 10; i++) { continue; }" }},
    });
}

test "no-else-return" {
    try RuleTester.run(.{
        .rule = "no-else-return",
        .valid = &.{
            \\function foo(x) {
            \\    if (x) {
            \\        return 1;
            \\    }
            \\    return 2;
            \\}
            \\foo(true);
        },
        .invalid = &.{.{
            .code =
            \\function foo(x) {
            \\    if (x) {
            \\        return 1;
            \\    } else {
            \\        return 2;
            \\    }
            \\}
            \\foo(true);
            ,
        }},
    });
}

test "no-eq-null" {
    try RuleTester.run(.{
        .rule = "no-eq-null",
        .valid = &.{"let x = 1; if (x === null) {}"},
        .invalid = &.{.{ .code = "let x = 1; if (x == null) {}" }},
    });
}

test "no-extra-boolean-cast" {
    try RuleTester.run(.{
        .rule = "no-extra-boolean-cast",
        .valid = &.{"let x = 1; if (x) {}"},
        .invalid = &.{.{ .code = "let x = 1; if (!!x) {}" }},
    });
}

test "no-floating-decimal" {
    try RuleTester.run(.{
        .rule = "no-floating-decimal",
        .valid = &.{"let x = 0.5;"},
        .invalid = &.{.{ .code = "let x = .5;" }},
    });
}

test "no-labels" {
    try RuleTester.run(.{
        .rule = "no-labels",
        .valid = &.{"for (let i = 0; i < 10; i++) {}"},
        .invalid = &.{.{ .code = "label: for (let i = 0; i < 10; i++) {}" }},
    });
}

test "no-multi-assign" {
    try RuleTester.run(.{
        .rule = "no-multi-assign",
        .valid = &.{"let a = 1; let b = 2; console.log(a, b);"},
        .invalid = &.{.{ .code = "var a = 1; var b = 1; a = b = 2; console.log(a, b);" }},
    });
}

test "no-negated-condition" {
    try RuleTester.run(.{
        .rule = "no-negated-condition",
        .valid = &.{"let x = true; if (x) { foo(); } else { bar(); }"},
        .invalid = &.{.{ .code = "let x = true; if (!x) { foo(); } else { bar(); }" }},
    });
}

test "no-nested-ternary" {
    try RuleTester.run(.{
        .rule = "no-nested-ternary",
        .valid = &.{"let a = true; let x = a ? 1 : 2; console.log(x);"},
        .invalid = &.{.{ .code = "let a = true; let b = true; let x = a ? b ? 1 : 2 : 3; console.log(x);" }},
    });
}

test "no-new" {
    try RuleTester.run(.{
        .rule = "no-new",
        .valid = &.{"let x = new Foo(); console.log(x);"},
        .invalid = &.{.{ .code = "new Foo();" }},
    });
}

test "no-new-func" {
    try RuleTester.run(.{
        .rule = "no-new-func",
        .valid = &.{"let f = function() {}; f();"},
        .invalid = &.{.{ .code = "let f = new Function('a', 'return a'); console.log(f);" }},
    });
}

test "no-new-object" {
    try RuleTester.run(.{
        .rule = "no-new-object",
        .valid = &.{"let obj = {}; console.log(obj);"},
        .invalid = &.{.{ .code = "let obj = new Object(); console.log(obj);" }},
    });
}

test "no-param-reassign" {
    try RuleTester.run(.{
        .rule = "no-param-reassign",
        .valid = &.{"function foo(x) { console.log(x); } foo(1);"},
        .invalid = &.{.{ .code = "function foo(x) { x = 1; } foo(1);" }},
    });
}

test "no-plusplus" {
    try RuleTester.run(.{
        .rule = "no-plusplus",
        .valid = &.{"let x = 1; x += 1; console.log(x);"},
        .invalid = &.{.{ .code = "let x = 1; x++; console.log(x);" }},
    });
}

test "no-return-assign" {
    try RuleTester.run(.{
        .rule = "no-return-assign",
        .valid = &.{"function f() { return 1; } f();"},
        .invalid = &.{.{ .code = "let x = 0; function f() { return x = 1; } f();" }},
    });
}

test "no-unneeded-ternary" {
    try RuleTester.run(.{
        .rule = "no-unneeded-ternary",
        .valid = &.{"let a = 1; let x = a ? b : c; console.log(x);"},
        .invalid = &.{.{ .code = "let a = 1; let x = a ? true : false; console.log(x);" }},
    });
}

test "prefer-template" {
    try RuleTester.run(.{
        .rule = "prefer-template",
        .valid = &.{"let x = 'hello'; console.log(x);"},
        .invalid = &.{.{ .code = "let name = 'world'; let x = 'hello' + name; console.log(x);" }},
    });
}

// ══════════════════════════════════════════════════════════════
// Clean Code
// ══════════════════════════════════════════════════════════════

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

// ══════════════════════════════════════════════════════════════
// Multiple Rules
// ══════════════════════════════════════════════════════════════

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

// ══════════════════════════════════════════════════════════════
// Fixture Files
// ══════════════════════════════════════════════════════════════

test "fixture: no_debugger" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_debugger.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-debugger");
}

test "fixture: no_empty" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_empty.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-empty");
    try testing.expect(countRule(diags, "no-empty") >= 2);
}

test "fixture: no_dupe_keys" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_dupe_keys.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-dupe-keys");
}

test "fixture: no_sparse_arrays" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_sparse_arrays.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-sparse-arrays");
}

test "fixture: no_unreachable" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_unreachable.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unreachable");
}

test "fixture: no_unused_vars" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_unused_vars.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-unused-vars");
}

test "fixture: no_const_assign" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_const_assign.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-const-assign");
}

test "fixture: no_constant_condition" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_constant_condition.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-constant-condition");
}

test "fixture: no_loss_of_precision" {
    const diags = try lintSource(@embedFile("fixtures/lint/no_loss_of_precision.js"));
    defer testing.allocator.free(diags);
    try expectRule(diags, "no-loss-of-precision");
}

test "fixture: clean code" {
    const diags = try lintSource(@embedFile("fixtures/lint/clean.js"));
    defer testing.allocator.free(diags);
    try testing.expectEqual(@as(usize, 0), diags.len);
}
