
Promise.resolve().catch((...args) => {
  throw args[0];
});
      