// ASI (Automatic Semicolon Insertion)
let a = 1
let b = 2
return
a + b

// Regex vs division
let x = 10 / 2;
let re = /pattern/gi;
if (/test/.test(str)) {}
let y = (a) / b;

// Optional chaining
obj?.prop;
obj?.[expr];
obj?.method();
arr?.[0];
func?.();

// Nullish coalescing
let val = a ?? b;
a ??= defaultVal;

// Exponentiation
let p = 2 ** 10;

// Comma operator
for (let i = 0, j = 10; i < j; i++, j--) {}

// Labeled statement
outer: for (let i = 0; i < 10; i++) {
    inner: for (let j = 0; j < 10; j++) {
        if (i === j) continue outer;
        if (i + j > 15) break outer;
    }
}

// with statement (sloppy mode)
with (Math) {
    let r = sqrt(x * x + y * y);
}

// debugger
debugger;

// Empty statement
;

// new.target
function Foo() {
    if (!new.target) throw "Must use new";
}

// Hashbang (would be first line in a real file)
// #!/usr/bin/env node
