const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

pub const meta = RuleMeta{
    .name = "no-fallthrough",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow fallthrough of case statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(range);
    if (cases.len == 0) return;

    const src = ctx.source();
    const allow_empty = ctx.getOptionBool("allowEmptyCase", false);
    const comment_pattern = ctx.getOptionString("commentPattern");

    for (cases[0 .. cases.len - 1], 0..) |case_int, i| {
        const case_node = NodeIndex.fromInt(case_int);
        const case_tag = ctx.nodeTag(case_node);
        if (case_tag != .switch_case and case_tag != .switch_default) continue;

        const case_data = ctx.nodeData(case_node);
        if (case_data.rhs == .none) continue;

        const case_range = ctx.extraData(ast.SubRange, @intFromEnum(case_data.rhs));
        const stmts = ctx.extraSlice(case_range);

        // Empty case body handling:
        // - `allowEmptyCase: true` → always allow empty cases (skip)
        // - `allowEmptyCase: false` (default) → allow adjacent case stacking
        //   (single newline or nothing between colon and next case), but flag
        //   if there's a blank line or comment between them.
        const next_case_node_for_empty = NodeIndex.fromInt(cases[i + 1]);
        if (stmts.len == 0) {
            if (allow_empty) continue;
            // Find the ':' colon after the case label by scanning forward from
            // the case node's main token.
            const ne = ctx.nodeSpan(next_case_node_for_empty).start;
            const gap_end = @min(ne, @as(u32, @intCast(src.len)));
            const colon_pos = blk: {
                const p: u32 = ctx.nodeMainToken(case_node);
                // scan forward in source to find the colon
                const case_src_start = ctx.tokenStart(p);
                var sp: u32 = case_src_start;
                while (sp < gap_end and src[sp] != ':') sp += 1;
                break :blk if (sp < gap_end) sp + 1 else gap_end;
            };
            if (colon_pos < gap_end) {
                if (!hasBlankLineOrComment(src[colon_pos..gap_end])) continue;
            } else {
                continue; // no gap after colon → stacking
            }
        }

        if (stmts.len > 0) {
            const last_stmt = NodeIndex.fromInt(stmts[stmts.len - 1]);
            if (alwaysTerminates(ctx, last_stmt)) continue;
        }

        // Check for a fallthrough-suppressing comment before the next case.
        const next_case_node = NodeIndex.fromInt(cases[i + 1]);
        const next_start = ctx.nodeSpan(next_case_node).start;
        const case_span = ctx.nodeSpan(case_node);
        const next_end = @min(next_start, @as(u32, @intCast(src.len)));

        const suppressed = blk: {
            if (stmts.len == 0) {
                // Empty case with gap: check for suppressing comment.
                if (case_span.start < next_end)
                    break :blk hasSuppressingComment(src[case_span.start..next_end], 0, comment_pattern);
            } else {
                const last_stmt = NodeIndex.fromInt(stmts[stmts.len - 1]);
                const maybe_code_end = lastCodeEnd(ctx, last_stmt);
                if (maybe_code_end) |code_end| {
                    if (code_end < next_end)
                        break :blk hasSuppressingComment(src[code_end..next_end], 1, comment_pattern);
                } else if (stmts.len == 1) {
                    if (case_span.start < next_end)
                        break :blk hasSuppressingComment(src[case_span.start..next_end], 2, comment_pattern);
                } else {
                    const prev_stmt = NodeIndex.fromInt(stmts[stmts.len - 2]);
                    const prev_end = lastCodeEnd(ctx, prev_stmt) orelse case_span.start;
                    const last_span = ctx.nodeSpan(last_stmt);
                    if (prev_end < last_span.start and
                        hasSuppressingComment(src[prev_end..last_span.start], 0, comment_pattern))
                        break :blk true;
                    if (last_span.start < next_end and
                        hasSuppressingComment(src[last_span.start..next_end], 1, comment_pattern))
                        break :blk true;
                }
            }
            break :blk false;
        };
        if (suppressed) continue;

        // Fix: insert "// falls through\n" before the next case.
        // Find the start of the line containing the next case for proper placement.
        var insert_pos = next_start;
        while (insert_pos > 0 and src[insert_pos - 1] != '\n') insert_pos -= 1;
        // Determine indentation of the next case line for matching.
        var indent_end = insert_pos;
        while (indent_end < next_start and (src[indent_end] == ' ' or src[indent_end] == '\t'))
            indent_end += 1;
        const indent = src[insert_pos..indent_end];
        _ = indent; // ESLint inserts at the case start; we do the same for simplicity.

        const fix_text = "// falls through\n";
        ctx.reportWithFix(
            next_case_node,
            Span{ .start = insert_pos, .end = insert_pos },
            fix_text,
        );
    }
}

