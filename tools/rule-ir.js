// Rule IR v1 — structured, constrained representation of an ESLint rule
// suitable for deterministic translation to Zig.
//
// The grammar is intentionally small. Rules that don't fit get a clear
// "unsupported pattern" signal — expanding the IR is a deliberate versioned
// step (bump IR_VERSION, add node kind, update codegen).
//
// Shape:
//   Rule {
//     irVersion: number
//     name:        string
//     category:    "correctness" | "suspicious" | "style" | "performance"
//     description: string
//     fixable:     "code" | "whitespace" | null
//     messages:    { messageId: text, ... }
//     handlers:    Handler[]
//   }
//   Handler {
//     selector: string    // simple ESTree node name (no esquery compound selectors yet)
//     body:     Statement[]
//   }
//   Statement =
//     | { op: "report",  node: Expr,   messageId: string }
//     | { op: "if",      cond: Expr,   then: Statement[], else?: Statement[] }
//     | { op: "return" }
//   Expr =
//     | { op: "node-ref" }                              // the handler's bound node parameter
//     | { op: "literal", value: string|number|boolean|null }
//     | { op: "identifier", name: string }              // reference to local binding (rare in v1)
//     | { op: "member", object: Expr, property: string, computed: false }
//     | { op: "binary", operator: "===" | "!==" | "==" | "!=" | "<" | "<=" | ">" | ">=" | "&&" | "||",
//                      lhs: Expr, rhs: Expr }

"use strict";

// Rule IR — constrained, deterministic representation of an ESLint rule.
// The validator below is the single source of truth for what's supported;
// an unsupported op is a clear "extend the IR" signal, not a version bump.

// Statement ops.
//   report              — context.report({ node, messageId })
//   if                  — conditional
//   return              — early exit (no value)
//   iterate-children    — for-loop over `node.<prop>` yielding each element
const STMT_OPS = new Set(["report", "if", "return", "iterate-children", "report-at-token",
  // no-fallthrough: when `reportUnusedFallthroughComment` option is true
  // and the previous case doesn't actually fall through but has a
  // fall-through comment, emit `unusedFallthroughComment` at the comment
  // span.  Internally checks the option and finds the comment.
  "report-unused-fallthrough-comment",
  // default-param-last: for each function param right-to-left, report
  // non-required params that precede a required one.
  "report-default-param-last",
  // Rule-specific composite statement: walks parents from the current node
  // up to the nearest sentinel ancestor (any *Statement, ArrowFunctionExpr,
  // FunctionExpr, ClassExpr) and emits a `returnMsgId` report when that
  // ancestor is a ReturnStatement, an `arrowMsgId` report when it's an
  // ArrowFunctionExpression whose body is the walk's last step.  Implements
  // the no-return-assign check shape end-to-end.
  "no-return-assign-check",
]);

