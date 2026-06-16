// HAND-WRITTEN.
// Rule: unicorn/prefer-node-protocol
//
// Prefer `node:fs` over `fs` when importing/requiring a Node.js builtin module.
// Fires on the module-name string of:
//   - import / export-from declarations and dynamic `import(...)`
//   - `require(...)` and `process.getBuiltinModule(...)` calls
//   - `import("mod")` in type position (ts_import_type, string at mainToken+2)
//   - `typeof import("mod")` in type position (ts_typeof_type, string at mainToken+3)
// Mirrors: tests/conformance/eslint-plugin-unicorn/rules/prefer-node-protocol.js

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const Span = parser.span.Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;

pub const meta = RuleMeta{
    .name = "prefer-node-protocol",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer using the `node:` protocol when importing Node.js builtin modules.",
};

pub const relevant_tags = [_]Node.Tag{ .string_literal, .ts_import_type, .ts_typeof_type };

pub const needs_semantic = true;

/// Unprefixed Node.js builtin module names that also have a `node:` form.
const BUILTIN_MODULES = [_][]const u8{
    "assert",          "assert/strict",     "async_hooks",   "buffer",
    "child_process",   "cluster",           "console",       "constants",
    "crypto",          "dgram",             "diagnostics_channel", "dns",
    "dns/promises",    "domain",            "events",        "fs",
    "fs/promises",     "http",              "http2",         "https",
    "inspector",       "inspector/promises", "module",       "net",
    "os",              "path",              "path/posix",    "path/win32",
    "perf_hooks",      "process",           "querystring",   "readline",
    "readline/promises", "repl",            "stream",        "stream/consumers",
    "stream/promises", "stream/web",        "string_decoder", "timers",
    "timers/promises", "tls",               "trace_events",  "tty",
    "url",             "util",              "util/types",    "v8",
    "vm",              "wasi",              "worker_threads", "zlib",
};

fn isBuiltinModule(name: []const u8) bool {
    for (BUILTIN_MODULES) |m| {
        if (std.mem.eql(u8, m, name)) return true;
    }
    return false;
}

/// Decode a string-literal's raw inner text into its cooked value.
fn cookString(raw: []const u8, buf: []u8) ?[]const u8 {
    var out: usize = 0;
    var i: usize = 0;
    while (i < raw.len) {
        if (raw[i] != '\\') {
            if (out >= buf.len) return null;
            buf[out] = raw[i];
            out += 1;
            i += 1;
            continue;
        }
        i += 1;
        if (i >= raw.len) return null;
        const c = raw[i];
        var cp: ?u21 = null;
        switch (c) {
            'x' => {
                if (i + 2 >= raw.len) return null;
                cp = std.fmt.parseInt(u21, raw[i + 1 .. i + 3], 16) catch return null;
                i += 3;
            },
            'u' => {
                if (i + 1 < raw.len and raw[i + 1] == '{') {
                    const close = std.mem.indexOfScalarPos(u8, raw, i + 2, '}') orelse return null;
                    cp = std.fmt.parseInt(u21, raw[i + 2 .. close], 16) catch return null;
                    i = close + 1;
                } else {
                    if (i + 4 >= raw.len) return null;
                    cp = std.fmt.parseInt(u21, raw[i + 1 .. i + 5], 16) catch return null;
                    i += 5;
                }
            },
            else => {
                if (out >= buf.len) return null;
                buf[out] = c;
                out += 1;
                i += 1;
                continue;
            },
        }
        const code = cp orelse return null;
        const n = std.unicode.utf8Encode(code, buf[out..]) catch return null;
        out += n;
    }
    return buf[0..out];
}

