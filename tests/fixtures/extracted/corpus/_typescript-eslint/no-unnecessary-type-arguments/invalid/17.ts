
interface Foo {}
declare var Foo: {
  new <T = string>(type: T): any;
};
class Bar extends Foo<string> {}
      