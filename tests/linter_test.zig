const std = @import("std");
const testing = std.testing;
const sanz = @import("sanz");
const Lexer = sanz.Lexer;
const Parser = sanz.Parser;
const SemanticAnalyzer = sanz.semantic.SemanticAnalyzer;
const linter = sanz.linter;
const LintDiagnostic = sanz.lint_context.LintDiagnostic;
const RuleTester = @import("rule_tester.zig").RuleTester;

// ── Helpers (kept for fixture/multi-rule tests) ──────────────

fn lintSource(source: []const u8) ![]const LintDiagnostic {
    const allocator = testing.allocator;
    var lex_result = try Lexer.tokenize(allocator, source);
    defer lex_result.deinit(allocator);
    var tokens = lex_result.tokens;
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
        .valid = &.{
            "var x = 1;",
            "function foo() { return 1; }",
            "if (x) { foo(); }",
        },
        .invalid = &.{
            .{ .code = "debugger;" },
            .{ .code = "function foo() { debugger; }" },
            .{ .code = "if (x) { debugger; }", .errors = 1 },
        },
    });
}

test "no-empty" {
    try RuleTester.run(.{
        .rule = "no-empty",
        .valid = &.{
            "if (true) { var x = 1; }",
            "while (false) { break; }",
            "try { foo(); } catch(e) { throw e; }",
        },
        .invalid = &.{
            .{ .code = "if (true) {}" },
            .{ .code = "while (false) {}" },
            .{ .code = "try {} catch(e) { throw e; }" },
        },
    });
}

test "no-extra-semi" {
    try RuleTester.run(.{
        .rule = "no-extra-semi",
        .valid = &.{
            "var x = 1;",
            "function foo() {}",
        },
        .invalid = &.{
            .{ .code = ";" },
            .{ .code = "var x = 1;;" },
        },
    });
}

test "no-dupe-keys" {
    try RuleTester.run(.{
        .rule = "no-dupe-keys",
        .valid = &.{
            "var obj = { a: 1, b: 2, c: 3 };",
            "var obj = { a: 1, 'b': 2 };",
            "var obj = {};",
        },
        .invalid = &.{
            .{ .code = "var obj = { a: 1, b: 2, a: 3 };" },
            .{ .code = "var obj = { 'a': 1, a: 2 };" },
        },
    });
}

test "no-dupe-args" {
    try RuleTester.run(.{
        .rule = "no-dupe-args",
        .valid = &.{
            "function foo(a, b, c) {}",
            "function foo(a) {}",
            "(a, b) => a + b;",
        },
        .invalid = &.{
            .{ .code = "function foo(a, b, a) {}" },
            .{ .code = "function foo(x, x) {}" },
        },
    });
}

test "no-sparse-arrays" {
    try RuleTester.run(.{
        .rule = "no-sparse-arrays",
        .valid = &.{
            "var arr = [1, 2, 3];",
            "var arr = [];",
            "var arr = [undefined, undefined];",
        },
        .invalid = &.{
            .{ .code = "var arr = [1,,3];" },
            .{ .code = "var arr = [,];" },
            .{ .code = "var arr = [1, 2,,];" },
        },
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
            "let x = 1; if (x > 0) {}",
            "let _unused = 1;",
            "function foo(x) { return x; } foo(1);",
            "const arr = [1, 2]; arr.push(3);",
        },
        .invalid = &.{
            .{ .code = "let x = 1;" },
            .{ .code = "const unused = 42;" },
        },
    });
}

test "no-undef" {
    try RuleTester.run(.{
        .rule = "no-undef",
        .valid = &.{
            "let x = 1; if (x > 0) {}",
            "typeof undeclaredVar;",
            "const arr = new Array(3);",
            "const p = new Promise(function(resolve) { resolve(1); });",
            "const obj = { type: true };",
        },
        .invalid = &.{
            .{ .code = "undeclaredVar;" },
            .{ .code = "let arr = []; arr.push(undeclaredVar);" },
        },
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
        .valid = &.{
            "let x = 1; x = 2;",
            "var y = 1; y += 1;",
            "const obj = {}; obj.x = 1;",
        },
        .invalid = &.{
            .{ .code = "const x = 1; x = 2;" },
            .{ .code = "const arr = []; arr = [];" },
        },
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
        .valid = &.{
            "let x = 1; if (x === 1) {}",
            "if (x !== null) {}",
            "if (a === b) {}",
        },
        .invalid = &.{
            .{ .code = "let x = 1; if (x == 1) {}" },
            .{ .code = "if (a != b) {}" },
            .{ .code = "let x = 1; if (x == null) {}" },
        },
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
        .valid = &.{
            "let x = 'hello'; throw new Error(x);",
            "let x = `hello ${name}`;",
            "'use strict';",
        },
        .invalid = &.{
            .{ .code = "let name = 'world'; let x = 'hello' + name; throw new Error(x);" },
            .{ .code = "const s = 'a' + 'b'; throw new Error(s);" },
        },
    });
}

// ══════════════════════════════════════════════════════════════
// Correctness v0.5 Rules
// ══════════════════════════════════════════════════════════════

test "no-class-assign" {
    try RuleTester.run(.{
        .rule = "no-class-assign",
        .valid = &.{
            "class Foo {} new Foo();",
            "let Foo = class {}; Foo = class {}; new Foo();",
        },
        .invalid = &.{
            .{ .code = "class Foo {} Foo = 1;" },
            .{ .code = "class Bar {} Bar = function() {};" },
        },
    });
}

test "no-unused-expressions" {
    try RuleTester.run(.{
        .rule = "no-unused-expressions",
        .valid = &.{
            "foo();",
            "let a = 1; a++;",
            "delete obj.x;",
            "let x = (1, 2);",
        },
        .invalid = &.{
            .{ .code = "1;" },
            .{ .code = "let a = 1; let b = 2; a + b;" },
            .{ .code = "let x = 1; x > 0;" },
        },
    });
}

