
interface Foo<T = string> {}
declare var Foo: {
  new <T>(type: T): any;
};
class Bar extends Foo<string> {}
    