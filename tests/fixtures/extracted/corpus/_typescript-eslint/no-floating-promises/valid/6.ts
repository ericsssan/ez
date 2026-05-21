
async function test() {
  Math.random() > 0.5 ? Promise.resolve().catch(() => {}) : null;
}
    