"use strict";

/**
 * ts-synth — synthetic TS-Compiler-shaped nodes.
 *
 * Many @typescript-eslint rules call `getParserServices(context, true).
 * esTreeNodeToTSNodeMap.get(node)` to traverse a TS-native AST for things
 * like operator precedence (`tsNode.parent.kind`), then call `ts.isX(...)`
 * type guards or compare `.kind` against `ts.SyntaxKind.*`. Without a real
 * TS Program we can't provide semantic info (inferred types, symbol
 * resolution), but we CAN provide just enough syntactic shape — a synthetic
 * node whose `.kind` matches the ESTree node type and whose `.parent`,
 * `.expression`, `.operatorToken`, etc. lazily wrap the same ESTree tree.
 *
 * This unblocks autofixes in rules like consistent-type-assertions whose
 * fix function uses the parent's syntax kind for precedence-aware wrapping
 * but doesn't actually need types.
 *
 * If the `typescript` package isn't installed in the host environment, the
 * map's `.get` returns undefined and rule fixes fall through to null — same
 * as the previous "empty WeakMap" behavior.
 */

// Lazy-load `typescript` — the rules themselves require it, so it's already
// in the require cache when we get here in conformance tests. Wrapped in a
// try so ez core stays runtime-independent of the package.
let _ts = undefined;
function getTs() {
  if (_ts !== undefined) return _ts;
  try { _ts = require("typescript"); }
  catch { _ts = null; }
  return _ts;
}

