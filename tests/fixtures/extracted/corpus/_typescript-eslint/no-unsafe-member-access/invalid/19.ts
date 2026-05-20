
function foo(x: { a: number }, y: NotKnown) {
  x[y];
}
      