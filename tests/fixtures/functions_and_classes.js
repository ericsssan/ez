// Function declaration
function greet(name) {
    return "Hello, " + name;
}

// Generator function
function* range(start, end) {
    for (let i = start; i < end; i++) {
        yield i;
    }
}

// Async function
async function fetchData(url) {
    const response = await fetch(url);
    return await response.json();
}

// Async generator
async function* streamData() {
    yield 1;
    yield 2;
}

// Arrow functions
const add = (a, b) => a + b;
const square = x => x * x;
const log = () => { console.log("hello"); };

// Async arrow
const fetchAsync = async (url) => {
    const res = await fetch(url);
    return res.json();
};

// Class
class Animal {
    #name;
    static count = 0;

    constructor(name) {
        this.#name = name;
        Animal.count++;
    }

    get name() {
        return this.#name;
    }

    set name(value) {
        this.#name = value;
    }

    speak() {
        return `${this.#name} makes a sound`;
    }

    static create(name) {
        return new Animal(name);
    }

    static {
        console.log("Animal class loaded");
    }
}

class Dog extends Animal {
    breed;

    constructor(name, breed) {
        super(name);
        this.breed = breed;
    }

    speak() {
        return `${super.name} barks`;
    }
}