/// Returns the source position of the last code in `node`, or null when empty.
fn lastCodeEnd(ctx: *const LintContext, node: NodeIndex) ?u32 {
    if (ctx.nodeTag(node) == .block_stmt) {
        const d = ctx.nodeData(node);
        if (d.lhs == .none) return null;
        const start = @intFromEnum(d.lhs);
        const end_idx = @intFromEnum(d.rhs);
        if (start >= end_idx) return null;
        const inner = ctx.extraSlice(.{ .start = start, .end = end_idx });
        if (inner.len == 0) return null;
        return lastCodeEnd(ctx, NodeIndex.fromInt(inner[inner.len - 1]));
    }
    return ctx.nodeSpan(node).end;
}

/// Scans `text` for a comment that suppresses the fallthrough warning.
/// Matches the default "falls through" pattern or a custom `comment_pattern`.
fn hasSuppressingComment(text: []const u8, skip_depth: u32, comment_pattern: ?[]const u8) bool {
    var i: usize = 0;
    var depth: u32 = 0;
    while (i < text.len) {
        if (text[i] == '"' or text[i] == '\'' or text[i] == '`') {
            const quote = text[i];
            i += 1;
            while (i < text.len) {
                if (text[i] == '\\') { i += 1; }
                else if (text[i] == quote) { i += 1; break; }
                i += 1;
            }
            continue;
        }
        if (text[i] == '{') { depth += 1; i += 1; continue; }
        if (text[i] == '}') { if (depth > 0) depth -= 1; i += 1; continue; }
        if (skip_depth > 0 and depth >= skip_depth) { i += 1; continue; }

        if (i + 1 < text.len and text[i] == '/' and text[i + 1] == '/') {
            const start = i + 2;
            var end = start;
            while (end < text.len and text[end] != '\n') end += 1;
            const comment = text[start..end];
            if (matchesSuppressor(comment, comment_pattern)) return true;
            i = end;
        } else if (i + 1 < text.len and text[i] == '/' and text[i + 1] == '*') {
            const start = i + 2;
            var end = start;
            while (end + 1 < text.len and !(text[end] == '*' and text[end + 1] == '/')) end += 1;
            const comment = text[start..end];
            if (matchesSuppressor(comment, comment_pattern)) return true;
            i = if (end + 2 <= text.len) end + 2 else text.len;
        } else {
            i += 1;
        }
    }
    return false;
}

/// Returns true if `comment_text` (comment interior) matches the suppressor.
fn matchesSuppressor(comment_text: []const u8, comment_pattern: ?[]const u8) bool {
    if (comment_pattern) |pat| {
        return matchCommentPattern(comment_text, pat);
    }
    return matchFallsThrough(comment_text);
}

/// Returns true if `text` contains "fall(s) through" or "fallthrough" as a
/// word boundary match (not part of "no-fallthrough" etc.).
fn matchFallsThrough(text: []const u8) bool {
    var i: usize = 0;
    while (i + 4 <= text.len) {
        // Require word boundary before "fall": not preceded by word char or dash.
        if (i > 0) {
            const prev = text[i - 1];
            if (isWordChar(prev) or prev == '-') { i += 1; continue; }
        }
        if (matchWord(text, i, "fall")) {
            var j = i + 4;
            if (j < text.len and (text[j] == 's' or text[j] == 'S')) j += 1;
            while (j < text.len and isWs(text[j])) j += 1;
            if (j + 7 <= text.len and matchWord(text, j, "through")) return true;
        }
        i += 1;
    }
    return false;
}

