
declare const maybeCallable: string | (() => void);
Promise.resolve().then(() => {}, maybeCallable);
      