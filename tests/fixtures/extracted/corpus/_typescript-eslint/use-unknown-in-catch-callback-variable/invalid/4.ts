
Promise.resolve().catch(
  (
    ...err: [
      unknown[],
      string | ((number | unknown) & { b: () => void }),
      string,
    ]
  ) => {
    throw err;
  },
);
      