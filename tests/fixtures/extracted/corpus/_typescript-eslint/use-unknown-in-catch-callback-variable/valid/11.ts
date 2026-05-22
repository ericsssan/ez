
      declare const catchArgs: [
        string | (() => never),
        (shouldntFlag: string) => void,
        number,
      ];
      Promise.reject(new Error()).catch(...catchArgs);
    