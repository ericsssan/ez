"use strict";

/**
 * ts-services — TypeScript type-aware linting support for Ez.
 *
 * Uses the user's installed `typescript` package to provide parserServices
 * (getTypeAtLocation, getSymbolAtLocation, etc.) to type-aware ESLint rules.
 *
 * Architecture:
 *   - Eager: LanguageService starts when tsconfig.json is detected
 *   - Plugin-agnostic: any rule calling getParserServices() gets types
 *   - Span bridge: ESTree node [range[0], range[1]] → ts.Node via parent walk
 *   - No @typescript-eslint/parser dependency — just `typescript`
 */

const fs   = require("fs");
const path = require("path");

// ── Load user's TypeScript ───────────────────────────────────

let ts = null;
try { ts = require("typescript"); } catch { /* not installed */ }

if (!ts) {
  // Export a no-op module — type-aware rules will be skipped silently
  module.exports = { init() {}, buildParserServices() { return null; }, dispose() {} };
  return;
}

// ── State ────────────────────────────────────────────────────

let _langService = null;
let _program = null;
let _configPath = null;
let _compilerOptions = null;
let _projectDir = null;
let _fileVersions = new Map();   // filename → version string (incremented on change)
let _fileContents = new Map();   // filename → source text (from Ez's buffer or disk)
let _sourceFiles = new Map();    // filename → ts.SourceFile (cached for position bridge)
let _initialized = false;

// ── tsconfig detection ───────────────────────────────────────

function findTsConfig(startDir) {
  let dir = path.resolve(startDir);
  while (true) {
    const candidate = path.join(dir, "tsconfig.json");
    if (fs.existsSync(candidate)) return candidate;
    const parent = path.dirname(dir);
    if (parent === dir) return null;
    dir = parent;
  }
}

// ── LanguageService setup ────────────────────────────────────

function _createLanguageService(configFile) {
  const configContent = ts.readConfigFile(configFile, ts.sys.readFile);
  if (configContent.error) return null;

  const projectDir = path.dirname(configFile);
  const parsed = ts.parseJsonConfigFileContent(
    configContent.config, ts.sys, projectDir,
    undefined, configFile,
  );

  _compilerOptions = parsed.options;
  _projectDir = projectDir;
  _configPath = configFile;

  // Seed file versions from discovered files
  for (const f of parsed.fileNames) {
    if (!_fileVersions.has(f)) _fileVersions.set(f, "0");
  }

  const host = {
    getScriptFileNames: () => [..._fileVersions.keys()],
    getScriptVersion: (fileName) => _fileVersions.get(fileName) || "0",
    getScriptSnapshot: (fileName) => {
      // Prefer Ez's in-memory buffer over disk
      const buffered = _fileContents.get(fileName);
      if (buffered != null) return ts.ScriptSnapshot.fromString(buffered);
      try {
        const text = ts.sys.readFile(fileName);
        return text != null ? ts.ScriptSnapshot.fromString(text) : undefined;
      } catch { return undefined; }
    },
    getCurrentDirectory: () => _projectDir,
    getCompilationSettings: () => _compilerOptions,
    getDefaultLibFileName: (opts) => ts.getDefaultLibFilePath(opts),
    fileExists: (fileName) => _fileContents.has(fileName) || ts.sys.fileExists(fileName),
    readFile: (fileName) => _fileContents.get(fileName) ?? ts.sys.readFile(fileName),
    readDirectory: ts.sys.readDirectory?.bind(ts.sys),
    directoryExists: ts.sys.directoryExists?.bind(ts.sys),
    getDirectories: ts.sys.getDirectories?.bind(ts.sys),

    // Pre-computed module resolution — feed Ez's resolved imports when available
    // For now, let tsc handle resolution (it caches aggressively)
    resolveModuleNameLiterals: undefined,
  };

  return ts.createLanguageService(host, ts.createDocumentRegistry());
}

