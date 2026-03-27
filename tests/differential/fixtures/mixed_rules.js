// Differential test fixture — triggers many rules in both ESLint and Sx3lint.

// no-debugger
debugger;

// no-eval
eval("code");

// no-var
var x = 1;

// eqeqeq
if (x == 1) {}

// no-empty
if (true) {}

// no-sparse-arrays
var arr = [1, , 3];

// no-dupe-keys
var obj = { a: 1, b: 2, a: 3 };

// no-self-compare
if (x === x) {}

// no-void
void 0;

// valid-typeof
if (typeof x === "strig") {}

// no-throw-literal
try { throw "error"; } catch(e) { console.log(e); }

// use-isnan
if (x === NaN) {}

// no-cond-assign
var q; if (q = true) { console.log(q); }

// no-new-wrappers
var s = new String("hi"); console.log(s);

// no-extra-boolean-cast
var bb = true; if (!!bb) {}

// no-floating-decimal
var fl = .5;

// no-new
new Object();

// no-new-func
var nf = new Function("a", "return a"); console.log(nf);

// no-new-object
var no = new Object(); console.log(no);

// no-bitwise
var bw = 1 | 2; console.log(bw);

// no-plusplus
var pp = 1; pp++; console.log(pp);

// no-nested-ternary
var a = true, b = true; var nt = a ? b ? 1 : 2 : 3; console.log(nt);

// no-array-constructor
var ac = new Array(); console.log(ac);

// no-continue
for (var i = 0; i < 10; i++) { continue; }

// no-labels
label: for (var j = 0; j < 10; j++) { break label; }

// no-multi-assign
var ma1, ma2; ma1 = ma2 = 1; console.log(ma1, ma2);

// no-negated-condition
var nc = true; if (!nc) { console.log(1); } else { console.log(2); }

// no-return-assign
var ra = 0; function fra() { return ra = 1; } fra();

// no-unneeded-ternary
var ut = true; var utr = ut ? true : false; console.log(utr);

// prefer-template
var name2 = "world"; var greeting = "hello " + name2; console.log(greeting);

// no-octal
var oct = 071; console.log(oct);

// no-unsafe-finally
function finFn() { try { console.log(1); } finally { return; } } finFn();
