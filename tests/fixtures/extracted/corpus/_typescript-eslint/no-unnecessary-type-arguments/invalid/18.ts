
declare var Foo: {
  new <T = string>(type: T): any;
};
interface Foo {}
class Bar extends Foo<string> {}
      