test "no-useless-constructor" {
    try RuleTester.run(.{
        .rule = "no-useless-constructor",
        .valid = &.{
            "class Foo { constructor(x) { this.x = x; } }",
            "class Foo { constructor() { super(); this.x = 1; } }",
        },
        .invalid = &.{
            .{ .code = "class Foo { constructor() {} }" },
        },
    });
}

// ══════════════════════════════════════════════════════════════
// Suspicious v0.5 Rules
// ══════════════════════════════════════════════════════════════

test "no-console" {
    try RuleTester.run(.{
        .rule = "no-console",
        .valid = &.{
            "foo();",
            "logger.log('hello');",
        },
        .invalid = &.{
            .{ .code = "console.log('hello');" },
            .{ .code = "console.error('oops');" },
            .{ .code = "console.warn('warn');" },
        },
    });
}

test "no-alert" {
    try RuleTester.run(.{
        .rule = "no-alert",
        .valid = &.{
            "foo('hello');",
            "myAlert('x');",
        },
        .invalid = &.{
            .{ .code = "alert('hello');" },
            .{ .code = "confirm('sure?');" },
            .{ .code = "prompt('name?');" },
        },
    });
}

test "no-duplicate-imports" {
    try RuleTester.run(.{
        .rule = "no-duplicate-imports",
        .valid = &.{
            "import { a } from 'foo'; import { b } from 'bar';",
        },
        .invalid = &.{
            .{ .code = "import { a } from 'foo'; import { b } from 'foo';" },
        },
    });
}

test "default-case" {
    try RuleTester.run(.{
        .rule = "default-case",
        .valid = &.{
            "let x = 1; switch(x) { case 1: break; default: break; }",
            "let x = 1; switch(x) { default: break; case 1: break; }",
        },
        .invalid = &.{
            .{ .code = "let x = 1; switch(x) { case 1: break; case 2: break; }" },
            .{ .code = "let x = 1; switch(x) { case 1: break; }" },
        },
    });
}

test "radix" {
    try RuleTester.run(.{
        .rule = "radix",
        .valid = &.{
            "parseInt('10', 10);",
            "parseInt('ff', 16);",
            "parseFloat('3.14');",
        },
        .invalid = &.{
            .{ .code = "parseInt('10');" },
            .{ .code = "parseInt('ff');" },
        },
    });
}

test "no-shadow" {
    try RuleTester.run(.{
        .rule = "no-shadow",
        .valid = &.{
            "let a = 1; function foo() { let b = 2; return b; } foo(); a;",
        },
        .invalid = &.{
            .{ .code = "let x = 1; function foo() { let x = 2; return x; } foo();" },
            .{ .code = "let msg = 'hi'; try { foo(); } catch(msg) { throw msg; }" },
        },
    });
}

// ══════════════════════════════════════════════════════════════
// Style v0.5 Rules
// ══════════════════════════════════════════════════════════════

test "object-shorthand" {
    try RuleTester.run(.{
        .rule = "object-shorthand",
        .valid = &.{
            "let x = 1; let obj = { x };",
            "let obj = { a: 1 };",
            "let x = 1; let obj = { y: x };",
        },
        .invalid = &.{
            .{ .code = "let x = 1; let obj = { x: x };" },
            .{ .code = "let name = 'foo'; let obj = { name: name };" },
        },
    });
}

test "prefer-exponentiation-operator" {
    try RuleTester.run(.{
        .rule = "prefer-exponentiation-operator",
        .valid = &.{
            "let x = 2 ** 3;",
            "Math.sqrt(4);",
        },
        .invalid = &.{
            .{ .code = "let x = Math.pow(2, 3);" },
            .{ .code = "Math.pow(a, b);" },
        },
    });
}

test "symbol-description" {
    try RuleTester.run(.{
        .rule = "symbol-description",
        .valid = &.{
            "let s = Symbol('mySymbol');",
            "let s = Symbol.for('key');",
        },
        .invalid = &.{
            .{ .code = "let s = Symbol();" },
        },
    });
}

test "no-useless-rename" {
    try RuleTester.run(.{
        .rule = "no-useless-rename",
        .valid = &.{
            "import { a as b } from 'foo';",
        },
        .invalid = &.{
            .{ .code = "import { a as a } from 'foo';" },
        },
    });
}

// ══════════════════════════════════════════════════════════════
// TypeScript v0.5 Rules
// ══════════════════════════════════════════════════════════════

test "ban-ts-comment" {
    try RuleTester.run(.{
        .rule = "ban-ts-comment",
        .lang = .ts,
        .valid = &.{
            "const x: number = 5;",
            "// regular comment",
        },
        .invalid = &.{
            .{ .code = "// @ts-ignore\nconst x = foo();" },
            .{ .code = "// @ts-nocheck\n" },
            .{ .code = "// @ts-expect-error\nconst x = foo();" },
        },
    });
}

test "no-this-alias" {
    try RuleTester.run(.{
        .rule = "no-this-alias",
        .lang = .ts,
        .valid = &.{
            "const obj = { x: 1 };",
            "const fn = () => this;",
        },
        .invalid = &.{
            .{ .code = "const self = this;" },
            .{ .code = "const _this = this;" },
        },
    });
}

test "no-duplicate-enum-values" {
    try RuleTester.run(.{
        .rule = "no-duplicate-enum-values",
        .lang = .ts,
        .valid = &.{
            "enum Foo { A = 1, B = 2, C = 3 }",
            "enum Status { Ok = 'ok', Error = 'error' }",
        },
        .invalid = &.{
            .{ .code = "enum Foo { A = 1, B = 2, C = 1 }" },
            .{ .code = "enum Foo { A = 'x', B = 'x' }" },
        },
    });
}

test "no-array-delete" {
    try RuleTester.run(.{
        .rule = "no-array-delete",
        .valid = &.{
            "delete obj.x;",
            "delete obj['key'];",
        },
        .invalid = &.{
            .{ .code = "let arr = [1,2,3]; delete arr[0];" },
        },
    });
}

