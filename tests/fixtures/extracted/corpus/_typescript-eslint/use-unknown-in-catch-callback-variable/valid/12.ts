
      declare const catchArgs: ['not callable'];
      Promise.reject(new Error()).catch(...catchArgs);
    