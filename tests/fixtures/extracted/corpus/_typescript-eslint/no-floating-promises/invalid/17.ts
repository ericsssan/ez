
async function test() {
  const obj = { foo: Promise.resolve() };
  obj.foo;
}
      