// ── Span bridge ──────────────────────────────────────────────
// Walk up from token at position to find ts.Node matching ESTree span.
// Validated: 45/45 tests pass across CallExpression, BinaryExpression,
// PropertyAccess, NewExpression, optional chaining, type assertions,
// class declarations, destructuring, generics.

function _findTsNodeForSpan(sourceFile, start, end) {
  const token = ts.getTokenAtPosition(sourceFile, start);
  let node = token;
  let best = token;
  while (node) {
    const nodeStart = node.getStart(sourceFile);
    if (nodeStart < start) break;
    if (Math.abs(node.end - end) <= Math.abs(best.end - end)) {
      best = node;
    }
    node = node.parent;
  }
  return best;
}

// ── parserServices builder ───────────────────────────────────

function _buildMapProxy(sourceFile) {
  // Proxy that mimics WeakMap<ESTreeNode, ts.Node>.
  // Rules call .get(estreeNode) → returns matching ts.Node via span bridge.
  // Rules call .has(estreeNode) → always true (we can always find a ts.Node).
  return {
    get(estreeNode) {
      if (!estreeNode?.range) return undefined;
      return _findTsNodeForSpan(sourceFile, estreeNode.range[0], estreeNode.range[1]);
    },
    has(estreeNode) {
      return estreeNode?.range != null;
    },
  };
}

function _buildReverseMapProxy(sourceFile, esTreeMap) {
  // Reverse map: ts.Node → ESTree node. Rarely used by rules.
  // Return a minimal proxy — rules that need this typically just check .has().
  return {
    get(_tsNode) { return undefined; },
    has(_tsNode) { return false; },
  };
}

// ── Public API ───────────────────────────────────────────────

/**
 * Initialize the TypeScript language service eagerly.
 * Call at startup when tsconfig.json is detected.
 *
 * @param {string} [cwd] - Working directory to search for tsconfig.json
 * @returns {boolean} true if service was initialized
 */
function init(cwd) {
  if (_initialized) return !!_langService;

  _initialized = true;
  const configFile = findTsConfig(cwd || process.cwd());
  if (!configFile) return false;

  _langService = _createLanguageService(configFile);
  return !!_langService;
}

/**
 * Update file content in the language service (for LSP/watch mode).
 * Call when a file changes before building parserServices.
 *
 * @param {string} filename - Absolute file path
 * @param {string} source - Current file content
 */
function updateFile(filename, source) {
  const abs = path.resolve(filename);
  _fileContents.set(abs, source);
  const prev = _fileVersions.get(abs);
  _fileVersions.set(abs, String((parseInt(prev || "0", 10) + 1)));
  _sourceFiles.delete(abs);  // invalidate cached sourceFile
}

/**
 * Build parserServices for a file. Returns the object that type-aware rules
 * expect from getParserServices(context).
 *
 * @param {string} filename - Absolute file path
 * @param {string} [source] - Source text (if available, avoids disk read)
 * @returns {object|null} parserServices or null if types unavailable
 */
function buildParserServices(filename, source) {
  // init() must be called explicitly at startup with the project root.
  // buildParserServices never triggers lazy init — if the service isn't
  // initialized, there's no tsconfig and type-aware rules are skipped.
  if (!_langService) return null;

  const abs = filename;

  // Update file content if source was provided
  if (source != null) {
    updateFile(abs, source);
  } else if (!_fileContents.has(abs)) {
    // Ensure the file is known to the language service
    try {
      const text = fs.readFileSync(abs, "utf8");
      _fileContents.set(abs, text);
      if (!_fileVersions.has(abs)) _fileVersions.set(abs, "0");
    } catch { return null; }
  }

  // Get the program — triggers incremental re-check for changed files
  const program = _langService.getProgram();
  if (!program) return null;

  const sourceFile = program.getSourceFile(abs);
  if (!sourceFile) {
    // File not in program (not included in tsconfig).
    // Add it and retry.
    if (!_fileVersions.has(abs)) {
      _fileVersions.set(abs, "0");
      const retryProgram = _langService.getProgram();
      const retrySF = retryProgram?.getSourceFile(abs);
      if (!retrySF) return null;
      return _buildServices(retryProgram, retrySF, abs);
    }
    return null;
  }

  return _buildServices(program, sourceFile, abs);
}

