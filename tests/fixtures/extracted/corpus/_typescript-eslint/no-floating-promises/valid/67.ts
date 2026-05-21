
        declare module 'abc' {
          export function it(name: string, action: () => void): void;
        }

        it('...', () => {});
      