// ESTree node type → ts.SyntaxKind name. The lookup is done lazily via
// ts.SyntaxKind[name] so we don't bake in version-specific numeric values.
// Coverage = what rule fix functions actually inspect (parent.kind plus
// type guards via ts.isXxx). Add entries as new rules hit unsupported types.
const ESTREE_TO_TS_NAME = Object.freeze({
  // Program / top-level
  Program: "SourceFile",

  // Declarations
  VariableDeclaration: "VariableStatement",
  VariableDeclarator: "VariableDeclaration",
  FunctionDeclaration: "FunctionDeclaration",
  ClassDeclaration: "ClassDeclaration",
  TSInterfaceDeclaration: "InterfaceDeclaration",
  TSTypeAliasDeclaration: "TypeAliasDeclaration",
  TSEnumDeclaration: "EnumDeclaration",
  TSEnumMember: "EnumMember",
  TSModuleDeclaration: "ModuleDeclaration",
  TSDeclareFunction: "FunctionDeclaration",

  // Expressions
  Identifier: "Identifier",
  PrivateIdentifier: "PrivateIdentifier",
  Literal: "StringLiteral", // refined dynamically below
  TemplateLiteral: "TemplateExpression",
  ArrayExpression: "ArrayLiteralExpression",
  ObjectExpression: "ObjectLiteralExpression",
  Property: "PropertyAssignment",
  FunctionExpression: "FunctionExpression",
  ArrowFunctionExpression: "ArrowFunction",
  ClassExpression: "ClassExpression",
  ThisExpression: "ThisKeyword",
  Super: "SuperKeyword",
  AssignmentExpression: "BinaryExpression",
  BinaryExpression: "BinaryExpression",
  LogicalExpression: "BinaryExpression",
  ConditionalExpression: "ConditionalExpression",
  CallExpression: "CallExpression",
  NewExpression: "NewExpression",
  MemberExpression: "PropertyAccessExpression", // refined for computed
  UnaryExpression: "PrefixUnaryExpression", // refined for operator
  UpdateExpression: "PrefixUnaryExpression", // refined for postfix
  YieldExpression: "YieldExpression",
  AwaitExpression: "AwaitExpression",
  SpreadElement: "SpreadElement",
  RestElement: "BindingElement",
  SequenceExpression: "BinaryExpression", // CommaToken
  TaggedTemplateExpression: "TaggedTemplateExpression",

  // Statements
  BlockStatement: "Block",
  ExpressionStatement: "ExpressionStatement",
  ReturnStatement: "ReturnStatement",
  IfStatement: "IfStatement",
  ForStatement: "ForStatement",
  ForInStatement: "ForInStatement",
  ForOfStatement: "ForOfStatement",
  WhileStatement: "WhileStatement",
  DoWhileStatement: "DoStatement",
  SwitchStatement: "SwitchStatement",
  SwitchCase: "CaseClause", // refined for default
  ThrowStatement: "ThrowStatement",
  TryStatement: "TryStatement",
  CatchClause: "CatchClause",
  BreakStatement: "BreakStatement",
  ContinueStatement: "ContinueStatement",
  LabeledStatement: "LabeledStatement",
  EmptyStatement: "EmptyStatement",
  DebuggerStatement: "DebuggerStatement",

  // Method/class members
  MethodDefinition: "MethodDeclaration", // refined for constructor/get/set
  PropertyDefinition: "PropertyDeclaration",
  AccessorProperty: "PropertyDeclaration",
  StaticBlock: "ClassStaticBlockDeclaration",

  // TS-specific
  TSAsExpression: "AsExpression",
  TSSatisfiesExpression: "SatisfiesExpression",
  TSTypeAssertion: "TypeAssertionExpression",
  TSNonNullExpression: "NonNullExpression",
  TSInstantiationExpression: "ExpressionWithTypeArguments",
  TSTypeReference: "TypeReference",
  TSQualifiedName: "QualifiedName",
  TSTypeAnnotation: "TypeReference", // wrapper; rules rarely reach here
  TSTypeParameter: "TypeParameter",
  TSTypeParameterDeclaration: "TypeParameterDeclaration",
  TSTypeParameterInstantiation: "TypeParameterInstantiation",
  TSCallSignatureDeclaration: "CallSignature",
  TSConstructSignatureDeclaration: "ConstructSignature",
  TSMethodSignature: "MethodSignature",
  TSPropertySignature: "PropertySignature",
  TSIndexSignature: "IndexSignature",
  TSImportType: "ImportType",
  TSImportEqualsDeclaration: "ImportEqualsDeclaration",
  TSExternalModuleReference: "ExternalModuleReference",
  TSAbstractMethodDefinition: "MethodDeclaration",
  TSAbstractPropertyDefinition: "PropertyDeclaration",
  TSParameterProperty: "Parameter",

  // TS keyword types
  TSAnyKeyword: "AnyKeyword",
  TSBooleanKeyword: "BooleanKeyword",
  TSStringKeyword: "StringKeyword",
  TSNumberKeyword: "NumberKeyword",
  TSBigIntKeyword: "BigIntKeyword",
  TSSymbolKeyword: "SymbolKeyword",
  TSObjectKeyword: "ObjectKeyword",
  TSUndefinedKeyword: "UndefinedKeyword",
  TSNullKeyword: "NullKeyword",
  TSNeverKeyword: "NeverKeyword",
  TSVoidKeyword: "VoidKeyword",
  TSUnknownKeyword: "UnknownKeyword",
  TSThisType: "ThisType",
  TSIntrinsicKeyword: "IntrinsicKeyword",

  // Import/export
  ImportDeclaration: "ImportDeclaration",
  ImportSpecifier: "ImportSpecifier",
  ImportDefaultSpecifier: "ImportClause",
  ImportNamespaceSpecifier: "NamespaceImport",
  ExportNamedDeclaration: "ExportDeclaration",
  ExportDefaultDeclaration: "ExportAssignment",
  ExportAllDeclaration: "ExportDeclaration",
  ExportSpecifier: "ExportSpecifier",

  // JSX
  JSXElement: "JsxElement",
  JSXSelfClosingElement: "JsxSelfClosingElement",
  JSXOpeningElement: "JsxOpeningElement",
  JSXClosingElement: "JsxClosingElement",
  JSXFragment: "JsxFragment",
  JSXOpeningFragment: "JsxOpeningFragment",
  JSXClosingFragment: "JsxClosingFragment",
  JSXIdentifier: "Identifier",
  JSXMemberExpression: "PropertyAccessExpression",
  JSXNamespacedName: "JsxNamespacedName",
  JSXAttribute: "JsxAttribute",
  JSXSpreadAttribute: "JsxSpreadAttribute",
  JSXText: "JsxText",
  JSXExpressionContainer: "JsxExpression",
});

