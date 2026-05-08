// Programmatic transform for `eslint-plugin-jsdoc/src/iterateJsdoc.js`.
//
// What it changes
// ---------------
// Each jsdoc rule wraps its handler in `iterateJsdoc(...)`, which
// produces a rule whose `create(context)` returns a visitor with a
// `*:not(Program)` listener that runs on every non-Program node. With
// ~30 jsdoc rules, that's 30 separate listeners installed against the
// same selector. The dispatcher fires each one per node visit; each
// listener calls `getJSDocComment(sourceCode, node, settings)` and
// then per-rule tracking/dispatch.
//
// Profile of typescript.js (947k nodes) attributed 10.6% Total to the
// `*:not(Program)` selector — 30 wrapper-call frames × 947k nodes plus
// 30 (mostly-cached) `getJSDocComment` calls per node.
//
// Coalesce: register each rule's per-node callback into a per-source-
// code shared registry. Only the FIRST rule returns the
// `*:not(Program)` listener; that listener computes `getJSDocComment`
// ONCE per node and dispatches to every registered callback. Per-rule
// state (trackedJsdocs, state object, ruleConfig) stays in each
// rule's closure — only the outer dispatch is shared.
//
// Trade-offs
// ----------
// - Listener-installation order matters: only the first jsdoc rule's
//   `create()` for a given sourceCode installs the shared listener.
//   Subsequent rules' `create()` add to the registry and return `{}`.
// - Settings: `getJSDocComment(sourceCode, node, settings)` is called
//   with the FIRST rule's `settings`. In practice all jsdoc rules in
//   one config share `context.settings.jsdoc`, so this is the same
//   object across rules.
// - The transform is brittle: anchored on textual markers in the
//   upstream source. Sanity asserts catch upstream restructuring;
//   build aborts loudly on mismatch.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-jsdoc/src/iterateJsdoc.js";