test "require-await" {
    try RuleTester.run(.{
        .rule = "require-await",
        .valid = &.{
            "async function f() { await fetch('/api'); }",
            "const f = async () => { const x = await Promise.resolve(1); return x; };",
            "async function f() { for await (const x of gen()) {} }",
            // Non-async functions are not checked
            "function f() { return 1; }",
        },
        .invalid = &.{
            .{ .code = "async function f() { return 1; }" },
            .{ .code = "const f = async () => { return 1; };" },
            .{ .code = "const f = async () => 42;" },
        },
    });
}

test "no-constructor-return" {
    try RuleTester.run(.{
        .rule = "no-constructor-return",
        .valid = &.{
            "class C { constructor() { this.x = 1; } }",
            "class C { constructor() { return; } }",
            "class C { constructor() { return undefined; } }",
        },
        .invalid = &.{
            .{ .code = "class C { constructor() { return 42; } }" },
            .{ .code = "class C { constructor() { return {}; } }" },
            .{ .code = "class C { constructor() { if (x) { return this; } } }" },
        },
    });
}

test "no-await-in-loop" {
    try RuleTester.run(.{
        .rule = "no-await-in-loop",
        .valid = &.{
            // await outside loop is fine
            "async function f() { await fetchAll(); }",
            // await inside nested async is fine
            "async function f() { for (const x of items) { const g = async () => await fetch(x); } }",
        },
        .invalid = &.{
            .{ .code = "async function f() { for (const x of items) { await fetch(x); } }" },
            .{ .code = "async function f() { while (true) { await sleep(100); } }" },
            .{ .code = "async function f() { do { await step(); } while (cond); }" },
        },
    });
}

test "no-promise-executor-return" {
    try RuleTester.run(.{
        .rule = "no-promise-executor-return",
        .valid = &.{
            "new Promise((resolve, reject) => { resolve(1); });",
            "new Promise(function(resolve) { resolve(1); });",
        },
        .invalid = &.{
            .{ .code = "new Promise((resolve) => resolve(1));" },
            .{ .code = "new Promise(function(resolve) { return resolve(1); });" },
        },
    });
}

test "no-loop-func" {
    try RuleTester.run(.{
        .rule = "no-loop-func",
        .valid = &.{
            "for (let i = 0; i < 3; i++) { i++; }",
            "while (true) { break; }",
        },
        .invalid = &.{
            .{ .code = "for (let i = 0; i < 3; i++) { const f = () => i; }" },
            .{ .code = "while (cond) { const f = function() {}; }" },
        },
    });
}

test "no-implicit-globals" {
    try RuleTester.run(.{
        .rule = "no-implicit-globals",
        .valid = &.{
            "const x = 1;",
            "let y = 2;",
            // var inside a function is not global scope
            "(function() { var z = 3; })();",
            // In module mode (global→module), var/function at top level
            // are in module scope (depth 1), not global — no error.
            "var x = 1;",
            "function globalFn() {}",
        },
        .invalid = &.{},
    });
}

test "no-process-exit" {
    try RuleTester.run(.{
        .rule = "no-process-exit",
        .valid = &.{
            "process.env.NODE_ENV;",
            "process.stdout.write('hello');",
        },
        .invalid = &.{
            .{ .code = "process.exit(1);" },
            .{ .code = "process.exit(0);" },
        },
    });
}

test "prefer-rest-params" {
    try RuleTester.run(.{
        .rule = "prefer-rest-params",
        .valid = &.{
            "function f(...args) { return args; }",
            "const f = (...args) => args;",
        },
        .invalid = &.{
            .{ .code = "function f() { return arguments; }" },
            .{ .code = "function f() { return arguments.length; }" },
        },
    });
}

test "prefer-spread" {
    try RuleTester.run(.{
        .rule = "prefer-spread",
        .valid = &.{
            "Math.max(...args);",
            "fn(...items);",
        },
        .invalid = &.{
            .{ .code = "fn.apply(null, args);" },
            .{ .code = "Math.max.apply(null, numbers);" },
        },
    });
}

test "no-useless-call" {
    try RuleTester.run(.{
        .rule = "no-useless-call",
        .valid = &.{
            "fn.call(obj, arg1);",
            "fn.apply(obj, [arg1]);",
        },
        .invalid = &.{
            .{ .code = "fn.call(null, arg1);" },
            .{ .code = "fn.apply(undefined, [arg1]);" },
        },
    });
}

test "no-empty-function" {
    try RuleTester.run(.{
        .rule = "no-empty-function",
        .valid = &.{
            "function f() { return 1; }",
            "const f = () => 42;",
            "const f = () => { return 1; };",
        },
        .invalid = &.{
            .{ .code = "function f() {}" },
            .{ .code = "const f = function() {};" },
            .{ .code = "const f = async function() {};" },
        },
    });
}

test "max-params" {
    try RuleTester.run(.{
        .rule = "max-params",
        .valid = &.{
            "function f(a, b, c) {}",
            "const f = (a, b, c, d) => {};",
        },
        .invalid = &.{
            .{ .code = "function f(a, b, c, d, e) {}" },
            .{ .code = "const f = (a, b, c, d, e) => {};" },
        },
    });
}

test "prefer-arrow-callback" {
    try RuleTester.run(.{
        .rule = "prefer-arrow-callback",
        .valid = &.{
            "arr.map((x) => x * 2);",
            "arr.filter((x) => x > 0);",
        },
        .invalid = &.{
            .{ .code = "arr.map(function(x) { return x * 2; });" },
            .{ .code = "setTimeout(function() { doSomething(); }, 100);" },
        },
    });
}

test "no-useless-empty-export" {
    try RuleTester.run(.{
        .rule = "no-useless-empty-export",
        .lang = .ts,
        .valid = &.{
            "export { foo };",
            "export { x as y };",
        },
        .invalid = &.{
            .{ .code = "export {};" },
        },
    });
}

