
class SafePromise<T> extends Promise<T> {}
let promise: () => SafePromise<number> = async () => 5;
0 || promise();
      