// Basic switch
switch (fruit) {
    case "apple":
        console.log("Apple");
        break;
    case "banana":
        console.log("Banana");
        break;
    case "cherry":
        console.log("Cherry");
        break;
    default:
        console.log("Unknown");
}

// Fall-through
switch (grade) {
    case "A":
    case "B":
        console.log("Good");
        break;
    case "C":
        console.log("Average");
        break;
    case "D":
    case "F":
        console.log("Needs improvement");
        break;
}

// Switch with expressions
switch (true) {
    case x > 100:
        handleBig();
        break;
    case x > 0:
        handlePositive();
        break;
    default:
        handleOther();
}

// Switch with block scoping
switch (action) {
    case "create": {
        const item = createItem();
        save(item);
        break;
    }
    case "delete": {
        const item = findItem();
        remove(item);
        break;
    }
}
