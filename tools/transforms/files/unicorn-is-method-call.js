// Programmatic transform for unicorn's `rules/ast/is-method-call.js`.
//
// `isMethodCall(node, ...)` is one of the hottest unicorn helpers
// — most calls match either:
//   isMethodCall(node, "push")
//   isMethodCall(node, ["push", "pop"])
//   isMethodCall(node, { methods: [...] })
//   isMethodCall(node, { method: "X", optionalCall: false, optionalMember: false })
//
// Stock implementation fans every call out into
// `isCallExpression(node, {...})` + `isMemberExpression(node.callee, {...})`
// + the full body of unicorn's generic `create()` — three frames per
// hit and plenty of property reads even when no real constraint is
// present. Profile attributed ~3% Total to `isMethodCall` plus its
// share of the helpers it calls.
//
// Fast-path the common shapes inline. Bail to the upstream slow
// path whenever an option that we'd have to forward is actually
// present (argumentsLength, allowSpreadElement, object, etc.).

// Bun.build resolves unicorn from the user-home node_modules (see TARGETS
// in tools/rule-transpile.js — `base: /Users/ericsan/node_modules/...`),
// so the upstream key must match that path. The project-local copy is a
// duplicate install left over and not what the bundler loads.
export const upstreamPath = "/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js";

export function transform(src) {
  if (!src.includes("export default function isMethodCall(node, options)")) {
    throw new Error("upstream isMethodCall shape changed (transform anchor missed)");
  }
  if (!src.includes("if (typeof options === 'string') {\n\t\toptions = {methods: [options]};\n\t}")) {
    throw new Error("upstream isMethodCall string-normalisation shape changed");
  }

  const fastPath = `\t// ez build-time fast-path. The hot rejection — node not a
\t// CallExpression, or its callee not a MemberExpression — is
\t// answered by one Uint8Array read from the precomputed shape
\t// bits (bit 0x01 = is-method-call-shape). Replaces the
\t// type+callee+type-getter chain. ~73% of calls reject here.
\t// For NodeView inputs whose options are simple (methods/method,
\t// optionalCall/optionalMember), inline the membership check.
\t// Falls through to upstream for complex options or non-NodeView
\t// inputs (test fixtures pass plain ESTree objects).
\tif (node && node._ast) {
\t\tif ((node._ast._shapeBits[node._i] & 0x01) === 0) return false;
\t\tconst _ez_callee = node.callee;
\t\tif (typeof options === 'string') {
\t\t\tconst _p = _ez_callee.property;
\t\t\treturn !_ez_callee.computed && _p.type === 'Identifier' && _p.name === options;
\t\t}
\t\tif (Array.isArray(options)) {
\t\t\tconst _p = _ez_callee.property;
\t\t\treturn !_ez_callee.computed && _p.type === 'Identifier' && options.includes(_p.name);
\t\t}
\t\tif (options !== undefined && options !== null
\t\t\t&& options.argumentsLength === undefined
\t\t\t&& options.minimumArguments === undefined
\t\t\t&& options.maximumArguments === undefined
\t\t\t&& options.allowSpreadElement === undefined
\t\t\t&& options.object === undefined
\t\t\t&& options.objects === undefined
\t\t\t&& options.computed === undefined
\t\t) {
\t\t\tconst _optC = options.optionalCall;
\t\t\tif (_optC === true && !node.optional) return false;
\t\t\tif (_optC === false && node.optional) return false;
\t\t\tconst _optM = options.optionalMember;
\t\t\tif (_optM === true && !_ez_callee.optional) return false;
\t\t\tif (_optM === false && _ez_callee.optional) return false;
\t\t\tconst _m = options.method;
\t\t\tconst _ms = options.methods;
\t\t\tif (_m === undefined && (_ms === undefined || _ms.length === 0)) return true;
\t\t\tconst _p = _ez_callee.property;
\t\t\tif (_p.type !== 'Identifier') return false;
\t\t\tif (_ez_callee.computed) return false;
\t\t\tif (_m !== undefined && _m !== '' && _p.name !== _m) return false;
\t\t\tif (_ms !== undefined && _ms.length > 0 && !_ms.includes(_p.name)) return false;
\t\t\treturn true;
\t\t}
\t\t// Complex options (argumentsLength, object/objects, etc.) —
\t\t// fall through to upstream which forwards to create() and
\t\t// isMemberExpression with full option handling.
\t}
`;

  // Insert the fast-path right after the function opening brace.
  const opener = "export default function isMethodCall(node, options) {\n";
  return src.replace(opener, opener + fastPath);
}
