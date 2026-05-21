
async function test() {
  class CanThen extends Promise<number> {}
  const canThen: CanThen = Foo.resolve(2);

  await canThen;
  canThen.then(
    () => {},
    () => {},
  );
  canThen.then(() => {}).catch(() => {});
  canThen
    .then(() => {})
    .catch(() => {})
    .finally(() => {});
  canThen.catch(() => {});
  return canThen;
}
    