// var redeclaration (allowed)
var a = 1;
var a = 2; // OK

// let redeclaration (error)
// let b = 1;
// let b = 2; // SyntaxError

// const redeclaration (error)
// const c = 1;
// const c = 2; // SyntaxError

// var + let conflict (error)
// var d = 1;
// let d = 2; // SyntaxError

// function + var (allowed in sloppy mode)
function e() {}
var e = 1; // OK in sloppy mode

// function + let (error)
// function f() {}
// let f = 1; // SyntaxError

// Parameters and var (allowed)
function params(x) {
    var x = 10; // OK — var can shadow parameter
    return x;
}

// Parameters and let (error in strict mode)
function paramsLet(x) {
    // let x = 10; // SyntaxError in strict mode
    return x;
}

// Catch parameter
try {
    throw new Error();
} catch (err) {
    // let err = 1; // SyntaxError — conflicts with catch param
    var err = 1; // OK — var hoists past catch scope
}

// Class name binding
class MyClass {
    method() {
        // MyClass is accessible here
        return new MyClass();
    }
}
