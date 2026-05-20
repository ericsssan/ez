
declare function foo(arg: null | (() => any)): void;
foo((): any => 'foo' as any);
    