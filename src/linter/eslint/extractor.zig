const std = @import("std");
const ast_mod = @import("../../parser/ast.zig");
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const Ast = ast_mod.Ast;
const Lexer = @import("../../parser/lexer.zig").Lexer;
const Parser = @import("../../parser/parser.zig").Parser;
const compiled = @import("compiled.zig");
const Pred = compiled.Pred;
const Nav = compiled.Nav;
const Prop = compiled.Prop;
const Report = compiled.Report;
const DataBinding = compiled.DataBinding;
const DataSource = compiled.DataSource;
const CompiledRule = compiled.CompiledRule;
const Severity = @import("../../parser/diagnostic.zig").Severity;

pub fn extract(
    rule_name: []const u8,
    severity: Severity,
    handler_source: []const u8,
    messages: *const std.StringArrayHashMap([]const u8),
    allocator: std.mem.Allocator,
) ?CompiledRule {
    // Detect source form and wrap appropriately for parsing
    const is_function = std.mem.startsWith(u8, handler_source, "function ");
    const is_quoted = handler_source.len > 0 and handler_source[0] == '"';

    var wrapped: []u8 = undefined;
    var wrapped_len: usize = undefined;

    if (is_function) {
        // "function checkName(node) { ... }" → parse directly as expression
        const prefix = "(";
        const suffix = ")";
        const total = prefix.len + handler_source.len + suffix.len;
        wrapped = allocator.alloc(u8, total) catch return null;
        @memcpy(wrapped[0..prefix.len], prefix);
        @memcpy(wrapped[prefix.len..][0..handler_source.len], handler_source);
        @memcpy(wrapped[prefix.len + handler_source.len ..], suffix);
        wrapped_len = total;
    } else if (is_quoted) {
        // '"QuotedKey"(node) { ... }' → strip quotes, wrap as method
        var qi: usize = 1;
        while (qi < handler_source.len and handler_source[qi] != '"') qi += 1;
        if (qi >= handler_source.len) return null;
        const unquoted_key = handler_source[1..qi];

        // Skip selector-style keys (contain > [ ] = space) — can't be method names
        for (unquoted_key) |ch| {
            if (ch == '>' or ch == '[' or ch == ']' or ch == '=' or ch == ' ') return null;
        }

        // Strip :exit suffix from method name (already tracked in is_exit)
        const method_name = if (std.mem.endsWith(u8, unquoted_key, ":exit"))
            unquoted_key[0 .. unquoted_key.len - 5]
        else
            unquoted_key;

        const after_quote = handler_source[qi + 1 ..]; // "(node) { ... }"
        const prefix = "({";
        const suffix = "})";
        const total = prefix.len + method_name.len + after_quote.len + suffix.len;
        wrapped = allocator.alloc(u8, total) catch return null;
        var pos: usize = 0;
        @memcpy(wrapped[pos..][0..prefix.len], prefix);
        pos += prefix.len;
        @memcpy(wrapped[pos..][0..method_name.len], method_name);
        pos += method_name.len;
        @memcpy(wrapped[pos..][0..after_quote.len], after_quote);
        pos += after_quote.len;
        @memcpy(wrapped[pos..][0..suffix.len], suffix);
        wrapped_len = total;
    } else {
        // "MethodName(node) { ... }" → wrap in object literal
        const prefix = "({";
        const suffix = "})";
        const total = prefix.len + handler_source.len + suffix.len;
        wrapped = allocator.alloc(u8, total) catch return null;
        @memcpy(wrapped[0..prefix.len], prefix);
        @memcpy(wrapped[prefix.len..][0..handler_source.len], handler_source);
        @memcpy(wrapped[prefix.len + handler_source.len ..], suffix);
        wrapped_len = total;
    }
    defer allocator.free(wrapped);

    // Parse
    var tokens = Lexer.tokenize(allocator, wrapped[0..wrapped_len]) catch return null;
    var tree = Parser.parse(allocator, wrapped[0..wrapped_len], tokens.slice()) catch return null;

    // Find body and param based on source form
    const body_idx = if (is_function) findFunctionBody(&tree) else findMethodBody(&tree);
    const param_name = if (is_function) findFunctionParam(&tree) else findParamName(&tree);
    if (body_idx == null or param_name == null) return null;
    const param = param_name.?;
    const body = body_idx.?;

    // Analyze body statements
    var preds: std.ArrayList(Pred) = .empty;
    var report: ?Report = null;

    const body_tag = tree.nodeTag(body);
    if (body_tag == .block_stmt) {
        const data = tree.nodeData(body);
        const stmts_start = @intFromEnum(data.lhs);
        const stmts_end = @intFromEnum(data.rhs);
        if (stmts_start >= tree.extra_data.len or stmts_end > tree.extra_data.len) return null;
        const stmts = tree.extra_data[stmts_start..stmts_end];

        for (stmts) |raw| {
            if (raw == 0xFFFFFFFF) continue;
            const stmt: NodeIndex = @enumFromInt(raw);
            const stmt_tag = tree.nodeTag(stmt);

            switch (stmt_tag) {
                // if (cond) return; → guard predicate
                .if_stmt => {
                    if (extractGuard(&tree, stmt, param, &preds, allocator)) continue;
                    if (extractIfReport(&tree, stmt, param, messages, &preds, &report, allocator)) continue;
                    return null;
                },
                // if (cond) { ... } else { ... }
                .if_else_stmt => {
                    // Try as guard: if (cond) return; else ...
                    if (extractGuard(&tree, stmt, param, &preds, allocator)) continue;
                    if (extractIfReport(&tree, stmt, param, messages, &preds, &report, allocator)) continue;
                    return null;
                },
                // context.report({...}) or report(node) → unconditional report
                .expression_stmt => {
                    const expr: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(stmt).lhs));
                    if (expr == .none) continue;
                    if (extractReport(&tree, expr, param, messages, &report, allocator)) continue;
                    // Non-report expression — skip if we already have predicates
                    // (could be closure setup like `funcInfo = ...`)
                    if (preds.items.len > 0 or report != null) continue;
                    return null;
                },
                .return_stmt => break,
                // Skip variable declarations if we already have enough context
                .var_decl, .let_decl, .const_decl => {
                    if (report != null) continue; // already got report, skip rest
                    return null;
                },
                else => {
                    if (report != null) continue;
                    return null;
                },
            }
        }
    } else {
        return null;
    }

    const r = report orelse return null;

    return .{
        .rule_name = rule_name,
        .severity = severity,
        .predicates = preds.toOwnedSlice(allocator) catch return null,
        .report = r,
    };
}

