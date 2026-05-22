
Promise.resolve('object destructuring').catch(function ({ gotcha }) {
  return null;
});
      