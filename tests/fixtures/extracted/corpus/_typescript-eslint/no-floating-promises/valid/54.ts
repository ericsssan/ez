
type Foo<T> = Promise<T> & { hey?: string };
declare const arrayOrPromiseTuple: Foo<unknown>[];
arrayOrPromiseTuple;
      