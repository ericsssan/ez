
type T = [number, T[]];
function foo(templates: TemplateStringsArray, arg: T) {}
declare const arg: any;
foo`${arg}`;
      