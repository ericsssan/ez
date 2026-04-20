"use strict";

/**
 * ts-services — stub.
 *
 * Ez does not depend on the `typescript` package at runtime. All TS/TSX parsing
 * is handled by Ez's native parser. Type-aware rules that require
 * `parserServices.program` (a TypeScript `Program` / `TypeChecker`) receive
 * `null` here — those rules either guard the null and skip gracefully, or fail
 * loudly. No fallback to a real LanguageService is provided.
 *
 * Static type information that Ez chooses to surface in the future will be
 * produced by AST-level analysis of the source (annotations, inferred shapes,
 * flow-safe tags) — not by running tsc.
 *
 * The historical LanguageService + span-bridge implementation lives in the git
 * history of this file if anyone needs it.
 */

const path = require("path");

// ── No-op API ────────────────────────────────────────────────

function init(_projectDir) { /* nothing to initialize */ }
function updateFile(_filename, _source) { /* no-op */ }
function registerFiles(_paths) { /* no-op */ }
function dispose() { /* no-op */ }

// parserServices returned to type-aware rules. Empty shape = most rules detect
// they can't do type work and skip. A few rules read `program`/`esTreeNodeToTSNodeMap`
// directly — those will throw, and calling code should filter them out.
function buildParserServices(_filename) { return null; }

// tsconfig.json detection — scan upward for a sibling config.
// Kept so callers that expected this helper still get a result, but we no
// longer parse the file (since we don't consume its content).
function findTsConfig(startDir) {
  const fs = require("fs");
  let dir = path.resolve(startDir);
  while (dir && dir !== path.dirname(dir)) {
    const candidate = path.join(dir, "tsconfig.json");
    try { if (fs.existsSync(candidate)) return candidate; } catch {}
    dir = path.dirname(dir);
  }
  return null;
}

module.exports = {
  init,
  updateFile,
  buildParserServices,
  registerFiles,
  dispose,
  findTsConfig,
};
