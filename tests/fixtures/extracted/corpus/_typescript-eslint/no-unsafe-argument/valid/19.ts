
type T = Array<T>;
declare function foo<T>(t: T): T;
const t: T = [];
foo(t);
    