// ── AST Navigation Helpers ─────────────────────────────────────

fn findFunctionBody(tree: *const Ast) ?NodeIndex {
    // root → expr_stmt → grouping_expr → fn_expr → body
    const root_data = tree.nodeData(.root);
    const stmts = tree.extra_data[@intFromEnum(root_data.lhs)..@intFromEnum(root_data.rhs)];
    if (stmts.len == 0) return null;

    const stmt: NodeIndex = @enumFromInt(stmts[0]);
    if (tree.nodeTag(stmt) != .expression_stmt) return null;

    var expr: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(stmt).lhs));
    if (tree.nodeTag(expr) == .grouping_expr) {
        expr = @enumFromInt(@intFromEnum(tree.nodeData(expr).lhs));
    }

    const tag = tree.nodeTag(expr);
    if (tag == .fn_expr or tag == .async_fn_expr or
        tag == .fn_decl or tag == .async_fn_decl or
        tag == .generator_fn_expr or tag == .async_generator_fn_expr)
    {
        const fd = tree.extraData(ast_mod.FnData, @intFromEnum(tree.nodeData(expr).lhs));
        return fd.body;
    }
    return null;
}

fn findFunctionParam(tree: *const Ast) ?[]const u8 {
    const root_data = tree.nodeData(.root);
    const stmts = tree.extra_data[@intFromEnum(root_data.lhs)..@intFromEnum(root_data.rhs)];
    if (stmts.len == 0) return null;

    const stmt: NodeIndex = @enumFromInt(stmts[0]);
    if (tree.nodeTag(stmt) != .expression_stmt) return null;

    var expr: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(stmt).lhs));
    if (tree.nodeTag(expr) == .grouping_expr) {
        expr = @enumFromInt(@intFromEnum(tree.nodeData(expr).lhs));
    }

    const tag = tree.nodeTag(expr);
    if (tag == .fn_expr or tag == .async_fn_expr or
        tag == .fn_decl or tag == .async_fn_decl or
        tag == .generator_fn_expr or tag == .async_generator_fn_expr)
    {
        const fd = tree.extraData(ast_mod.FnData, @intFromEnum(tree.nodeData(expr).lhs));
        const params = tree.extra_data[fd.params..fd.params_end];
        if (params.len > 0) {
            const p: NodeIndex = @enumFromInt(params[0]);
            if (p != .none and tree.nodeTag(p) == .identifier) {
                return tree.tokenText(tree.nodeMainToken(p));
            }
        }
    }
    return null;
}

