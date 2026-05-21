
declare const definitelyCallable: () => void;
Promise.reject().catch(definitelyCallable);
      