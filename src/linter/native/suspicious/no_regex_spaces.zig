const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .regex_literal, .call_expr, .new_expr };

pub const meta = RuleMeta{
    .name = "no-regex-spaces",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow multiple consecutive spaces in regular expression literals",
};

const MSG = "Multiple consecutive spaces in regex. Use a quantifier instead, e.g. ' {2}'";

/// Returns true if character at position j is a regex quantifier start (+, *, ?, {).
fn isQuantifier(text: []const u8, j: usize, end: usize) bool {
    if (j >= end) return false;
    const c = text[j];
    return c == '+' or c == '*' or c == '?' or c == '{';
}

/// Scan `text[start..end]` for multiple consecutive spaces (outside character classes).
///
/// Regex-pattern scan rules (used for both regex literals and RegExp string args):
///   - `\[` and `\]` do NOT affect character class state (bracket is "escaped")
///   - `\ ` (backslash-space): the `\` is not a space (resets the run), but the space
///     immediately FOLLOWING it is still counted. ESLint checks for consecutive
///     space characters in the raw pattern text regardless of preceding `\`.
///   - For any other `\X`: skip X entirely (it's not a space and has no class effect).
///
/// Returns true if a violation was found.
fn scanForSpaces(text: []const u8, start: usize, end: usize) bool {
    var in_class = false;
    var consecutive_spaces: u32 = 0;
    var i: usize = start;
    while (i < end) : (i += 1) {
        if (text[i] == '\\') {
            consecutive_spaces = 0; // \ itself is not a space
            if (i + 1 < end) {
                const next = text[i + 1];
                if (next == '[' or next == ']') {
                    // Skip bracket: it does NOT open/close a character class.
                    i += 1;
                } else if (next == ' ') {
                    // Do NOT skip the space — let the outer loop process it.
                    // (ESLint counts spaces even when preceded by \)
                } else {
                    // Any other escaped char: skip it entirely.
                    i += 1;
                }
            }
            continue;
        }

        if (text[i] == '[') {
            in_class = true;
            consecutive_spaces = 0;
            continue;
        }
        if (text[i] == ']') {
            in_class = false;
            consecutive_spaces = 0;
            continue;
        }

        if (text[i] == ' ' and !in_class) {
            consecutive_spaces += 1;
            if (consecutive_spaces >= 2) {
                const next_j = i + 1;
                const last_quantified = isQuantifier(text, next_j, end);
                const effective = if (last_quantified) consecutive_spaces - 1 else consecutive_spaces;
                if (effective >= 2) return true;
            }
        } else {
            consecutive_spaces = 0;
        }
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);

    if (tag == .regex_literal) {
        runOnRegexLiteral(node, ctx);
    } else {
        runOnRegExpCall(node, ctx);
    }
}

fn runOnRegexLiteral(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    // Find where the pattern ends (closing unescaped /) to know the valid range.
    var pattern_end: usize = text.len;
    {
        var k: usize = 1;
        var in_cls = false;
        while (k < text.len) : (k += 1) {
            if (text[k] == '\\') { k += 1; continue; }
            if (text[k] == '[') { in_cls = true; continue; }
            if (text[k] == ']') { in_cls = false; continue; }
            if (text[k] == '/' and !in_cls) { pattern_end = k; break; }
        }
    }

    if (scanForSpaces(text, 1, pattern_end)) {
        ctx.report(node);
    }
}

