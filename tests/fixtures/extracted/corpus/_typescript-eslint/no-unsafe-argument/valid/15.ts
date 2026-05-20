
declare function foo<E extends string[]>(...params: E): void;

foo('a', 'b', 1 as any);
    