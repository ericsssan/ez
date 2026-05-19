const add = (a, b) => a + b;
const multiply = (x, y) => x * y;

const result = add(1, 2);
const product = multiply(3, 4);

const positive = result > 0 && product > 0;

const arr = [1, 2, 3];
const doubled = arr.map((item) => item * 2);

const hasItems = doubled.length > 0;
const both = positive && hasItems;
