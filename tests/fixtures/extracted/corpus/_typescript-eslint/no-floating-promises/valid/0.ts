
async function test() {
  await Promise.resolve('value');
  Promise.resolve('value').then(
    () => {},
    () => {},
  );
  Promise.resolve('value')
    .then(() => {})
    .catch(() => {});
  Promise.resolve('value')
    .then(() => {})
    .catch(() => {})
    .finally(() => {});
  Promise.resolve('value').catch(() => {});
  return Promise.resolve('value');
}
    