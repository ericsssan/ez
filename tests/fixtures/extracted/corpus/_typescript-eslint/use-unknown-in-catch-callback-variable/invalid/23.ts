
declare const condition: boolean;
Promise.resolve('foo').then(() => {}, condition ? err => {} : err => {});
      