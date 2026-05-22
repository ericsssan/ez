
type A = Map<string, string>;
type B<T = A> = T;
type C = B<Map<string, string>>;
      