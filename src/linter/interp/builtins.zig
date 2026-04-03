const std = @import("std");
const Value = @import("value.zig").Value;
const RuntimeCallbacks = @import("interpreter.zig").RuntimeCallbacks;

/// Build the astUtils module object with native Zig implementations.
/// These replace the 92-export ast-utils.js from ESLint.
pub fn buildAstUtils(arena: std.mem.Allocator) *Value.Object {
    const obj = arena.create(Value.Object) catch @panic("OOM");
    obj.* = .{ .entries = std.StringArrayHashMap(Value).init(arena) };

    // Register each function as a string marker that the interpreter
    // will recognize in callStringBuiltin. Format: "__astUtils_<name>__"
    const funcs = [_][]const u8{
        // Node type checkers
        "isFunction",
        "isLoop",
        "isInLoop",
        "isNullOrUndefined",
        "isNullLiteral",
        "isCallee",
        "isEmptyFunction",
        "isEmptyBlock",
        "isStringLiteral",
        "isNumericLiteral",
        "isStaticTemplateLiteral",
        "isConstant",
        "isBreakableStatement",

        // Token checkers (used for sourceCode.getFirstToken filters)
        "isTokenOnSameLine",
        "isOpeningParenToken",
        "isClosingParenToken",
        "isOpeningBraceToken",
        "isClosingBraceToken",
        "isOpeningBracketToken",
        "isClosingBracketToken",
        "isSemicolonToken",
        "isCommaToken",
        "isColonToken",
        "isDotToken",
        "isCommentToken",
        "isArrowToken",
        "isKeywordToken",
        "isNotOpeningParenToken",
        "isNotClosingParenToken",
        "isNotOpeningBraceToken",
        "isNotClosingBraceToken",
        "isNotSemicolonToken",
        "isNotCommaToken",
        "isNotColonToken",

        // Property/value extractors
        "getStaticPropertyName",
        "getStaticStringValue",
        "getUpperFunction",
        "getVariableByName",
        "getPrecedence",
        "getFunctionNameWithKind",
        "getFunctionHeadLoc",
        "getModifyingReferences",
        "skipChainExpression",

        // Comparison/checking
        "isSameReference",
        "isParenthesised",
        "isSpecificId",
        "isSpecificMemberAccess",
        "isDirective",
        "isTopLevelExpressionStatement",
        "canTokensBeAdjacent",
        "needsPrecedingSemicolon",
        "couldBeError",
        "equalTokens",
        "isLogicalExpression",
        "isCoalesceExpression",
        "isMixedLogicalAndCoalesceExpressions",
        "isReferenceToGlobalVariable",
        "isES5Constructor",
        "isDefaultThisBinding",
        "isLogicalAssignmentOperator",
        "isDecimalInteger",
    };

    for (funcs) |name| {
        const marker = std.fmt.allocPrint(arena, "__astUtils_{s}__", .{name}) catch continue;
        obj.entries.put(name, .{ .string = marker }) catch {};
    }

    // Constants
    obj.entries.put("STATEMENT_LIST_PARENTS", .{ .array = &.{
        .{ .string = "Program" },
        .{ .string = "BlockStatement" },
        .{ .string = "StaticBlock" },
        .{ .string = "SwitchCase" },
    } }) catch {};

    obj.entries.put("LINEBREAK_MATCHER", .{ .string = "/[\\r\\n\\u2028\\u2029]/" }) catch {};
    obj.entries.put("SHEBANG_MATCHER", .{ .string = "/^#!.*/" }) catch {};

    return obj;
}

