
type InvalidHandler = (arg: any) => void;
Promise.resolve().catch(<InvalidHandler>(
  function (err /* awkward spot for comment */) {
    throw err;
  }
));
    