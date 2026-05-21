
async function test() {
  class CanThen extends Promise<number> {}
  const canThen: CanThen = Foo.resolve(2);

  canThen;
  canThen.then(() => {});
  canThen.catch();
  canThen.finally();
}
      