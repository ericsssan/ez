
declare const thenArgs: [() => {}, (err: any) => {}];
Promise.resolve().then(...thenArgs);
    