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
const STMT_OPS = new Set(["report", "if", "return", "iterate-children", "report-at-token"]);

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
  "node-prop-name-equals",
  "node-operator-in-set",
  "node-literal-value-equals",
  "node-raw-starts-with",
  "node-raw-ends-with",
  "node-raw-contains",
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
  // Token boolean checks:
  "token-has-newline-before",  // tok.has_newline_before
  "token-tag-equals",          // tok.tag == <TagName>
  "token-has-space-between",   // gap between two adjacent tokens > 0
  "tokens-same-line",          // two tokens on same line (no newline between)
]);

// Helper-function kinds.
//   node-type-predicate — finite lookup table: NodeType string → bool or expr
//   report-if          — user-local helper `function(node) { if (COND) context.report({node, messageId}); }` — inlined at each call site
const HELPER_KINDS = new Set(["node-type-predicate", "report-if", "direct-report"]);

// Top-level constant kinds (declared at top of rule.create body, used in handler bodies).
//   string-set   — `const X = new Set([s1, s2, ...])` with string literals
//   string-array — `const X = [s1, s2, ...]` with string literals (ordered, allows duplicates)
const CONSTANT_KINDS = new Set(["string-set", "string-array"]);

// Binary operators understood by codegen.
const BINARY_OPS = new Set(["===", "!==", "==", "!=", "<", "<=", ">", ">=", "&&", "||"]);

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
    if (typeof h.selector !== "string") return fail("selector must be string", path);
    // Optional handler kind — e.g. "for-each-unresolved-global-ref" — triggers
    // a symbol-phase emit instead of the default AST-walk dispatch.
    if (h.kind != null) {
      if (h.kind !== "for-each-unresolved-global-ref" && h.kind !== "for-each-node")
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
  if (e.op === "node-raw-starts-with" || e.op === "node-raw-ends-with" || e.op === "node-raw-contains") {
    if (typeof e.prefix !== "string") return fail(`${e.op}.prefix must be string`, path);
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
  if (e.op === "token-tag-equals") {
    if (typeof e.tag !== "string") return fail("token-tag-equals.tag must be string", path);
    return validateExpr(e.token, `${path}.token`);
  }
  if (e.op === "token-has-space-between" || e.op === "tokens-same-line") {
    const a = validateExpr(e.a, `${path}.a`);
    if (!a.ok) return a;
    return validateExpr(e.b, `${path}.b`);
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
