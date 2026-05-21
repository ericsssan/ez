
declare const promiseValue: Promise<number>;
async function test() {
  await promiseValue;
  promiseValue.then(
    () => {},
    () => {},
  );
  promiseValue.then(() => {}).catch(() => {});
  promiseValue
    .then(() => {})
    .catch(() => {})
    .finally(() => {});
  promiseValue.catch(() => {});
  return promiseValue;
}
    