/// Execute a native astUtils function.
/// Called when the interpreter encounters a call to an "__astUtils_*__" marker.
pub fn callAstUtilsFunction(
    name: []const u8,
    args: []const Value,
    runtime: RuntimeCallbacks,
    arena: std.mem.Allocator,
) Value {
    // ── Node type checkers ──
    if (eql(name, "isFunction")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string) {
                const t = type_val.string;
                // ESLint pattern: /^(?:Function(?:Declaration|Expression)|ArrowFunctionExpression)$/
                // Also include MethodDefinition because sanz's AST puts block_stmt directly under
                // method_def rather than wrapping it in a FunctionExpression like ESLint does.
                return .{ .boolean = eql(t, "FunctionDeclaration") or eql(t, "FunctionExpression") or
                    eql(t, "ArrowFunctionExpression") or eql(t, "MethodDefinition") };
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isLoop")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string) {
                const t = type_val.string;
                return .{ .boolean = eql(t, "ForStatement") or eql(t, "ForInStatement") or
                    eql(t, "ForOfStatement") or eql(t, "WhileStatement") or
                    eql(t, "DoWhileStatement") };
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isNullOrUndefined")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string) {
                if (eql(type_val.string, "Literal")) {
                    const val = runtime.getNodeProperty(runtime.ctx, args[0].node, "raw");
                    if (val == .string) return .{ .boolean = eql(val.string, "null") };
                }
                if (eql(type_val.string, "Identifier")) {
                    const name_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "name");
                    if (name_val == .string) return .{ .boolean = eql(name_val.string, "undefined") };
                }
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isNullLiteral")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string and eql(type_val.string, "Literal")) {
                const val = runtime.getNodeProperty(runtime.ctx, args[0].node, "raw");
                if (val == .string) return .{ .boolean = eql(val.string, "null") };
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isStringLiteral")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string) {
                if (eql(type_val.string, "Literal")) {
                    const raw = runtime.getNodeProperty(runtime.ctx, args[0].node, "raw");
                    if (raw == .string and raw.string.len > 0) {
                        return .{ .boolean = raw.string[0] == '"' or raw.string[0] == '\'' };
                    }
                }
                return .{ .boolean = eql(type_val.string, "TemplateLiteral") };
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isCallee")) {
        if (args.len > 0 and args[0] == .node) {
            const parent = runtime.getNodeProperty(runtime.ctx, args[0].node, "parent");
            if (parent == .node) {
                const ptype = runtime.getNodeProperty(runtime.ctx, parent.node, "type");
                if (ptype == .string and (eql(ptype.string, "CallExpression") or eql(ptype.string, "NewExpression"))) {
                    const callee = runtime.getNodeProperty(runtime.ctx, parent.node, "callee");
                    if (callee == .node) return .{ .boolean = callee.node == args[0].node };
                }
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isEmptyBlock")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string and eql(type_val.string, "BlockStatement")) {
                const body = runtime.getNodeProperty(runtime.ctx, args[0].node, "body");
                if (body == .array) return .{ .boolean = body.array.len == 0 };
            }
        }
        return .{ .boolean = false };
    }

    // ── Property extractors ──

    if (eql(name, "getStaticPropertyName")) {
        if (args.len > 0 and args[0] == .node) {
            // For MemberExpression: return property name
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string) {
                if (eql(type_val.string, "MemberExpression")) {
                    const computed = runtime.getNodeProperty(runtime.ctx, args[0].node, "computed");
                    if (computed == .boolean and !computed.boolean) {
                        const prop = runtime.getNodeProperty(runtime.ctx, args[0].node, "property");
                        if (prop == .string) return .{ .string = prop.string };
                        if (prop == .node) {
                            const pname = runtime.getNodeProperty(runtime.ctx, prop.node, "name");
                            if (pname == .string) return pname;
                        }
                        // Synthetic Identifier object (from memberProp non-computed path)
                        if (prop == .object) {
                            if (prop.object.entries.get("name")) |n| {
                                if (n == .string) return n;
                            }
                        }
                    }
                }
                // For Property/MethodDefinition: return key name
                if (eql(type_val.string, "Property") or eql(type_val.string, "MethodDefinition")) {
                    const key_node = runtime.getNodeProperty(runtime.ctx, args[0].node, "key");
                    if (key_node == .node) {
                        const key_type = runtime.getNodeProperty(runtime.ctx, key_node.node, "type");
                        if (key_type == .string) {
                            if (eql(key_type.string, "Identifier")) {
                                return runtime.getNodeProperty(runtime.ctx, key_node.node, "name");
                            }
                            if (eql(key_type.string, "Literal")) {
                                return runtime.getNodeProperty(runtime.ctx, key_node.node, "value");
                            }
                        }
                    }
                }
            }
        }
        return Value.null_val;
    }

    if (eql(name, "skipChainExpression")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string and eql(type_val.string, "ChainExpression")) {
                const expr = runtime.getNodeProperty(runtime.ctx, args[0].node, "expression");
                if (expr == .node) return expr;
            }
            return args[0];
        }
        return .undefined;
    }

    if (eql(name, "getUpperFunction")) {
        if (args.len > 0 and args[0] == .node) {
            var current = runtime.getNodeProperty(runtime.ctx, args[0].node, "parent");
            var depth: u32 = 0;
            while (current == .node and depth < 100) : (depth += 1) {
                const t = runtime.getNodeProperty(runtime.ctx, current.node, "type");
                if (t == .string) {
                    if (eql(t.string, "FunctionDeclaration") or eql(t.string, "FunctionExpression") or
                        eql(t.string, "ArrowFunctionExpression"))
                        return current;
                }
                current = runtime.getNodeProperty(runtime.ctx, current.node, "parent");
            }
        }
        return Value.null_val;
    }

    if (eql(name, "getVariableByName")) {
        // getVariableByName(scope, name) → variable or null
        if (args.len >= 2 and args[0] == .scope and args[1] == .string) {
            const result = runtime.callBuiltin(runtime.ctx, .source_getScope, &.{args[0]});
            _ = result;
            // Walk scope chain looking for variable
            // For now, use the scope's variables
        }
        return Value.null_val;
    }

    if (eql(name, "isInLoop")) {
        if (args.len > 0 and args[0] == .node) {
            var current = runtime.getNodeProperty(runtime.ctx, args[0].node, "parent");
            var depth: u32 = 0;
            while (current == .node and depth < 100) : (depth += 1) {
                const t = runtime.getNodeProperty(runtime.ctx, current.node, "type");
                if (t == .string) {
                    if (eql(t.string, "ForStatement") or eql(t.string, "ForInStatement") or
                        eql(t.string, "ForOfStatement") or eql(t.string, "WhileStatement") or
                        eql(t.string, "DoWhileStatement"))
                        return .{ .boolean = true };
                    // Stop at function boundary
                    if (eql(t.string, "FunctionDeclaration") or eql(t.string, "FunctionExpression") or
                        eql(t.string, "ArrowFunctionExpression"))
                        return .{ .boolean = false };
                }
                current = runtime.getNodeProperty(runtime.ctx, current.node, "parent");
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "getPrecedence")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string) {
                const t = type_val.string;
                // ES operator precedence table
                if (eql(t, "SequenceExpression")) return .{ .number = 0 };
                if (eql(t, "AssignmentExpression") or eql(t, "ArrowFunctionExpression") or eql(t, "YieldExpression")) return .{ .number = 1 };
                if (eql(t, "ConditionalExpression")) return .{ .number = 3 };
                if (eql(t, "LogicalExpression")) {
                    const op = runtime.getNodeProperty(runtime.ctx, args[0].node, "operator");
                    if (op == .string) {
                        if (eql(op.string, "||") or eql(op.string, "??")) return .{ .number = 4 };
                        if (eql(op.string, "&&")) return .{ .number = 5 };
                    }
                }
                if (eql(t, "BinaryExpression")) {
                    const op = runtime.getNodeProperty(runtime.ctx, args[0].node, "operator");
                    if (op == .string) {
                        if (eql(op.string, "|")) return .{ .number = 6 };
                        if (eql(op.string, "^")) return .{ .number = 7 };
                        if (eql(op.string, "&")) return .{ .number = 8 };
                        if (eql(op.string, "==") or eql(op.string, "!=") or eql(op.string, "===") or eql(op.string, "!==")) return .{ .number = 9 };
                        if (eql(op.string, "<") or eql(op.string, "<=") or eql(op.string, ">") or eql(op.string, ">=") or eql(op.string, "in") or eql(op.string, "instanceof")) return .{ .number = 10 };
                        if (eql(op.string, "<<") or eql(op.string, ">>") or eql(op.string, ">>>")) return .{ .number = 11 };
                        if (eql(op.string, "+") or eql(op.string, "-")) return .{ .number = 12 };
                        if (eql(op.string, "*") or eql(op.string, "/") or eql(op.string, "%")) return .{ .number = 13 };
                        if (eql(op.string, "**")) return .{ .number = 15 };
                    }
                }
                if (eql(t, "UnaryExpression") or eql(t, "AwaitExpression")) return .{ .number = 16 };
                if (eql(t, "UpdateExpression")) return .{ .number = 17 };
                if (eql(t, "CallExpression") or eql(t, "ImportExpression")) return .{ .number = 18 };
                if (eql(t, "NewExpression")) return .{ .number = 19 };
            }
        }
        return .{ .number = -1 };
    }

    if (eql(name, "isTokenOnSameLine")) {
        // isTokenOnSameLine(left, right) — compare line numbers
        if (args.len >= 2) {
            const left_loc = getLoc(args[0], runtime);
            const right_loc = getLoc(args[1], runtime);
            if (left_loc != null and right_loc != null)
                return .{ .boolean = left_loc.? == right_loc.? };
        }
        return .{ .boolean = true };
    }

    if (eql(name, "isParenthesised")) {
        // args: (sourceCode, node) — check if node is wrapped in parens
        // Find the node argument (skip sourceCode object)
        const node_arg = for (args) |a| {
            if (a == .node) break a;
        } else return .{ .boolean = false };

        // Standard ESLint check: token after is ")" AND token before is "("
        const after = runtime.callBuiltin(runtime.ctx, .source_getTokenAfter, &.{node_arg});
        if (after == .token) {
            const after_val = runtime.getTokenProperty(runtime.ctx, after.token, "value");
            if (after_val == .string and eql(after_val.string, ")")) {
                const before = runtime.callBuiltin(runtime.ctx, .source_getTokenBefore, &.{node_arg});
                if (before == .token) {
                    const before_val = runtime.getTokenProperty(runtime.ctx, before.token, "value");
                    if (before_val == .string and eql(before_val.string, "(")) return .{ .boolean = true };
                }
            }
        }

        // sanz-specific: parenthesized SequenceExpressions include the surrounding parens in
        // their range (main_token = open_paren), so getTokenBefore/After see tokens outside
        // the parens. ESLint's SequenceExpression range excludes parens. For these nodes,
        // check if main_token == "(" to distinguish truly parenthesized sequences from those
        // whose first sub-expression starts with "(" (e.g. `() => 1, 2`).
        if (node_arg == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, node_arg.node, "type");
            if (type_val == .string and eql(type_val.string, "SequenceExpression")) {
                const mt = runtime.getNodeProperty(runtime.ctx, node_arg.node, "__mainTokenValue__");
                if (mt == .string and eql(mt.string, "(")) return .{ .boolean = true };
            }
        }

        return .{ .boolean = false };
    }

    if (eql(name, "isSpecificMemberAccess")) {
        // isSpecificMemberAccess(node, objectName, propertyName)
        if (args.len >= 2 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string and (eql(type_val.string, "MemberExpression") or eql(type_val.string, "ChainExpression"))) {
                var target = args[0];
                if (eql(type_val.string, "ChainExpression")) {
                    const expr = runtime.getNodeProperty(runtime.ctx, args[0].node, "expression");
                    if (expr == .node) target = expr;
                }
                if (target == .node) {
                    const obj_node = runtime.getNodeProperty(runtime.ctx, target.node, "object");
                    if (obj_node == .node and args[1] == .string) {
                        const obj_name = runtime.getNodeProperty(runtime.ctx, obj_node.node, "name");
                        if (obj_name == .string and eql(obj_name.string, args[1].string)) {
                            if (args.len >= 3 and args[2] == .string) {
                                const prop_name = runtime.getNodeProperty(runtime.ctx, target.node, "property");
                                if (prop_name == .string) return .{ .boolean = eql(prop_name.string, args[2].string) };
                                // Synthetic Identifier object from non-computed member
                                if (prop_name == .object) {
                                    if (prop_name.object.entries.get("name")) |n| {
                                        if (n == .string) return .{ .boolean = eql(n.string, args[2].string) };
                                    }
                                }
                                return .{ .boolean = false };
                            }
                            return .{ .boolean = true };
                        }
                    }
                }
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isSpecificId")) {
        // isSpecificId(node, name)
        if (args.len >= 2 and args[0] == .node and args[1] == .string) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string and eql(type_val.string, "Identifier")) {
                const node_name = runtime.getNodeProperty(runtime.ctx, args[0].node, "name");
                if (node_name == .string) return .{ .boolean = eql(node_name.string, args[1].string) };
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isLogicalExpression")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string and eql(type_val.string, "LogicalExpression")) {
                const op = runtime.getNodeProperty(runtime.ctx, args[0].node, "operator");
                if (op == .string) return .{ .boolean = eql(op.string, "&&") or eql(op.string, "||") };
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isCoalesceExpression")) {
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string and eql(type_val.string, "LogicalExpression")) {
                const op = runtime.getNodeProperty(runtime.ctx, args[0].node, "operator");
                if (op == .string) return .{ .boolean = eql(op.string, "??") };
            }
        }
        return .{ .boolean = false };
    }

    if (eql(name, "couldBeError")) {
        if (args.len > 0 and args[0] == .node) {
            return .{ .boolean = couldBeError(args[0].node, runtime) };
        }
        return .{ .boolean = false };
    }

    if (eql(name, "isDirective")) {
        // isDirective(node) mirrors ESLint's astUtils.isDirective:
        //   node.type === "ExpressionStatement" && typeof node.directive === "string"
        // The `directive` property is set only on UNPARENTHESIZED string literal
        // expression statements (matching espree's behaviour). Parenthesized
        // string literals like ("a") are NOT directives.
        if (args.len > 0 and args[0] == .node) {
            const type_val = runtime.getNodeProperty(runtime.ctx, args[0].node, "type");
            if (type_val == .string and eql(type_val.string, "ExpressionStatement")) {
                const directive = runtime.getNodeProperty(runtime.ctx, args[0].node, "directive");
                return .{ .boolean = directive == .string };
            }
        }
        return .{ .boolean = false };
    }

    // ── Token type checkers (return functions for use as filter callbacks) ──
    // These are used like: sourceCode.getFirstToken(node, { filter: astUtils.isOpeningParenToken })
    // We return a string marker; the interpreter handles the callback dispatch.
    if (std.mem.startsWith(u8, name, "is") and std.mem.endsWith(u8, name, "Token")) {
        // Already returned as string markers
        return .undefined;
    }

    // ── Regex-returning functions — return regex strings so exec stub fires ──
    // Any function returning a regex/matcher must return a string starting with '/'
    // so that accessing .exec on it returns the __regex_exec_null__ stub.
    if (eql(name, "createGlobalLinebreakMatcher") or
        eql(name, "createGlobalLinebreakMatcherFn") or
        eql(name, "createLinebreakMatcher") or
        eql(name, "LINEBREAK_MATCHER") or
        eql(name, "createNewlineRegex") or
        eql(name, "createTaggedTemplateLiteralChecker"))
    {
        _ = arena;
        return .{ .string = "/regex_stub/g" };
    }

    // ── Fallback: return undefined for unimplemented functions ──
    _ = arena;
    return .undefined;
}

