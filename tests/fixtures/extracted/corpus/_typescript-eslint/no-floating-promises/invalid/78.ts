
type UnsafePromise = Promise<number> & { hey?: string };
let promise: () => UnsafePromise = async () => 5;
null ?? promise().catch();
      