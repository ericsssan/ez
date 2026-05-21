
declare const returnsPromise: () => Promise<void> | null;
returnsPromise()?.finally(() => {});
      