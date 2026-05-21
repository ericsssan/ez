
declare const promiseIntersection: Promise<number> & number;
(async function () {
  promiseIntersection;
  promiseIntersection.then(() => {});
  promiseIntersection.catch();
  promiseIntersection.finally();
})();
      