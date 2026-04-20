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

const IR_VERSION = 1;

// Statement ops supported by v1. Everything else → unsupported pattern.
const STMT_OPS = new Set(["report", "if", "return"]);

// Expr ops supported by v1.
const EXPR_OPS = new Set(["node-ref", "literal", "identifier", "member", "binary"]);

// Binary operators understood by codegen.
const BINARY_OPS = new Set(["===", "!==", "==", "!=", "<", "<=", ">", ">=", "&&", "||"]);

// Validate a Rule record matches the v1 grammar. Returns { ok: true } or
// { ok: false, reason: "...", path: "handlers[0].body[1].cond" }.
function validateRule(rule) {
  if (!rule || typeof rule !== "object") return fail("not-an-object");
  if (rule.irVersion !== IR_VERSION) return fail(`bad irVersion ${rule.irVersion}`);
  if (typeof rule.name !== "string" || !rule.name) return fail("missing name");
  if (!["correctness", "suspicious", "style", "performance"].includes(rule.category))
    return fail(`bad category ${rule.category}`);
  if (typeof rule.description !== "string") return fail("missing description");
  if (rule.fixable != null && !["code", "whitespace"].includes(rule.fixable))
    return fail(`bad fixable ${rule.fixable}`);
  if (!rule.messages || typeof rule.messages !== "object") return fail("missing messages");
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
  return fail("unreachable", path);
}

function fail(reason, path) {
  return { ok: false, reason, path: path || "<root>" };
}

module.exports = {
  IR_VERSION,
  STMT_OPS,
  EXPR_OPS,
  BINARY_OPS,
  validateRule,
};
