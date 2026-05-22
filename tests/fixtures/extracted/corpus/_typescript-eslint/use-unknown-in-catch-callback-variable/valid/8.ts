
      Promise.resolve().catch((...args: readonly unknown[]) => {
        throw args[0];
      });
    