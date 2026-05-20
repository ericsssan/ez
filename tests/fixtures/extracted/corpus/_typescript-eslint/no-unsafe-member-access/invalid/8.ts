
function foo(x: { a: number }, y: any) {
  x[(y += 1)];
}
      