test "prefer-optional-chain" {
    try RuleTester.run(.{
        .rule = "prefer-optional-chain",
        .lang = .ts,
        .valid = &.{
            "a?.b;",
            "a?.b?.c;",
        },
        .invalid = &.{
            .{ .code = "a && a.b;" },
            .{ .code = "foo && foo.bar;" },
        },
    });
}

test "no-unreachable-loop" {
    try RuleTester.run(.{
        .rule = "no-unreachable-loop",
        .valid = &.{
            "for (let i = 0; i < 10; i++) { doSomething(); }",
            "while (cond) { if (done) break; step(); }",
            "for (const x of items) { process(x); }",
        },
        .invalid = &.{
            .{ .code = "while (true) { return 1; }" },
            .{ .code = "for (const x of items) { return x; }" },
            .{ .code = "while (cond) { break; }" },
        },
    });
}

test "consistent-return" {
    try RuleTester.run(.{
        .rule = "consistent-return",
        .valid = &.{
            "function f() { return 1; }",
            "function f() { return; }",
            "const f = (x) => { if (x) return x; };",
        },
        .invalid = &.{
            .{ .code = "function f(x) { if (x) return x; return; }" },
            .{ .code = "function f(x) { if (x) { return; } return x; }" },
        },
    });
}

test "no-implicit-coercion" {
    try RuleTester.run(.{
        .rule = "no-implicit-coercion",
        .valid = &.{
            "Boolean(x);",
            "Number(x);",
            "String(x);",
            "!x;",
        },
        .invalid = &.{
            .{ .code = "!!x;" },
            .{ .code = "const n = +str;" },
            .{ .code = "const s = '' + val;" },
        },
    });
}

test "no-useless-concat" {
    try RuleTester.run(.{
        .rule = "no-useless-concat",
        .valid = &.{
            "'hello ' + name;",
            "a + b;",
        },
        .invalid = &.{
            .{ .code = "'hello' + ' world';" },
            .{ .code = "const s = 'a' + 'b';" },
        },
    });
}

test "arrow-body-style" {
    try RuleTester.run(.{
        .rule = "arrow-body-style",
        .valid = &.{
            "const f = (x) => x * 2;",
            "const f = (x) => { if (x) return x; return 0; };",
            "const f = () => {};",
        },
        .invalid = &.{
            .{ .code = "const f = (x) => { return x * 2; };" },
            .{ .code = "const g = () => { return 42; };" },
        },
    });
}

test "no-non-null-asserted-optional-chain" {
    try RuleTester.run(.{
        .rule = "no-non-null-asserted-optional-chain",
        .lang = .ts,
        .valid = &.{
            "a!.b;",
            "a?.b;",
        },
        .invalid = &.{
            .{ .code = "a?.b!;" },
            .{ .code = "a?.()!;" },
        },
    });
}

test "no-confusing-non-null-assertion" {
    try RuleTester.run(.{
        .rule = "no-confusing-non-null-assertion",
        .lang = .ts,
        .valid = &.{
            "a!;",
            "a?.b!;",
        },
        .invalid = &.{
            .{ .code = "a!!;" },
        },
    });
}

test "no-non-null-asserted-nullish-coalescing" {
    try RuleTester.run(.{
        .rule = "no-non-null-asserted-nullish-coalescing",
        .lang = .ts,
        .valid = &.{
            "a ?? b;",
            "a?.b ?? c;",
        },
        .invalid = &.{
            .{ .code = "a! ?? b;" },
        },
    });
}

test "no-empty-static-block" {
    try RuleTester.run(.{
        .rule = "no-empty-static-block",
        .valid = &.{
            "class C { static { this.x = 1; } }",
        },
        .invalid = &.{
            .{ .code = "class C { static {} }" },
        },
    });
}

test "default-param-last" {
    try RuleTester.run(.{
        .rule = "default-param-last",
        .valid = &.{
            "function f(a, b, c = 1) {}",
            "const f = (x, y = 2) => {};",
            "function f(a, b = 1, ...rest) {}",
        },
        .invalid = &.{
            .{ .code = "function f(a = 1, b) {}" },
            .{ .code = "const f = (x = 0, y) => {};" },
        },
    });
}

test "accessor-pairs" {
    try RuleTester.run(.{
        .rule = "accessor-pairs",
        .valid = &.{
            "const obj = { get x() { return 1; }, set x(v) {} };",
            "const obj = { x: 1 };",
        },
        .invalid = &.{
            .{ .code = "const obj = { set x(v) {} };" },
        },
    });
}

test "prefer-promise-reject-errors" {
    try RuleTester.run(.{
        .rule = "prefer-promise-reject-errors",
        .valid = &.{
            "Promise.reject(new Error('msg'));",
            "Promise.reject(new TypeError('msg'));",
            "Promise.reject(err);",
        },
        .invalid = &.{
            .{ .code = "Promise.reject('string error');" },
            .{ .code = "Promise.reject(42);" },
            .{ .code = "Promise.reject(null);" },
        },
    });
}

test "logical-assignment-operators" {
    try RuleTester.run(.{
        .rule = "logical-assignment-operators",
        .valid = &.{
            "a ||= b;",
            "a &&= b;",
            "a ??= b;",
        },
        .invalid = &.{
            .{ .code = "a = a || b;" },
            .{ .code = "a = a && b;" },
            .{ .code = "a = a ?? b;" },
        },
    });
}

test "no-invalid-new" {
    try RuleTester.run(.{
        .rule = "no-invalid-new",
        .valid = &.{
            "new MyClass();",
            "new Error('msg');",
            "new Map();",
        },
        .invalid = &.{
            .{ .code = "new String('hello');" },
            .{ .code = "new Number(42);" },
            .{ .code = "new Boolean(true);" },
            .{ .code = "new Symbol();" },
        },
    });
}

