
declare const promiseUnion: Promise<number> | number;
async function test() {
  await promiseUnion;
  promiseUnion.then(
    () => {},
    () => {},
  );
  promiseUnion.then(() => {}).catch(() => {});
  promiseUnion
    .then(() => {})
    .catch(() => {})
    .finally(() => {});
  promiseUnion.catch(() => {});
  promiseValue.finally(() => {});
  return promiseUnion;
}
    