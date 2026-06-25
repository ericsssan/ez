#!/usr/bin/env node
// ESTree-fidelity diff harness.
//
// Parses a snippet with both the reference parser (@typescript-eslint/parser)
// and ez's parser, then walks the reference tree comparing `type` and `range`
// at every node against ez's ESTree. Use it to pin down where ez's ESTree
// diverges from the parser the differential oracle uses — especially for the
// most AST-sensitive rules like `indent`.
//
// Usage:
//   node tests/differential/estree-fidelity.js '<code>' [lang]
//   node tests/differential/estree-fidelity.js --file path.ts [lang]
// lang: js | ts | jsx | tsx  (default inferred: ts if code has TS syntax else js)

const path = require("path");
const JS_ROOT = path.join(__dirname, "..", "..", "js");
const { parseSource, getTagNames } = require(path.join(JS_ROOT, "index.js"));
const adapter = require(path.join(JS_ROOT, "estree-adapter.js"));
const tsParser = require(path.join(JS_ROOT, "node_modules", "@typescript-eslint", "parser", "dist", "index.js"));

function parseRef(code, jsx) {
  return tsParser.parse(code, {
    range: true,
    loc: false,
    comment: false,
    jsx: !!jsx,
    // no project — purely syntactic ESTree, which is all indent needs.
  });
}

function isNode(v) { return v && typeof v === "object" && typeof v.type === "string"; }

// Walk the reference tree; at each node compare against the matching ez node.
function diff(ref, ours, out, pathStr) {
  if (!ref) return;
  if (!ours) { out.push(`${pathStr}: ref ${ref.type}[${ref.range}] — ez node MISSING`); return; }
  const ourType = ours.type;
  if (ourType !== ref.type) {
    out.push(`${pathStr}: TYPE  ref=${ref.type}[${ref.range}]  ez=${ourType}[${ours.range}]`);
    // types diverged — children won't line up; stop this branch.
    return;
  }
  const rr = ref.range, or = ours.range;
  if (!or || rr[0] !== or[0] || rr[1] !== or[1]) {
    out.push(`${pathStr} ${ref.type}: RANGE ref=[${rr}] ez=[${or}]`);
  }
  // Recurse into child keys present on the reference node.
  for (const key of Object.keys(ref)) {
    if (key === "type" || key === "range" || key === "loc" || key === "parent") continue;
    const rv = ref[key];
    if (Array.isArray(rv)) {
      let ov;
      try { ov = ours[key]; } catch { ov = undefined; }
      for (let i = 0; i < rv.length; i++) {
        if (!isNode(rv[i])) continue;
        const oc = Array.isArray(ov) ? ov[i] : undefined;
        diff(rv[i], oc, out, `${pathStr}.${key}[${i}]`);
      }
    } else if (isNode(rv)) {
      let ov;
      try { ov = ours[key]; } catch { ov = undefined; }
      diff(rv, ov, out, `${pathStr}.${key}`);
    }
  }
}

function main() {
  const argv = process.argv.slice(2);
  let code, lang;
  if (argv[0] === "--file") {
    code = require("fs").readFileSync(argv[1], "utf8");
    lang = argv[2];
  } else {
    code = argv[0];
    lang = argv[1];
  }
  if (code == null) { console.error("usage: estree-fidelity.js '<code>' [lang]"); process.exit(2); }
  const jsx = lang === "jsx" || lang === "tsx";
  if (!lang) lang = /\b(abstract|public|private|protected|readonly|implements|interface|enum|namespace|:\s*\w+\s*[=;)])/.test(code) ? "ts" : "js";

  adapter.setTagNames(getTagNames());
  const ours = parseSource(code, { lang, sourceType: "module" }).root();
  let ref;
  try { ref = parseRef(code, jsx); }
  catch (e) { console.error("reference parse error:", e.message); process.exit(1); }

  const out = [];
  diff(ref, ours, out, "Program");
  if (out.length === 0) console.log("✓ identical (type + range) across", code.split("\n").length, "lines");
  else { console.log(`${out.length} difference(s):`); for (const l of out) console.log("  " + l); }
}

main();
