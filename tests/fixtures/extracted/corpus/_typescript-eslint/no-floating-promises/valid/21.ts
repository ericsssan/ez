
const doSomething = async (
  obj1: { a?: { b?: { c?: () => Promise<void> } } },
  obj2: { a?: { b?: { c: () => Promise<void> } } },
  obj3: { a?: { b: { c?: () => Promise<void> } } },
  obj4: { a: { b: { c?: () => Promise<void> } } },
  obj5: { a?: () => { b?: { c?: () => Promise<void> } } },
  obj6?: { a: { b: { c?: () => Promise<void> } } },
  callback?: () => Promise<void>,
): Promise<void> => {
  await obj1.a?.b?.c?.();
  await obj2.a?.b?.c();
  await obj3.a?.b.c?.();
  await obj4.a.b.c?.();
  await obj5.a?.().b?.c?.();
  await obj6?.a.b.c?.();

  return callback?.();
};

void doSomething();
    