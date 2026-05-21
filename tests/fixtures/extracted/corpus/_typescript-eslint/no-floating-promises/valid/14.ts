
declare const intersectionPromise: Promise<number> & number;
async function test() {
  await (Math.random() > 0.5 ? numberPromise : 0);
  await (Math.random() > 0.5 ? foo : 0);
  await (Math.random() > 0.5 ? bar : 0);

  await intersectionPromise;
}
    