
interface SafeThenable<T> {
  then<TResult1 = T, TResult2 = never>(
    onfulfilled?:
      | ((value: T) => TResult1 | SafeThenable<TResult1>)
      | undefined
      | null,
    onrejected?:
      | ((reason: any) => TResult2 | SafeThenable<TResult2>)
      | undefined
      | null,
  ): SafeThenable<TResult1 | TResult2>;
}
let promise: () => SafeThenable<number> = () => Promise.resolve(5);
0 ? promise() : 3;
      