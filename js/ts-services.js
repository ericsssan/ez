"use strict";

/**
 * TypeScript integration for the sanz plugin runner.
 *
 * Provides parserServices compatible with @typescript-eslint rules:
 *   - context.sourceCode.parserServices.program        → ts.Program
 *   - context.sourceCode.parserServices.esTreeNodeToTSNodeMap.get(node) → ts.Node
 *   - context.sourceCode.parserServices.tsNodeToESTreeNodeMap.get(tsNode) → sanzNode
 *
 * The mapping is position-based: sanz node.start (UTF-16 offset) → ts.Node at
 * that position via TypeScript's own AST.  No full ESTree↔tsAST parallel walk
 * needed — only lookups that rules actually request are performed.
 */

const path = require("path");
let ts = null;

function _loadTs() {
  if (ts) return ts;
  try {
    ts = require("typescript");
  } catch {
    throw new Error(
      "sanz: 'typescript' package not found. Run: npm install typescript"
    );
  }
  return ts;
}

// ── Program cache ─────────────────────────────────────────────────
// Keyed by the resolved tsconfig.json path (or absolute file path for
// tsconfig-less files).  One program per project, shared across files.
const _programCache = new Map();

/**
 * Find the deepest ts.Node that starts at or contains `pos`.
 * Uses the internal ts.getTokenAtPosition when available (TypeScript ≥ 2.x),
 * falling back to a recursive child walk.
 */
function _tsNodeAtPos(sourceFile, pos) {
  const typescript = _loadTs();
  if (typeof typescript.getTokenAtPosition === "function") {
    return typescript.getTokenAtPosition(sourceFile, pos);
  }
  // Fallback: recursive walk
  function walk(node) {
    const ns = node.getStart(sourceFile, /* includeJsDocComment */ true);
    const ne = node.getEnd();
    if (pos < ns || pos > ne) return null;
    let best = node;
    typescript.forEachChild(node, (child) => {
      const found = walk(child);
      if (found) best = found;
    });
    return best;
  }
  return walk(sourceFile);
}

/**
 * Create or retrieve a cached ts.Program for `filePath`.
 *
 * Resolution order:
 *   1. Walk up from the file's directory looking for tsconfig.json.
 *   2. If found, parse it and create a full-project program (cached by tsconfig path).
 *   3. If not found, create a minimal single-file program (cached by absolute file path).
 */
function getProgram(filePath) {
  const typescript = _loadTs();
  const absPath = path.resolve(filePath);

  const configPath = typescript.findConfigFile(
    path.dirname(absPath),
    typescript.sys.fileExists,
    "tsconfig.json"
  );

  const cacheKey = configPath || absPath;
  const cached = _programCache.get(cacheKey);
  if (cached) return cached;

  let program;
  if (configPath) {
    const configFile = typescript.readConfigFile(configPath, typescript.sys.readFile);
    if (configFile.error) {
      // Malformed tsconfig — fall through to single-file mode
    } else {
      const parsed = typescript.parseJsonConfigFileContent(
        configFile.config,
        typescript.sys,
        path.dirname(configPath)
      );
      program = typescript.createProgram(parsed.fileNames, {
        ...parsed.options,
        skipLibCheck: true,
        noEmit: true,
      });
    }
  }

  if (!program) {
    // No tsconfig or broken config: single-file program
    program = typescript.createProgram([absPath], {
      target: typescript.ScriptTarget.Latest,
      module: typescript.ModuleKind.ESNext,
      allowJs: true,
      checkJs: false,
      strict: false,
      skipLibCheck: true,
      noEmit: true,
      jsx: typescript.JsxEmit.Preserve,
    });
  }

  _programCache.set(cacheKey, program);
  return program;
}

/**
 * A Map-like that lazily maps sanz NodeView objects → ts.Node by position.
 * Rules call .get(sanzNode) which looks up node.start in the TypeScript AST.
 */
class EsTreeToTsNodeMap {
  constructor(sourceFile) {
    this._sf = sourceFile;
    this._cache = new WeakMap();
  }

  get(sanzNode) {
    if (!sanzNode || sanzNode.start == null) return undefined;
    const cached = this._cache.get(sanzNode);
    if (cached !== undefined) return cached;
    const result = _tsNodeAtPos(this._sf, sanzNode.start) || undefined;
    if (sanzNode && typeof sanzNode === "object") {
      this._cache.set(sanzNode, result);
    }
    return result;
  }

  has(sanzNode) {
    return this.get(sanzNode) != null;
  }
}

/**
 * Build a parserServices object compatible with @typescript-eslint rules.
 *
 * Returns null if TypeScript is unavailable or the file can't be found in the
 * program (e.g., a .js file with no tsconfig).
 */
function buildParserServices(filePath) {
  let typescript;
  try {
    typescript = _loadTs();
  } catch {
    return null;
  }

  const absPath = path.resolve(filePath);
  let program;
  try {
    program = getProgram(absPath);
  } catch {
    return null;
  }

  const sourceFile =
    program.getSourceFile(absPath) ||
    // Normalise separators on Windows
    program.getSourceFile(absPath.replace(/\\/g, "/"));

  if (!sourceFile) {
    // File not part of the program — create a standalone program for it
    try {
      const standaloneProgram = typescript.createProgram([absPath], {
        target: typescript.ScriptTarget.Latest,
        allowJs: true,
        checkJs: false,
        skipLibCheck: true,
        noEmit: true,
        jsx: typescript.JsxEmit.Preserve,
      });
      const sf = standaloneProgram.getSourceFile(absPath);
      if (!sf) return null;
      return _makeServices(standaloneProgram, sf);
    } catch {
      return null;
    }
  }

  return _makeServices(program, sourceFile);
}

function _makeServices(program, sourceFile) {
  const esTreeNodeToTSNodeMap = new EsTreeToTsNodeMap(sourceFile);

  // tsNode → sanz node: rarely used by rules, provide a no-op stub
  const tsNodeToESTreeNodeMap = {
    get(_tsNode) { return undefined; },
    has(_tsNode) { return false; },
  };

  const checker = program.getTypeChecker();
  const compilerOptions = program.getCompilerOptions();

  // Mirrors createParserServices from @typescript-eslint/typescript-estree
  return {
    program,
    esTreeNodeToTSNodeMap,
    tsNodeToESTreeNodeMap,
    hasFullTypeInformation: true,
    emitDecoratorMetadata: compilerOptions.emitDecoratorMetadata ?? false,
    experimentalDecorators: compilerOptions.experimentalDecorators ?? false,
    isolatedDeclarations: compilerOptions.isolatedDeclarations ?? false,
    getContextualType:         (node) => checker.getContextualType(esTreeNodeToTSNodeMap.get(node)),
    getResolvedSignature:      (node) => checker.getResolvedSignature(esTreeNodeToTSNodeMap.get(node)),
    getSymbolAtLocation:       (node) => checker.getSymbolAtLocation(esTreeNodeToTSNodeMap.get(node)),
    getTypeAtLocation:         (node) => checker.getTypeAtLocation(esTreeNodeToTSNodeMap.get(node)),
    getTypeFromTypeNode:       (node) => checker.getTypeFromTypeNode(esTreeNodeToTSNodeMap.get(node)),
    getTypeOfSymbolAtLocation: (symbol, node) => checker.getTypeOfSymbolAtLocation(symbol, esTreeNodeToTSNodeMap.get(node)),
  };
}

/** Clear the program cache (useful in tests or watch mode). */
function clearCache() {
  _programCache.clear();
}

module.exports = { buildParserServices, getProgram, clearCache };