/// Simple commentPattern matcher: splits on common regex metachar sequences and
/// checks that all literal segments appear in order in the comment text.
fn matchCommentPattern(text: []const u8, pattern: []const u8) bool {
    // Extract literal segments from pattern by skipping regex metachar sequences.
    var segments: [8][]const u8 = undefined;
    var seg_count: usize = 0;

    var p: usize = 0;
    var seg_start: usize = 0;
    while (p < pattern.len) {
        if (p + 1 < pattern.len and pattern[p] == '\\') {
            // Escaped char: flush any literal up to here, skip 2 chars.
            if (p > seg_start and seg_count < 8) {
                segments[seg_count] = pattern[seg_start..p];
                seg_count += 1;
            }
            p += 2;
            seg_start = p;
        } else if (pattern[p] == '[') {
            // Character class: flush literal before it, skip to ']'.
            if (p > seg_start and seg_count < 8) {
                segments[seg_count] = pattern[seg_start..p];
                seg_count += 1;
            }
            p += 1;
            while (p < pattern.len and pattern[p] != ']') p += 1;
            if (p < pattern.len) p += 1;
            seg_start = p;
        } else if (pattern[p] == '?' or pattern[p] == '+' or pattern[p] == '*' or
                   pattern[p] == '(' or pattern[p] == ')' or pattern[p] == '|' or
                   pattern[p] == '^' or pattern[p] == '$')
        {
            // Quantifier or anchor: skip.
            if (p > seg_start and seg_count < 8) {
                segments[seg_count] = pattern[seg_start..p];
                seg_count += 1;
            }
            p += 1;
            seg_start = p;
        } else {
            p += 1;
        }
    }
    if (seg_start < pattern.len and seg_count < 8) {
        segments[seg_count] = pattern[seg_start..pattern.len];
        seg_count += 1;
    }

    // Filter out empty segments.
    var valid_segs: [8][]const u8 = undefined;
    var valid_count: usize = 0;
    for (segments[0..seg_count]) |seg| {
        if (seg.len > 0) {
            valid_segs[valid_count] = seg;
            valid_count += 1;
        }
    }

    if (valid_count == 0) return false;

    // Check all segments appear in order.
    var search_start: usize = 0;
    for (valid_segs[0..valid_count]) |seg| {
        const idx = std.mem.indexOf(u8, text[search_start..], seg) orelse return false;
        search_start += idx + seg.len;
    }
    return true;
}

/// Returns true if `text` (the gap after a case colon up to the next case keyword)
/// suggests accidental fallthrough: either a blank line (two consecutive newlines)
/// or a comment that starts on a line after the first newline.
/// Same-line trailing comments (e.g. `case 0: // note\n case 1:`) are allowed.
fn hasBlankLineOrComment(text: []const u8) bool {
    var saw_newline = false;
    var i: usize = 0;
    while (i < text.len) {
        if (text[i] == '\n') {
            if (saw_newline) return true; // blank line (two newlines)
            saw_newline = true;
            i += 1;
        } else if (text[i] == ' ' or text[i] == '\t' or text[i] == '\r') {
            i += 1;
        } else if (i + 1 < text.len and text[i] == '/' and
            (text[i + 1] == '/' or text[i + 1] == '*'))
        {
            // Comment: only counts as "separator" if it's on a new line.
            if (saw_newline) return true;
            // Same-line comment: skip to end of comment.
            if (text[i + 1] == '/') {
                while (i < text.len and text[i] != '\n') i += 1;
            } else {
                i += 2;
                while (i + 1 < text.len and !(text[i] == '*' and text[i + 1] == '/')) i += 1;
                if (i + 2 <= text.len) i += 2;
            }
        } else {
            i += 1; // other content (shouldn't appear in a valid gap)
        }
    }
    return false;
}