// Expr ops.
//   node-ref        — the handler's bound node parameter
//   literal         — number/string/boolean/null
//   identifier      — reference to a local binding (iterate-children element or top-level constant)
//   member          — obj.prop
//   binary          — comparison / logical
//   unary           — !x, -x, +x, typeof x
//   call-helper     — invoke a helper fn declared in rule.helpers by name
//   set-contains    — <const-string-set>.has(<expr>)
//   parent-node     — parent node of operand (node-valued)
//   node-tag-equals — tag of node matches a named ESTree type (bool)
//   node-main-child — main child node (Data.lhs) — node-valued
//   nodes-equal     — two node values point at the same NodeIndex (bool)
//   get-ecma-version        — ctx.getEcmaVersion() → i64
//   global-is-explicitly-enabled — ctx.globalIsExplicitlyEnabled(__name__) → bool (for-each-unresolved-global-ref only)
//   globals-explicitly-set  — ctx.globalsExplicitlySet() → bool
//   node-first-arg  — first argument of call/new expr → NodeIndex (or .none)
const EXPR_OPS = new Set([
  "node-ref", "literal", "identifier", "member", "binary", "unary", "call-helper", "set-contains",
  "parent-node", "node-tag-equals", "node-main-child", "nodes-equal", "node-args-length-zero",
  "node-operator-equals", "conditional-consequent", "conditional-alternate",
  "node-secondary-child", "node-is-computed", "get-option-bool", "get-option-string",
  "get-ecma-version", "global-is-explicitly-enabled", "globals-explicitly-set", "node-first-arg",
  "node-arg-at", "node-callee", "parent-node-skip-grouping", "node-in-bool-ctx",
  "node-is-boolean-call", "node-main-child-skip-grouping", "node-elements-has-null",
  "node-tag-in-set",
  // Unwrap `grouping_expr` wrappers from a node-valued IR.  Returns the
  // node as-is if it isn't a grouping_expr.  Used when an attribute-filter
  // recognizer wants to look at the underlying expression regardless of
  // surrounding parens (`Promise(((async () => {})))` → look at the async
  // arrow, not the outer grouping).
  "node-skip-grouping",
  "node-prop-name-equals",
  "node-prop-name-in-set",
  "node-has-static-prop-name",
  "node-has-static-string-value",
  "node-static-string-starts-with",
  "node-static-string-starts-with-i",
  "node-raw-has-octal-escape",
  "option-equals-string",
  "node-operator-in-set",
  "node-literal-value-equals",
  "node-raw-starts-with",
  "node-raw-ends-with",
  "node-raw-contains",
  // <node>.<token-source>[idx] === "X" — single-char check at byte index
  "node-raw-char-equals",
  "conditional-test",
  "node-is-function",
  "node-is-loop",
  "node-body-length-zero",
  "is-method-call",
  "is-member-expression",
  "is-new-expression",
  "is-call-expression",
  "is-call-or-new-expression",
  "is-node-matches",
  "node-string-value-equals",
  "node-args-count-equals",
  // Block-body indexed access: <node>.body.body[idx] — first/last/Nth
  // statement of a BlockStatement-bearing node (catch.body, try.block,
  // function.body, etc.).  When N is negative-from-end it stays as a
  // positive count from end via `fromEnd: true`.
  "node-body-stmt-at",
  "node-body-stmt-count",
  "node-body-stmt-count-equals",
  // <X>.body — single body statement of a loop / if / function / arrow
  // (resolves to the body block for fn/arrow/while/for/etc).  Node-valued.
  "node-body",
  // try_stmt has-finalizer check (`parent.finalizer` truthy).
  "node-has-finalizer",
  // Null/not-null checks on specific child slots
  "node-secondary-child-is-none",
  "node-secondary-child-not-none",
  "node-main-child-is-none",
  "node-main-child-not-none",
  // Function parameter count
  "node-params-count-equals",
  // Empty collection checks
  "node-is-empty-array-expression",
  "node-is-empty-object-expression",
  // Negative-one literal check (UnaryExpression `-` applied to `1`)
  "node-is-negative-one",
  // ── Token-level ops ──────────────────────────────────────────────────────
  // Token navigation (TokenIndex-valued):
  "token-of-node",        // main token of a node → TokenIndex
  "token-before",         // tok - 1 → TokenIndex
  "token-after",          // tok + 1 → TokenIndex
  // Token position (u32-valued):
  "token-start",          // byte offset of token start
  "token-end",            // byte offset of token end (start + len)
  // Node position (u32-valued):
  "node-span-start",      // byte offset of node start (ctx.nodeSpan(n).start)
  "node-span-end",        // byte offset of node end   (ctx.nodeSpan(n).end)
  // Source text between two byte offsets (string-valued).
  "source-text-range",
  // True when two nodes have identical source text (token-equivalent).
  // Stand-in for no-self-compare's hasSameTokens, no-dupe-else-if's equal, etc.
  "node-source-equals",
  // True when node is the last case in its parent switch_stmt's `cases`
  // SubRange.  Used by the default-case-last recognizer.
  "node-is-last-switch-case",
  // True when this switch_case has a `test` that token-equals any
  // PRECEDING switch_case's test within the same switch_stmt.  Used by
  // the no-duplicate-case recognizer.
  "node-has-duplicate-prev-case-test",
  // True when node's source text contains a line-terminator character.
  // Equivalent to ESLint's astUtils.LINEBREAK_MATCHER.test(rawText).
  "node-raw-contains-linebreak",
  // True when node's tag is one of the JSX-family tags.  Stand-in for
  // ESLint rules' `isJSXElement` / `node.type.indexOf("JSX") === 0`.
  "node-is-jsx",
  // Token boolean checks:
  "token-has-newline-before",  // tok.has_newline_before
  "token-tag-equals",          // tok.tag == <TagName>
  "token-has-space-between",   // gap between two adjacent tokens > 0
  "tokens-same-line",          // two tokens on same line (no newline between)
  // ── Source-text ops (string-valued; used in fix-text templates) ─────────
  "source-text-of",            // sourceCode.getText(node) — slice of node's full span
  "args-text-of",              // call's `(...)` body — getArgumentsText helper
  "template-string",           // `lit${expr}lit` parts → runtime allocPrint
  // ── Conditional value (lifted from `let X; if(c){X=A}else{X=B}` patterns)
  "ternary",                   // { cond, then, else } — codegen branches per use site
  // ── astUtils boolean helpers (lower to ctx.<helper>(node)).
  "is-start-of-expression-statement",
  "needs-preceding-semicolon",
  "has-comments-before-args",   // file-local hasCommentsInArrayConstructor-style helper
  "has-comments-inside-node",   // sourceCode.getCommentsInside(node).length > 0
  "node-is-optional",           // node.optional → tag is one of optional_*
  "node-has-type-arguments",    // node.typeArguments → callee is ts_instantiation_expr
  "node-non-spread-args-count", // n.arguments.reduce(non-spread count) → u32
  // ── Message-data value ops (string-valued; lowered into `data:` entries) ──
  // Identifier name / operator keyword text — both resolve to ctx.tokenText(
  // ctx.nodeMainToken(<node>)).  Use main-token-text for any "the keyword
  // or identifier this node leads with" case (`node.name`, `node.operator`).
  "node-main-token-text",
  // ESLint AST type name for a node (e.g. "BlockStatement").  Used by rules
  // that drop `node.type` into a message template.
  "node-eslint-type-name",
  // ── Token-of-node by position ────────────────────────────────────────────
  // Last token of a node (TokenIndex-valued).  Mirrors ESLint's
  // `sourceCode.getLastToken(node)`.
  "token-of-node-last",
  // Second-to-last token of a node — used by `getLastTokens(node, 2)`
  // destructure into `[penultimate, last]`.
  "token-of-node-penultimate",
  // First token at or after `start` whose text equals the literal `punct`.
  // Walk semantics matche ESLint's `getTokenAfter(X, isCommaToken)` etc.
  // when the predicate is a known punctuator check.
  "token-after-matching-punct",
  // ── Scope-aware ──────────────────────────────────────────────────────────
  // `sourceCode.isGlobalReference(<node>)` — true iff the identifier reference
  // resolves to a global binding (implicit-global or unresolved).  Used by
  // rules like no-implied-eval, no-setter-return that gate on whether the
  // callee is the built-in `Object`/`setTimeout`/etc.
  "is-global-reference",
  // `astUtils.getVariableByName(scope, "<name>").defs.length === 0` — true
  // when no user-declared binding named `<name>` is reachable from `node`'s
  // scope chain (so the bare identifier `name` would resolve to a global).
  "name-has-no-user-binding",
  // True when an Identifier node shadows a binding of the same name
  // reachable from its smallest enclosing scope.  Used by no-label-var:
  // `astUtils.getVariableByName(scope, node.label.name) !== null`.
  "identifier-shadows-binding",
  // Nearest function-like ancestor of a node (fn_decl/fn_expr/arrow_fn and
  // async/generator variants).  Stand-in for ESLint's onCodePathStart/End
  // stack lookup when a rule only needs "the enclosing function" — no real
  // code-path graph required.  Returns `.none` at program scope.
  "node-nearest-function-ancestor",
  // True when a node is a class constructor — method_def whose key is the
  // identifier `constructor` (or constructor_def for TS-ambient shapes).
  "is-constructor-method",
  // True when a node is a generator function in any form — bare generator
  // function decl/expr OR method_def with generator modifier (`*foo() {}`).
  "is-generator-function-or-method",
  // True when any descendant of the given node has the given tag.  Used by
  // require-yield to check whether a generator's body contains any
  // YieldExpression — avoids real state tracking across handler invocations.
  "node-subtree-contains-tag",
  // Byte offsets of the ESLint "function head" span — from the function's
  // first token up to the `(` of params.  Mirrors getFunctionHeadLoc for
  // non-arrow shapes.
  "node-fn-head-span-start",
  "node-fn-head-span-end",
  // SwitchCase helpers used by no-fallthrough: previous sibling case
  // (node-valued; .none for first/non-case), exit-reachability flag, and
  // non-empty-consequent check.
  "node-previous-switch-case",
  // True when a loop's code path has at least one back-edge (the loop
  // body actually iterates).  False ≡ no-unreachable-loop should fire.
  "loop-has-iteration-back-edge",
  // True when `nodeReachable(n)` — entry reachability from semantic.
  "node-reachable",
  // True when `options[0].ignore` array contains the ESLint type name of
  // the given node — used by no-unreachable-loop's `ignore: [...]` option.
  "option-ignore-contains-node-type",
  // True when walking up from `n` we hit a TryStatement's finalizer
  // block before crossing the no-unsafe-finally sentinel boundary.
  // Statement-kind-aware: break/continue have wider sentinel sets.
  "node-is-inside-finally-before-sentinel",
  // True when the given await_expr sits inside the test/update/body of
  // an enclosing loop — no-await-in-loop's core check.
  "await-is-in-loop",
  // True when an `arguments` identifier reference qualifies as a
  // prefer-rest-params violation (not a member-access object + inside a
  // non-arrow function-binding scope).
  "arguments-ref-is-restable-violation",
  "switch-case-exit-reachable",
  "switch-case-has-consequent",
  // True when prev_case has a consequent OR `allowEmptyCase: false` AND
  // blank lines separate the cases — combined fallthrough qualifier.
  "switch-case-qualifies-for-fallthrough",
  // True when a `falls through` comment sits between the two adjacent
  // switch cases in source — caller passes (prev, curr).
  "switch-cases-have-fallthrough-comment",
  // Generic "this node is not .none" check.  Useful when a node-valued op
  // (e.g. previous-switch-case, nearest-function-ancestor) needs an
  // existence guard.
  "node-not-none",
]);