fn findMethodBody(tree: *const Ast) ?NodeIndex {
    // root → expr_stmt → paren_expr → object_literal → method_def → body
    const root_data = tree.nodeData(.root);
    const stmts = tree.extra_data[@intFromEnum(root_data.lhs)..@intFromEnum(root_data.rhs)];
    if (stmts.len == 0) return null;

    const stmt: NodeIndex = @enumFromInt(stmts[0]);
    if (tree.nodeTag(stmt) != .expression_stmt) return null;

    var expr: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(stmt).lhs));
    // Unwrap parenthesized expression
    if (tree.nodeTag(expr) == .grouping_expr ) {
        expr = @enumFromInt(@intFromEnum(tree.nodeData(expr).lhs));
    }

    if (tree.nodeTag(expr) != .object_literal) return null;

    // First property should be the method
    const obj_data = tree.nodeData(expr);
    const props_start = @intFromEnum(obj_data.lhs);
    const props_end = @intFromEnum(obj_data.rhs);
    if (props_start >= tree.extra_data.len or props_end > tree.extra_data.len or props_end <= props_start) return null;
    const props = tree.extra_data[props_start..props_end];
    if (props.len == 0) return null;

    const method: NodeIndex = @enumFromInt(props[0]);
    const method_tag = tree.nodeTag(method);

    if (method_tag == .method_def or method_tag == .computed_method_def) {
        const md = tree.extraData(ast_mod.MethodData, @intFromEnum(tree.nodeData(method).rhs));
        return md.body;
    }

    return null;
}

fn findParamName(tree: *const Ast) ?[]const u8 {
    // Same traversal as findMethodBody, but extract param name
    const root_data = tree.nodeData(.root);
    const stmts = tree.extra_data[@intFromEnum(root_data.lhs)..@intFromEnum(root_data.rhs)];
    if (stmts.len == 0) return null;

    const stmt: NodeIndex = @enumFromInt(stmts[0]);
    if (tree.nodeTag(stmt) != .expression_stmt) return null;

    var expr: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(stmt).lhs));
    if (tree.nodeTag(expr) == .grouping_expr) {
        expr = @enumFromInt(@intFromEnum(tree.nodeData(expr).lhs));
    }

    if (tree.nodeTag(expr) != .object_literal) return null;

    const obj_data = tree.nodeData(expr);
    const props_start = @intFromEnum(obj_data.lhs);
    const props_end = @intFromEnum(obj_data.rhs);
    if (props_start >= tree.extra_data.len or props_end > tree.extra_data.len or props_end <= props_start) return null;
    const props = tree.extra_data[props_start..props_end];
    if (props.len == 0) return null;

    const method: NodeIndex = @enumFromInt(props[0]);
    const method_tag = tree.nodeTag(method);

    if (method_tag == .method_def or method_tag == .computed_method_def) {
        const md = tree.extraData(ast_mod.MethodData, @intFromEnum(tree.nodeData(method).rhs));
        const params = tree.extra_data[md.params_start..md.params_end];
        if (params.len > 0) {
            const p: NodeIndex = @enumFromInt(params[0]);
            if (p != .none and tree.nodeTag(p) == .identifier) {
                return tree.tokenText(tree.nodeMainToken(p));
            }
        }
    }

    return null;
}

// ── Guard Extraction ───────────────────────────────────────────
// Pattern: if (node.X !== "Y") return;  OR  if (node.X === "Y") return;

