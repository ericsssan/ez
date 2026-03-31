const add = (a, b) => a + b;
const multiply = (x, y) => x * y;

const result = add(1, 2);
const product = multiply(3, 4);

if (result > 0 && product > 0) {
    throw new Error("positive result");
}

const arr = [1, 2, 3];
const doubled = arr.map((item) => item * 2);

if (doubled.length > 0) {
    throw new Error("has items");
}
