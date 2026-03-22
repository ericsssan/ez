// Temporal Dead Zone examples

// let TDZ
function letTDZ() {
    // x is in TDZ here
    // console.log(x); // ReferenceError
    let x = 1;
    console.log(x); // OK
}

// const TDZ
function constTDZ() {
    // y is in TDZ here
    const y = 2;
    return y;
}

// TDZ in default parameters
function paramTDZ(a = b, b = 1) {
    // a = b throws because b is in TDZ when a's default is evaluated
    return a + b;
}

// Class TDZ
// const c = new MyClass(); // ReferenceError
class MyClass {
    constructor() {
        this.value = 1;
    }
}

// TDZ scope boundary
function tdzBoundary() {
    let x = "outer";
    {
        // x refers to the inner x which is in TDZ
        // console.log(x); // ReferenceError
        let x = "inner";
    }
}

// typeof and TDZ
function typeofTDZ() {
    // typeof on undeclared is OK
    typeof undeclaredVar; // "undefined"

    // typeof on TDZ variable still throws
    // typeof y; // ReferenceError
    let y = 1;
}
