
function _<T, S extends Array<T | Promise<T>>>(
  maybePromiseArray: S | undefined,
): void {
  maybePromiseArray?.[0];
}
      