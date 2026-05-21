
async function test() {
  Promise.resolve().catch(() => {}) ||
    Promise.resolve().then(
      () => {},
      () => {},
    );
}
    