test "no-object-constructor" {
    try RuleTester.run(.{
        .rule = "no-object-constructor",
        .valid = &.{
            "new Map();",
            "new MyClass();",
            "new Object(existingValue);",
            "new Object({ key: 'val' });",
        },
        .invalid = &.{
            .{ .code = "new Object();" },
        },
    });
}

test "prefer-object-spread" {
    try RuleTester.run(.{
        .rule = "prefer-object-spread",
        .valid = &.{
            "Object.assign(target, source);",
            "Object.assign(obj, { x: 1 });",
            "{ ...obj };",
        },
        .invalid = &.{
            .{ .code = "Object.assign({}, source);" },
            .{ .code = "Object.assign({}, defaults, overrides);" },
        },
    });
}

test "no-warning-comments" {
    try RuleTester.run(.{
        .rule = "no-warning-comments",
        .valid = &.{
            "// normal comment\nconst x = 1;",
            "/* block comment */",
        },
        .invalid = &.{
            .{ .code = "// TODO: fix this\nconst x = 1;" },
            .{ .code = "// FIXME: broken\nconst x = 1;" },
            .{ .code = "// HACK: workaround\nconst x = 1;" },
        },
    });
}

// ══════════════════════════════════════════════════════════════
// v0.7 Rules
// ══════════════════════════════════════════════════════════════

test "no-constant-binary-expression" {
    try RuleTester.run(.{
        .rule = "no-constant-binary-expression",
        .valid = &.{
            "const x = null == y;",
            "if (a || b) {}",
            "if (a && b) {}",
        },
        .invalid = &.{
            .{ .code = "const x = new Foo() == null;" },
            .{ .code = "const x = [] == null;" },
            .{ .code = "const y = true || x;" },
            .{ .code = "const z = false && x;" },
        },
    });
}

test "no-div-regex" {
    try RuleTester.run(.{
        .rule = "no-div-regex",
        .valid = &.{
            "const re = / =foo/;",
            "const re = /abc/;",
        },
        .invalid = &.{
            .{ .code = "const re = /=foo/;" },
            .{ .code = "const re = /=bar/gi;" },
        },
    });
}

test "array-callback-return" {
    try RuleTester.run(.{
        .rule = "array-callback-return",
        .valid = &.{
            "arr.map(x => x * 2);",
            "arr.filter(x => x > 0);",
            "arr.map(function(x) { return x + 1; });",
            "arr.forEach(function(x) { console.log(x); });",
        },
        .invalid = &.{
            .{ .code = "arr.map(function(x) { if (x) return x; return; });" },
            .{ .code = "arr.filter(function(x) { return; });" },
        },
    });
}

test "no-return-await" {
    try RuleTester.run(.{
        .rule = "no-return-await",
        .valid = &.{
            "async function f() { return fetch(); }",
            "async function f() { const x = await fetch(); return x; }",
        },
        .invalid = &.{
            .{ .code = "async function f() { return await fetch(); }" },
            .{ .code = "const f = async () => { return await Promise.resolve(1); };" },
        },
    });
}

test "no-new-array" {
    try RuleTester.run(.{
        .rule = "no-new-array",
        .valid = &.{
            "const a = new Array(1, 2, 3);",
            "const b = [];",
            "const c = Array.from({ length: 3 });",
        },
        .invalid = &.{
            .{ .code = "const a = new Array(100);" },
            .{ .code = "const b = new Array(0);" },
        },
    });
}

test "require-unicode-regexp" {
    try RuleTester.run(.{
        .rule = "require-unicode-regexp",
        .valid = &.{
            "const re = /foo/u;",
            "const re = /foo/v;",
            "const re = /foo/giu;",
        },
        .invalid = &.{
            .{ .code = "const re = /foo/;" },
            .{ .code = "const re = /foo/gi;" },
            .{ .code = "const re = new RegExp('foo');" },
        },
    });
}

test "camelcase" {
    try RuleTester.run(.{
        .rule = "camelcase",
        .valid = &.{
            "const myVariable = 1;",
            "const MY_CONSTANT = 1;",
            "const _private = 1;",
            "const __dunder__ = 1;",
        },
        .invalid = &.{
            .{ .code = "const my_variable = 1;" },
            .{ .code = "const some_long_name = 1;" },
        },
    });
}

test "prefer-numeric-literals" {
    try RuleTester.run(.{
        .rule = "prefer-numeric-literals",
        .valid = &.{
            "parseInt('10', 10);",
            "parseInt('10');",
            "const x = 0b1010;",
        },
        .invalid = &.{
            .{ .code = "parseInt('1010', 2);" },
            .{ .code = "parseInt('ff', 16);" },
            .{ .code = "Number.parseInt('1234', 8);" },
        },
    });
}

test "prefer-regex-literals" {
    try RuleTester.run(.{
        .rule = "prefer-regex-literals",
        .valid = &.{
            "const re = /foo/;",
            "const re = new RegExp(pattern);",
            "const re = new RegExp(pattern, 'g');",
        },
        .invalid = &.{
            .{ .code = "const re = new RegExp('foo');" },
            .{ .code = "const re = new RegExp('foo', 'g');" },
        },
    });
}

test "no-useless-return" {
    try RuleTester.run(.{
        .rule = "no-useless-return",
        .valid = &.{
            "function f() { return 1; }",
            "function f() { if (x) return; doWork(); }",
        },
        .invalid = &.{
            .{ .code = "function f() { doWork(); return; }" },
            .{ .code = "const f = () => { doWork(); return; };" },
        },
    });
}

test "func-style" {
    try RuleTester.run(.{
        .rule = "func-style",
        .valid = &.{
            "function foo() {}",
            "const f = () => {};",
            "const f = function() {};",
        },
        .invalid = &.{
            .{ .code = "const foo = function bar() {};" },
        },
    });
}

