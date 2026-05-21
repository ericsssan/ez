
class SafePromise<T> extends Promise<T> {}
let promise: SafePromise<number> = Promise.resolve(5);
promise.catch();
      