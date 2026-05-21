
async function test() {
  (async () => true)();
  (async () => true)().then(() => {});
  (async () => true)().catch();
}
      