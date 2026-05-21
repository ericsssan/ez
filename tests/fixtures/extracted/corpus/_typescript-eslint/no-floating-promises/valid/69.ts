
interface SafePromise<T> extends Promise<T> {
  brand: 'safe';
}

declare const createSafePromise: () => SafePromise<string>;
createSafePromise();
      