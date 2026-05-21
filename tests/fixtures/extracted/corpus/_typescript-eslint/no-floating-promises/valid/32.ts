
async function foo() {
  const myPromise = async () => void 0;
  let condition = false;
  condition && myPromise();
  condition = true;
  condition || myPromise();
  condition ?? myPromise();
}
      