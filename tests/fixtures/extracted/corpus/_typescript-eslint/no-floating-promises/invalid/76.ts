
class UnsafePromise<T> extends Promise<T> {}
let promise: () => UnsafePromise<number> = async () => 5;
promise().finally();
      