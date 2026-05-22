
      Promise.resolve().catch((...args: [unknown]) => {
        throw args[0];
      });
    