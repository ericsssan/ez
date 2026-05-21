
async function foo() {
  const myPromise = async () => void 0;
  const condition = true;

  void condition || myPromise();
}
      