
      type Wrapper<T> = { inner: T };
      type Extractor<D extends Wrapper<any>> = D extends Wrapper<infer V> ? V : never;
      const fn =
        <D extends Wrapper<any>>(foo: Extractor<D>) =>
        () =>
          foo;
    