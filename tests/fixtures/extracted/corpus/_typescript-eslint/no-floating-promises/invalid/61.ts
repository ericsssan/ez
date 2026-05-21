
declare const promiseArray: Array<Promise<unknown>>;
async function f() {
  await promiseArray;
}
      