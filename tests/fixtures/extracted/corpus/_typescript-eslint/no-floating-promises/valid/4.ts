
async function test() {
  async function returnsPromise() {}
  await returnsPromise();
  returnsPromise().then(
    () => {},
    () => {},
  );
  returnsPromise()
    .then(() => {})
    .catch(() => {});
  returnsPromise()
    .then(() => {})
    .catch(() => {})
    .finally(() => {});
  returnsPromise().catch(() => {});
  return returnsPromise();
}
    