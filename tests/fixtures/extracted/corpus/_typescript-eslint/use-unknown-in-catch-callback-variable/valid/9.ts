
      declare const notAPromise: { catch: (f: Function) => void };
      notAPromise.catch((...args: [a: string, string]) => {
        throw args[0];
      });
    