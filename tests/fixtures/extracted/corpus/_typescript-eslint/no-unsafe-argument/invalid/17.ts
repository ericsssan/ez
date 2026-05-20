
function foo(
  templates: TemplateStringsArray,
  arg1: number,
  arg2: any,
  arg3: string,
) {}
declare const arg: any;
foo<number>`${arg}${arg}${arg}`;
      