export function transform(src) {
  // Sanity checks — upstream shape we rely on.
  if (!src.includes("const iterateAllJsdocs = ")) throw new Error("upstream missing iterateAllJsdocs");
  if (!src.includes("'*:not(Program)' (node)")) throw new Error("upstream `*:not(Program)` listener shape changed");
  if (!src.includes("'Program:exit' ()")) throw new Error("upstream `Program:exit` listener shape changed");
  if (!src.includes("const trackedJsdocs = new Set();")) throw new Error("upstream trackedJsdocs declaration changed");

  // Match the entire `return { create(context) { ... } , meta: ruleConfig.meta };`
  // block at the end of `iterateAllJsdocs`. Replace it with a coalesced version.
  // The closure-captured `callIterator`, `handler`, `settings`, `trackedJsdocs`
  // are still in scope (we don't touch the outer factory body).
  const oldReturn = `  return {
    create (context) {
      /* c8 ignore next -- Fallback to deprecated method */
      const {
        // @ts-expect-error ESLint < 10
        sourceCode = context.getSourceCode(),
      } = context;
      settings = getSettings(context);
      if (!settings) {
        return {};
      }

      if (contexts) {
        handler = commentHandler({
          ...settings,
          mode: settings.mode === 'permissive' ? 'typescript' : settings.mode,
        });
      }

      const state = {};

      return {
        /**
         * @param {import('eslint').Rule.Node} node
         * @returns {void}
         */
        '*:not(Program)' (node) {
          const commentNode = getJSDocComment(
            sourceCode, node, /** @type {Settings} */ (settings),
          );
          if (!ruleConfig.noTracking && trackedJsdocs.has(commentNode)) {
            return;
          }

          if (!commentNode) {
            if (ruleConfig.nonComment) {
              const ste = /** @type {StateObject} */ (state);
              ruleConfig.nonComment({
                node,
                state: ste,
              });
            }

            return;
          }

          trackedJsdocs.add(commentNode);
          callIterator(context, node, [
            /** @type {import('estree').Comment} */
            (commentNode),
          ], /** @type {StateObject} */ (state));
        },
        'Program:exit' () {
          const allComments = /** @type {import('estree').Comment[]} */ (
            sourceCode.getAllComments()
          );
          const untrackedJSdoc = allComments.filter((node) => {
            return !trackedJsdocs.has(node);
          });

          callIterator(
            context,
            null,
            untrackedJSdoc,
            /** @type {StateObject} */
            (state),
            true,
          );
        },
      };
    },
    meta: ruleConfig.meta,
  };
};`;

  if (!src.includes(oldReturn)) throw new Error("iterateAllJsdocs return-block shape changed (transform anchor missed)");

  const newReturn = `  return {
    create (context) {
      const sourceCode = context.sourceCode || context.getSourceCode();
      settings = getSettings(context);
      if (!settings) {
        return {};
      }

      if (contexts) {
        handler = commentHandler({
          ...settings,
          mode: settings.mode === 'permissive' ? 'typescript' : settings.mode,
        });
      }

      const state = {};

      // Per-rule callback closing over this rule state. Two
      // shapes split by whether the rule cares about non-comment
      // nodes. Most jsdoc rules do not define nonComment, so on
      // nodes without a leading JSDoc (over 99% of the AST) they
      // are pure no-ops and we skip them entirely.
      const onNodeWithComment = (node, commentNode) => {
        if (!ruleConfig.noTracking && trackedJsdocs.has(commentNode)) {
          return;
        }
        trackedJsdocs.add(commentNode);
        callIterator(context, node, [commentNode], state);
      };
      const onNodeAllNodes = (node, commentNode) => {
        if (!commentNode) {
          ruleConfig.nonComment({ node, state });
          return;
        }
        if (!ruleConfig.noTracking && trackedJsdocs.has(commentNode)) {
          return;
        }
        trackedJsdocs.add(commentNode);
        callIterator(context, node, [commentNode], state);
      };
      const onProgramExit = () => {
        const allComments = sourceCode.getAllComments();
        const untrackedJSdoc = allComments.filter((node) => !trackedJsdocs.has(node));
        callIterator(context, null, untrackedJSdoc, state, true);
      };

      // Per-sourceCode shared registry. First jsdoc rule installs
      // the *:not(Program) and Program:exit listeners; subsequent
      // rules just push callbacks. Saves listener frame setup on
      // every node visit when multiple jsdoc rules are active.
      let registry = sourceCode.__ez_jsdoc_shared_registry;
      if (!registry) {
        registry = {
          settings,
          commentOnlyFns: [],
          allNodeFns: [],
          onExitFns: [],
          installed: false,
        };
        Object.defineProperty(sourceCode, '__ez_jsdoc_shared_registry', {
          value: registry, writable: true, configurable: true, enumerable: false,
        });
      }
      if (ruleConfig.nonComment) {
        registry.allNodeFns.push(onNodeAllNodes);
      } else {
        registry.commentOnlyFns.push(onNodeWithComment);
      }
      registry.onExitFns.push(onProgramExit);

      if (registry.installed) {
        return {};
      }
      registry.installed = true;
      const sharedSettings = registry.settings;
      const commentOnlyFns = registry.commentOnlyFns;
      const allNodeFns = registry.allNodeFns;
      const onExitFns = registry.onExitFns;
      // Narrow the listener from *:not(Program) to the set of node
      // types that JSDoc actually attaches to. Two wins:
      //   1. The dispatcher routes plain type-union keys through the
      //      direct map (fast path) instead of esquery selector
      //      matching for *:not(Program).
      //   2. Most non-declaration nodes (Identifier, Literal, etc.)
      //      no longer trigger getJSDocComment, which was 10% Total
      //      pre-narrowing.
      // Types covered: declarations + class/object members + TS
      // variants + import/export carriers (types that
      // getReducedASTNode reduces, plus their containers from
      // allowableCommentNode).
      return {
        'ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration' (node) {
          const commentNode = getJSDocComment(sourceCode, node, sharedSettings);
          if (commentNode) {
            for (let i = 0, n = commentOnlyFns.length; i < n; i++) {
              commentOnlyFns[i](node, commentNode);
            }
          }
          if (allNodeFns.length) {
            for (let i = 0, n = allNodeFns.length; i < n; i++) {
              allNodeFns[i](node, commentNode);
            }
          }
        },
        'Program:exit' () {
          for (let i = 0, n = onExitFns.length; i < n; i++) {
            onExitFns[i]();
          }
        },
      };
    },
    meta: ruleConfig.meta,
  };
};`;

  return src.replace(oldReturn, newReturn);
}
