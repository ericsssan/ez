
const doSomething = async (
  obj1: { a?: { b?: { c?: () => Promise<void> } } },
  obj2: { a?: { b?: { c: () => Promise<void> } } },
  obj3: { a?: { b: { c?: () => Promise<void> } } },
  obj4: { a: { b: { c?: () => Promise<void> } } },
  obj5: { a?: () => { b?: { c?: () => Promise<void> } } },
  obj6?: { a: { b: { c?: () => Promise<void> } } },
  callback?: () => Promise<void>,
): Promise<void> => {
  obj1.a?.b?.c?.();
  obj2.a?.b?.c();
  obj3.a?.b.c?.();
  obj4.a.b.c?.();
  obj5.a?.().b?.c?.();
  obj6?.a.b.c?.();

  callback?.();
};

doSomething();
      