// Array destructuring
const [a, b, c] = [1, 2, 3];
const [first, ...rest] = [1, 2, 3, 4];
const [x, , z] = [1, 2, 3]; // hole

// Object destructuring
const { name, age } = person;
const { name: n, age: a2 } = person;
const { x: { y: { z: deep } } } = nested;
const { a: a3 = 1, b: b3 = 2 } = obj; // defaults

// Destructuring in parameters
function greet({ name, greeting = "Hello" }) {
    return `${greeting}, ${name}!`;
}

// Destructuring in for-of
for (const [key, value] of entries) {
    console.log(key, value);
}

// Mixed
const { data: [first2, ...rest2], meta: { total } } = response;
