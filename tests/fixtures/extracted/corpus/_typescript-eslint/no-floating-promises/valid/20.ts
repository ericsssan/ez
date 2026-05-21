
declare const returnsPromise: () => Promise<void> | null;
async function test() {
  await returnsPromise?.();
  returnsPromise()?.then(
    () => {},
    () => {},
  );
  returnsPromise()
    ?.then(() => {})
    ?.catch(() => {});
  returnsPromise()?.catch(() => {});
  return returnsPromise();
}
    