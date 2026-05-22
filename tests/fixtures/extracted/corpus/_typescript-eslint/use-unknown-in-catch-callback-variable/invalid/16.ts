
Promise.resolve(' a string ').catch(
  (a: any, b: () => any, c: (x: string & number) => void) => {},
);
      