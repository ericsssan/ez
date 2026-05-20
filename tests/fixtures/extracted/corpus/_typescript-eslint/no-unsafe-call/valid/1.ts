
function foo(x?: { a: () => void }) {
  x?.a();
}
    