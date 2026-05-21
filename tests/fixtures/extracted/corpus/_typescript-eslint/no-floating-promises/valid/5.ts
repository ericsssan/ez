
async function test() {
  const x = Promise.resolve();
  const y = x.then(() => {});
  y.catch(() => {});
}
    