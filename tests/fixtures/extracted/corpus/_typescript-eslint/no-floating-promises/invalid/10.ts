
async function test() {
  (Promise.resolve(), 123);
  (123, Promise.resolve());
  (123, Promise.resolve(), 123);
}
      