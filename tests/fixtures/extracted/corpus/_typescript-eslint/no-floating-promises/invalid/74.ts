
interface UnsafeThenable<T> {
  then<TResult1 = T, TResult2 = never>(
    onfulfilled?:
      | ((value: T) => TResult1 | UnsafeThenable<TResult1>)
      | undefined
      | null,
    onrejected?:
      | ((reason: any) => TResult2 | UnsafeThenable<TResult2>)
      | undefined
      | null,
  ): UnsafeThenable<TResult1 | TResult2>;
}
let promise: UnsafeThenable<number> = Promise.resolve(5);
promise;
      