/// Scan a JS string's raw content for consecutive spaces in the embedded regex pattern.
///
/// In a JS string, escape sequences differ from regex escapes:
///   - `\\` → literal `\` (skip 2 source chars; the `\` in the regex doesn't open a class)
///   - `\n`, `\r`, `\t`, `\v`, `\b`, `\f`, `\0` → control chars (skip 2; not spaces)
///   - `\uXXXX` → Unicode char (skip 6)
///   - `\xXX` → hex char (skip 4)
///   - `\[`, `\]` → NOT a valid string escape; the `\` is consumed, leaving `[`/`]`
///     which DOES affect character class tracking in the regex pattern.
///   - `\ ` (backslash-space) → `\` consumed, leaving ` ` which counts as a space.
///
/// We need to reconstruct which characters end up in the regex pattern (to track
/// character classes) and which positions in the raw text correspond to spaces.
/// Because this is approximate (we skip proper JS string evaluation), we handle
/// the common cases and skip unusual ones.
fn scanStringPatternForSpaces(text: []const u8, start: usize, end: usize) bool {
    var in_class = false;
    var consecutive_spaces: u32 = 0;
    var i: usize = start;
    while (i < end) : (i += 1) {
        if (text[i] == '\\') {
            if (i + 1 >= end) break;
            const next = text[i + 1];
            switch (next) {
                // `\\` → literal `\` in the regex pattern.
                // The `\` in the regex may then escape the NEXT raw string character.
                // Specifically: `\\[` → `\[` in regex = escaped bracket (does NOT open class).
                '\\' => {
                    consecutive_spaces = 0;
                    i += 1; // consume the second `\`
                    // If the next raw char is `[` or `]`, it becomes `\[`/`\]` in the
                    // regex (escaped bracket), so skip it and don't affect class state.
                    if (i + 1 < end) {
                        const after_escape = text[i + 1];
                        if (after_escape == '[' or after_escape == ']') {
                            i += 1; // skip the bracket entirely
                        }
                    }
                    continue;
                },
                // Other recognized string escapes: skip 2 source chars, not a space
                'n', 'r', 't', 'v', 'b', 'f', '0', '\'', '"' => {
                    consecutive_spaces = 0;
                    i += 1; // skip the escape char; outer loop advances again
                    continue;
                },
                // `\uXXXX`: skip 6 chars total
                'u' => {
                    consecutive_spaces = 0;
                    const skip_to = i + 5;
                    i = if (skip_to < end) skip_to else end - 1;
                    continue;
                },
                // `\xXX`: skip 4 chars total
                'x' => {
                    consecutive_spaces = 0;
                    const skip_to = i + 3;
                    i = if (skip_to < end) skip_to else end - 1;
                    continue;
                },
                // `\[` → `\` consumed, `[` remains in pattern → opens character class
                '[' => {
                    consecutive_spaces = 0;
                    in_class = true;
                    i += 1; // consume the `\`, let `[` be "processed" (we do it here)
                    continue;
                },
                // `\]` → `\` consumed, `]` remains → closes character class
                ']' => {
                    consecutive_spaces = 0;
                    in_class = false;
                    i += 1;
                    continue;
                },
                // `\ ` (space) → `\` consumed, ` ` remains in pattern — count it
                ' ' => {
                    consecutive_spaces = 0; // the `\` breaks any run; space is handled next
                    // Don't advance: let outer loop process the space at i+1
                    // But we need to eat the `\` here. Since continue will NOT advance i
                    // (we need the outer loop to advance to i+1 = the space), we can:
                    // Just don't advance. The outer loop increments i → processes space.
                    // But wait, we're at `\` (i), outer loop will increment to `\`+1 = space.
                    // The space will be processed next iteration. ✓
                },
                // Any other `\X`: skip both (not a recognized class-state char)
                else => {
                    consecutive_spaces = 0;
                    i += 1;
                    continue;
                },
            }
            continue;
        }

        if (text[i] == '[') {
            in_class = true;
            consecutive_spaces = 0;
            continue;
        }
        if (text[i] == ']') {
            in_class = false;
            consecutive_spaces = 0;
            continue;
        }

        if (text[i] == ' ' and !in_class) {
            consecutive_spaces += 1;
            if (consecutive_spaces >= 2) {
                const next_j = i + 1;
                const last_quantified = isQuantifier(text, next_j, end);
                const effective = if (last_quantified) consecutive_spaces - 1 else consecutive_spaces;
                if (effective >= 2) return true;
            }
        } else {
            consecutive_spaces = 0;
        }
    }
    return false;
}

