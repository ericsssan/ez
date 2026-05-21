
declare const x: Generator<number, Promise<number>, void>;
function* generator(): Generator<number, void, void> {
  yield* x;
}
      