fn extractGuard(
    tree: *const Ast,
    if_idx: NodeIndex,
    param: []const u8,
    preds: *std.ArrayList(Pred),
    allocator: std.mem.Allocator,
) bool {
    const stmt_tag = tree.nodeTag(if_idx);
    const data = tree.nodeData(if_idx);
    const test_idx: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));

    if (stmt_tag == .if_stmt) {
        const consequent: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
        if (!isReturnStmt(tree, consequent)) return false;
        return extractCondAsPred(tree, test_idx, param, preds, true, allocator);
    }

    if (stmt_tag == .if_else_stmt) {
        // lhs = test, rhs = extra index to IfData { consequent, alternate }
        const if_data = tree.extraData(ast_mod.IfData, @intFromEnum(data.rhs));
        const consequent: NodeIndex = @enumFromInt(@intFromEnum(if_data.consequent));
        if (!isReturnStmt(tree, consequent)) return false;
        return extractCondAsPred(tree, test_idx, param, preds, true, allocator);
    }

    return false;
}

fn isReturnStmt(tree: *const Ast, idx: NodeIndex) bool {
    if (idx == .none) return false;
    const tag = tree.nodeTag(idx);
    if (tag == .return_stmt) return true;
    // Block with single return
    if (tag == .block_stmt) {
        const d = tree.nodeData(idx);
        const start = @intFromEnum(d.lhs);
        const end = @intFromEnum(d.rhs);
        if (start >= tree.extra_data.len or end > tree.extra_data.len) return false;
        const stmts = tree.extra_data[start..end];
        if (stmts.len == 1) {
            const s: NodeIndex = @enumFromInt(stmts[0]);
            return s != .none and tree.nodeTag(s) == .return_stmt;
        }
    }
    return false;
}

// ── Condition → Predicate ──────────────────────────────────────

fn extractCondAsPred(
    tree: *const Ast,
    cond: NodeIndex,
    param: []const u8,
    preds: *std.ArrayList(Pred),
    negate: bool,
    allocator: std.mem.Allocator,
) bool {
    if (cond == .none) return false;
    const tag = tree.nodeTag(cond);
    const data = tree.nodeData(cond);

    switch (tag) {
        // node.X !== "Y" or node.X === "Y"
        .strict_not_equal, .not_equal => {
            return extractComparison(tree, data, param, preds, if (negate) .eq else .neq, allocator);
        },
        .strict_equal, .equal => {
            return extractComparison(tree, data, param, preds, if (negate) .neq else .eq, allocator);
        },
        // !expr → negate and recurse
        .logical_not => {
            const arg: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
            return extractCondAsPred(tree, arg, param, preds, !negate, allocator);
        },
        // a && b
        .logical_and => {
            const lhs_idx: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
            const rhs_idx: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
            if (!negate) {
                // a && b (positive) → both must hold
                return extractCondAsPred(tree, lhs_idx, param, preds, false, allocator) and
                    extractCondAsPred(tree, rhs_idx, param, preds, false, allocator);
            } else {
                // !(a && b) → !a || !b — can't express as AND chain
                return false;
            }
        },
        // a || b
        .logical_or => {
            const lhs_idx: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
            const rhs_idx: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
            if (negate) {
                // !(a || b) → !a && !b
                return extractCondAsPred(tree, lhs_idx, param, preds, true, allocator) and
                    extractCondAsPred(tree, rhs_idx, param, preds, true, allocator);
            } else {
                // a || b (positive) — try as any_of disjunction
                var branch_a: std.ArrayList(Pred) = .empty;
                var branch_b: std.ArrayList(Pred) = .empty;
                if (extractCondAsPred(tree, lhs_idx, param, &branch_a, false, allocator) and
                    extractCondAsPred(tree, rhs_idx, param, &branch_b, false, allocator))
                {
                    const branches = allocator.alloc([]const Pred, 2) catch return false;
                    branches[0] = branch_a.toOwnedSlice(allocator) catch return false;
                    branches[1] = branch_b.toOwnedSlice(allocator) catch return false;
                    preds.append(allocator, .{ .any_of = branches }) catch return false;
                    return true;
                }
                return false;
            }
        },
        // Member expression as boolean: node.X (truthy) or !node.X (falsy)
        .member_expr, .optional_member_expr => {
            const nav_prop = resolveMemberChain(tree, cond, param);
            if (nav_prop) |np| {
                // Boolean properties: node.computed, node.prefix, node.shorthand
                if (np.prop == .computed or np.prop == .prefix or np.prop == .shorthand) {
                    const pred: Pred = if (negate)
                        .{ .bool_false = .{ .nav = np.nav, .prop = np.prop } }
                    else
                        .{ .bool_true = .{ .nav = np.nav, .prop = np.prop } };
                    preds.append(allocator, pred) catch return false;
                    return true;
                }
                // Other named properties: could be child node navigation
                // This is a truthy check on a child — not a predicate we can compile
                // without knowing the specific tag→child mapping
            }
            return false;
        },
        // Identifier as boolean: just a variable name, can't compile
        .identifier => return false,
        else => return false,
    }
}

