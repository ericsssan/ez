
async function test() {
  (Promise.resolve().catch(() => {}), 123);
  (123,
    Promise.resolve().then(
      () => {},
      () => {},
    ));
  (123,
    Promise.resolve().then(
      () => {},
      () => {},
    ),
    123);
}
    