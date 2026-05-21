
declare const promiseIntersection: Promise<number> & number;

async function test() {
  promiseIntersection;
  promiseIntersection.then(() => {});
  promiseIntersection.catch();
}
      