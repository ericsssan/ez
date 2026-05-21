
type UnsafePromise = Promise<number> & { hey?: string };
let promise: UnsafePromise = Promise.resolve(5);
0 ? promise.catch() : 2;
      