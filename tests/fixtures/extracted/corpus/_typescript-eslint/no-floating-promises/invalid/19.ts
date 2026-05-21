
declare const promiseValue: Promise<number>;

async function test() {
  promiseValue;
  promiseValue.then(() => {});
  promiseValue.catch();
  promiseValue.finally();
}
      