
type T = [number, T[]];
declare function foo(t: T): void;
declare const t: T;

foo(t);
    