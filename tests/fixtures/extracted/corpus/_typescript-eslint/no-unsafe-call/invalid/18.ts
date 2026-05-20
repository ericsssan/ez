
interface UnsafeToConstruct extends Function {
  (): void;
}
declare const unsafe: UnsafeToConstruct;
new unsafe();
      