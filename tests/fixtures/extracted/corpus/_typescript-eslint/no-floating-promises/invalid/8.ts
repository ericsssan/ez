
async function test() {
  async function returnsPromise() {}

  returnsPromise();
  returnsPromise().then(() => {});
  returnsPromise().catch();
  returnsPromise().finally();
}
      