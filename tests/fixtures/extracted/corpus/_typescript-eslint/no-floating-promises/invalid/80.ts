
type SafePromise = Promise<number> & { hey?: string };
let foo: SafePromise = Promise.resolve(1);
let bar = [Promise.resolve(2), foo];
bar;
      