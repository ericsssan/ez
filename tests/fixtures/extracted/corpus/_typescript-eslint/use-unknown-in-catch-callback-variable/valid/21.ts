
      declare const arrayArg: (() => void)[];
      Promise.resolve().then(...arrayArg, error => {});
    