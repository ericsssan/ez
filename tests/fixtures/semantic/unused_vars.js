// Used variables
let used = 1;
console.log(used);

// Unused variable
let unused = 2;

// Read-only usage
const readOnly = 3;
if (readOnly > 0) {}

// Write-only usage
let writeOnly;
writeOnly = 5;

// Used in nested scope
let outerVar = 1;
function useOuter() {
    return outerVar;
}

// Parameter unused
function unusedParam(a, b) {
    return a;
    // b is unused
}

// Destructured — some unused
const { x, y } = obj;
console.log(x);
// y is unused

// Import unused
// import { foo, bar } from 'mod';
// console.log(foo); // bar is unused

// Used only as typeof
let typeofOnly;
typeof typeofOnly;

// Assignment to const (error)
const immutable = 1;
// immutable = 2; // TypeError