const CompareOp = enum { eq, neq };

fn extractComparison(
    tree: *const Ast,
    data: Node.Data,
    param: []const u8,
    preds: *std.ArrayList(Pred),
    op: CompareOp,
    allocator: std.mem.Allocator,
) bool {
    const lhs: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
    const rhs: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));

    // Try: node.X op "literal"
    if (extractMemberVsLiteral(tree, lhs, rhs, param, preds, op, allocator)) return true;
    // Try: "literal" op node.X
    if (extractMemberVsLiteral(tree, rhs, lhs, param, preds, op, allocator)) return true;

    return false;
}

fn extractMemberVsLiteral(
    tree: *const Ast,
    member_idx: NodeIndex,
    literal_idx: NodeIndex,
    param: []const u8,
    preds: *std.ArrayList(Pred),
    op: CompareOp,
    allocator: std.mem.Allocator,
) bool {
    // literal must be a string
    if (literal_idx == .none) return false;
    const lit_tag = tree.nodeTag(literal_idx);
    if (lit_tag != .string_literal) return false;
    const raw = tree.tokenText(tree.nodeMainToken(literal_idx));
    if (raw.len < 2) return false;
    const lit_value = raw[1 .. raw.len - 1]; // strip quotes

    // member must be param.prop or param.parent.prop or param.X.prop
    const nav_prop = resolveMemberChain(tree, member_idx, param) orelse return false;

    const pred: Pred = switch (op) {
        .eq => .{ .str_eq = .{ .nav = nav_prop.nav, .prop = nav_prop.prop, .value = lit_value } },
        .neq => .{ .str_neq = .{ .nav = nav_prop.nav, .prop = nav_prop.prop, .value = lit_value } },
    };
    preds.append(allocator, pred) catch return false;
    return true;
}

const NavProp = struct { nav: Nav, prop: Prop };

fn resolveMemberChain(tree: *const Ast, idx: NodeIndex, param: []const u8) ?NavProp {
    if (idx == .none) return null;
    const tag = tree.nodeTag(idx);

    // Must be member_expr: obj.prop
    if (tag != .member_expr and tag != .optional_member_expr) return null;

    const data = tree.nodeData(idx);
    const obj: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
    const prop_text = tree.tokenText(@intFromEnum(data.rhs)); // rhs is token index for member_expr

    // Simple: param.prop
    if (obj != .none and tree.nodeTag(obj) == .identifier) {
        const obj_name = tree.tokenText(tree.nodeMainToken(obj));
        if (std.mem.eql(u8, obj_name, param)) {
            const prop = propFromName(prop_text) orelse return null;
            return .{ .nav = .self, .prop = prop };
        }
    }

    // param.parent.prop
    if (obj != .none and (tree.nodeTag(obj) == .member_expr or tree.nodeTag(obj) == .optional_member_expr)) {
        const inner_data = tree.nodeData(obj);
        const inner_obj: NodeIndex = @enumFromInt(@intFromEnum(inner_data.lhs));
        const mid_prop = tree.tokenText(@intFromEnum(inner_data.rhs));

        if (inner_obj != .none and tree.nodeTag(inner_obj) == .identifier) {
            const inner_name = tree.tokenText(tree.nodeMainToken(inner_obj));
            if (std.mem.eql(u8, inner_name, param)) {
                if (std.mem.eql(u8, mid_prop, "parent")) {
                    const prop = propFromName(prop_text) orelse return null;
                    return .{ .nav = .parent, .prop = prop };
                }
                if (std.mem.eql(u8, mid_prop, "left") or std.mem.eql(u8, mid_prop, "argument") or
                    std.mem.eql(u8, mid_prop, "callee") or std.mem.eql(u8, mid_prop, "id") or
                    std.mem.eql(u8, mid_prop, "test") or std.mem.eql(u8, mid_prop, "expression"))
                {
                    const prop = propFromName(prop_text) orelse return null;
                    return .{ .nav = .lhs, .prop = prop };
                }
                if (std.mem.eql(u8, mid_prop, "right") or std.mem.eql(u8, mid_prop, "init") or
                    std.mem.eql(u8, mid_prop, "body") or std.mem.eql(u8, mid_prop, "consequent"))
                {
                    const prop = propFromName(prop_text) orelse return null;
                    return .{ .nav = .rhs, .prop = prop };
                }
            }
        }
    }

    return null;
}

