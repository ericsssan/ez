
async function test() {
  class CatchableThenable {
    then(callback: () => void, callback: () => void): CatchableThenable {
      return new CatchableThenable();
    }
  }
  const thenable = new CatchableThenable();

  thenable;
  thenable.then(() => {});
}
      