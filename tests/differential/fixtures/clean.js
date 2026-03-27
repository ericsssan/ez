// This file should produce zero diagnostics from both ESLint and Sx3lint.

"use strict";

function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

const result = fibonacci(10);
console.log("fib(10) =", result);

class Stack {
    constructor() {
        this.items = [];
    }

    push(item) {
        this.items.push(item);
    }

    pop() {
        return this.items.pop();
    }

    get size() {
        return this.items.length;
    }
}

const stack = new Stack();
stack.push(1);
stack.push(2);
console.log(stack.pop(), stack.size);
