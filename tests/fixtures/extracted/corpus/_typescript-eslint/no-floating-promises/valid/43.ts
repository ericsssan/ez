
class SafePromise<T> extends Promise<T> {}
let promise: { a: SafePromise<number> } = { a: Promise.resolve(5) };
promise.a;
      