// Binary/logical operator → TS token kind name (looked up via ts.SyntaxKind).
const OP_TO_TS_NAME = Object.freeze({
  "+": "PlusToken",
  "-": "MinusToken",
  "*": "AsteriskToken",
  "**": "AsteriskAsteriskToken",
  "/": "SlashToken",
  "%": "PercentToken",
  "==": "EqualsEqualsToken",
  "===": "EqualsEqualsEqualsToken",
  "!=": "ExclamationEqualsToken",
  "!==": "ExclamationEqualsEqualsToken",
  "<": "LessThanToken",
  "<=": "LessThanEqualsToken",
  ">": "GreaterThanToken",
  ">=": "GreaterThanEqualsToken",
  "<<": "LessThanLessThanToken",
  ">>": "GreaterThanGreaterThanToken",
  ">>>": "GreaterThanGreaterThanGreaterThanToken",
  "&": "AmpersandToken",
  "|": "BarToken",
  "^": "CaretToken",
  "&&": "AmpersandAmpersandToken",
  "||": "BarBarToken",
  "??": "QuestionQuestionToken",
  "in": "InKeyword",
  "instanceof": "InstanceOfKeyword",
  "=": "EqualsToken",
  "+=": "PlusEqualsToken",
  "-=": "MinusEqualsToken",
  "*=": "AsteriskEqualsToken",
  "/=": "SlashEqualsToken",
  "%=": "PercentEqualsToken",
  "**=": "AsteriskAsteriskEqualsToken",
  "<<=": "LessThanLessThanEqualsToken",
  ">>=": "GreaterThanGreaterThanEqualsToken",
  ">>>=": "GreaterThanGreaterThanGreaterThanEqualsToken",
  "&=": "AmpersandEqualsToken",
  "|=": "BarEqualsToken",
  "^=": "CaretEqualsToken",
  "&&=": "AmpersandAmpersandEqualsToken",
  "||=": "BarBarEqualsToken",
  "??=": "QuestionQuestionEqualsToken",
});

function _refineKind(ts, estNode) {
  const t = estNode.type;
  if (t === "Literal") {
    const v = estNode.value;
    if (typeof v === "string") return ts.SyntaxKind.StringLiteral;
    if (typeof v === "number") return ts.SyntaxKind.NumericLiteral;
    if (typeof v === "bigint") return ts.SyntaxKind.BigIntLiteral;
    if (typeof v === "boolean") return v ? ts.SyntaxKind.TrueKeyword : ts.SyntaxKind.FalseKeyword;
    if (v === null) return ts.SyntaxKind.NullKeyword;
    if (estNode.regex) return ts.SyntaxKind.RegularExpressionLiteral;
    return ts.SyntaxKind.StringLiteral;
  }
  if (t === "MemberExpression") {
    return estNode.computed ? ts.SyntaxKind.ElementAccessExpression : ts.SyntaxKind.PropertyAccessExpression;
  }
  if (t === "UpdateExpression") {
    return estNode.prefix ? ts.SyntaxKind.PrefixUnaryExpression : ts.SyntaxKind.PostfixUnaryExpression;
  }
  if (t === "SwitchCase") {
    return estNode.test ? ts.SyntaxKind.CaseClause : ts.SyntaxKind.DefaultClause;
  }
  if (t === "MethodDefinition") {
    if (estNode.kind === "constructor") return ts.SyntaxKind.Constructor;
    if (estNode.kind === "get") return ts.SyntaxKind.GetAccessor;
    if (estNode.kind === "set") return ts.SyntaxKind.SetAccessor;
    return ts.SyntaxKind.MethodDeclaration;
  }
  return undefined;
}

