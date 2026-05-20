
declare function foo(arg1: string, arg2: number, ...rest: string[]): void;

const x = [1, 2] as [number, ...number[]];
foo('a', ...x, 1 as any);
      