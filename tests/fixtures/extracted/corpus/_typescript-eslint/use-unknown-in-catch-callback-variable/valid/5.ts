
      declare const crappyHandler: (() => void) | 2;
      Promise.reject(new Error()).catch(crappyHandler);
    