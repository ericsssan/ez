
      declare const catchArgs: [(x: unknown) => void];
      Promise.reject(new Error()).catch(...catchArgs);
    