fn propFromName(name: []const u8) ?Prop {
    if (std.mem.eql(u8, name, "type")) return .type_name;
    if (std.mem.eql(u8, name, "operator")) return .operator;
    if (std.mem.eql(u8, name, "name")) return .name;
    if (std.mem.eql(u8, name, "kind")) return .kind;
    if (std.mem.eql(u8, name, "value")) return .value;
    if (std.mem.eql(u8, name, "raw")) return .raw;
    if (std.mem.eql(u8, name, "computed")) return .computed;
    if (std.mem.eql(u8, name, "prefix")) return .prefix;
    if (std.mem.eql(u8, name, "shorthand")) return .shorthand;
    return null;
}

// ── Report Extraction ──────────────────────────────────────────

fn extractIfReport(
    tree: *const Ast,
    if_idx: NodeIndex,
    param: []const u8,
    messages: *const std.StringArrayHashMap([]const u8),
    preds: *std.ArrayList(Pred),
    report: *?Report,
    allocator: std.mem.Allocator,
) bool {
    const data = tree.nodeData(if_idx);
    const test_idx: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
    const consequent: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));

    // Extract condition as positive predicate
    if (!extractCondAsPred(tree, test_idx, param, preds, false, allocator)) return false;

    // Consequent must contain context.report(...)
    return extractReportFromBlock(tree, consequent, param, messages, report, allocator);
}

fn extractReportFromBlock(
    tree: *const Ast,
    block: NodeIndex,
    param: []const u8,
    messages: *const std.StringArrayHashMap([]const u8),
    report: *?Report,
    allocator: std.mem.Allocator,
) bool {
    if (block == .none) return false;
    const tag = tree.nodeTag(block);

    if (tag == .block_stmt) {
        const d = tree.nodeData(block);
        const stmts = tree.extra_data[@intFromEnum(d.lhs)..@intFromEnum(d.rhs)];
        for (stmts) |raw| {
            if (raw == 0xFFFFFFFF) continue;
            const s: NodeIndex = @enumFromInt(raw);
            if (tree.nodeTag(s) == .expression_stmt) {
                const expr: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(s).lhs));
                if (expr != .none and extractReport(tree, expr, param, messages, report, allocator))
                    return true;
            }
        }
    } else if (tag == .expression_stmt) {
        const expr: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(block).lhs));
        return expr != .none and extractReport(tree, expr, param, messages, report, allocator);
    }
    return false;
}

fn extractReport(
    tree: *const Ast,
    call_idx: NodeIndex,
    param: []const u8,
    messages: *const std.StringArrayHashMap([]const u8),
    report: *?Report,
    allocator: std.mem.Allocator,
) bool {
    _ = param;
    if (call_idx == .none) return false;
    const tag = tree.nodeTag(call_idx);
    if (tag != .call_expr) return false;

    const data = tree.nodeData(call_idx);
    const callee: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));

    // Must be context.report or report
    if (callee == .none) return false;
    const callee_tag = tree.nodeTag(callee);

    var is_report = false;
    if (callee_tag == .member_expr) {
        const prop_text = tree.tokenText(@intFromEnum(tree.nodeData(callee).rhs));
        if (std.mem.eql(u8, prop_text, "report")) is_report = true;
    } else if (callee_tag == .identifier) {
        const name = tree.tokenText(tree.nodeMainToken(callee));
        if (std.mem.eql(u8, name, "report")) is_report = true;
    }
    if (!is_report) return false;

    // Extract arguments: context.report({ node, messageId: "X" })
    const args_range = tree.extraData(ast_mod.SubRange, @intFromEnum(data.rhs));
    const args = tree.extra_data[args_range.start..args_range.end];
    if (args.len == 0) return false;

    const arg0: NodeIndex = @enumFromInt(args[0]);
    if (arg0 == .none) return false;

    if (tree.nodeTag(arg0) == .object_literal) {
        return extractReportObject(tree, arg0, messages, report, allocator);
    }

    // report(node) — closure helper with just a node arg.
    // Use first messageId from messages as default.
    if (tree.nodeTag(arg0) == .identifier and messages.count() > 0) {
        const keys = messages.keys();
        const first_key = keys[0];
        const template = messages.get(first_key) orelse first_key;
        report.* = .{
            .message_id = first_key,
            .template = template,
            .data_bindings = &.{},
        };
        return true;
    }

    return false;
}

