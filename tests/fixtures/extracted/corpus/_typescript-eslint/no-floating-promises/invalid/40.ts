
async function foo() {
  const myPromise = Promise.resolve(true);
  let condition = null;
  condition ?? myPromise;
}
      