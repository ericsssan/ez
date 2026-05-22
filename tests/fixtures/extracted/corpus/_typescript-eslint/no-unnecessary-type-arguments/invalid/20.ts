
class Foo<T = string> {}
namespace Foo {
  export class Bar {}
}
class Bar extends Foo<string> {}
      