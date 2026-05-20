
async function foo() {
  return {} as Promise<any> & { __brand: 'any' };
}
      