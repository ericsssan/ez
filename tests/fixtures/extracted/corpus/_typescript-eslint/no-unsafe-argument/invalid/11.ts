
declare function foo(arg1: string, arg2: number, arg2: string): void;

const x = [1] as const;
foo('a', ...x, 1 as any);
      