
async function test() {
  Math.random() > 0.5 ? Promise.resolve() : null;
  Math.random() > 0.5 ? null : Promise.resolve();
}
      