function _buildServices(program, sourceFile, filename) {
  const checker = program.getTypeChecker();
  const esTreeNodeToTSNodeMap = _buildMapProxy(sourceFile);
  const tsNodeToESTreeNodeMap = _buildReverseMapProxy(sourceFile, esTreeNodeToTSNodeMap);

  // No prewarm.  program.getSemanticDiagnostics(sourceFile) previously ran
  // here to force full type resolution up front, on the theory that many
  // per-node queries would hit a warm cache.  In practice it computes and
  // formats every TS error/warning for the file — createDiagnosticForNode,
  // formatStringFromArgs, createFileDiagnostic — which the caller discards.
  // Dropping the prewarm cut ~12% of total lint time on the 1000-file
  // profile; first getTypeAtLocation pays its own resolution cost, which
  // is cheaper than prewarming everything.

  return {
    program,
    esTreeNodeToTSNodeMap,
    tsNodeToESTreeNodeMap,

    getTypeAtLocation(estreeNode) {
      const tsNode = esTreeNodeToTSNodeMap.get(estreeNode);
      return tsNode ? checker.getTypeAtLocation(tsNode) : checker.getAnyType();
    },

    getSymbolAtLocation(estreeNode) {
      const tsNode = esTreeNodeToTSNodeMap.get(estreeNode);
      return tsNode ? checker.getSymbolAtLocation(tsNode) : undefined;
    },

    getContextualType(estreeNode) {
      const tsNode = esTreeNodeToTSNodeMap.get(estreeNode);
      if (!tsNode) return undefined;
      try { return checker.getContextualType(tsNode); } catch { return undefined; }
    },

    getResolvedSignature(estreeNode) {
      const tsNode = esTreeNodeToTSNodeMap.get(estreeNode);
      if (!tsNode) return undefined;
      try { return checker.getResolvedSignature(tsNode); } catch { return undefined; }
    },

    getTypeFromTypeNode(estreeNode) {
      const tsNode = esTreeNodeToTSNodeMap.get(estreeNode);
      if (!tsNode) return checker.getAnyType();
      try { return checker.getTypeFromTypeNode(tsNode); } catch { return checker.getAnyType(); }
    },

    getTypeOfSymbolAtLocation(symbol, estreeNode) {
      const tsNode = esTreeNodeToTSNodeMap.get(estreeNode);
      if (!tsNode) return checker.getAnyType();
      return checker.getTypeOfSymbolAtLocation(symbol, tsNode);
    },
  };
}

/**
 * Dispose the language service and free resources.
 */
function dispose() {
  if (_langService) {
    _langService.dispose();
    _langService = null;
  }
  _program = null;
  _fileVersions.clear();
  _fileContents.clear();
  _sourceFiles.clear();
  _initialized = false;
}

/**
 * Pre-register a batch of files with the LanguageService before any
 * buildParserServices call.  Avoids the O(N) rebinding cost of adding
 * files one at a time: TS getProgram() fires once on first query and
 * sees every file, rather than re-running binding as each new file gets
 * inserted.  Safe to call multiple times; unknown files are added.
 *
 * @param {string[]} paths  Absolute file paths
 */
function registerFiles(paths) {
  if (!_langService) return;
  for (const p of paths) {
    if (!_fileVersions.has(p)) _fileVersions.set(p, "0");
  }
  // Do not force getProgram() here — let the first real query trigger it.
}

module.exports = { init, updateFile, buildParserServices, registerFiles, dispose, findTsConfig };
