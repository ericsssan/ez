
      declare const singleTupleArg: [() => void];
      Promise.resolve().then(...singleTupleArg, (error: unknown) => {});
    