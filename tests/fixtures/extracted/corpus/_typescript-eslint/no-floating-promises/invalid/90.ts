
class MyPromise<T> extends Promise<T> {
  additional: string;
}
declare const createMyPromise: () => MyPromise<number>;
createMyPromise();
      