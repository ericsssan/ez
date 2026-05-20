
interface ConstructSignatureMakesSafe extends Function {
  new (): ConstructSignatureMakesSafe;
}
declare const safe: ConstructSignatureMakesSafe;
new safe();
    