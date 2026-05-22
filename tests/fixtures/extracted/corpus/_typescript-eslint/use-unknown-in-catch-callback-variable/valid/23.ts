
declare const catchArgs: [
  string | (() => never) | ((x: string) => void),
  number,
];
Promise.reject(new Error()).catch(...catchArgs);
    