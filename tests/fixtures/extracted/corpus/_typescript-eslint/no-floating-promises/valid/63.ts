
declare const promiseArray: Array<Promise<unknown>>;
async function* generator() {
  yield* promiseArray;
}
      