"use strict";
/**
 * sanz as an ESLint custom parser (Option 3).
 *
 * Implements the full ESLint parseForESLint() interface:
 *   { ast, visitorKeys, scopeManager }
 *
 * Zero-copy: sanz writes the AST into a pre-allocated ArrayBuffer.
 * NodeView objects read buffer fields via DataView — no JSON, no marshalling.
 *
 * ESLint sets node.parent on every visited node. NodeProto has a `set parent`
 * accessor that shadows itself with a writable own property on first write —
 * standard technique used by @babel/eslint-parser and others.
 *
 * scopeManager is backed by sanz's scope buffer — prevents eslint-scope from
 * running its own analysis and provides sanz's semantic data to rules directly.
 */

const { parse } = require("./index");
const evk = require("./node_modules/eslint-visitor-keys");
const { buildScopeManager } = require("./scope-manager");

// Use standard ESTree visitor keys. These tell ESLint which child properties
// to traverse for each node type — preventing crashes on unknown properties.
// NodeView implements all standard ESTree properties, so this is correct.
const VISITOR_KEYS = evk.KEYS;

module.exports = {
  parseForESLint(code, options) {
    const filename = (options && options.filePath) || "<input>";
    const ast = parse(code, { filename });
    const root = ast.root();
    const scopeManager = buildScopeManager(ast);

    return {
      ast: root,
      visitorKeys: VISITOR_KEYS,
      scopeManager,
    };
  },
};
