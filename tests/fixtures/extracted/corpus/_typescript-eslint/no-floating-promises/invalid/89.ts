
class MyPromise<T> extends Promise<T> {}
declare const createMyPromise: () => MyPromise<number>;
createMyPromise();
      