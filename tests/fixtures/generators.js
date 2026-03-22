// Generator function
function* fibonacci() {
    let a = 0, b = 1;
    while (true) {
        yield a;
        [a, b] = [b, a + b];
    }
}

// Generator with return
function* gen() {
    yield 1;
    yield 2;
    return 3;
}

// yield delegation
function* delegating() {
    yield* [1, 2, 3];
    yield* gen();
}

// Generator expression
const genExpr = function* () {
    yield 1;
};

// Generator method in class
class Collection {
    #items = [];

    *[Symbol.iterator]() {
        yield* this.#items;
    }

    *entries() {
        for (let i = 0; i < this.#items.length; i++) {
            yield [i, this.#items[i]];
        }
    }
}

// Async generator
async function* asyncRange(start, end) {
    for (let i = start; i < end; i++) {
        await new Promise(resolve => setTimeout(resolve, 100));
        yield i;
    }
}
