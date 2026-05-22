
Promise.resolve().catch(
  (err: string | ((number | unknown) & { b: () => void })) => {
    throw err;
  },
);
      