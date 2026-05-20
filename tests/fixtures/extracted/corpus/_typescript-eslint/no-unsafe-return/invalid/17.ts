
declare function foo(arg: null | (() => any)): void;
foo(() => 'foo' as any);
      