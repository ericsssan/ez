
declare const really: undefined[];
declare const dumb: [];
declare const code: (x: Error) => void;
Promise.resolve(undefined).catch(...really, ...dumb, code);
    