test "id-length" {
    try RuleTester.run(.{
        .rule = "id-length",
        .valid = &.{
            "const foo = 1;",
            "const i = 0;",
            "const _ = null;",
        },
        .invalid = &.{
            .{ .code = "const q = 1;" },
            .{ .code = "const r = 1;" },
        },
    });
}

test "operator-assignment" {
    try RuleTester.run(.{
        .rule = "operator-assignment",
        .valid = &.{
            "x += 1;",
            "x -= y;",
            "x = y + z;",
        },
        .invalid = &.{
            .{ .code = "x = x + 1;" },
            .{ .code = "x = x - y;" },
            .{ .code = "x = x * 2;" },
        },
    });
}

test "prefer-object-has-own" {
    try RuleTester.run(.{
        .rule = "prefer-object-has-own",
        .valid = &.{
            "Object.hasOwn(obj, key);",
            "obj.hasOwnProperty(key);",
        },
        .invalid = &.{
            .{ .code = "Object.prototype.hasOwnProperty.call(obj, key);" },
            .{ .code = "({}).hasOwnProperty.call(obj, 'foo');" },
        },
    });
}

test "no-underscore-dangle" {
    try RuleTester.run(.{
        .rule = "no-underscore-dangle",
        .valid = &.{
            "const foo = 1;",
            "const _ = null;",
            "const __ = null;",
        },
        .invalid = &.{
            .{ .code = "const _foo = 1;" },
            .{ .code = "const foo_ = 1;" },
        },
    });
}

test "yoda" {
    try RuleTester.run(.{
        .rule = "yoda",
        .valid = &.{
            "if (x === 5) {}",
            "if (foo == null) {}",
            "if (5 === 5) {}",
        },
        .invalid = &.{
            .{ .code = "if (5 === x) {}" },
            .{ .code = "if ('foo' == bar) {}" },
            .{ .code = "if (null != x) {}" },
        },
    });
}

test "no-ternary" {
    try RuleTester.run(.{
        .rule = "no-ternary",
        .valid = &.{
            "if (x) { y = 1; } else { y = 2; }",
        },
        .invalid = &.{
            .{ .code = "const x = a ? b : c;" },
            .{ .code = "return condition ? 1 : 0;" },
        },
    });
}

test "prefer-named-capture-group" {
    try RuleTester.run(.{
        .rule = "prefer-named-capture-group",
        .valid = &.{
            "const re = /(?<year>\\d{4})/;",
            "const re = /(?:foo)/;",
            "const re = /(?<=foo)bar/;",
            "const re = /abc/;",
        },
        .invalid = &.{
            .{ .code = "const re = /(\\d+)/;" },
            .{ .code = "const re = /(foo)(bar)/;" },
        },
    });
}

test "ban-types" {
    try RuleTester.run(.{
        .rule = "ban-types",
        .lang = .ts,
        .valid = &.{
            "const x: string = 'hi';",
            "const x: number = 1;",
            "const x: Record<string, unknown> = {};",
        },
        .invalid = &.{
            .{ .code = "const x: String = 'hi';" },
            .{ .code = "const x: Number = 1;" },
            .{ .code = "const x: Object = {};" },
            .{ .code = "const x: Function = () => {};" },
        },
    });
}

test "prefer-literal-enum-member" {
    try RuleTester.run(.{
        .rule = "prefer-literal-enum-member",
        .lang = .ts,
        .valid = &.{
            "enum Foo { A = 1, B = 2 }",
            "enum Foo { A = 'a', B = 'b' }",
            "enum Foo { A, B, C }",
            "enum Foo { A = -1, B = -2 }",
        },
        .invalid = &.{
            .{ .code = "const x = 1; enum Foo { A = x }" },
            .{ .code = "enum Foo { A = 1 + 2 }" },
        },
    });
}

test "no-duplicate-type-constituents" {
    try RuleTester.run(.{
        .rule = "no-duplicate-type-constituents",
        .lang = .ts,
        .valid = &.{
            "type T = string | number;",
            "type T = A & B & C;",
        },
        .invalid = &.{
            .{ .code = "type T = string | string;" },
            .{ .code = "type T = A & A;" },
        },
    });
}

test "no-mixed-enums" {
    try RuleTester.run(.{
        .rule = "no-mixed-enums",
        .lang = .ts,
        .valid = &.{
            "enum Foo { A = 1, B = 2 }",
            "enum Foo { A = 'a', B = 'b' }",
            "enum Foo { A, B, C }",
        },
        .invalid = &.{
            .{ .code = "enum Foo { A = 1, B = 'b' }" },
            .{ .code = "enum Foo { A, B = 'string' }" },
        },
    });
}

test "no-useless-backreference" {
    try RuleTester.run(.{
        .rule = "no-useless-backreference",
        .valid = &.{
            "const re = /(\\w+) \\1/;",
            "const re = /abc/;",
        },
        .invalid = &.{
            .{ .code = "const re = /\\1/;" },
            .{ .code = "const re = /\\2(a)/;" },
        },
    });
}

test "dot-notation" {
    try RuleTester.run(.{
        .rule = "dot-notation",
        .valid = &.{
            "obj.prop;",
            "obj['some-prop'];",
            "obj[variable];",
            "obj[0];",
        },
        .invalid = &.{
            .{ .code = "obj['prop'];" },
            .{ .code = "obj['myMethod']();" },
        },
    });
}

test "no-confusing-arrow" {
    try RuleTester.run(.{
        .rule = "no-confusing-arrow",
        .valid = &.{
            "const f = (x) => { return x > 0 ? 1 : -1; };",
            "const f = x => x * 2;",
        },
        .invalid = &.{
            .{ .code = "const f = x => x > 0 ? 1 : -1;" },
            .{ .code = "const g = a => a === b ? c : d;" },
        },
    });
}

