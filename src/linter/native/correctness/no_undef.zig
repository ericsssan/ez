const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ReferenceId = @import("../../../parser/reference.zig").ReferenceId;

pub const meta = RuleMeta{
    .name = "no-undef",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow the use of undeclared variables",
};

pub const relevant_tags = [_]Node.Tag{};

// ── ECMAScript built-in globals ────────────────────────────────
const es_globals = [_][]const u8{
    "undefined",      "NaN",              "Infinity",           "globalThis",
    "eval",           "parseInt",         "parseFloat",         "isNaN",
    "isFinite",       "decodeURI",        "decodeURIComponent", "encodeURI",
    "encodeURIComponent",
    "Object",         "Function",         "Boolean",            "Symbol",
    "Number",         "BigInt",           "Math",               "Date",
    "String",         "RegExp",           "Array",
    "Int8Array",      "Uint8Array",       "Uint8ClampedArray",  "Int16Array",
    "Uint16Array",    "Int32Array",       "Uint32Array",        "Float32Array",
    "Float64Array",   "BigInt64Array",    "BigUint64Array",
    "Map",            "Set",              "WeakMap",            "WeakSet",
    "WeakRef",        "FinalizationRegistry",
    "ArrayBuffer",    "SharedArrayBuffer", "DataView",          "Atomics",
    "JSON",           "Promise",          "Proxy",              "Reflect",
    "Error",          "AggregateError",   "EvalError",          "RangeError",
    "ReferenceError", "SyntaxError",      "TypeError",          "URIError",
    "Intl",           "Iterator",         "AsyncIterator",
};

// ── Browser / Web API globals ──────────────────────────────────
const browser_globals = [_][]const u8{
    "window",            "self",              "document",          "navigator",
    "location",          "history",           "screen",            "localStorage",
    "sessionStorage",    "indexedDB",         "console",
    "setTimeout",        "setInterval",       "clearTimeout",      "clearInterval",
    "requestAnimationFrame", "cancelAnimationFrame",
    "requestIdleCallback", "cancelIdleCallback",
    "queueMicrotask",   "reportError",       "structuredClone",
    "fetch",             "Request",           "Response",          "Headers",
    "URL",               "URLSearchParams",   "AbortController",   "AbortSignal",
    "WebSocket",         "EventSource",       "XMLHttpRequest",
    "FormData",          "Blob",              "File",              "FileReader",
    "Event",             "CustomEvent",       "EventTarget",
    "Element",           "HTMLElement",       "Node",              "NodeList",
    "Document",          "DocumentFragment",
    "MutationObserver",  "ResizeObserver",    "IntersectionObserver",
    "PerformanceObserver",
    "TextEncoder",       "TextDecoder",       "atob",              "btoa",
    "crypto",            "SubtleCrypto",
    "Image",             "Audio",             "OffscreenCanvas",
    "Worker",            "SharedWorker",      "MessageChannel",    "MessagePort",
    "BroadcastChannel",  "postMessage",
    "ReadableStream",    "WritableStream",    "TransformStream",
    "Performance",       "performance",
    "alert",             "confirm",           "prompt",            "open",
    "close",             "print",             "getComputedStyle",  "matchMedia",
    "DOMParser",         "Range",             "Selection",
    "HTMLDocument",      "HTMLCollection",    "DOMException",
    "Cache",             "CacheStorage",
};

// ── Node.js globals ────────────────────────────────────────────
const node_globals = [_][]const u8{
    "require",         "module",          "exports",
    "__dirname",       "__filename",
    "process",         "Buffer",          "global",
    "setImmediate",    "clearImmediate",
};

// ── Test framework globals ─────────────────────────────────────
const test_globals = [_][]const u8{
    "describe",      "it",            "test",          "expect",
    "beforeAll",     "afterAll",      "beforeEach",    "afterEach",
    "jest",          "vi",            "suite",         "bench",
    "assert",
};

const known_globals = std.StaticStringMap(void).initComptime(blk: {
    const lists = .{ es_globals, browser_globals, node_globals, test_globals };
    var count: usize = 0;
    for (lists) |list| count += list.len;
    var entries: [count]struct { []const u8, void } = undefined;
    var i: usize = 0;
    for (lists) |list| {
        for (list) |g| {
            entries[i] = .{ g, {} };
            i += 1;
        }
    }
    break :blk entries;
});

fn isKnownGlobal(name: []const u8) bool {
    return known_globals.has(name);
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const count = refs.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const ref_id = ReferenceId.fromInt(i);
        if (refs.isResolved(ref_id)) continue;
        if (refs.getKind(ref_id) == .type_of) continue;

        const node_idx = refs.getNode(ref_id);
        const name = ctx.tokenText(ctx.nodeMainToken(node_idx));
        if (isKnownGlobal(name)) continue;
        ctx.report(node_idx, meta.name, "Variable is not defined", meta.default_severity);
    }
}
