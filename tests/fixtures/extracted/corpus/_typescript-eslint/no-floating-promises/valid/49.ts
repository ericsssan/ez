
type Foo = Promise<number> & { hey?: string };
let promise: () => Foo = () => Promise.resolve(5);
promise();
      