// Per-instance prototype: pulls fields from the wrapped ESTree node and
// recursively synthesizes TS shapes on demand. The cache (a WeakMap keyed
// on the ESTree node) ensures `tsNode.parent === tsNode.parent` etc.
function _makeTsNodeFactory(ts, cache, source) {
  function wrap(estNode) {
    if (estNode == null || typeof estNode !== "object" || !estNode.type) return undefined;
    // TS has no distinct node for type arguments — they're a property of the
    // call/typeref/new. typescript-eslint maps the synthetic ESTree
    // TSTypeParameterInstantiation to its TS parent, so rules can ts.isCall/
    // isTypeReference on the mapped node (no-unnecessary-type-arguments).
    if (estNode.type === "TSTypeParameterInstantiation" && estNode.parent) {
      return wrap(estNode.parent);
    }
    let n = cache.get(estNode);
    if (n) return n;
    const refined = _refineKind(ts, estNode);
    const kindName = ESTREE_TO_TS_NAME[estNode.type];
    const kind = refined != null ? refined
      : (kindName && ts.SyntaxKind[kindName] != null) ? ts.SyntaxKind[kindName]
      : ts.SyntaxKind.Unknown;
    n = Object.create(_tsNodeProto);
    n._estree = estNode;
    n._wrap = wrap;
    n._ts = ts;
    n._source = source;
    n.kind = kind;
    cache.set(estNode, n);
    return n;
  }
  return wrap;
}

