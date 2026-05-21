
async function test() {
  class Thenable {
    then(callback: () => void): Thenable {
      return new Thenable();
    }
  }
  const thenable = new Thenable();

  await thenable;
  thenable;
  thenable.then(() => {});
  return thenable;
}
    