
declare function foo(arg: number, arg2: number): void;
const x = [1, 2] as const;
foo(...x);
    