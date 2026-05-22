
declare const you: [];
declare const cannot: [];
declare const fool: [];
declare const me: [(x: Error) => void] | undefined;
Promise.resolve(undefined).catch(...you, ...cannot, ...fool, ...me!);
    