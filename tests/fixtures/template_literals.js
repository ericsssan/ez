// Simple template
const greeting = `Hello, world!`;

// With expression
const name = "Alice";
const msg = `Hello, ${name}!`;

// With complex expressions
const result = `${a + b} is the sum of ${a} and ${b}`;

// Nested templates
const nested = `outer ${`inner ${x}`} outer`;

// Tagged template
function tag(strings, ...values) {
    return strings.join("");
}
const tagged = tag`hello ${name} world ${42}`;

// Multi-line
const multi = `
  line 1
  line 2
  line 3
`;

// With method calls
const formatted = `Result: ${obj.method(arg)}`;
