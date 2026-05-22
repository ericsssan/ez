
declare const x: ((x: any) => string)[];
Promise.resolve('string promise').catch(...x);
    