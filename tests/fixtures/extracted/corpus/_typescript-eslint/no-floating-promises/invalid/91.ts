
declare const x: any;
function* generator(): Generator<number, void, Promise<number>> {
  yield x;
}
      