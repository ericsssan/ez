
declare const maybeFunction: unknown;
if (typeof maybeFunction === 'function') {
  maybeFunction('call', 'with', 'any', 'args');
}
      