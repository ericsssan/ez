
declare function foo(arg: () => any): void;
foo((): any => 'foo' as any);
    