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
const STMT_OPS = new Set(["report", "if", "return", "iterate-children"]);

// Expr ops.
//   node-ref        — the handler's bound node parameter
//   literal         — number/string/boolean/null
//   identifier      — reference to a local binding (iterate-children element or top-level constant)
//   member          — obj.prop
//   binary          — comparison / logical
//   unary           — !x, -x, +x, typeof x
//   call-helper     — invoke a helper fn declared in rule.helpers by name
//   set-contains    — <const-string-set>.has(<expr>)
const EXPR_OPS = new Set(["node-ref", "literal", "identifier", "member", "binary", "unary", "call-helper", "set-contains"]);

// Helper-function kinds.
//   node-type-predicate — finite lookup table: NodeType string → bool or expr
const HELPER_KINDS = new Set(["node-type-predicate"]);

// Top-level constant kinds (declared at top of rule.create body, used in handler bodies).
//   string-set — `const X = new Set([s1, s2, ...])` with string literals
const CONSTANT_KINDS = new Set(["string-set"]);

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
    if (c.kind === "string-set") {
      if (!Array.isArray(c.values)) return fail("string-set.values must be array", cPath);
      for (const v of c.values) if (typeof v !== "string") return fail("string-set entry must be string", cPath);
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
  }
  if (!Array.isArray(rule.handlers)) return fail("handlers must be array");
  for (let hi = 0; hi < rule.handlers.length; hi++) {
    const h = rule.handlers[hi];
    const path = `handlers[${hi}]`;
    if (typeof h.selector !== "string") return fail("selector must be string", path);
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
