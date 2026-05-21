
declare const maybeCallable: string | (() => void);
declare const definitelyCallable: () => void;
Promise.resolve().then(() => {}, undefined);
Promise.resolve().then(() => {}, null);
Promise.resolve().then(() => {}, 3);
Promise.resolve().then(() => {}, maybeCallable);
Promise.resolve().then(() => {}, definitelyCallable);

Promise.resolve().catch(undefined);
Promise.resolve().catch(null);
Promise.resolve().catch(3);
Promise.resolve().catch(maybeCallable);
Promise.resolve().catch(definitelyCallable);
      