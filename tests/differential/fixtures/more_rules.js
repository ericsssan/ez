// Differential test fixture — triggers the remaining comparable rules.

// for-direction (loop going wrong way)
for (var i = 10; i >= 0; i++) {}

// getter-return (getter missing return on all paths)
var gObj = { get gVal() { if (true) return 1; } };

// no-async-promise-executor
var p1 = new Promise(async function(resolve) { resolve(1); });

// no-compare-neg-zero
var x = 0;
if (x === -0) {}

// no-const-assign
const c1 = 1;
c1 = 2;

// no-dupe-args
function dupeArgs(a, b, a) { return a + b; }

// no-dupe-class-members
class DupeMembers {
  foo() { return 1; }
  foo() { return 2; }
}

// no-dupe-else-if
var cond = true;
if (cond) {} else if (cond) {}

// no-duplicate-case
switch (x) { case 1: break; case 1: break; }

// no-empty-pattern
var {} = {};
var [] = [];

// no-ex-assign
try { throw new Error(); } catch (e) { e = 1; }

// no-extra-semi
;

// no-fallthrough
switch (x) { case 1: doA(); case 2: doB(); break; }

// no-func-assign
function funcToAssign() {}
funcToAssign = 1;

// no-global-assign
undefined = 1;

// no-inner-declarations
if (true) { function innerFunc() {} }

// no-new-symbol
var sym = new Symbol("desc");

// no-obj-calls
var m = Math();

// no-prototype-builtins
var hasOwn = {}.hasOwnProperty("key");

// no-self-assign
var sa = 1;
sa = sa;

// no-setter-return (setter returns a value)
var sObj = { set sVal(v) { return v; } };

// no-template-curly-in-string (dollar-brace in regular string)
var tpl = "Hello ${name}";

// no-unreachable
function unreachFn() { return 1; var dead = 2; }

// no-unsafe-negation
var arr2 = [1, 2, 3];
if (!1 in arr2) {}

// no-unsafe-optional-chaining
var oc = null;
var ocVal = oc?.foo + 1;

// no-useless-catch
try { throw new Error(); } catch (err) { throw err; }

// no-case-declarations
switch (x) { case 1: var caseVar = 1; break; }

// no-control-regex (regex with control char \x00)
var ctrlRe = /\x00/;

// no-delete-var
var delVar = 1;
delete delVar;

// no-empty-character-class
var ecc = /re[]/;

// no-implied-eval
setTimeout("doSomething()", 100);

// no-label-var
var labelName = 1;
labelName: for (var k = 0; k < 1; k++) { break labelName; }

// no-lone-blocks
{ var loneBlock = 1; }

// no-multi-str
var ms = "multi\
line";

// no-nonoctal-decimal-escape
var nod = "\9";

// no-octal
var oct = 071;

// no-redeclare
var rd = 1;
var rd = 2;

// no-regex-spaces
var rs = /x  y/;

// no-restricted-globals
var ev = event;

// no-sequences
var seq = (1, 2, 3);

// no-shadow-restricted-names
var undefined2; var NaN2; // can't shadow undefined directly in many engines
function shadowUnd(undefined) { return undefined; }

// no-unused-labels
unused_label: var ul = 1;

// no-useless-escape
var ue = "\a";

// no-with
with ({}) {}

// require-yield
function* noYield() { return 1; }

// no-caller
function calleeUser() { return arguments.callee; }

// no-else-return
function elseReturn(x) { if (x) { return 1; } else { return 2; } }

// no-eq-null
if (x == null) {}

// no-extend-native
Array.prototype.myMethod = function() {};

// no-extra-bind
var eb = function() { return 1; }.bind(this);

// no-iterator
var it = { __iterator__: function() {} };

// no-lonely-if
if (true) {} else { if (true) {} }

// no-octal-escape
var oe = "\251";

// no-param-reassign
function paramReassign(p) { p = 1; return p; }

// no-proto
var obj2 = {};
var pr = obj2.__proto__;

// prefer-const (let that is never reassigned)
let neverReassigned = 42;
console.log(neverReassigned);