// Helper-function kinds.
//   node-type-predicate — finite lookup table: NodeType string → bool or expr
//   report-if          — user-local helper `function(node) { if (COND) context.report({node, messageId}); }` — inlined at each call site
const HELPER_KINDS = new Set(["node-type-predicate", "report-if", "direct-report", "args-text-of", "has-comments-before-args"]);

// Top-level constant kinds (declared at top of rule.create body, used in handler bodies).
//   string-set   — `const X = new Set([s1, s2, ...])` with string literals
//   string-array — `const X = [s1, s2, ...]` with string literals (ordered, allows duplicates)
const CONSTANT_KINDS = new Set(["string-set", "string-array"]);

// Binary operators understood by codegen.
const BINARY_OPS = new Set(["===", "!==", "==", "!=", "<", "<=", ">", ">=", "&&", "||", "+", "-"]);

// Unary operators understood by codegen.
const UNARY_OPS = new Set(["!", "-", "+", "typeof"]);

// Validate a Rule record matches the v1 grammar. Returns { ok: true } or
// { ok: false, reason: "...", path: "handlers[0].body[1].cond" }.
function validateRule(rule) {
  if (!rule || typeof rule !== "object") return fail("not-an-object");
  if (typeof rule.name !== "string" || !rule.name) return fail("missing name");
  if (!["correctness", "suspicious", "style", "performance"].includes(rule.category))
    return fail(`bad category ${rule.category}`);
  if (typeof rule.description !== "string") return fail("missing description");
  if (rule.fixable != null && !["code", "whitespace"].includes(rule.fixable))
    return fail(`bad fixable ${rule.fixable}`);
  if (!rule.messages || typeof rule.messages !== "object") return fail("missing messages");
  if (rule.constants != null && typeof rule.constants !== "object") return fail("constants must be object");
  for (const [cn, c] of Object.entries(rule.constants || {})) {
    const cPath = `constants.${cn}`;
    if (!CONSTANT_KINDS.has(c.kind)) return fail(`unsupported constant kind '${c.kind}'`, cPath);
    if (c.kind === "string-set" || c.kind === "string-array") {
      if (!Array.isArray(c.values)) return fail(`${c.kind}.values must be array`, cPath);
      for (const v of c.values) if (typeof v !== "string") return fail(`${c.kind} entry must be string`, cPath);
    }
  }
  if (rule.helpers != null && typeof rule.helpers !== "object") return fail("helpers must be object");
  for (const [hn, h] of Object.entries(rule.helpers || {})) {
    const hPath = `helpers.${hn}`;
    if (!HELPER_KINDS.has(h.kind)) return fail(`unsupported helper kind '${h.kind}'`, hPath);
    if (h.kind === "node-type-predicate") {
      if (typeof h.param !== "string") return fail("helper.param must be string", hPath);
      if (!Array.isArray(h.cases)) return fail("helper.cases must be array", hPath);
      for (let ci = 0; ci < h.cases.length; ci++) {
        const c = h.cases[ci];
        const cPath = `${hPath}.cases[${ci}]`;
        if (!Array.isArray(c.types)) return fail("case.types must be array", cPath);
        for (const t of c.types) if (typeof t !== "string") return fail("case.type must be string", cPath);
        if (typeof c.returns === "boolean") {
          /* ok */
        } else if (c.returns && typeof c.returns === "object") {
          const r = validateExpr(c.returns, `${cPath}.returns`);
          if (!r.ok) return r;
        } else {
          return fail("case.returns must be boolean or Expr", cPath);
        }
      }
      if (typeof h.default !== "boolean") return fail("helper.default must be boolean", hPath);
    }
    if (h.kind === "report-if") {
      if (typeof h.param !== "string") return fail("helper.param must be string", hPath);
      if (typeof h.messageId !== "string") return fail("helper.messageId must be string", hPath);
      const r = validateExpr(h.cond, `${hPath}.cond`);
      if (!r.ok) return r;
    }
    if (h.kind === "direct-report") {
      if (typeof h.param !== "string") return fail("helper.param must be string", hPath);
      if (typeof h.messageId !== "string") return fail("helper.messageId must be string", hPath);
    }
  }
  if (!Array.isArray(rule.handlers)) return fail("handlers must be array");
  for (let hi = 0; hi < rule.handlers.length; hi++) {
    const h = rule.handlers[hi];
    const path = `handlers[${hi}]`;
    // Handler kinds that don't dispatch on AST nodes (pure symbol-phase
    // walkers) skip the selector requirement.
    if (h.kind === "report-all-unresolved-refs") {
      if (typeof h.messageId !== "string") return fail("messageId must be string", path);
      if (typeof h.considerTypeof !== "boolean") return fail("considerTypeof must be bool", path);
      continue;
    }
    if (typeof h.selector !== "string") return fail("selector must be string", path);
    // Optional handler kind — e.g. "for-each-unresolved-global-ref" — triggers
    // a symbol-phase emit instead of the default AST-walk dispatch.
    if (h.kind != null) {
      if (h.kind !== "for-each-unresolved-global-ref" &&
          h.kind !== "for-each-node" &&
          h.kind !== "for-each-readonly-global-write-ref" &&
          h.kind !== "for-each-write-ref-of-binding")
        return fail(`unsupported handler kind '${h.kind}'`, path);
      if (h.kind === "for-each-unresolved-global-ref") {
        if (typeof h.namesConstant !== "string")
          return fail("handler.namesConstant must be string (top-level constant name)", path);
        if (typeof h.refIdentifierBinding !== "string")
          return fail("handler.refIdentifierBinding must be string", path);
        if (h.methodChainCheck != null) {
          if (typeof h.methodChainCheck.methodsConstant !== "string")
            return fail("methodChainCheck.methodsConstant must be string", path);
          if (typeof h.methodChainCheck.messageId !== "string")
            return fail("methodChainCheck.messageId must be string", path);
        }
      }
      if (h.kind === "for-each-node") {
        if (typeof h.nodeBinding !== "string")
          return fail("handler.nodeBinding must be string", path);
      }
      if (h.kind === "for-each-readonly-global-write-ref") {
        if (typeof h.messageId !== "string")
          return fail("handler.messageId must be string", path);
        if (h.exceptionsOption != null && typeof h.exceptionsOption !== "string")
          return fail("handler.exceptionsOption must be string or null", path);
        // body is empty by construction — the lowering is fully determined
        // by messageId / exceptionsOption / hasNameData.
        continue;
      }
      if (h.kind === "for-each-write-ref-of-binding") {
        if (typeof h.messageId !== "string")
          return fail("handler.messageId must be string", path);
        if (!Array.isArray(h.bindingKinds) || h.bindingKinds.length === 0)
          return fail("handler.bindingKinds must be non-empty string[]", path);
        for (const k of h.bindingKinds)
          if (typeof k !== "string") return fail("bindingKinds entries must be strings", path);
        continue;
      }
    }
    if (!Array.isArray(h.body)) return fail("body must be array", path);
    for (let si = 0; si < h.body.length; si++) {
      const r = validateStatement(h.body[si], `${path}.body[${si}]`);
      if (!r.ok) return r;
    }
  }
  return { ok: true };
}