/// True when `str` is the module-name string of an import/require construct.
fn isModuleSource(ctx: *const LintContext, str: NodeIndex, parent: NodeIndex) bool {
    const ptag = ctx.ast.nodeTag(parent);
    switch (ptag) {
        .import_decl, .export_named_from => {
            const d = ctx.ast.extraData(ast.ImportData, @intFromEnum(ctx.ast.nodeData(parent).lhs));
            return d.source == str;
        },
        .import_expr => {
            return ctx.nodeSkipGrouping(ctx.ast.nodeData(parent).lhs) == str;
        },
        .export_all => {
            return ctx.ast.nodeData(parent).lhs == str;
        },
        .call_expr => {
            const d = ctx.ast.nodeData(parent);
            if (d.rhs == .none) return false;
            const sr = ctx.ast.extraData(ast.SubRange, @intFromEnum(d.rhs));
            const args = ctx.ast.extraSlice(sr);
            if (args.len != 1) return false;
            if (@as(NodeIndex, @enumFromInt(args[0])) != str) return false;
            const callee = ctx.nodeSkipGrouping(d.lhs);
            const ctag = ctx.ast.nodeTag(callee);
            if (ctag == .identifier) {
                return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "require");
            }
            if (ctag == .member_expr) {
                const obj = ctx.nodeSkipGrouping(ctx.ast.nodeData(callee).lhs);
                const prop = ctx.ast.nodeData(callee).rhs;
                if (obj == .none or ctx.ast.nodeTag(obj) != .identifier) return false;
                if (prop == .none or ctx.ast.nodeTag(prop) != .property_ident) return false;
                return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "process") and
                    std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(prop)), "getBuiltinModule");
            }
            return false;
        },
        else => return false,
    }
}

/// Report on a token-encoded module string (ts_import_type / ts_typeof_type).
/// `str_tok` is the token index of the quoted module string.
fn reportTokenModule(str_tok: u32, ctx: *const LintContext) void {
    const tok_text = ctx.tokenText(str_tok);
    if (tok_text.len < 2) return;
    const q = tok_text[0];
    if (q != '"' and q != '\'') return;
    const inner = tok_text[1 .. tok_text.len - 1];
    var buf: [256]u8 = undefined;
    const value = cookString(inner, &buf) orelse return;
    if (std.mem.startsWith(u8, value, "node:")) return;
    if (!isBuiltinModule(value)) return;
    const tok_start = ctx.tokenStart(str_tok);
    const tok_end = ctx.tokenEnd(str_tok);
    const diag_span = Span{ .start = tok_start, .end = tok_end };
    // Fix: insert "node:" after the opening quote.
    const fix_span = Span{ .start = tok_start + 1, .end = tok_start + 1 };
    ctx.reportSpanWithFixAndMessageId(diag_span, fix_span, "node:", "prefer-node-protocol");
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);

    // ts_import_type: `import("mod")` in type position.
    // The module string token is at mainToken+2: `import` `(` `"mod"`.
    if (tag == .ts_import_type) {
        const mt = ctx.nodeMainToken(node);
        reportTokenModule(mt + 2, ctx);
        return;
    }

    // ts_typeof_type: `typeof import("mod")` in type position.
    // Detect by checking token at mt+1 == `import`; string is at mt+3.
    if (tag == .ts_typeof_type) {
        const mt = ctx.nodeMainToken(node);
        if (!std.mem.eql(u8, ctx.tokenText(mt + 1), "import")) return;
        reportTokenModule(mt + 3, ctx);
        return;
    }

    // string_literal: standard import/require paths.
    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    if (!isModuleSource(ctx, node, parent)) return;

    const raw = ctx.nodeStaticStringValue(node) orelse return;
    var buf: [256]u8 = undefined;
    const value = cookString(raw, &buf) orelse return;
    if (std.mem.startsWith(u8, value, "node:")) return;
    if (!isBuiltinModule(value)) return;

    const sp = ctx.nodeSpan(node);
    const fix_span = Span{ .start = sp.start + 1, .end = sp.start + 1 };
    ctx.reportSpanWithFixAndMessageId(sp, fix_span, "node:", "prefer-node-protocol");
}
