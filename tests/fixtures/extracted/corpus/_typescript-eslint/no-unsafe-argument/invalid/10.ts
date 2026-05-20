
declare function foo(arg1: string, arg2: number): void;
foo(...(['foo', 1, 2] as [string, any, number]));
      