fn extractReportObject(
    tree: *const Ast,
    obj_idx: NodeIndex,
    messages: *const std.StringArrayHashMap([]const u8),
    report: *?Report,
    allocator: std.mem.Allocator,
) bool {
    const obj_data = tree.nodeData(obj_idx);
    const start = @intFromEnum(obj_data.lhs);
    const end = @intFromEnum(obj_data.rhs);
    if (start >= tree.extra_data.len or end > tree.extra_data.len) return false;

    const props = tree.extra_data[start..end];
    var message_id: ?[]const u8 = null;
    var data_bindings: std.ArrayList(DataBinding) = .empty;

    for (props) |raw| {
        if (raw == 0xFFFFFFFF) continue;
        const prop: NodeIndex = @enumFromInt(raw);
        const ptag = tree.nodeTag(prop);

        if (ptag == .property) {
            const pdata = tree.nodeData(prop);
            const key: NodeIndex = @enumFromInt(@intFromEnum(pdata.lhs));
            const val: NodeIndex = @enumFromInt(@intFromEnum(pdata.rhs));

            if (key == .none or val == .none) continue;
            const key_name = if (tree.nodeTag(key) == .identifier)
                tree.tokenText(tree.nodeMainToken(key))
            else if (tree.nodeTag(key) == .string_literal) blk: {
                const r = tree.tokenText(tree.nodeMainToken(key));
                break :blk if (r.len >= 2) r[1 .. r.len - 1] else r;
            } else continue;

            if (std.mem.eql(u8, key_name, "messageId")) {
                if (tree.nodeTag(val) == .string_literal) {
                    const r = tree.tokenText(tree.nodeMainToken(val));
                    if (r.len >= 2) message_id = r[1 .. r.len - 1];
                }
            }

            if (std.mem.eql(u8, key_name, "data") and tree.nodeTag(val) == .object_literal) {
                // Extract data bindings: { operator: node.operator }
                const dd = tree.nodeData(val);
                const ds = @intFromEnum(dd.lhs);
                const de = @intFromEnum(dd.rhs);
                if (ds < tree.extra_data.len and de <= tree.extra_data.len) {
                    for (tree.extra_data[ds..de]) |draw| {
                        if (draw == 0xFFFFFFFF) continue;
                        const dp: NodeIndex = @enumFromInt(draw);
                        if (tree.nodeTag(dp) == .property) {
                            const dk: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(dp).lhs));
                            const dv: NodeIndex = @enumFromInt(@intFromEnum(tree.nodeData(dp).rhs));
                            if (dk != .none and dv != .none and tree.nodeTag(dk) == .identifier) {
                                const dk_name = tree.tokenText(tree.nodeMainToken(dk));
                                // Check if value is node.prop
                                if (dv != .none and tree.nodeTag(dv) == .member_expr) {
                                    const dv_prop = tree.tokenText(@intFromEnum(tree.nodeData(dv).rhs));
                                    if (propFromName(dv_prop)) |p| {
                                        data_bindings.append(allocator, .{
                                            .key = dk_name,
                                            .source = .{ .node_prop = p },
                                        }) catch {};
                                    }
                                }
                            }
                        } else if (tree.nodeTag(dp) == .shorthand_property) {
                            // Shorthand: { operator } means key=operator, value=node.operator? Skip for now.
                        }
                    }
                }
            }
        } else if (ptag == .shorthand_property) {
            // { node } shorthand — skip, it's just the node reference
        }
    }

    const mid = message_id orelse return false;
    const template = messages.get(mid) orelse mid;

    report.* = .{
        .message_id = mid,
        .template = template,
        .data_bindings = data_bindings.toOwnedSlice(allocator) catch &.{},
    };
    return true;
}
