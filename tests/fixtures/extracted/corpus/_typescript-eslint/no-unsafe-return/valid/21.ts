
      async function fn<T extends any>(x: T): Promise<unknown> {
        return x as any;
      }
    