const _tsNodeProto = {
  get parent() {
    return this._wrap(this._estree.parent);
  },
  get expression() {
    // TS's `.expression` maps to different ESTree fields by node kind: a
    // CallExpression/NewExpression's callee is `.callee`, a member access's
    // object is `.object`. ESTree CallExpression has no `.expression`, so the
    // bare `_estree.expression` would be undefined for the most common
    // value-position consumer (getTypeAtLocation(call.expression)).
    const e = this._estree;
    const t = e.type;
    if (t === "CallExpression" || t === "NewExpression") return this._wrap(e.callee);
    if (t === "MemberExpression") return this._wrap(e.object);
    if (t === "AwaitExpression" || t === "SpreadElement") return this._wrap(e.argument);
    return this._wrap(e.expression);
  },
  get left() {
    return this._wrap(this._estree.left);
  },
  get right() {
    return this._wrap(this._estree.right);
  },
  get name() {
    // ESTree id (FunctionDeclaration, ClassDeclaration, etc.) maps to TS .name.
    const e = this._estree;
    return this._wrap(e.id ?? e.key ?? e.name);
  },
  get type() {
    // tsNode.type points at the type annotation node (TS shape). For
    // VariableDeclaration / Parameter / PropertyDeclaration: estNode.id.typeAnnotation.
    // For FunctionDeclaration / FunctionExpression / ArrowFunction the return
    // type annotation is ESTree's `.returnType` (ts FunctionLike.type) — rules
    // like no-unsafe-return gate on its presence.
    const e = this._estree;
    if (e.typeAnnotation) return this._wrap(e.typeAnnotation);
    if (e.returnType) return this._wrap(e.returnType);
    if (e.id && e.id.typeAnnotation) return this._wrap(e.id.typeAnnotation);
    return undefined;
  },
  get typeName() {
    return this._wrap(this._estree.typeName);
  },
  get typeParameters() {
    return this._wrap(this._estree.typeParameters);
  },
  get initializer() {
    // VariableDeclarator.init / EnumMember.initializer / PropertyDefinition.value
    const e = this._estree;
    return this._wrap(e.init ?? e.initializer ?? e.value);
  },
  get members() {
    // ClassDeclaration.body.body / TSInterfaceDeclaration.body.body / TSTypeLiteral.members
    const e = this._estree;
    const arr = (e.body && e.body.body) || e.members;
    if (!Array.isArray(arr)) return undefined;
    return arr.map(this._wrap);
  },
  get heritageClauses() {
    // ESTree gives ClassDeclaration.superClass + .implements separately.
    // TS combines into HeritageClauses. Rules typically check non-null; provide
    // a shape that satisfies that.
    const e = this._estree;
    const clauses = [];
    if (e.superClass) {
      clauses.push({
        kind: this._ts.SyntaxKind.HeritageClause,
        token: this._ts.SyntaxKind.ExtendsKeyword,
        types: [this._wrap(e.superClass)].filter(Boolean),
      });
    }
    if (Array.isArray(e.implements) && e.implements.length > 0) {
      clauses.push({
        kind: this._ts.SyntaxKind.HeritageClause,
        token: this._ts.SyntaxKind.ImplementsKeyword,
        types: e.implements.map(this._wrap).filter(Boolean),
      });
    }
    if (Array.isArray(e.extends) && e.extends.length > 0) {
      clauses.push({
        kind: this._ts.SyntaxKind.HeritageClause,
        token: this._ts.SyntaxKind.ExtendsKeyword,
        types: e.extends.map(this._wrap).filter(Boolean),
      });
    }
    return clauses.length > 0 ? clauses : undefined;
  },
  // ts.TryStatement parts ← ESTree block/handler/finalizer. return-await compares
  // a child node against each by identity; the wrap cache keys on the ESTree node,
  // so wrap(block) here === the child synth node walking up from inside the block.
  get tryBlock() { return this._wrap(this._estree.block); },
  get catchClause() { return this._wrap(this._estree.handler); },
  get finallyBlock() { return this._wrap(this._estree.finalizer); },
  get operatorToken() {
    const e = this._estree;
    const t = e.type;
    if (t !== "BinaryExpression" && t !== "LogicalExpression" && t !== "AssignmentExpression") {
      return undefined;
    }
    const op = e.operator;
    const name = OP_TO_TS_NAME[op];
    const kind = (name && this._ts.SyntaxKind[name] != null)
      ? this._ts.SyntaxKind[name]
      : this._ts.SyntaxKind.Unknown;
    return { kind };
  },
  get arguments() {
    const args = this._estree.arguments;
    if (!Array.isArray(args)) return undefined;
    return args.map(this._wrap);
  },
  getText() {
    // TS Node.getText() returns the source slice for this node. Use the
    // ESTree range when available.
    const e = this._estree;
    const range = e.range || (e.start != null ? [e.start, e.end] : null);
    if (!range || !this._source) return "";
    return this._source.slice(range[0], range[1]);
  },
  getChildAt(index) {
    // TS interleaves keyword tokens as children. The only consumer (return-await)
    // reads an AwaitExpression's getChildAt(1) — the operand after the `await`
    // keyword (child 0). Other kinds aren't modelled; undefined feeds the
    // facade's never-undefined getTypeAtLocation (→ unknown), so no crash.
    const e = this._estree;
    if (e.type === "AwaitExpression") return index >= 1 ? this._wrap(e.argument) : undefined;
    return undefined;
  },
  getStart() {
    const e = this._estree;
    return (e.range && e.range[0]) || e.start || 0;
  },
  getEnd() {
    const e = this._estree;
    return (e.range && e.range[1]) || e.end || 0;
  },
};

/**
 * Build a synthetic `esTreeNodeToTSNodeMap` for the given source. Returned
 * object has `.get(node)` that lazily wraps the ESTree node in a TS-shaped
 * synthetic. Returns null if the `typescript` package isn't available.
 */
function buildEsTreeNodeToTSNodeMap(source) {
  const ts = getTs();
  if (!ts) return null;
  const cache = new WeakMap();
  const wrap = _makeTsNodeFactory(ts, cache, source);
  return {
    get(node) { return wrap(node); },
    has(node) { return wrap(node) != null; },
  };
}

module.exports = { buildEsTreeNodeToTSNodeMap, getTs };
