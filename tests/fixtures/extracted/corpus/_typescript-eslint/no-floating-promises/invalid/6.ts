
async function test() {
  Promise.reject(new Error('message'));
  Promise.reject(new Error('message')).then(() => {});
  Promise.reject(new Error('message')).catch();
  Promise.reject(new Error('message')).finally();
}
      