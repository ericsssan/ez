
function foo() {
  return this;
}

function bar() {
  return () => this;
}
      