/// Heuristic: detect patterns that would be invalid in unicode/unicodeSets mode,
/// so we can skip them (ESLint skips patterns that fail to parse with regexpp).
/// Current check: a lone `{` at the start of the pattern that is not a valid
/// quantifier (not `{n}`, `{n,}`, `{n,m}`).
fn looksLikeInvalidUnicodePattern(text: []const u8, start: usize, end: usize) bool {
    if (start >= end) return false;
    // Lone `{` at start of pattern (outside char class) that isn't a valid quantifier.
    if (text[start] == '{') {
        // Check if it's a valid quantifier: {digits} or {digits,} or {digits,digits}
        const k = start + 1;
        if (k < end and (text[k] < '0' or text[k] > '9')) {
            return true; // `{` not followed by a digit → invalid in unicode mode
        }
    }
    return false;
}

fn runOnRegExpCall(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // Callee must be a bare identifier named "RegExp".
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;
    const callee_token = ctx.nodeMainToken(callee);
    const callee_name = ctx.tokenText(callee_token);
    if (!std.mem.eql(u8, callee_name, "RegExp")) return;

    // Check if "RegExp" is locally shadowed: find the reference for the callee node
    // and check if it resolves to a local symbol.
    if (isCalleeResolved(callee, ctx)) return;

    // Get args.
    if (data.rhs == .none) return;
    const args_range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
    const items = ctx.extraSlice(args_range);
    if (items.len == 0) return;

    // First arg must be a string literal.
    const first_arg: NodeIndex = @enumFromInt(items[0]);
    if (first_arg == .none) return;
    if (ctx.nodeTag(first_arg) != .string_literal) return;

    // Determine flags (second arg). If non-string (dynamic), skip entirely.
    var flags: []const u8 = "";
    if (items.len >= 2) {
        const flags_arg: NodeIndex = @enumFromInt(items[1]);
        if (flags_arg != .none) {
            if (ctx.nodeTag(flags_arg) != .string_literal) return; // dynamic flags
            const flags_token = ctx.nodeMainToken(flags_arg);
            const flags_text = ctx.tokenText(flags_token);
            if (flags_text.len >= 2) flags = flags_text[1 .. flags_text.len - 1];
        }
    }

    // Get raw string content between the quotes.
    const str_token = ctx.nodeMainToken(first_arg);
    const str_text = ctx.tokenText(str_token);
    if (str_text.len < 2) return;

    // Skip template literals (backtick) — too complex.
    if (str_text[0] == '`') return;

    // Content is str_text[1..str_text.len-1].
    const content_start: usize = 1;
    const content_end: usize = str_text.len - 1;

    // In unicode/unicodeSets mode, certain patterns are syntactically invalid that
    // would be valid without those flags (e.g., a lone `{`). ESLint silently skips
    // patterns that fail to parse with regexpp. Use a heuristic to detect common cases.
    const unicode_mode = std.mem.indexOfScalar(u8, flags, 'u') != null or
        std.mem.indexOfScalar(u8, flags, 'v') != null;
    if (unicode_mode and looksLikeInvalidUnicodePattern(str_text, content_start, content_end)) return;

    if (scanStringPatternForSpaces(str_text, content_start, content_end)) {
        ctx.report(node);
    }
}

/// Returns true if the identifier node has a resolved reference (i.e., is locally declared/shadowed).
fn isCalleeResolved(callee: NodeIndex, ctx: *const LintContext) bool {
    const refs = ctx.references();
    const count = refs.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const ref_id = @import("../../../parser/reference.zig").ReferenceId.fromInt(i);
        if (refs.getNode(ref_id) == callee) {
            return refs.isResolved(ref_id);
        }
    }
    return false;
}

pub fn runOnSymbols(_: *const LintContext) void {}