function validateStatement(s, path) {
  if (!s || typeof s !== "object") return fail("not-an-object", path);
  if (!STMT_OPS.has(s.op)) return fail(`unsupported stmt op '${s.op}'`, path);
  if (s.op === "report") {
    if (typeof s.messageId !== "string") return fail("report.messageId must be string", path);
    if (s.data) {
      if (!Array.isArray(s.data)) return fail("report.data must be array", path);
      for (let i = 0; i < s.data.length; i++) {
        const kv = s.data[i];
        if (!kv || typeof kv.key !== "string") return fail(`report.data[${i}].key must be string`, path);
        const v = validateExpr(kv.value, `${path}.data[${i}].value`);
        if (!v.ok) return v;
      }
    }
    if (s.loc) {
      if (typeof s.loc !== "object") return fail("report.loc must be object", path);
      const ls = validateExpr(s.loc.start, `${path}.loc.start`);
      if (!ls.ok) return ls;
      const le = validateExpr(s.loc.end, `${path}.loc.end`);
      if (!le.ok) return le;
    }
    return validateExpr(s.node, `${path}.node`);
  }
  if (s.op === "if") {
    const c = validateExpr(s.cond, `${path}.cond`);
    if (!c.ok) return c;
    for (let i = 0; i < (s.then || []).length; i++) {
      const r = validateStatement(s.then[i], `${path}.then[${i}]`);
      if (!r.ok) return r;
    }
    for (let i = 0; i < (s.else || []).length; i++) {
      const r = validateStatement(s.else[i], `${path}.else[${i}]`);
      if (!r.ok) return r;
    }
    return { ok: true };
  }
  if (s.op === "return") return { ok: true };
  if (s.op === "report-at-token") {
    if (typeof s.messageId !== "string") return fail("report-at-token.messageId must be string", path);
    return validateExpr(s.token, `${path}.token`);
  }
  if (s.op === "report-default-param-last") {
    if (typeof s.messageId !== "string") return fail("report-default-param-last.messageId must be string", path);
    return validateExpr(s.node, `${path}.node`);
  }
  if (s.op === "report-unused-fallthrough-comment") {
    if (typeof s.messageId !== "string") return fail("report-unused-fallthrough-comment.messageId must be string", path);
    const a = validateExpr(s.prev, `${path}.prev`);
    if (!a.ok) return a;
    return validateExpr(s.curr, `${path}.curr`);
  }
  if (s.op === "no-return-assign-check") {
    if (typeof s.returnMsgId !== "string") return fail("no-return-assign-check.returnMsgId must be string", path);
    if (typeof s.arrowMsgId !== "string") return fail("no-return-assign-check.arrowMsgId must be string", path);
    if (s.exceptParens != null && typeof s.exceptParens !== "boolean")
      return fail("no-return-assign-check.exceptParens must be boolean", path);
    return { ok: true };
  }
  if (s.op === "iterate-children") {
    // { op: "iterate-children", source: Expr (must be member of node-ref, e.g. node.consequent),
    //   elementBinding: string, body: Statement[] }
    if (typeof s.elementBinding !== "string") return fail("iterate.elementBinding must be string", path);
    const r = validateExpr(s.source, `${path}.source`);
    if (!r.ok) return r;
    for (let i = 0; i < (s.body || []).length; i++) {
      const rr = validateStatement(s.body[i], `${path}.body[${i}]`);
      if (!rr.ok) return rr;
    }
    return { ok: true };
  }
  return fail("unreachable", path);
}

