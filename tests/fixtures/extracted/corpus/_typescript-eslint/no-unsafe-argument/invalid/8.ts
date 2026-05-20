
declare function foo(arg1: string, arg2: number): void;

const x = ['a', 1 as any] as const;
foo(...x);
      