/// Mirrors ESLint's astUtils.couldBeError() — returns true if the node could
/// evaluate to an Error object at runtime (and should therefore not be flagged
/// by no-throw-literal).
fn couldBeError(node_id: u32, runtime: RuntimeCallbacks) bool {
    const type_val = runtime.getNodeProperty(runtime.ctx, node_id, "type");
    if (type_val != .string) return false;
    const t = type_val.string;

    // Always possibly an error
    if (eql(t, "Identifier") or
        eql(t, "CallExpression") or
        eql(t, "NewExpression") or
        eql(t, "MemberExpression") or
        eql(t, "TaggedTemplateExpression") or
        eql(t, "YieldExpression") or
        eql(t, "AwaitExpression") or
        eql(t, "ChainExpression")) return true;

    if (eql(t, "AssignmentExpression")) {
        const op = runtime.getNodeProperty(runtime.ctx, node_id, "operator");
        if (op == .string) {
            if (eql(op.string, "=") or eql(op.string, "&&=")) {
                const right = runtime.getNodeProperty(runtime.ctx, node_id, "right");
                if (right == .node) return couldBeError(right.node, runtime);
                return false;
            }
            if (eql(op.string, "||=") or eql(op.string, "??=")) {
                const left = runtime.getNodeProperty(runtime.ctx, node_id, "left");
                const right = runtime.getNodeProperty(runtime.ctx, node_id, "right");
                const l = if (left == .node) couldBeError(left.node, runtime) else false;
                const r = if (right == .node) couldBeError(right.node, runtime) else false;
                return l or r;
            }
        }
        return false;
    }

    if (eql(t, "SequenceExpression")) {
        const exprs = runtime.getNodeProperty(runtime.ctx, node_id, "expressions");
        if (exprs == .array and exprs.array.len > 0) {
            const last = exprs.array[exprs.array.len - 1];
            if (last == .node) return couldBeError(last.node, runtime);
        }
        return false;
    }

    if (eql(t, "LogicalExpression")) {
        const op = runtime.getNodeProperty(runtime.ctx, node_id, "operator");
        if (op == .string and eql(op.string, "&&")) {
            const right = runtime.getNodeProperty(runtime.ctx, node_id, "right");
            if (right == .node) return couldBeError(right.node, runtime);
            return false;
        }
        const left = runtime.getNodeProperty(runtime.ctx, node_id, "left");
        const right = runtime.getNodeProperty(runtime.ctx, node_id, "right");
        const l = if (left == .node) couldBeError(left.node, runtime) else false;
        const r = if (right == .node) couldBeError(right.node, runtime) else false;
        return l or r;
    }

    if (eql(t, "ConditionalExpression")) {
        const consequent = runtime.getNodeProperty(runtime.ctx, node_id, "consequent");
        const alternate = runtime.getNodeProperty(runtime.ctx, node_id, "alternate");
        const c = if (consequent == .node) couldBeError(consequent.node, runtime) else false;
        const a = if (alternate == .node) couldBeError(alternate.node, runtime) else false;
        return c or a;
    }

    return false;
}

fn getLoc(val: Value, runtime: RuntimeCallbacks) ?f64 {
    if (val == .node) {
        const loc = runtime.getNodeProperty(runtime.ctx, val.node, "loc");
        if (loc == .object) {
            const end_obj = loc.object.get("end");
            if (end_obj == .object) {
                const line = end_obj.object.get("line");
                if (line == .number) return line.number;
            }
        }
    }
    if (val == .token) {
        const loc = runtime.getTokenProperty(runtime.ctx, val.token, "loc");
        if (loc == .object) {
            const end_obj = loc.object.get("end");
            if (end_obj == .object) {
                const line = end_obj.object.get("line");
                if (line == .number) return line.number;
            }
        }
    }
    return null;
}

fn eql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}
