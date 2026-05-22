
type A = Map<string, string>;
type B<T = A> = T;
type C2 = B<Map<string, number>>;
    