test "no-extra-label" {
    try RuleTester.run(.{
        .rule = "no-extra-label",
        .valid = &.{
            "outer: for (let i = 0; i < 10; i++) { for (let j = 0; j < 10; j++) { if (j === 5) break outer; } }",
        },
        .invalid = &.{
            .{ .code = "loop: for (let i = 0; i < 10; i++) { if (i > 5) break loop; }" },
            .{ .code = "outer: while (true) { break outer; }" },
        },
    });
}

test "vars-on-top" {
    try RuleTester.run(.{
        .rule = "vars-on-top",
        .valid = &.{
            "function f() { var x = 1; console.log(x); }",
            "function f() { 'use strict'; var x = 1; }",
        },
        .invalid = &.{
            .{ .code = "function f() { console.log(1); var x = 1; }" },
            .{ .code = "function f() { if (true) {} var x = 1; }" },
        },
    });
}

test "prefer-destructuring" {
    try RuleTester.run(.{
        .rule = "prefer-destructuring",
        .valid = &.{
            "const { foo } = obj;",
            "const bar = obj.foo;",
            "const baz = obj.other;",
        },
        .invalid = &.{
            .{ .code = "const foo = obj.foo;" },
            .{ .code = "const name = person.name;" },
        },
    });
}

test "no-new-native-nonconstructor" {
    try RuleTester.run(.{
        .rule = "no-new-native-nonconstructor",
        .valid = &.{
            "const s = Symbol('foo');",
            "const b = BigInt(42);",
            "const e = new Error('msg');",
        },
        .invalid = &.{
            .{ .code = "const s = new Symbol('foo');" },
            .{ .code = "const b = new BigInt(42);" },
        },
    });
}

test "complexity" {
    try RuleTester.run(.{
        .rule = "complexity",
        .valid = &.{
            "function simple() { return 1; }",
            "function small() { if (a) { return 1; } return 2; }",
        },
        .invalid = &.{
            // 21 branches = complexity > 20
            .{ .code =
                \\function complex(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u) {
                \\  if(a){}if(b){}if(c){}if(d){}if(e){}if(f){}if(g){}if(h){}
                \\  if(i){}if(j){}if(k){}if(l){}if(m){}if(n){}if(o){}if(p){}
                \\  if(q){}if(r){}if(s){}if(t){}if(u){}
                \\}
            },
        },
    });
}

test "max-statements" {
    try RuleTester.run(.{
        .rule = "max-statements",
        .valid = &.{
            "function f() { const x = 1; return x; }",
        },
        .invalid = &.{
            .{ .code =
                \\function tooMany() {
                \\  const a=1;const b=2;const c=3;const d=4;const e=5;
                \\  const f=6;const g=7;const h=8;const i=9;const j=10;
                \\  const k=11;const l=12;const m=13;const n=14;const o=15;
                \\  const p=16;const q=17;const r=18;const s=19;const t=20;
                \\  const u=21;
                \\}
            },
        },
    });
}

test "sort-keys" {
    try RuleTester.run(.{
        .rule = "sort-keys",
        .valid = &.{
            "const x = { a: 1, b: 2, c: 3 };",
            "const x = {};",
            "const x = { x: 1 };",
        },
        .invalid = &.{
            .{ .code = "const x = { b: 2, a: 1 };" },
            .{ .code = "const x = { z: 3, a: 1, m: 2 };" },
        },
    });
}

test "max-depth" {
    try RuleTester.run(.{
        .rule = "max-depth",
        .valid = &.{
            "function f() { if (a) { if (b) { if (c) { if (d) {} } } } }",
            "function f() { return 1; }",
        },
        .invalid = &.{
            .{ .code = "function f() { if (a) { if (b) { if (c) { if (d) { if (e) {} } } } } }" },
            .{ .code = "function f() { for(;;) { while(x) { if (a) { for(;;) { if (b) {} } } } } }" },
        },
    });
}

test "prefer-enum-initializers" {
    try RuleTester.run(.{
        .rule = "prefer-enum-initializers",
        .lang = .ts,
        .valid = &.{
            "enum Foo { A = 0, B = 1, C = 2 }",
            "enum Foo { A = 'a', B = 'b' }",
        },
        .invalid = &.{
            .{ .code = "enum Foo { A, B, C }", .errors = 3 },
            .{ .code = "enum Foo { A = 1, B }", .errors = 1 },
        },
    });
}

test "default-case-last" {
    try RuleTester.run(.{
        .rule = "default-case-last",
        .valid = &.{
            "switch (x) { case 1: break; case 2: break; default: break; }",
            "switch (x) { default: break; }",
        },
        .invalid = &.{
            .{ .code = "switch (x) { default: break; case 1: break; }" },
            .{ .code = "switch (x) { case 1: break; default: break; case 2: break; }" },
        },
    });
}

test "guard-for-in" {
    try RuleTester.run(.{
        .rule = "guard-for-in",
        .valid = &.{
            "for (key in obj) { if (obj.hasOwnProperty(key)) {} }",
            "for (key in obj) if (Object.hasOwn(obj, key)) {}",
        },
        .invalid = &.{
            .{ .code = "for (key in obj) { console.log(key); }" },
            .{ .code = "for (key in obj) doSomething(key);" },
        },
    });
}

test "max-lines" {
    // Valid: short file — tested implicitly since all tests are short
    // Just test the rule exists and fires on a 300+ line source
    const long_source = "\n" ** 301 ++ "const x = 1;";
    try RuleTester.run(.{
        .rule = "max-lines",
        .valid = &.{
            "const x = 1;",
        },
        .invalid = &.{
            .{ .code = long_source },
        },
    });
}

test "no-mixed-operators" {
    try RuleTester.run(.{
        .rule = "no-mixed-operators",
        .valid = &.{
            "const x = a && b && c;",
            "const x = a || b || c;",
            "const x = (a && b) || c;",
            "const x = a && (b || c);",
        },
        .invalid = &.{
            .{ .code = "const x = a && b || c;" },
            .{ .code = "const x = a || b && c;" },
        },
    });
}

