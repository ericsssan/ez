
async function foo() {
  const myPromise = Promise.resolve(true);
  let condition = false;
  condition || myPromise;
}
      