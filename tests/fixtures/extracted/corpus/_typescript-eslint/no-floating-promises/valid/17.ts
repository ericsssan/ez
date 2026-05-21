
async function test() {
  class NonFunctionThenable {
    then: number;
  }
  const thenable = new NonFunctionThenable();

  thenable;
  thenable.then;
  return thenable;
}
    