function validateExpr(e, path) {
  if (!e || typeof e !== "object") return fail("not-an-object", path);
  if (!EXPR_OPS.has(e.op)) return fail(`unsupported expr op '${e.op}'`, path);
  if (e.op === "node-ref") return { ok: true };
  if (e.op === "literal") {
    const t = typeof e.value;
    if (e.value !== null && !["string", "number", "boolean"].includes(t))
      return fail(`bad literal value type ${t}`, path);
    return { ok: true };
  }
  if (e.op === "identifier") {
    if (typeof e.name !== "string") return fail("identifier.name must be string", path);
    return { ok: true };
  }
  if (e.op === "member") {
    if (typeof e.property !== "string") return fail("member.property must be string", path);
    if (e.computed !== false) return fail("computed member not supported in v1", path);
    return validateExpr(e.object, `${path}.object`);
  }
  if (e.op === "binary") {
    if (!BINARY_OPS.has(e.operator)) return fail(`bad binary op '${e.operator}'`, path);
    const l = validateExpr(e.lhs, `${path}.lhs`);
    if (!l.ok) return l;
    return validateExpr(e.rhs, `${path}.rhs`);
  }
  if (e.op === "unary") {
    if (!UNARY_OPS.has(e.operator)) return fail(`bad unary op '${e.operator}'`, path);
    return validateExpr(e.operand, `${path}.operand`);
  }
  if (e.op === "call-helper") {
    if (typeof e.name !== "string") return fail("call-helper.name must be string", path);
    return validateExpr(e.arg, `${path}.arg`);
  }
  if (e.op === "set-contains") {
    if (typeof e.setName !== "string") return fail("set-contains.setName must be string", path);
    return validateExpr(e.value, `${path}.value`);
  }
  if (e.op === "parent-node") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-main-child") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-tag-equals") {
    if (typeof e.estreeType !== "string") return fail("node-tag-equals.estreeType must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "nodes-equal") {
    const a = validateExpr(e.a, `${path}.a`);
    if (!a.ok) return a;
    return validateExpr(e.b, `${path}.b`);
  }
  if (e.op === "node-args-length-zero") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-operator-equals") {
    if (typeof e.operator !== "string") return fail("node-operator-equals.operator must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "conditional-consequent" || e.op === "conditional-alternate" || e.op === "conditional-test") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-secondary-child" || e.op === "node-is-computed") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "get-option-bool") {
    if (typeof e.name !== "string") return fail("get-option-bool.name must be string", path);
    if (typeof e.default !== "boolean") return fail("get-option-bool.default must be boolean", path);
    return { ok: true };
  }
  if (e.op === "get-option-string") {
    if (typeof e.name !== "string") return fail("get-option-string.name must be string", path);
    if (typeof e.default !== "string") return fail("get-option-string.default must be string", path);
    return { ok: true };
  }
  if (e.op === "get-ecma-version") return { ok: true };
  if (e.op === "global-is-explicitly-enabled") return { ok: true };
  if (e.op === "globals-explicitly-set") return { ok: true };
  if (e.op === "node-first-arg") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-arg-at") {
    if (typeof e.index !== "number" || !Number.isInteger(e.index) || e.index < 0)
      return fail("node-arg-at.index must be a non-negative integer", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-callee") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "parent-node-skip-grouping") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-in-bool-ctx") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-is-boolean-call") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-main-child-skip-grouping") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-skip-grouping") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-elements-has-null") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-tag-in-set") {
    if (typeof e.setName !== "string") return fail("node-tag-in-set.setName must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-prop-name-equals") {
    if (typeof e.name !== "string") return fail("node-prop-name-equals.name must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-prop-name-in-set") {
    if (typeof e.setName !== "string") return fail("node-prop-name-in-set.setName must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-has-static-prop-name") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-has-static-string-value") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-static-string-starts-with" || e.op === "node-static-string-starts-with-i") {
    if (typeof e.prefix !== "string") return fail(`${e.op}.prefix must be string`, path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-raw-has-octal-escape") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "option-equals-string") {
    if (typeof e.needle !== "string") return fail("option-equals-string.needle must be string", path);
    return { ok: true };
  }
  if (e.op === "node-operator-in-set") {
    if (typeof e.setName !== "string") return fail("node-operator-in-set.setName must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-literal-value-equals") {
    if (typeof e.value !== "number") return fail("node-literal-value-equals.value must be number", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-string-value-equals") {
    if (typeof e.value !== "string") return fail("node-string-value-equals.value must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-args-count-equals") {
    if (typeof e.count !== "number" || !Number.isInteger(e.count) || e.count < 0)
      return fail("node-args-count-equals.count must be non-negative integer", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-body-stmt-at") {
    if (typeof e.index !== "number" || !Number.isInteger(e.index))
      return fail("node-body-stmt-at.index must be integer", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-body-stmt-count") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-body-stmt-count-equals") {
    if (typeof e.count !== "number" || !Number.isInteger(e.count) || e.count < 0)
      return fail("node-body-stmt-count-equals.count must be non-negative integer", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-has-finalizer") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-body") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-raw-starts-with" || e.op === "node-raw-ends-with" || e.op === "node-raw-contains") {
    if (typeof e.prefix !== "string") return fail(`${e.op}.prefix must be string`, path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-raw-char-equals") {
    if (typeof e.index !== "number" || !Number.isInteger(e.index) || e.index < 0)
      return fail("node-raw-char-equals.index must be a non-negative integer", path);
    if (typeof e.char !== "string" || e.char.length !== 1)
      return fail("node-raw-char-equals.char must be a single-char string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-is-function" || e.op === "node-is-loop" || e.op === "node-body-length-zero") {
    return validateExpr(e.node, `${path}.node`);
  }
  // Unicorn helper inlines — composite type+property checks.
  if (e.op === "is-method-call" || e.op === "is-member-expression" || e.op === "is-new-expression" || e.op === "is-call-expression" || e.op === "is-call-or-new-expression") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "is-node-matches") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-secondary-child-is-none" || e.op === "node-secondary-child-not-none") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-main-child-is-none" || e.op === "node-main-child-not-none") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-params-count-equals") {
    if (typeof e.count !== "number" || !Number.isInteger(e.count) || e.count < 0)
      return fail("node-params-count-equals.count must be non-negative integer", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-is-empty-array-expression" || e.op === "node-is-empty-object-expression") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-is-negative-one") {
    return validateExpr(e.node, `${path}.node`);
  }
  // Token-level ops
  if (e.op === "token-of-node") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "token-before" || e.op === "token-after") {
    return validateExpr(e.token, `${path}.token`);
  }
  if (e.op === "token-start" || e.op === "token-end" || e.op === "token-has-newline-before") {
    return validateExpr(e.token, `${path}.token`);
  }
  if (e.op === "node-span-start" || e.op === "node-span-end") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "source-text-range") {
    const s = validateExpr(e.start, `${path}.start`);
    if (!s.ok) return s;
    return validateExpr(e.end, `${path}.end`);
  }
  if (e.op === "node-source-equals") {
    const a = validateExpr(e.a, `${path}.a`);
    if (!a.ok) return a;
    return validateExpr(e.b, `${path}.b`);
  }
  if (e.op === "node-is-last-switch-case"
      || e.op === "node-raw-contains-linebreak"
      || e.op === "node-is-jsx"
      || e.op === "node-has-duplicate-prev-case-test") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "token-tag-equals") {
    if (typeof e.tag !== "string") return fail("token-tag-equals.tag must be string", path);
    return validateExpr(e.token, `${path}.token`);
  }
  if (e.op === "token-has-space-between" || e.op === "tokens-same-line") {
    const a = validateExpr(e.a, `${path}.a`);
    if (!a.ok) return a;
    return validateExpr(e.b, `${path}.b`);
  }
  // Source-text and ternary ops (used in fix-text templates).
  if (e.op === "source-text-of" || e.op === "args-text-of"
      || e.op === "is-start-of-expression-statement" || e.op === "needs-preceding-semicolon"
      || e.op === "has-comments-before-args" || e.op === "has-comments-inside-node"
      || e.op === "node-is-optional" || e.op === "node-has-type-arguments"
      || e.op === "node-non-spread-args-count"
      || e.op === "node-main-token-text" || e.op === "node-eslint-type-name"
      || e.op === "is-global-reference"
      || e.op === "identifier-shadows-binding"
      || e.op === "node-nearest-function-ancestor"
      || e.op === "is-constructor-method"
      || e.op === "is-generator-function-or-method") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-subtree-contains-tag") {
    if (typeof e.tag !== "string") return fail("node-subtree-contains-tag.tag must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "node-fn-head-span-start" || e.op === "node-fn-head-span-end"
      || e.op === "node-previous-switch-case"
      || e.op === "switch-case-exit-reachable"
      || e.op === "switch-case-has-consequent"
      || e.op === "node-not-none"
      || e.op === "loop-has-iteration-back-edge"
      || e.op === "node-reachable"
      || e.op === "option-ignore-contains-node-type"
      || e.op === "node-is-inside-finally-before-sentinel"
      || e.op === "await-is-in-loop"
      || e.op === "arguments-ref-is-restable-violation") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "switch-cases-have-fallthrough-comment"
      || e.op === "switch-case-qualifies-for-fallthrough") {
    const a = validateExpr(e.prev, `${path}.prev`);
    if (!a.ok) return a;
    return validateExpr(e.curr, `${path}.curr`);
  }
  if (e.op === "name-has-no-user-binding") {
    if (typeof e.name !== "string") return fail("name-has-no-user-binding.name must be string", path);
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "token-of-node-last" || e.op === "token-of-node-penultimate") {
    return validateExpr(e.node, `${path}.node`);
  }
  if (e.op === "token-after-matching-punct") {
    if (typeof e.punct !== "string") return fail("token-after-matching-punct.punct must be string", path);
    return validateExpr(e.start, `${path}.start`);
  }
  if (e.op === "template-string") {
    if (!Array.isArray(e.parts)) return fail("template-string.parts must be array", path);
    for (let i = 0; i < e.parts.length; i++) {
      const p = e.parts[i];
      if (p.kind === "str") {
        if (typeof p.value !== "string") return fail(`template-string.parts[${i}].value must be string`, path);
      } else if (p.kind === "expr") {
        const r = validateExpr(p.expr, `${path}.parts[${i}].expr`);
        if (!r.ok) return r;
      } else {
        return fail(`template-string.parts[${i}].kind must be 'str'|'expr'`, path);
      }
    }
    return { ok: true };
  }
  if (e.op === "ternary") {
    const c = validateExpr(e.cond, `${path}.cond`);
    if (!c.ok) return c;
    const t = validateExpr(e.then, `${path}.then`);
    if (!t.ok) return t;
    return validateExpr(e.else, `${path}.else`);
  }
  return fail("unreachable", path);
}

function fail(reason, path) {
  return { ok: false, reason, path: path || "<root>" };
}

module.exports = {
  STMT_OPS,
  EXPR_OPS,
  BINARY_OPS,
  HELPER_KINDS,
  CONSTANT_KINDS,
  validateRule,
};