test "consistent-this" {
    try RuleTester.run(.{
        .rule = "consistent-this",
        .valid = &.{
            "const that = this;",
            "const x = 1;",
        },
        .invalid = &.{
            .{ .code = "const self = this;" },
            .{ .code = "const _this = this;" },
        },
    });
}

test "no-extra-non-null-assertion" {
    try RuleTester.run(.{
        .rule = "no-extra-non-null-assertion",
        .lang = .ts,
        .valid = &.{
            "const x = foo!;",
            "const x = foo?.bar;",
        },
        .invalid = &.{
            .{ .code = "const x = foo!!;" },
            .{ .code = "const x = foo!!.bar;" },
        },
    });
}

test "no-undef-init" {
    try RuleTester.run(.{
        .rule = "no-undef-init",
        .valid = &.{
            "let x;",
            "let x = null;",
            "let x = 0;",
        },
        .invalid = &.{
            .{ .code = "let x = undefined;" },
            .{ .code = "var foo = undefined;" },
        },
    });
}

test "new-cap" {
    try RuleTester.run(.{
        .rule = "new-cap",
        .valid = &.{
            "new MyClass();",
            "new Error('msg');",
            "new Map();",
        },
        .invalid = &.{
            .{ .code = "new myClass();" },
            .{ .code = "new foo();" },
        },
    });
}

test "no-empty-object-type" {
    try RuleTester.run(.{
        .rule = "no-empty-object-type",
        .lang = .ts,
        .valid = &.{
            "type T = { x: number };",
            "type T = Record<string, unknown>;",
        },
        .invalid = &.{
            .{ .code = "type T = {};" },
            .{ .code = "function f(x: {}) {}" },
        },
    });
}

test "consistent-type-assertions" {
    try RuleTester.run(.{
        .rule = "consistent-type-assertions",
        .lang = .ts,
        .valid = &.{
            "const x = foo as string;",
            "const x = foo as unknown;",
        },
        .invalid = &.{
            .{ .code = "const x = <string>foo;" },
            .{ .code = "const x = <number>bar;" },
        },
    });
}

test "array-type" {
    try RuleTester.run(.{
        .rule = "array-type",
        .lang = .ts,
        .valid = &.{
            "type T = string[];",
            "type T = readonly string[];",
        },
        .invalid = &.{
            .{ .code = "type T = Array<string>;" },
            .{ .code = "type T = ReadonlyArray<number>;" },
        },
    });
}

test "max-classes-per-file" {
    try RuleTester.run(.{
        .rule = "max-classes-per-file",
        .valid = &.{
            "class Foo {}",
            "const x = 1;",
        },
        .invalid = &.{
            .{ .code = "class Foo {} class Bar {}" },
            .{ .code = "class A {} class B {} class C {}" },
        },
    });
}

test "prefer-namespace-keyword" {
    try RuleTester.run(.{
        .rule = "prefer-namespace-keyword",
        .lang = .ts,
        .valid = &.{
            "namespace Foo {}",
        },
        .invalid = &.{
            .{ .code = "module Foo {}" },
        },
    });
}

test "triple-slash-reference" {
    try RuleTester.run(.{
        .rule = "triple-slash-reference",
        .lang = .ts,
        .valid = &.{
            "// regular comment\nconst x = 1;",
            "import type { Foo } from './foo';",
        },
        .invalid = &.{
            .{ .code = "/// <reference path='./foo' />\nconst x = 1;" },
            .{ .code = "/// <reference types='node' />\nconst x = 1;" },
        },
    });
}

test "no-unnecessary-boolean-literal-compare" {
    try RuleTester.run(.{
        .rule = "no-unnecessary-boolean-literal-compare",
        .lang = .ts,
        .valid = &.{
            "if (x) {}",
            "if (x === y) {}",
            "if (x == null) {}",
        },
        .invalid = &.{
            .{ .code = "if (x === true) {}" },
            .{ .code = "if (x !== false) {}" },
            .{ .code = "if (true === x) {}" },
        },
    });
}

test "prefer-while" {
    try RuleTester.run(.{
        .rule = "prefer-while",
        .valid = &.{
            "while (true) {}",
            "for (let i = 0; i < 10; i++) {}",
            "for (let i = 0; ; i++) {}",
        },
        .invalid = &.{
            .{ .code = "for (;;) {}" },
            .{ .code = "for (;;) { if (x) break; }" },
        },
    });
}

test "no-useless-switch-case" {
    try RuleTester.run(.{
        .rule = "no-useless-switch-case",
        .valid = &.{
            "switch (x) { case 1: foo(); break; default: bar(); }",
            "switch (x) { case 1: case 2: foo(); break; }",
        },
        .invalid = &.{
            .{ .code = "switch (x) { case 1: default: foo(); }" },
        },
    });
}

test "no-dynamic-delete" {
    try RuleTester.run(.{
        .rule = "no-dynamic-delete",
        .lang = .ts,
        .valid = &.{
            "delete obj.prop;",
        },
        .invalid = &.{
            .{ .code = "delete obj[key];" },
            .{ .code = "delete obj[computed + key];" },
            .{ .code = "delete obj['literal-key'];" },
        },
    });
}

test "prefer-ts-expect-error" {
    try RuleTester.run(.{
        .rule = "prefer-ts-expect-error",
        .lang = .ts,
        .valid = &.{
            "// @ts-expect-error\nconst x: number = 'str';",
            "// regular comment",
        },
        .invalid = &.{
            .{ .code = "// @ts-ignore\nconst x: number = 'str';" },
        },
    });
}

// ══════════════════════════════════════════════════════════════
// Clean Code
// ══════════════════════════════════════════════════════════════

test "clean code produces no diagnostics" {
    const diags = try lintSource(
        \\const add = (a, b) => a + b;
        \\const sum = add(1, 2);
        \\if (sum > 0) {
        \\    throw new Error("positive");
        \\}
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
