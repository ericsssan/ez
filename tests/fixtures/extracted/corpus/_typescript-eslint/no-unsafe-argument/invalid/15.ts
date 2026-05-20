
declare function foo(param1: string, ...params: [number, string, any]): void;
foo('a', 1 as any, 'a' as any, 1 as any);
      