
type Props = { a: string };
declare function Foo(props: Props): never;
<Foo a={1 as any} />;
      