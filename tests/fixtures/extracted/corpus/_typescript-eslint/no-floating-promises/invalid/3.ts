
declare const myTag: (strings: TemplateStringsArray) => Promise<void>;
myTag`abc`.then(() => {});
      