fn isWs(c: u8) bool {
    return c == ' ' or c == '\t' or c == '\n' or c == '\r';
}

fn isWordChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_';
}

fn matchWord(text: []const u8, start: usize, word: []const u8) bool {
    if (start + word.len > text.len) return false;
    for (word, 0..) |c, k| {
        const b = text[start + k];
        const lower = if (b >= 'A' and b <= 'Z') b + 32 else b;
        if (lower != c) return false;
    }
    return true;
}

/// Returns true if the statement always transfers control out of the switch case.
fn alwaysTerminates(ctx: *const LintContext, node: NodeIndex) bool {
    return switch (ctx.nodeTag(node)) {
        .break_stmt, .break_label,
        .return_stmt, .throw_stmt,
        .continue_stmt, .continue_label => true,
        .block_stmt => blk: {
            const d = ctx.nodeData(node);
            if (d.lhs == .none) break :blk false;
            const start = @intFromEnum(d.lhs);
            const end_idx = @intFromEnum(d.rhs);
            if (start >= end_idx) break :blk false;
            const stmts = ctx.extraSlice(.{ .start = start, .end = end_idx });
            if (stmts.len == 0) break :blk false;
            break :blk alwaysTerminates(ctx, NodeIndex.fromInt(stmts[stmts.len - 1]));
        },
        .if_else_stmt => blk: {
            const d = ctx.nodeData(node);
            const if_data = ctx.extraData(ast.IfData, @intFromEnum(d.rhs));
            break :blk alwaysTerminates(ctx, if_data.consequent) and
                alwaysTerminates(ctx, if_data.alternate);
        },
        .try_stmt => blk: {
            const d = ctx.nodeData(node);
            const try_data = ctx.extraData(ast.TryData, @intFromEnum(d.rhs));
            const try_body = d.lhs;
            if (try_data.finally_body != .none and alwaysTerminates(ctx, try_data.finally_body))
                break :blk true;
            if (try_data.catch_node != .none) {
                const catch_d = ctx.nodeData(try_data.catch_node);
                break :blk alwaysTerminates(ctx, try_body) and
                    alwaysTerminates(ctx, catch_d.rhs);
            }
            break :blk alwaysTerminates(ctx, try_body);
        },
        // do { body } while (cond): `break`/`continue` in body exit the LOOP, not the switch.
        // Only return/throw from the body can terminate the enclosing case.
        .do_while_stmt => blk: {
            const d = ctx.nodeData(node);
            break :blk alwaysTerminatesNoLoopCtrl(ctx, d.lhs);
        },
        else => false,
    };
}

/// Like alwaysTerminates but treats break/continue as non-terminating.
/// Used for loop bodies: break/continue exit the loop, not the enclosing switch.
fn alwaysTerminatesNoLoopCtrl(ctx: *const LintContext, node: NodeIndex) bool {
    return switch (ctx.nodeTag(node)) {
        .return_stmt, .throw_stmt => true,
        .break_stmt, .break_label,
        .continue_stmt, .continue_label => false,
        .block_stmt => blk: {
            const d = ctx.nodeData(node);
            if (d.lhs == .none) break :blk false;
            const start = @intFromEnum(d.lhs);
            const end_idx = @intFromEnum(d.rhs);
            if (start >= end_idx) break :blk false;
            const stmts = ctx.extraSlice(.{ .start = start, .end = end_idx });
            if (stmts.len == 0) break :blk false;
            break :blk alwaysTerminatesNoLoopCtrl(ctx, NodeIndex.fromInt(stmts[stmts.len - 1]));
        },
        .if_else_stmt => blk: {
            const d = ctx.nodeData(node);
            const if_data = ctx.extraData(ast.IfData, @intFromEnum(d.rhs));
            break :blk alwaysTerminatesNoLoopCtrl(ctx, if_data.consequent) and
                alwaysTerminatesNoLoopCtrl(ctx, if_data.alternate);
        },
        else => false,
    };
}
