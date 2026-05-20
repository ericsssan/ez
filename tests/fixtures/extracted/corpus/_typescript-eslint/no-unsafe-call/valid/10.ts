
interface CallGoodConstructBad extends Function {
  (): void;
}
declare const safe: CallGoodConstructBad;
safe();
    