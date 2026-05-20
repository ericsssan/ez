
declare function foo(arg: any, arg2: number): void;
const x = [1 as any, 2] as const;
foo(...x);
    