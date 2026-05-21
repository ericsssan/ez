
async function test() {
  await Promise.reject(new Error('message'));
  Promise.reject(new Error('message')).then(
    () => {},
    () => {},
  );
  Promise.reject(new Error('message'))
    .then(() => {})
    .catch(() => {});
  Promise.reject(new Error('message'))
    .then(() => {})
    .catch(() => {})
    .finally(() => {});
  Promise.reject(new Error('message')).catch(() => {});
  return Promise.reject(new Error('message'));
}
    