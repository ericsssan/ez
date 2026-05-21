
async function foo() {
  const myPromise = Promise.resolve(true);
  let condition = true;
  condition && myPromise;
}
      