
type Foo = Promise<number> & { hey?: string };
let promise: () => Foo = async () => 5;
promise().finally();
      