
declare const promiseIntersection: Promise<number> & number;
async function test() {
  await promiseIntersection;
  promiseIntersection.then(
    () => {},
    () => {},
  );
  promiseIntersection.then(() => {}).catch(() => {});
  promiseIntersection.catch(() => {});
  return promiseIntersection;
}
    