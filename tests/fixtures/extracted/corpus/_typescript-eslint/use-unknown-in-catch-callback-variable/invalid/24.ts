
declare const condition: boolean;
declare const maybeNullishHandler: null | ((err: any) => void);
Promise.resolve('foo').catch(
  condition
    ? ((err => {}, err => {}, maybeNullishHandler) ?? (err => {}))
    : (condition && (err => {})) || (err => {}),
);
      