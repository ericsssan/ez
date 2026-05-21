
type SafePromise = Promise<number> & { __linterBrands?: string };
declare const myTag: (strings: TemplateStringsArray) => SafePromise;
myTag`abc`;
      