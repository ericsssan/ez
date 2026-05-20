
function foo(templates: TemplateStringsArray, arg: number) {}
declare const arg: any;
foo`${arg}`;
      