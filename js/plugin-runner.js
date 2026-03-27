"use strict";

const { nodeView } = require("./node-view");

// ── Context ─────────────────────────────────────────────────────

/**
 * ESLint-compatible rule context passed to plugin visitor functions.
 */
class RuleContext {
  constructor(ast, filename, sourceText) {
    this._ast = ast;
    this._filename = filename;
    this._source = sourceText;
    this._reports = [];
  }

  /**
   * Report a lint violation.
   * @param {object} descriptor - { node, message, loc? }
   */
  report(descriptor) {
    const { node, message, loc } = descriptor;
    this._reports.push({
      ruleId: this._currentRule,
      message,
      node: node ? { type: node.type, start: node.start } : undefined,
      loc: loc || (node ? { start: node.start } : undefined),
    });
  }

  getSourceCode() {
    return {
      text: this._source,
      ast: this._ast,
    };
  }

  getFilename() {
    return this._filename;
  }
}

// ── Visitor Walk ─────────────────────────────────────────────────

/**
 * Build a reverse mapping from ESTree type name → list of visitor functions.
 * This enables efficient single-pass traversal.
 */
function buildVisitorMap(plugins, context) {
  const map = new Map();

  for (const plugin of plugins) {
    const visitors = plugin.create(context);
    for (const [typeName, handler] of Object.entries(visitors)) {
      if (!map.has(typeName)) {
        map.set(typeName, []);
      }
      map.get(typeName).push({ handler, ruleId: plugin.meta?.name || "unknown" });
    }
  }

  return map;
}

/**
 * Walk all AST nodes in a single pass, invoking matching visitor handlers.
 * Errors are caught per-handler so one failing plugin doesn't abort others.
 */
function walkNodes(ast, visitorMap, context, tagNames) {
  const nodeCount = ast.nodeCount;
  const nodeTags = ast.nodeTags;

  for (let i = 0; i < nodeCount; i++) {
    const tagIdx = nodeTags[i];
    const typeName = tagNames[tagIdx];
    if (!typeName) continue;

    const handlers = visitorMap.get(typeName);
    if (!handlers) continue;

    const node = nodeView(ast, i);
    for (let h = 0; h < handlers.length; h++) {
      context._currentRule = handlers[h].ruleId;
      try {
        handlers[h].handler(node);
      } catch (err) {
        context._reports.push({
          ruleId: handlers[h].ruleId,
          message: `Plugin error: ${err.message}`,
        });
      }
    }
  }
}

// ── Public API ───────────────────────────────────────────────────

/**
 * Run ESLint-compatible plugins against a parsed AST.
 *
 * @param {AstView} ast - Parsed AST from sx3lint.parse()
 * @param {Array} plugins - Array of { meta?: { name }, create(context) => visitors }
 * @param {object} [options] - { filename?: string, tagNames?: string[] }
 * @returns {Array} - Array of { ruleId, message, node?, loc? }
 *
 * Plugin format (ESLint-compatible):
 *   {
 *     meta: { name: "no-debugger" },
 *     create(context) {
 *       return {
 *         DebuggerStatement(node) {
 *           context.report({ node, message: "Unexpected debugger" });
 *         }
 *       };
 *     }
 *   }
 */
function runPlugins(ast, plugins, options = {}) {
  const { filename = "<input>", tagNames } = options;

  if (!tagNames) {
    throw new Error("runPlugins requires options.tagNames (call getTagNames() first)");
  }

  const context = new RuleContext(ast, filename, ast.source);
  const visitorMap = buildVisitorMap(plugins, context);

  walkNodes(ast, visitorMap, context, tagNames);

  return context._reports;
}

module.exports = { runPlugins, RuleContext };
