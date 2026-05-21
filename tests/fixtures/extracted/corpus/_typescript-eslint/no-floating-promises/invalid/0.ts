
async function test() {
  Promise.resolve('value');
  Promise.resolve('value').then(() => {});
  Promise.resolve('value').catch();
  Promise.resolve('value').finally();
}
      