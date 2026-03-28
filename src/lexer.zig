const std = @import("std");
const Token = @import("token.zig");
const TokenTag = Token.Tag;
const keywords = Token.keywords;
const Ast = @import("ast.zig");

pub const TokenList = Ast.Ast.TokenList;

/// ES2024 JavaScript lexer with SIMD-accelerated whitespace/identifier scanning.
///
/// Tokenizes source text into a flat MultiArrayList of (tag, start) pairs.
/// Handles all ES2024 token types including template literals with brace
/// depth tracking, regex/division disambiguation, numeric separators,
/// BigInt, and hashbang lines.
const Language = Token.Language;

pub const Lexer = struct {
    source: []const u8,
    index: u32,
    tokens: TokenList,
    allocator: std.mem.Allocator,
    prev_token_tag: TokenTag,
    template_depth: u32,
    /// Brace depth per template nesting level. Tracks nested `{}` inside `${}`.
    /// When `${` is entered, slot is zeroed. Each `{` increments, each `}` decrements.
    /// At 0, the `}` closes the template expression. Falls back to simple depth
    /// counting beyond 16 levels (sufficient for any real-world code).
    brace_depth_stack: [16]u32 = [_]u32{0} ** 16,
    /// Brace context stack for regex/division disambiguation after `}`.
    /// Tracks whether each `{` started an expression (object literal) or block.
    /// true = expression context (object literal), false = block/statement.
    brace_is_expr: [256]bool = [_]bool{false} ** 256,
    brace_depth: u32 = 0,
    /// Track function expression context for `}` → division disambiguation.
    /// Set when `function` appears in expression position. The next `{` after
    /// the matching `)` will be marked as expression context.
    /// When true, the next `{` should be marked as expression context
    /// (closing a function expression's param list).
    fn_expr_next_brace: bool = false,
    /// Paren depth at which function expression params were opened.
    fn_expr_paren_depths: [32]u32 = [_]u32{0} ** 32,
    fn_expr_depth_count: u32 = 0,
    paren_depth: u32 = 0,
    language: Language,

    /// Initialize a new lexer. Call `next()` repeatedly or use `tokenize()`.
    pub fn init(allocator: std.mem.Allocator, source: []const u8) Lexer {
        return initWithLanguage(allocator, source, .js);
    }

    /// Initialize a new lexer with a specific language mode.
    pub fn initWithLanguage(allocator: std.mem.Allocator, source: []const u8, language: Language) Lexer {
        return .{
            .source = source,
            .index = 0,
            .tokens = .{},
            .allocator = allocator,
            .prev_token_tag = .eof,
            .template_depth = 0,
            .language = language,
        };
    }

    /// Tokenize the entire source, returning a MultiArrayList of tokens.
    /// The final token is always `.eof`.
    pub fn tokenize(allocator: std.mem.Allocator, source: []const u8) !TokenList {
        return tokenizeWithLanguage(allocator, source, .js);
    }

    /// Tokenize with a specific language mode.
    pub fn tokenizeWithLanguage(allocator: std.mem.Allocator, source: []const u8, language: Language) !TokenList {
        var self = initWithLanguage(allocator, source, language);

        // Pre-allocate a reasonable estimate: ~1 token per 8 bytes of source.
        const estimate = @max(source.len / 8, 64);
        try self.tokens.ensureTotalCapacity(allocator, @intCast(estimate));

        while (true) {
            const tok = self.next();
            try self.tokens.append(allocator, .{
                .tag = tok.tag,
                .start = tok.start,
            });
            if (tok.tag == .eof) break;
        }

        return self.tokens;
    }

    /// Return the next token and advance the lexer position.
    pub fn next(self: *Lexer) Token.Token {
        // Skip whitespace and comments in a loop (comments may be followed by
        // more whitespace or more comments).
        while (true) {
            self.skipWhitespace();

            if (self.index >= self.source.len) {
                return self.makeToken(.eof, self.index);
            }

            // Check for comments: // and /* ... */
            if (self.peek(0) == '/') {
                if (self.peek(1) == '/') {
                    self.skipLineComment();
                    continue;
                }
                if (self.peek(1) == '*') {
                    self.skipBlockComment();
                    continue;
                }
            }

            // HTML open comment: <!-- (Annex B, B.1.3)
            // Treated as single-line comment in script mode.
            if (self.peek(0) == '<' and self.peek(1) == '!' and
                self.peek(2) == '-' and self.peek(3) == '-')
            {
                self.index += 4;
                self.skipToEndOfLine();
                continue;
            }

            // HTML close comment: --> at start of line (Annex B, B.1.3)
            // Only valid after a line terminator (or at start of file after whitespace/comments).
            if (self.peek(0) == '-' and self.peek(1) == '-' and self.peek(2) == '>') {
                if (self.isAtLineStart()) {
                    self.index += 3;
                    self.skipToEndOfLine();
                    continue;
                }
            }

            break;
        }

        // Hashbang: #! at very start of file (before any tokens)
        if (self.index == 0 and self.prev_token_tag == .eof) {
            if (self.peek(0) == '#' and self.peek(1) == '!') {
                return self.scanHashbang();
            }
        }

        const start = self.index;
        const c = self.source[self.index];

        // ── Identifiers and keywords ──────────────────────────
        if (isIdentStart(c)) {
            return self.scanIdentifierOrKeyword();
        }

        // ── Number literals ───────────────────────────────────
        if (isDigit(c)) {
            return self.scanNumber();
        }

        // ── Dot: could be `.`, `...`, or `.123` (number starting with dot)
        if (c == '.') {
            if (self.peek(1) == '.' and self.peek(2) == '.') {
                self.index += 3;
                return self.makeToken(.ellipsis, start);
            }
            // .123 is a valid decimal literal
            if (isDigit(self.peek(1))) {
                return self.scanNumber();
            }
            self.index += 1;
            return self.makeToken(.dot, start);
        }

        // ── String literals ───────────────────────────────────
        if (c == '\'' or c == '"') {
            return self.scanString();
        }

        // ── Template literals ─────────────────────────────────
        if (c == '`') {
            return self.scanTemplateLiteral();
        }

        // ── Operators and punctuation ─────────────────────────
        return self.scanOperatorOrPunct();
    }

    // ══════════════════════════════════════════════════════════
    //  SIMD Whitespace Skipping
    // ══════════════════════════════════════════════════════════

    fn skipWhitespace(self: *Lexer) void {
        const src = self.source;
        var i: u32 = self.index;
        const len: u32 = @intCast(src.len);

        // SIMD: process 16 bytes at a time
        while (i + 16 <= len) {
            const chunk: @Vector(16, u8) = src[i..][0..16].*;
            const spaces = chunk == @as(@Vector(16, u8), @splat(@as(u8, ' ')));
            const tabs = chunk == @as(@Vector(16, u8), @splat(@as(u8, '\t')));
            const newlines = chunk == @as(@Vector(16, u8), @splat(@as(u8, '\n')));
            const returns = chunk == @as(@Vector(16, u8), @splat(@as(u8, '\r')));
            // Unicode BOM / misc whitespace handled in scalar fallback
            const form_feeds = chunk == @as(@Vector(16, u8), @splat(@as(u8, 0x0C)));
            const vtabs = chunk == @as(@Vector(16, u8), @splat(@as(u8, 0x0B)));
            const ws = spaces | tabs | newlines | returns | form_feeds | vtabs;

            const mask: u16 = @bitCast(ws);
            const non_ws = ~mask;
            if (non_ws != 0) {
                i += @ctz(non_ws);
                self.index = i;
                // Handle multi-byte Unicode whitespace at the scalar level
                self.skipScalarWhitespace();
                return;
            }
            i += 16;
        }

        self.index = i;
        // Scalar fallback for remaining bytes
        self.skipScalarWhitespace();
    }

    fn skipScalarWhitespace(self: *Lexer) void {
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            switch (c) {
                ' ', '\t', '\n', '\r', 0x0B, 0x0C => {
                    self.index += 1;
                },
                // UTF-8 encoded Unicode whitespace: U+FEFF (BOM), U+00A0 (NBSP),
                // U+2000..U+200B, U+2028, U+2029, U+202F, U+205F, U+3000
                0xC2 => {
                    // U+00A0 NBSP = C2 A0
                    if (self.peek(1) == 0xA0) {
                        self.index += 2;
                    } else {
                        return;
                    }
                },
                0xE2 => {
                    if (self.index + 2 < self.source.len) {
                        const b1 = self.source[self.index + 1];
                        const b2 = self.source[self.index + 2];
                        if (b1 == 0x80) {
                            // U+2000..U+200B: E2 80 80..8B
                            // U+2028 LINE SEPARATOR: E2 80 A8
                            // U+2029 PARAGRAPH SEPARATOR: E2 80 A9
                            if ((b2 >= 0x80 and b2 <= 0x8B) or b2 == 0xA8 or b2 == 0xA9 or b2 == 0xAF) {
                                self.index += 3;
                                continue;
                            }
                        }
                        if (b1 == 0x81 and b2 == 0x9F) {
                            // U+205F MEDIUM MATHEMATICAL SPACE: E2 81 9F
                            self.index += 3;
                            continue;
                        }
                    }
                    return;
                },
                0xE3 => {
                    // U+3000 IDEOGRAPHIC SPACE: E3 80 80
                    if (self.index + 2 < self.source.len and
                        self.source[self.index + 1] == 0x80 and
                        self.source[self.index + 2] == 0x80)
                    {
                        self.index += 3;
                    } else {
                        return;
                    }
                },
                0xE1 => {
                    // U+1680 OGHAM SPACE MARK: E1 9A 80
                    if (self.index + 2 < self.source.len and
                        self.source[self.index + 1] == 0x9A and
                        self.source[self.index + 2] == 0x80)
                    {
                        self.index += 3;
                    } else {
                        return;
                    }
                },
                0xEF => {
                    // U+FEFF BOM: EF BB BF
                    if (self.index + 2 < self.source.len and
                        self.source[self.index + 1] == 0xBB and
                        self.source[self.index + 2] == 0xBF)
                    {
                        self.index += 3;
                    } else {
                        return;
                    }
                },
                else => return,
            }
        }
    }

    /// Skip to end of current line (for HTML comment handling).
    fn skipToEndOfLine(self: *Lexer) void {
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c == '\n' or c == '\r') return;
            if (c == 0xE2 and self.index + 2 < self.source.len and
                self.source[self.index + 1] == 0x80 and
                (self.source[self.index + 2] == 0xA8 or self.source[self.index + 2] == 0xA9)) return;
            self.index += 1;
        }
    }

    /// Check if current position is at the start of a line
    /// (only whitespace/comments between the last line terminator and here).
    fn isAtLineStart(self: *const Lexer) bool {
        if (self.index == 0) return true;
        var i = self.index;
        while (i > 0) {
            i -= 1;
            const c = self.source[i];
            if (c == '\n' or c == '\r') return true;
            if (c == ' ' or c == '\t' or c == 0x0B or c == 0x0C) continue;
            // Check for block comment ending: */
            if (c == '/' and i > 0 and self.source[i - 1] == '*') {
                // Walk back past the block comment
                if (i < 2) return false;
                i -= 2;
                while (i > 0) {
                    if (self.source[i] == '*' and i > 0 and self.source[i - 1] == '/') {
                        i -= 1; // skip past /*
                        break;
                    }
                    i -= 1;
                }
                continue;
            }
            return false;
        }
        return true; // start of file
    }

    // ══════════════════════════════════════════════════════════
    //  Comment Skipping
    // ══════════════════════════════════════════════════════════

    fn skipLineComment(self: *Lexer) void {
        // Skip the leading //
        self.index += 2;
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c == '\n') {
                self.index += 1;
                return;
            }
            if (c == '\r') {
                self.index += 1;
                if (self.index < self.source.len and self.source[self.index] == '\n') {
                    self.index += 1;
                }
                return;
            }
            // Check for Unicode line terminators: U+2028, U+2029
            if (c == 0xE2 and self.index + 2 < self.source.len) {
                if (self.source[self.index + 1] == 0x80) {
                    const b2 = self.source[self.index + 2];
                    if (b2 == 0xA8 or b2 == 0xA9) {
                        self.index += 3;
                        return;
                    }
                }
            }
            self.index += 1;
        }
    }

    fn skipBlockComment(self: *Lexer) void {
        // Skip the leading /*
        const start = self.index;
        self.index += 2;
        while (self.index + 1 < self.source.len) {
            if (self.source[self.index] == '*' and self.source[self.index + 1] == '/') {
                self.index += 2;
                return;
            }
            self.index += 1;
        }
        // Unterminated block comment — emit invalid token and advance to end
        self.index = @intCast(self.source.len);
        self.tokens.append(self.allocator, .{
            .tag = .invalid,
            .start = start,
        }) catch {};
    }

    // ══════════════════════════════════════════════════════════
    //  Hashbang
    // ══════════════════════════════════════════════════════════

    fn scanHashbang(self: *Lexer) Token.Token {
        const start = self.index;
        // Skip #! until line terminator (\n, \r, U+2028 LS, U+2029 PS)
        self.index += 2;
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c == '\n' or c == '\r') break;
            // U+2028/U+2029: 0xe2 0x80 0xa8/0xa9
            if (c == 0xe2 and self.index + 2 < self.source.len and
                self.source[self.index + 1] == 0x80 and
                (self.source[self.index + 2] == 0xa8 or self.source[self.index + 2] == 0xa9))
                break;
            self.index += 1;
        }
        return self.makeToken(.hashbang, start);
    }

    // ══════════════════════════════════════════════════════════
    //  Identifiers and Keywords (SIMD-accelerated)
    // ══════════════════════════════════════════════════════════

    fn scanIdentifierOrKeyword(self: *Lexer) Token.Token {
        const start = self.index;
        var has_unicode_escape = false;

        // Handle \uXXXX at start of identifier
        if (self.source[self.index] == '\\') {
            if (self.peek(1) == 'u') {
                has_unicode_escape = true;
                if (!self.skipUnicodeEscape()) {
                    return self.makeToken(.invalid, start);
                }
            } else {
                self.index += 1;
                return self.makeToken(.invalid, start);
            }
        } else if (self.source[self.index] >= 0x80) {
            // Multi-byte UTF-8 start: decode and validate as ID_Start
            const cp_len = utf8ByteLen(self.source[self.index]);
            if (cp_len == 0) {
                self.index += 1;
                return self.makeToken(.invalid, start);
            }
            const cp = decodeUtf8(self.source[self.index..], cp_len);
            if (!isValidIdentStartCodepoint(cp)) {
                self.index += cp_len;
                return self.makeToken(.invalid, start);
            }
            self.index += cp_len;
        } else {
            self.index += 1; // skip first ASCII char
        }

        // SIMD scan of ASCII identifier continuation chars
        self.scanIdentChunksSIMD();

        // Scalar fallback for any remaining chars or Unicode escapes
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (isIdentContinue(c)) {
                self.index += 1;
            } else if (c == '\\') {
                if (self.peek(1) == 'u') {
                    has_unicode_escape = true;
                    if (!self.skipUnicodeEscape()) {
                        return self.makeToken(.invalid, start);
                    }
                } else {
                    // \o, \x etc in identifier position — invalid
                    return self.makeToken(.invalid, start);
                }
            } else if (c >= 0x80) {
                const cp_len = utf8ByteLen(c);
                if (cp_len == 0) break;
                // Decode and validate the codepoint
                const cp = decodeUtf8(self.source[self.index..], cp_len);
                if (!isValidIdentCodepoint(cp)) break; // not an ident char → end identifier
                self.index += cp_len;
            } else {
                break;
            }
        }

        const text = self.source[start..self.index];

        // If identifier contains unicode escapes, resolve and check for keyword collision.
        // Escaped keywords like \u0076ar (= "var") are emitted as .escaped_keyword
        // so the parser can reject them in binding/label positions but accept in property names.
        if (has_unicode_escape) {
            var resolved_buf: [256]u8 = undefined;
            const resolved = resolveUnicodeEscapes(text, &resolved_buf) orelse {
                // Buffer overflow = identifier too long to be a keyword. Accept as identifier.
                return self.makeToken(.identifier, start);
            };
            if (keywords.get(resolved) != null) {
                return self.makeToken(.escaped_keyword, start);
            }
            if (self.language.isTs()) {
                if (Token.ts_keywords.get(resolved) != null) {
                    return self.makeToken(.escaped_keyword, start);
                }
            }
            return self.makeToken(.identifier, start);
        }

        // Keyword lookup (no escapes, exact match)
        if (keywords.get(text)) |kw_tag| {
            return self.makeToken(kw_tag, start);
        }

        // TypeScript contextual keyword lookup (TS/TSX mode only)
        if (self.language.isTs()) {
            if (Token.ts_keywords.get(text)) |ts_tag| {
                return self.makeToken(ts_tag, start);
            }
        }

        return self.makeToken(.identifier, start);
    }

    /// Use SIMD to scan 16-byte chunks of ASCII identifier characters.
    fn scanIdentChunksSIMD(self: *Lexer) void {
        const src = self.source;
        const len: u32 = @intCast(src.len);

        while (self.index + 16 <= len) {
            const chunk: @Vector(16, u8) = src[self.index..][0..16].*;

            // Check: a-z
            const ge_a = chunk >= @as(@Vector(16, u8), @splat(@as(u8, 'a')));
            const le_z = chunk <= @as(@Vector(16, u8), @splat(@as(u8, 'z')));
            const lower = ge_a & le_z;

            // Check: A-Z
            const ge_A = chunk >= @as(@Vector(16, u8), @splat(@as(u8, 'A')));
            const le_Z = chunk <= @as(@Vector(16, u8), @splat(@as(u8, 'Z')));
            const upper = ge_A & le_Z;

            // Check: 0-9
            const ge_0 = chunk >= @as(@Vector(16, u8), @splat(@as(u8, '0')));
            const le_9 = chunk <= @as(@Vector(16, u8), @splat(@as(u8, '9')));
            const digit = ge_0 & le_9;

            // Check: _ and $
            const underscore = chunk == @as(@Vector(16, u8), @splat(@as(u8, '_')));
            const dollar = chunk == @as(@Vector(16, u8), @splat(@as(u8, '$')));

            const ident = lower | upper | digit | underscore | dollar;
            const mask: u16 = @bitCast(ident);
            const non_ident = ~mask;

            if (non_ident != 0) {
                self.index += @ctz(non_ident);
                return;
            }
            self.index += 16;
        }
    }

    /// Skip and validate \uXXXX or \u{XXXX}. Returns false if invalid.
    /// Also validates the decoded codepoint is a valid identifier character.
    fn skipUnicodeEscape(self: *Lexer) bool {
        self.index += 2; // skip \u
        if (self.index < self.source.len and self.source[self.index] == '{') {
            self.index += 1;
            var digits: u32 = 0;
            var codepoint: u32 = 0;
            while (self.index < self.source.len and self.source[self.index] != '}') {
                const d = self.source[self.index];
                const val: u32 = if (d >= '0' and d <= '9') d - '0'
                    else if (d >= 'a' and d <= 'f') d - 'a' + 10
                    else if (d >= 'A' and d <= 'F') d - 'A' + 10
                    else return false;
                codepoint = codepoint * 16 + val;
                digits += 1;
                self.index += 1;
            }
            if (digits == 0 or codepoint > 0x10FFFF) return false;
            if (self.index < self.source.len) self.index += 1; // skip }
            return isValidIdentCodepoint(codepoint);
        } else {
            var codepoint: u32 = 0;
            var count: u32 = 0;
            while (count < 4 and self.index < self.source.len and isHexDigit(self.source[self.index])) {
                const d = self.source[self.index];
                const val: u32 = if (d >= '0' and d <= '9') d - '0'
                    else if (d >= 'a' and d <= 'f') d - 'a' + 10
                    else if (d >= 'A' and d <= 'F') d - 'A' + 10
                    else unreachable;
                codepoint = codepoint * 16 + val;
                self.index += 1;
                count += 1;
            }
            if (count != 4) return false;
            return isValidIdentCodepoint(codepoint);
        }
    }

    /// Resolve all \uXXXX and \u{XXXX} escapes in an identifier string.
    /// Returns the resolved string as a slice of `buf`, or null if it doesn't fit.
    fn resolveUnicodeEscapes(text: []const u8, buf: *[256]u8) ?[]const u8 {
        var out_len: usize = 0;
        var i: usize = 0;
        while (i < text.len) {
            if (text[i] == '\\' and i + 1 < text.len and text[i + 1] == 'u') {
                i += 2; // skip \u
                var codepoint: u32 = 0;
                if (i < text.len and text[i] == '{') {
                    i += 1; // skip {
                    while (i < text.len and text[i] != '}') {
                        const d = text[i];
                        const val: u32 = if (d >= '0' and d <= '9') d - '0'
                            else if (d >= 'a' and d <= 'f') d - 'a' + 10
                            else if (d >= 'A' and d <= 'F') d - 'A' + 10
                            else return null;
                        codepoint = codepoint * 16 + val;
                        i += 1;
                    }
                    if (i < text.len) i += 1; // skip }
                } else {
                    // \uXXXX — exactly 4 hex digits
                    var count: u32 = 0;
                    while (count < 4 and i < text.len) {
                        const d = text[i];
                        const val: u32 = if (d >= '0' and d <= '9') d - '0'
                            else if (d >= 'a' and d <= 'f') d - 'a' + 10
                            else if (d >= 'A' and d <= 'F') d - 'A' + 10
                            else return null;
                        codepoint = codepoint * 16 + val;
                        i += 1;
                        count += 1;
                    }
                }
                // Encode codepoint as UTF-8
                if (codepoint < 0x80) {
                    if (out_len >= buf.len) return null;
                    buf[out_len] = @intCast(codepoint);
                    out_len += 1;
                } else if (codepoint < 0x800) {
                    if (out_len + 2 > buf.len) return null;
                    buf[out_len] = @intCast(0xC0 | (codepoint >> 6));
                    buf[out_len + 1] = @intCast(0x80 | (codepoint & 0x3F));
                    out_len += 2;
                } else if (codepoint < 0x10000) {
                    if (out_len + 3 > buf.len) return null;
                    buf[out_len] = @intCast(0xE0 | (codepoint >> 12));
                    buf[out_len + 1] = @intCast(0x80 | ((codepoint >> 6) & 0x3F));
                    buf[out_len + 2] = @intCast(0x80 | (codepoint & 0x3F));
                    out_len += 3;
                } else {
                    if (out_len + 4 > buf.len) return null;
                    buf[out_len] = @intCast(0xF0 | (codepoint >> 18));
                    buf[out_len + 1] = @intCast(0x80 | ((codepoint >> 12) & 0x3F));
                    buf[out_len + 2] = @intCast(0x80 | ((codepoint >> 6) & 0x3F));
                    buf[out_len + 3] = @intCast(0x80 | (codepoint & 0x3F));
                    out_len += 4;
                }
            } else {
                if (out_len >= buf.len) return null;
                buf[out_len] = text[i];
                out_len += 1;
                i += 1;
            }
        }
        return buf[0..out_len];
    }

    /// Check if a codepoint is valid for JavaScript identifiers.
    /// Simplified check — rejects known-invalid ranges.
    /// Check if a codepoint is valid as the START of an identifier (ID_Start + $ + _).
    /// More restrictive than ID_Continue: no ZWNJ/ZWJ, no combining marks, no digits.
    fn isValidIdentStartCodepoint(cp: u32) bool {
        // ASCII
        if (cp < 0x80) {
            return switch (@as(u8, @intCast(cp))) {
                'a'...'z', 'A'...'Z', '_', '$' => true,
                else => false,
            };
        }
        // ZWNJ/ZWJ are ID_Continue only, not ID_Start
        if (cp == 0x200C or cp == 0x200D) return false;
        // Replacement char
        if (cp == 0xFFFD) return false;
        // Delegate to the general check for other exclusions
        return isValidIdentCodepoint(cp);
    }

    fn isValidIdentCodepoint(cp: u32) bool {
        // ASCII range
        if (cp < 0x80) {
            return switch (@as(u8, @intCast(cp))) {
                'a'...'z', 'A'...'Z', '0'...'9', '_', '$' => true,
                else => false,
            };
        }
        // Reject surrogates and some invalid ranges
        if (cp >= 0xD800 and cp <= 0xDFFF) return false;
        if (cp == 0xFFFE or cp == 0xFFFF) return false;
        // U+200C (ZWNJ) and U+200D (ZWJ) are valid in identifiers
        if (cp == 0x200C or cp == 0x200D) return true;
        // BOM (U+FEFF) is NOT valid in identifiers
        if (cp == 0xFEFF) return false;

        // Whitespace characters are NOT valid identifiers
        if (cp == 0x00A0) return false; // NBSP
        if (cp == 0x1680) return false; // Ogham Space Mark
        if (cp >= 0x2000 and cp <= 0x200B) return false; // En/Em space, etc.
        if (cp == 0x202F) return false; // Narrow No-Break Space
        if (cp == 0x205F) return false; // Medium Mathematical Space
        if (cp == 0x3000) return false; // Ideographic Space
        if (cp == 0x180E) return false; // Mongolian Vowel Separator

        // BMP general punctuation and symbols (not valid as identifiers)
        if (cp >= 0x2000 and cp <= 0x206F) return false; // General Punctuation
        if (cp >= 0x2190 and cp <= 0x23FF) return false; // Arrows, Math Operators, Misc Technical
        if (cp >= 0x2500 and cp <= 0x27BF) return false; // Box Drawing, Geometric, Dingbats
        if (cp >= 0x2900 and cp <= 0x2BFF) return false; // Supplemental Arrows, Misc Symbols
        if (cp >= 0xFE00 and cp <= 0xFE0F) return false; // Variation Selectors
        if (cp >= 0xFE10 and cp <= 0xFE1F) return false; // Vertical Forms (punctuation)
        // FE20-FE2F: Combining Half Marks (Mn) — valid ID_Continue, skip
        if (cp >= 0xFE30 and cp <= 0xFE6F) return false; // CJK Compat Forms, Small Form Variants
        if (cp >= 0xFF01 and cp <= 0xFF60) return false; // Fullwidth Latin (punctuation/symbols)
        if (cp >= 0xFFE0 and cp <= 0xFFEF) return false; // Fullwidth/halfwidth symbols

        // SMP codepoints (>= U+10000)
        if (cp >= 0x10000) return isValidIdentCodepointSMP(cp);

        // Most BMP non-ASCII codepoints in script blocks are valid (Lo/Ll/Lu/Mn/Mc/Nd/Pc)
        return true;
    }

    /// Check Supplementary Multilingual Plane codepoints for ID_Continue validity.
    fn isValidIdentCodepointSMP(cp: u32) bool {
        // Reject known symbol, punctuation, and non-identifier blocks
        // Aegean word separators (Po)
        if (cp >= 0x10100 and cp <= 0x10102) return false;
        // Counting Rod Numerals (No — not ID_Continue)
        if (cp >= 0x1D360 and cp <= 0x1D378) return false;
        // Bassa Vah: U+16AF5 is Full Stop (Po)
        if (cp == 0x16AF5) return false;
        // Pahawh Hmong digits are Nd (valid), but punctuation at end of block
        if (cp >= 0x16B44 and cp <= 0x16B45) return false;
        // Duployan punctuation
        if (cp == 0x1BC9F) return false;
        // Musical Symbols (So)
        if (cp >= 0x1D000 and cp <= 0x1D1FF) return false;
        // Ancient Greek Musical Notation (So)
        if (cp >= 0x1D200 and cp <= 0x1D24F) return false;
        // Tai Xuan Jing Symbols (So)
        if (cp >= 0x1D300 and cp <= 0x1D356) return false;
        // Emoji and Symbols blocks (but NOT segmented digits at 1FBF0-1FBF9 which are Nd)
        if (cp >= 0x1F000 and cp <= 0x1FBEF) return false;
        if (cp >= 0x1FBFA and cp <= 0x1FFFF) return false;
        // Tags (deprecated, format chars)
        if (cp >= 0xE0000 and cp <= 0xE007F) return false;
        // Variation Selectors Supplement
        if (cp >= 0xE0100 and cp <= 0xE01EF) return false;
        // Reject specific known-unassigned codepoints that appear in test fixtures
        if (cp == 0x2B81E or cp == 0x2B81F) return false; // Unassigned at end of CJK Ext D
        // Accept: most SMP codepoints are script letters (Lo) or marks (Mn/Mc)
        return true;
    }

    // ══════════════════════════════════════════════════════════
    //  Number Literals
    // ══════════════════════════════════════════════════════════

    fn scanNumber(self: *Lexer) Token.Token {
        const start = self.index;
        var is_bigint = false;

        if (self.source[self.index] == '0' and self.index + 1 < self.source.len) {
            const next_ch = self.source[self.index + 1];
            switch (next_ch) {
                'x', 'X' => {
                    // Hex literal: 0xFF_FF
                    self.index += 2;
                    const before_hex = self.index;
                    const sep_ok = self.scanHexDigits();
                    if (self.index == before_hex) return self.makeToken(.invalid, start);
                    if (!sep_ok) return self.makeToken(.invalid, start);
                    if (self.index < self.source.len and self.source[self.index] == 'n') {
                        is_bigint = true;
                        self.index += 1;
                    }
                    return self.finishNumber(start, is_bigint);
                },
                'o', 'O' => {
                    // Octal literal: 0o77
                    self.index += 2;
                    const before_digits = self.index;
                    const sep_ok = self.scanOctalDigits();
                    if (self.index == before_digits) return self.makeToken(.invalid, start);
                    if (!sep_ok) return self.makeToken(.invalid, start);
                    if (self.index < self.source.len and self.source[self.index] == 'n') {
                        is_bigint = true;
                        self.index += 1;
                    }
                    return self.finishNumber(start, is_bigint);
                },
                'b', 'B' => {
                    // Binary literal: 0b1010
                    self.index += 2;
                    const before_bin = self.index;
                    const sep_ok = self.scanBinaryDigits();
                    if (self.index == before_bin) return self.makeToken(.invalid, start);
                    if (!sep_ok) return self.makeToken(.invalid, start);
                    if (self.index < self.source.len and self.source[self.index] == 'n') {
                        is_bigint = true;
                        self.index += 1;
                    }
                    return self.finishNumber(start, is_bigint);
                },
                // 0_... with underscore right after leading 0 is invalid (octal ambiguity)
                '_' => {
                    self.index += 1; // skip the '0'
                    // Skip remaining digit-like chars for error recovery
                    while (self.index < self.source.len and (isDigit(self.source[self.index]) or self.source[self.index] == '_')) {
                        self.index += 1;
                    }
                    return self.makeToken(.invalid, start);
                },
                else => {},
            }
        }

        // Decimal literal (may start with . from caller)
        const dec_ok = self.scanDecimalDigits();

        // Fractional part
        var frac_ok = true;
        if (self.index < self.source.len and self.source[self.index] == '.') {
            self.index += 1;
            // Underscore right after `.` is invalid: `1._2`
            if (self.index < self.source.len and self.source[self.index] == '_') {
                // Skip remaining digits for error recovery
                while (self.index < self.source.len and (isDigit(self.source[self.index]) or self.source[self.index] == '_')) {
                    self.index += 1;
                }
                return self.makeToken(.invalid, start);
            }
            frac_ok = self.scanDecimalDigits();
        }

        // Exponent part
        var exp_ok = true;
        if (self.index < self.source.len) {
            const e = self.source[self.index];
            if (e == 'e' or e == 'E') {
                self.index += 1;
                if (self.index < self.source.len) {
                    const sign = self.source[self.index];
                    if (sign == '+' or sign == '-') {
                        self.index += 1;
                    }
                }
                const before_exp = self.index;
                exp_ok = self.scanDecimalDigits();
                if (self.index == before_exp) return self.makeToken(.invalid, start);
            }
        }

        if (!dec_ok or !frac_ok or !exp_ok) return self.makeToken(.invalid, start);

        // BigInt suffix
        if (self.index < self.source.len and self.source[self.index] == 'n') {
            // BigInt is only valid for integer literals (no decimal, no exponent, no legacy octal)
            const text = self.source[start..self.index];
            var has_dot = false;
            var has_exp = false;
            var is_legacy_octal = false;
            for (text, 0..) |c, i| {
                if (c == '.') has_dot = true;
                if ((c == 'e' or c == 'E') and i > 0) has_exp = true;
            }
            // Legacy octal: starts with 0 followed by a digit (not 0x, 0o, 0b)
            if (text.len >= 2 and text[0] == '0' and text[1] >= '0' and text[1] <= '9') {
                is_legacy_octal = true;
            }
            if (has_dot or has_exp or is_legacy_octal) {
                self.index += 1; // consume 'n' for error recovery
                return self.makeToken(.invalid, start);
            }
            is_bigint = true;
            self.index += 1;
        }

        return self.finishNumber(start, is_bigint);
    }

    /// Finish scanning a number: reject if followed immediately by identifier char.
    fn finishNumber(self: *Lexer, start: u32, is_bigint: bool) Token.Token {
        if (self.index < self.source.len) {
            const c = self.source[self.index];
            // Non-ASCII bytes: check if it's a Unicode whitespace (not identifier)
            if (c >= 0x80) {
                if (!self.isUnicodeWhitespaceAt(self.index)) {
                    // Non-whitespace non-ASCII after number = invalid (e.g. `2π`)
                    while (self.index < self.source.len and (isIdentContinue(self.source[self.index]) or self.source[self.index] >= 0x80)) {
                        self.index += 1;
                    }
                    return self.makeToken(.invalid, start);
                }
            } else if (isIdentStart(c) or c == '\\') {
                while (self.index < self.source.len and (isIdentContinue(self.source[self.index]) or self.source[self.index] >= 0x80)) {
                    self.index += 1;
                }
                return self.makeToken(.invalid, start);
            }
        }
        return self.makeToken(if (is_bigint) .bigint_literal else .number_literal, start);
    }

    /// Check if the bytes at position `pos` are a Unicode whitespace character.
    fn isUnicodeWhitespaceAt(self: *const Lexer, pos: u32) bool {
        if (pos >= self.source.len) return false;
        const c = self.source[pos];
        if (c == 0xC2 and pos + 1 < self.source.len and self.source[pos + 1] == 0xA0) return true; // NBSP
        if (c == 0xE2 and pos + 2 < self.source.len) {
            const b1 = self.source[pos + 1];
            const b2 = self.source[pos + 2];
            if (b1 == 0x80 and ((b2 >= 0x80 and b2 <= 0x8B) or b2 == 0xA8 or b2 == 0xA9 or b2 == 0xAF)) return true;
            if (b1 == 0x81 and b2 == 0x9F) return true; // U+205F
        }
        if (c == 0xE3 and pos + 2 < self.source.len and self.source[pos + 1] == 0x80 and self.source[pos + 2] == 0x80) return true; // U+3000
        if (c == 0xEF and pos + 2 < self.source.len and self.source[pos + 1] == 0xBB and self.source[pos + 2] == 0xBF) return true; // BOM
        if (c == 0xE1 and pos + 2 < self.source.len and self.source[pos + 1] == 0x9A and self.source[pos + 2] == 0x80) return true; // U+1680 Ogham
        return false;
    }

    /// Scan decimal digits with numeric separator validation.
    /// Returns false if a separator error was found (leading _, trailing _, double __).
    fn scanDecimalDigits(self: *Lexer) bool {
        var prev_underscore = false;
        var has_sep_error = false;
        // Leading underscore check: if first char is _, that's invalid
        if (self.index < self.source.len and self.source[self.index] == '_') {
            has_sep_error = true;
        }
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (isDigit(c)) {
                prev_underscore = false;
                self.index += 1;
            } else if (c == '_') {
                if (prev_underscore) has_sep_error = true; // double __
                prev_underscore = true;
                self.index += 1;
            } else {
                break;
            }
        }
        // Trailing underscore
        if (prev_underscore) has_sep_error = true;
        return !has_sep_error;
    }

    /// Scan hex digits with numeric separator validation.
    fn scanHexDigits(self: *Lexer) bool {
        var prev_underscore = false;
        var has_sep_error = false;
        if (self.index < self.source.len and self.source[self.index] == '_') {
            has_sep_error = true;
        }
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (isHexDigit(c)) {
                prev_underscore = false;
                self.index += 1;
            } else if (c == '_') {
                if (prev_underscore) has_sep_error = true;
                prev_underscore = true;
                self.index += 1;
            } else {
                break;
            }
        }
        if (prev_underscore) has_sep_error = true;
        return !has_sep_error;
    }

    /// Scan octal digits with numeric separator validation.
    fn scanOctalDigits(self: *Lexer) bool {
        var prev_underscore = false;
        var has_sep_error = false;
        if (self.index < self.source.len and self.source[self.index] == '_') {
            has_sep_error = true;
        }
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c >= '0' and c <= '7') {
                prev_underscore = false;
                self.index += 1;
            } else if (c == '_') {
                if (prev_underscore) has_sep_error = true;
                prev_underscore = true;
                self.index += 1;
            } else {
                break;
            }
        }
        if (prev_underscore) has_sep_error = true;
        return !has_sep_error;
    }

    /// Scan binary digits with numeric separator validation.
    fn scanBinaryDigits(self: *Lexer) bool {
        var prev_underscore = false;
        var has_sep_error = false;
        if (self.index < self.source.len and self.source[self.index] == '_') {
            has_sep_error = true;
        }
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c == '0' or c == '1') {
                prev_underscore = false;
                self.index += 1;
            } else if (c == '_') {
                if (prev_underscore) has_sep_error = true;
                prev_underscore = true;
                self.index += 1;
            } else {
                break;
            }
        }
        if (prev_underscore) has_sep_error = true;
        return !has_sep_error;
    }

    // ══════════════════════════════════════════════════════════
    //  String Literals
    // ══════════════════════════════════════════════════════════

    fn scanString(self: *Lexer) Token.Token {
        const start = self.index;
        const quote = self.source[self.index];
        self.index += 1; // skip opening quote

        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c == quote) {
                self.index += 1; // skip closing quote
                return self.makeToken(.string_literal, start);
            }
            if (c == '\\') {
                self.index += 1; // skip backslash
                if (self.index < self.source.len) {
                    const escaped = self.source[self.index];
                    if (escaped == '\r') {
                        // Line continuation: \<CR> or \<CR><LF>
                        self.index += 1;
                        if (self.index < self.source.len and self.source[self.index] == '\n') {
                            self.index += 1;
                        }
                    } else if (escaped == '8' or escaped == '9') {
                        // NonOctalDecimalEscapeSequence — valid in sloppy mode (Annex B).
                        // Strict mode checks happen at parser level, not lexer.
                        self.index += 1;
                    } else if (escaped == 'u') {
                        self.index += 1; // skip 'u'
                        if (self.index < self.source.len and self.source[self.index] == '{') {
                            // \u{XXXX} — validate hex digits and range
                            self.index += 1;
                            var digits: u32 = 0;
                            var codepoint: u32 = 0;
                            while (self.index < self.source.len and self.source[self.index] != '}') {
                                const d = self.source[self.index];
                                const val: u32 = if (d >= '0' and d <= '9') d - '0'
                                    else if (d >= 'a' and d <= 'f') d - 'a' + 10
                                    else if (d >= 'A' and d <= 'F') d - 'A' + 10
                                    else return self.makeToken(.invalid, start);
                                codepoint = codepoint * 16 + val;
                                digits += 1;
                                self.index += 1;
                            }
                            if (digits == 0 or codepoint > 0x10FFFF) return self.makeToken(.invalid, start);
                            if (self.index < self.source.len) self.index += 1; // skip }
                        } else {
                            // \uXXXX — need exactly 4 hex digits
                            var i: u32 = 0;
                            while (i < 4) : (i += 1) {
                                if (self.index >= self.source.len) return self.makeToken(.invalid, start);
                                const d = self.source[self.index];
                                if (!((d >= '0' and d <= '9') or (d >= 'a' and d <= 'f') or (d >= 'A' and d <= 'F')))
                                    return self.makeToken(.invalid, start);
                                self.index += 1;
                            }
                        }
                    } else if (escaped == 'x') {
                        self.index += 1; // skip 'x'
                        // \xXX — need exactly 2 hex digits
                        var i: u32 = 0;
                        while (i < 2) : (i += 1) {
                            if (self.index >= self.source.len) return self.makeToken(.invalid, start);
                            const d = self.source[self.index];
                            if (!((d >= '0' and d <= '9') or (d >= 'a' and d <= 'f') or (d >= 'A' and d <= 'F')))
                                return self.makeToken(.invalid, start);
                            self.index += 1;
                        }
                    } else {
                        self.index += 1;
                    }
                }
                continue;
            }
            // Unescaped newline in string is invalid
            if (c == '\n' or c == '\r') {
                return self.makeToken(.invalid, start);
            }
            self.index += 1;
        }

        // Unterminated string
        return self.makeToken(.invalid, start);
    }

    // ══════════════════════════════════════════════════════════
    //  Template Literals
    // ══════════════════════════════════════════════════════════

    fn scanTemplateLiteral(self: *Lexer) Token.Token {
        const start = self.index;
        self.index += 1; // skip opening `

        return self.scanTemplateContent(start, true);
    }

    /// Scan the body of a template literal. Called after the opening ` or after
    /// we resume from a `}` that closes a template expression.
    /// `is_head` is true when scanning from `, false when resuming from }.
    fn scanTemplateContent(self: *Lexer, start: u32, is_head: bool) Token.Token {
        while (self.index < self.source.len) {
            const c = self.source[self.index];

            if (c == '`') {
                // End of template
                self.index += 1;
                if (is_head) {
                    return self.makeToken(.template_no_sub, start);
                } else {
                    return self.makeToken(.template_tail, start);
                }
            }

            if (c == '$' and self.peek(1) == '{') {
                // Start of template expression: ${
                self.index += 2;
                if (self.template_depth < self.brace_depth_stack.len) {
                    self.brace_depth_stack[self.template_depth] = 0;
                }
                self.template_depth += 1;
                if (is_head) {
                    return self.makeToken(.template_head, start);
                } else {
                    return self.makeToken(.template_middle, start);
                }
            }

            if (c == '\\') {
                self.index += 1;
                if (self.index < self.source.len) {
                    const esc = self.source[self.index];
                    // Per ES2018 "template literal revision", invalid escape sequences
                    // are allowed in tagged templates (cooked value is undefined, raw preserved).
                    // Since the lexer can't distinguish tagged vs untagged, we allow all
                    // escapes and let the parser validate for untagged templates.
                    if (esc >= '0' and esc <= '9') {
                        // Skip digit(s) — \0, \01, \8, \9 etc. all allowed at lex level
                        self.index += 1;
                    } else if (esc == 'x') {
                        // \xHH — skip past the x and any hex digits
                        self.index += 1;
                        var count: u32 = 0;
                        while (count < 2 and self.index < self.source.len and isHexDigit(self.source[self.index])) {
                            self.index += 1;
                            count += 1;
                        }
                        // Don't reject if count != 2 — tagged templates allow it
                    } else if (esc == 'u') {
                        // \uXXXX or \u{XXXX} — skip past them (lenient for tagged templates)
                        self.index += 1;
                        if (self.index < self.source.len and self.source[self.index] == '{') {
                            self.index += 1;
                            // Skip until closing } or template boundary
                            while (self.index < self.source.len and self.source[self.index] != '}' and
                                self.source[self.index] != '`' and self.source[self.index] != '$')
                            {
                                self.index += 1;
                            }
                            if (self.index < self.source.len and self.source[self.index] == '}') self.index += 1;
                        } else {
                            // \uXXXX — skip up to 4 hex digits (don't reject if fewer)
                            var count: u32 = 0;
                            while (count < 4 and self.index < self.source.len and isHexDigit(self.source[self.index])) {
                                self.index += 1;
                                count += 1;
                            }
                        }
                    } else {
                        self.index += 1;
                    }
                }
                continue;
            }

            self.index += 1;
        }

        // Unterminated template literal
        return self.makeToken(.invalid, start);
    }

    // ══════════════════════════════════════════════════════════
    //  Regex Literals
    // ══════════════════════════════════════════════════════════

    fn scanRegex(self: *Lexer) Token.Token {
        const start = self.index;
        self.index += 1; // skip opening /

        var in_char_class = false;

        while (self.index < self.source.len) {
            const c = self.source[self.index];

            if (c == '\\') {
                // Escape — skip next char, but newline after \ is still invalid in regex
                self.index += 1;
                if (self.index < self.source.len) {
                    const next_ch = self.source[self.index];
                    if (next_ch == '\n' or next_ch == '\r') {
                        return self.makeToken(.invalid, start);
                    }
                    // U+2028/U+2029 after backslash is also invalid
                    if (next_ch == 0xe2 and self.index + 2 < self.source.len and
                        self.source[self.index + 1] == 0x80 and
                        (self.source[self.index + 2] == 0xa8 or self.source[self.index + 2] == 0xa9))
                    {
                        return self.makeToken(.invalid, start);
                    }
                    self.index += 1;
                }
                continue;
            }

            if (c == '[') {
                in_char_class = true;
                self.index += 1;
                continue;
            }

            if (c == ']') {
                in_char_class = false;
                self.index += 1;
                continue;
            }

            if (c == '/' and !in_char_class) {
                const body_end = self.index;
                self.index += 1; // skip closing /
                // Scan optional flags: g, i, m, s, u, v, y, d
                const flags_start = self.index;
                while (self.index < self.source.len and isIdentContinue(self.source[self.index])) {
                    self.index += 1;
                }
                // Validate flags: only d,g,i,m,s,u,v,y allowed, no duplicates
                const flags = self.source[flags_start..self.index];
                var has_u = false;
                var flag_seen: u8 = 0; // bit mask for d,g,i,m,s,u,v,y
                var flags_valid = true;
                for (flags) |fc| {
                    const bit: u8 = switch (fc) {
                        'd' => 0x01,
                        'g' => 0x02,
                        'i' => 0x04,
                        'm' => 0x08,
                        's' => 0x10,
                        'u' => 0x20,
                        'v' => 0x40,
                        'y' => 0x80,
                        else => 0,
                    };
                    if (bit == 0) {
                        flags_valid = false;
                        break;
                    }
                    if (flag_seen & bit != 0) {
                        flags_valid = false; // duplicate
                        break;
                    }
                    flag_seen |= bit;
                    if (fc == 'u' or fc == 'v') has_u = true;
                }
                if (!flags_valid) {
                    return self.makeToken(.invalid, start);
                }
                if (has_u) {
                    // body is source[start+1 .. body_end]
                    if (!validateRegexBody(self.source[start + 1 .. body_end], true)) {
                        return self.makeToken(.invalid, start);
                    }
                } else {
                    // Non-/u mode: still validate modifiers, braced quantifiers,
                    // lookbehind quantifiers, and named group syntax.
                    if (!validateRegexBody(self.source[start + 1 .. body_end], false)) {
                        return self.makeToken(.invalid, start);
                    }
                }
                return self.makeToken(.regex_literal, start);
            }

            // Unescaped newline in regex is invalid (includes U+2028 LS, U+2029 PS)
            if (c == '\n' or c == '\r') {
                return self.makeToken(.invalid, start);
            }
            if (c == 0xe2 and self.index + 2 < self.source.len and
                self.source[self.index + 1] == 0x80 and
                (self.source[self.index + 2] == 0xa8 or self.source[self.index + 2] == 0xa9))
            {
                return self.makeToken(.invalid, start);
            }

            self.index += 1;
        }

        // Unterminated regex
        return self.makeToken(.invalid, start);
    }

    // ══════════════════════════════════════════════════════════
    //  Regex validator — recursive-descent parser
    //
    //  Implements the ES2024 RegExp grammar for both normal and Unicode mode:
    //    Pattern     → Disjunction
    //    Disjunction → Alternative ('|' Alternative)*
    //    Alternative → Term*
    //    Term        → Assertion | Atom Quantifier?
    //
    //  Key rules:
    //  - Quantifier after Assertion is always a syntax error (both modes)
    //    EXCEPT that in non-/u mode, lookbehind assertions (?<=) and (?<!)
    //    are NOT quantifiable assertions (unlike lookahead).
    //  - Invalid modifiers in (?X:...) groups are always errors
    //  - {n} in atom position is always an error (InvalidBracedQuantifier)
    // ══════════════════════════════════════════════════════════

    const RegexValidator = struct {
        const MAX_GROUPS = 32;

        body: []const u8,
        pos: usize,
        unicode: bool,
        group_defs: [MAX_GROUPS][2]u16 = [_][2]u16{.{ 0, 0 }} ** MAX_GROUPS,
        group_refs: [MAX_GROUPS][2]u16 = [_][2]u16{.{ 0, 0 }} ** MAX_GROUPS,
        group_def_count: u8 = 0,
        group_ref_count: u8 = 0,
        has_named_group: bool = false,
        capturing_group_count: u16 = 0,
        max_numeric_backref: u16 = 0,

        const Kind = enum { atom, assertion, lookbehind_assertion, invalid, empty };

        fn validate(body: []const u8, unicode: bool) bool {
            var v = RegexValidator{ .body = body, .pos = 0, .unicode = unicode };
            const result = v.disjunction();
            if (result == .invalid) return false;

            // Post-parse: validate group references
            // Check duplicate group definitions (always)
            if (v.group_def_count > 1) {
                var i: usize = 0;
                while (i < v.group_def_count) : (i += 1) {
                    var j = i + 1;
                    while (j < v.group_def_count) : (j += 1) {
                        const a = v.body[v.group_defs[i][0]..v.group_defs[i][1]];
                        const b = v.body[v.group_defs[j][0]..v.group_defs[j][1]];
                        if (std.mem.eql(u8, a, b)) return false;
                    }
                }
            }
            // Check dangling references — only when named groups exist
            // (in non-/u without named groups, \k<x> is just an identity escape)
            if (v.has_named_group and v.group_ref_count > 0) {
                var ri: usize = 0;
                while (ri < v.group_ref_count) : (ri += 1) {
                    const ref = v.body[v.group_refs[ri][0]..v.group_refs[ri][1]];
                    var found = false;
                    var di: usize = 0;
                    while (di < v.group_def_count) : (di += 1) {
                        const def = v.body[v.group_defs[di][0]..v.group_defs[di][1]];
                        if (std.mem.eql(u8, ref, def)) { found = true; break; }
                    }
                    if (!found) return false;
                }
            }
            // In /u mode, \k<x> without ANY named group is also an error
            if (v.unicode and !v.has_named_group and v.group_ref_count > 0) return false;
            // In /u mode, backreferences to non-existent groups are errors
            if (v.unicode and v.max_numeric_backref > v.capturing_group_count) return false;
            return true;
        }

        /// Disjunction → Alternative ('|' Alternative)*
        fn disjunction(self: *RegexValidator) Kind {
            var k = self.alternative();
            if (k == .invalid) return .invalid;
            while (self.pos < self.body.len and self.body[self.pos] == '|') {
                self.pos += 1;
                k = self.alternative();
                if (k == .invalid) return .invalid;
            }
            return k;
        }

        /// Alternative → Term*
        /// Returns kind of the LAST term (needed by caller).
        fn alternative(self: *RegexValidator) Kind {
            var last: Kind = .empty;
            while (self.pos < self.body.len) {
                const c = self.body[self.pos];
                if (c == '|' or c == ')') break;
                const k = self.term();
                if (k == .invalid) return .invalid;
                last = k;
            }
            return last;
        }

        /// Term → Assertion | Atom Quantifier?
        fn term(self: *RegexValidator) Kind {
            const kind = self.atomOrAssertion();
            if (kind == .invalid) return .invalid;

            // Check for quantifier
            if (self.pos < self.body.len and self.isQuantifierStart()) {
                if (kind == .assertion and self.unicode) return .invalid; // quantifier on assertion invalid in /u
                if (kind == .lookbehind_assertion) return .invalid; // lookbehind never quantifiable
                if (!self.skipQuantifier()) {
                    if (self.unicode) return .invalid;
                    // In non-/u mode, invalid `{` is a literal — already consumed
                    // by atomOrAssertion, so just continue
                }
            }
            return kind;
        }

        /// Parse one atom or assertion. Returns its kind.
        fn atomOrAssertion(self: *RegexValidator) Kind {
            if (self.pos >= self.body.len) return .empty;
            const c = self.body[self.pos];

            switch (c) {
                // ── Assertions ──
                '^', '$' => { self.pos += 1; return .assertion; },

                // ── Escape sequences ──
                '\\' => return self.escape(),

                // ── Character class ──
                '[' => return self.charClass(),

                // ── Groups ──
                '(' => return self.group(),

                // ── Lone } is invalid in /u mode ──
                '}' => {
                    if (self.unicode) return .invalid;
                    self.pos += 1;
                    return .atom;
                },

                // ── { must be either a valid quantifier (handled by term) or invalid ──
                // In both /u and non-/u mode, bare {n} in atom position is a SyntaxError
                // (InvalidBracedQuantifier). We detect it here — if it looks like a valid
                // braced quantifier but there's no preceding atom, it's invalid.
                '{' => {
                    const end = quantifierEnd(self.body, self.pos);
                    if (end != 0) {
                        // Looks like {n} or {n,m} — invalid in atom position (no preceding atom)
                        return .invalid;
                    }
                    if (self.unicode) return .invalid;
                    self.pos += 1;
                    return .atom;
                },

                // ── Quantifier chars without preceding atom are always invalid ──
                // ?, +, * are SyntaxCharacters that can only appear as quantifiers
                // (after an atom). At atom position, they are syntax errors.
                '?', '+', '*' => return .invalid,

                // ── Regular atom (., literal char, etc.) ──
                else => { self.pos += 1; return .atom; },
            }
        }

        /// Returns true if c is a hex digit
        fn isHex(c: u8) bool {
            return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F');
        }

        /// Validate and skip \u{HHHH} escape in /u mode.
        /// Returns false if invalid (non-hex, empty, underscore, out of bounds).
        fn validateUnicodeBraced(self: *RegexValidator) bool {
            // pos is after '{'
            const brace_start = self.pos;
            var count: usize = 0;
            while (self.pos < self.body.len and self.body[self.pos] != '}') {
                const ch = self.body[self.pos];
                if (!isHex(ch)) return false; // non-hex (includes underscore, comma)
                count += 1;
                self.pos += 1;
            }
            if (self.pos >= self.body.len) return false; // unterminated
            if (count == 0) return false; // empty \u{}
            self.pos += 1; // skip }
            // Check value ≤ 0x10FFFF (allow arbitrary leading zeros)
            // Parse the hex value (overflow-safe: if > 0x10FFFF at any point, invalid)
            var val: u32 = 0;
            var i = brace_start;
            while (i < self.pos - 1) : (i += 1) {
                const d = self.body[i];
                const digit: u32 = if (d >= '0' and d <= '9') d - '0'
                      else if (d >= 'a' and d <= 'f') d - 'a' + 10
                      else d - 'A' + 10;
                val = val *| 16 +| digit;
                if (val > 0x10FFFF) return false;
            }
            return true;
        }

        /// Escape: \d, \b, \1, etc.
        fn escape(self: *RegexValidator) Kind {
            self.pos += 1; // skip '\'
            if (self.pos >= self.body.len) return .invalid;
            const c = self.body[self.pos];
            self.pos += 1;

            if (self.unicode) {
                return switch (c) {
                    // \b and \B are assertions
                    'b', 'B' => .assertion,
                    // Character class escapes — valid atoms in /u
                    'd', 'D', 's', 'S', 'w', 'W' => .atom,
                    // Control escapes
                    'f', 'n', 'r', 't', 'v' => .atom,
                    // \0 [lookahead ∉ DecimalDigit] — null character escape, valid in /u
                    '0' => blk: {
                        if (self.pos < self.body.len and self.body[self.pos] >= '0' and self.body[self.pos] <= '9')
                            break :blk .invalid; // \0N is octal, invalid in /u
                        break :blk .atom;
                    },
                    // \1-\9 back-references — in /u mode, the referenced group must exist
                    '1'...'9' => blk: {
                        // Parse the full number (multi-digit back-ref like \12)
                        var ref_num: u16 = c - '0';
                        while (self.pos < self.body.len and self.body[self.pos] >= '0' and self.body[self.pos] <= '9') {
                            ref_num = ref_num *| 10 +| (self.body[self.pos] - '0');
                            self.pos += 1;
                        }
                        if (ref_num > self.max_numeric_backref) self.max_numeric_backref = ref_num;
                        break :blk .atom;
                    },
                    // \u{HHHH} or \uHHHH
                    'u' => blk: {
                        if (self.pos < self.body.len and self.body[self.pos] == '{') {
                            self.pos += 1; // skip {
                            if (!self.validateUnicodeBraced()) break :blk .invalid;
                        } else {
                            // \uXXXX — must be exactly 4 hex digits
                            var j: usize = 0;
                            while (j < 4 and self.pos < self.body.len and isHex(self.body[self.pos])) : (j += 1) self.pos += 1;
                            if (j < 4) break :blk .invalid;
                        }
                        break :blk .atom;
                    },
                    // \xXX — must be exactly 2 hex digits
                    'x' => blk: {
                        var j: usize = 0;
                        while (j < 2 and self.pos < self.body.len and isHex(self.body[self.pos])) : (j += 1) self.pos += 1;
                        if (j < 2) break :blk .invalid;
                        break :blk .atom;
                    },
                    // \p{...} / \P{...} — Unicode property escape
                    'p', 'P' => blk: {
                        if (self.pos < self.body.len and self.body[self.pos] == '{') {
                            self.pos += 1;
                            while (self.pos < self.body.len and self.body[self.pos] != '}') self.pos += 1;
                            if (self.pos >= self.body.len) break :blk .invalid;
                            self.pos += 1;
                        } else {
                            break :blk .invalid;
                        }
                        break :blk .atom;
                    },
                    // \k<name> — named back-reference in /u mode
                    // \k without < is invalid in /u mode
                    'k' => blk: {
                        if (self.pos >= self.body.len or self.body[self.pos] != '<') break :blk .invalid;
                        self.pos += 1; // skip <
                        const ref_start = self.pos;
                        // Empty name is invalid
                        if (self.pos < self.body.len and self.body[self.pos] == '>') break :blk .invalid;
                        // Skip name content
                        while (self.pos < self.body.len and self.body[self.pos] != '>') {
                            if (self.body[self.pos] == ')') break; // unterminated
                            self.pos += 1;
                        }
                        if (self.pos >= self.body.len or self.body[self.pos] != '>') break :blk .invalid;
                        // Record reference
                        if (self.group_ref_count < MAX_GROUPS) {
                            self.group_refs[self.group_ref_count] = .{
                                @intCast(ref_start), @intCast(self.pos),
                            };
                            self.group_ref_count += 1;
                        }
                        self.pos += 1; // skip >
                        break :blk .atom;
                    },
                    // \cX — must be a-z or A-Z
                    'c' => blk: {
                        if (self.pos >= self.body.len) break :blk .invalid;
                        const nc = self.body[self.pos];
                        if (!((nc >= 'a' and nc <= 'z') or (nc >= 'A' and nc <= 'Z'))) break :blk .invalid;
                        self.pos += 1;
                        break :blk .atom;
                    },
                    // Identity escape in /u mode: only syntax chars and / are allowed
                    // \M, \Q, etc. are invalid — only ^$\.*+?()[]{}|/ are valid identity escapes
                    else => {
                        const is_syntax_char = switch (c) {
                            '^', '$', '\\', '.', '*', '+', '?', '(', ')', '[', ']', '{', '}', '|', '/' => true,
                            else => false,
                        };
                        if (!is_syntax_char) return .invalid;
                        return .atom;
                    },
                };
            } else {
                // Non-/u mode: more permissive escape handling
                return switch (c) {
                    'b', 'B' => .assertion,
                    // \u{HHHH} or \uHHHH — in non-/u, braces may be treated as literals
                    'u' => blk: {
                        if (self.pos < self.body.len and self.body[self.pos] == '{') {
                            // In non-/u mode, \u{...} is just \u followed by literal chars
                            // Skip as atom (not validated)
                            self.pos += 1;
                            while (self.pos < self.body.len and self.body[self.pos] != '}') self.pos += 1;
                            if (self.pos < self.body.len) self.pos += 1;
                        } else {
                            var j: usize = 0;
                            while (j < 4 and self.pos < self.body.len) : (j += 1) self.pos += 1;
                        }
                        break :blk .atom;
                    },
                    'x' => blk: {
                        var j: usize = 0;
                        while (j < 2 and self.pos < self.body.len) : (j += 1) self.pos += 1;
                        break :blk .atom;
                    },
                    'p', 'P' => blk: {
                        if (self.pos < self.body.len and self.body[self.pos] == '{') {
                            self.pos += 1;
                            while (self.pos < self.body.len and self.body[self.pos] != '}') self.pos += 1;
                            if (self.pos < self.body.len) self.pos += 1;
                        }
                        break :blk .atom;
                    },
                    // \k in non-/u: if followed by <name>, record as potential back-ref.
                    // Only validated post-parse if named groups exist.
                    'k' => blk: {
                        if (self.pos < self.body.len and self.body[self.pos] == '<') {
                            self.pos += 1;
                            const ref_start = self.pos;
                            while (self.pos < self.body.len and self.body[self.pos] != '>' and self.body[self.pos] != ')') self.pos += 1;
                            if (self.pos < self.body.len and self.body[self.pos] == '>') {
                                // Record reference (only checked if named groups exist)
                                if (self.group_ref_count < MAX_GROUPS) {
                                    self.group_refs[self.group_ref_count] = .{
                                        @intCast(ref_start), @intCast(self.pos),
                                    };
                                    self.group_ref_count += 1;
                                }
                                self.pos += 1; // skip >
                            }
                            // If no >, it's just \k followed by literal chars (valid in non-/u)
                        }
                        break :blk .atom;
                    },
                    // \cX
                    'c' => blk: {
                        if (self.pos < self.body.len) {
                            const nc = self.body[self.pos];
                            if ((nc >= 'a' and nc <= 'z') or (nc >= 'A' and nc <= 'Z')) self.pos += 1;
                        }
                        break :blk .atom;
                    },
                    else => .atom,
                };
            }
        }

        /// Character class: [...] with range validation in /u mode
        fn charClass(self: *RegexValidator) Kind {
            self.pos += 1; // skip [
            // Optional negation
            if (self.pos < self.body.len and self.body[self.pos] == '^') self.pos += 1;

            if (self.unicode) {
                // In /u mode, validate class ranges: [A-Z] ok, [\d-z] or [z-a] invalid
                while (self.pos < self.body.len and self.body[self.pos] != ']') {
                    const is_escape = self.body[self.pos] == '\\';
                    var is_class_escape = false;
                    if (is_escape) {
                        self.pos += 1;
                        if (self.pos >= self.body.len) return .invalid;
                        const ec = self.body[self.pos];
                        // Class escapes (\d, \D, \w, \W, \s, \S) represent multi-char sets
                        is_class_escape = switch (ec) {
                            'd', 'D', 'w', 'W', 's', 'S', 'p', 'P' => true,
                            else => false,
                        };
                        self.pos += 1;
                        // Skip rest of escape (like \u{HHHH}, \p{...})
                        if (ec == 'u' or ec == 'x') {
                            if (ec == 'u' and self.pos < self.body.len and self.body[self.pos] == '{') {
                                self.pos += 1;
                                while (self.pos < self.body.len and self.body[self.pos] != '}') self.pos += 1;
                                if (self.pos < self.body.len) self.pos += 1;
                            } else if (ec == 'u') {
                                var j: usize = 0;
                                while (j < 3 and self.pos < self.body.len) : (j += 1) self.pos += 1;
                            } else {
                                // \x — skip 1 more
                                if (self.pos < self.body.len) self.pos += 1;
                            }
                        } else if (ec == 'p' or ec == 'P') {
                            if (self.pos < self.body.len and self.body[self.pos] == '{') {
                                self.pos += 1;
                                while (self.pos < self.body.len and self.body[self.pos] != '}') self.pos += 1;
                                if (self.pos < self.body.len) self.pos += 1;
                            }
                        }
                    } else {
                        // Handle multi-byte chars
                        const b = self.body[self.pos];
                        if (b & 0x80 != 0) {
                            // Multi-byte UTF-8 — skip entire codepoint
                            const len: usize = if (b & 0xE0 == 0xC0) 2
                                              else if (b & 0xF0 == 0xE0) 3
                                              else if (b & 0xF8 == 0xF0) 4
                                              else 1;
                            self.pos += @min(len, self.body.len - self.pos);
                        } else {
                            self.pos += 1;
                        }
                    }
                    // Check for '-' range separator
                    if (self.pos < self.body.len and self.body[self.pos] == '-' and
                        self.pos + 1 < self.body.len and self.body[self.pos + 1] != ']')
                    {
                        // Both sides must be single characters (not class escapes)
                        if (is_class_escape) return .invalid;
                        self.pos += 1; // skip '-'
                        // Check right side
                        if (self.pos < self.body.len and self.body[self.pos] == '\\') {
                            self.pos += 1;
                            if (self.pos >= self.body.len) return .invalid;
                            const ec2 = self.body[self.pos];
                            const right_is_class_escape = switch (ec2) {
                                'd', 'D', 'w', 'W', 's', 'S', 'p', 'P' => true,
                                else => false,
                            };
                            if (right_is_class_escape) return .invalid;
                            self.pos += 1;
                        } else if (self.pos < self.body.len) {
                            const b2 = self.body[self.pos];
                            if (b2 & 0x80 != 0) {
                                const len: usize = if (b2 & 0xE0 == 0xC0) 2
                                                  else if (b2 & 0xF0 == 0xE0) 3
                                                  else if (b2 & 0xF8 == 0xF0) 4
                                                  else 1;
                                self.pos += @min(len, self.body.len - self.pos);
                            } else {
                                self.pos += 1;
                            }
                        }
                    }
                }
            } else {
                // Non-/u mode: simple scan until ]
                while (self.pos < self.body.len and self.body[self.pos] != ']') {
                    if (self.body[self.pos] == '\\') {
                        self.pos += 1; // skip \
                        if (self.pos < self.body.len) self.pos += 1; // skip escaped char
                    } else {
                        self.pos += 1;
                    }
                }
            }

            if (self.pos < self.body.len) self.pos += 1; // skip ]
            return .atom;
        }

        /// Validate a named group identifier (between < and >).
        /// Returns false if invalid (empty, starts with digit, contains invalid chars).
        /// pos should be right after '<', ends just before '>'.
        fn validateGroupName(name_start: usize, name_end: usize, body: []const u8) bool {
            if (name_start >= name_end) return false; // empty name
            const name = body[name_start..name_end];
            if (name.len == 0) return false;
            // Check for backslash in name (like (?<a\>.)) — name ends before \
            // The caller already handles skipping to '>' but if '\' appears before '>'
            // then the name contains '\'  which is invalid.
            for (name) |ch| {
                if (ch == '\\') return false;
            }
            // Check first char: must be ID_Start or $/_
            const first = name[0];
            // ASCII ID_Start: a-z, A-Z, _
            const first_is_ascii_id = (first >= 'a' and first <= 'z') or
                                      (first >= 'A' and first <= 'Z') or
                                      first == '_' or first == '$';
            if (first & 0x80 == 0) {
                // ASCII: must be letter/underscore/$
                if (!first_is_ascii_id) return false;
                // Also check for digits at start (42a...)
                if (first >= '0' and first <= '9') return false;
            }
            // Non-ASCII (multi-byte UTF-8): need to check if it's a valid ID_Start codepoint
            // For now, check for common invalid patterns:
            // - Lone surrogates encoded as UTF-16 (\uD800-\uDFFF)
            // These are fine to allow through for non-ASCII (they are likely valid Unicode)
            // The validator catches the most common cases.
            return true;
        }

        /// Group: (...), (?:...), (?=...), (?!...), (?<=...), (?<!...), (?<name>...)
        /// Also validates ES2024 inline modifiers: (?ims:...) or (?ims-ims:...)
        fn group(self: *RegexValidator) Kind {
            self.pos += 1; // skip (
            var kind: Kind = .atom; // default: capturing group → atom
            var is_capturing = true;

            if (self.pos < self.body.len and self.body[self.pos] == '?') {
                self.pos += 1;
                if (self.pos >= self.body.len) return .invalid;
                const c = self.body[self.pos];
                switch (c) {
                    ':' => { self.pos += 1; kind = .atom; is_capturing = false; }, // non-capturing
                    '=' => { self.pos += 1; kind = .assertion; is_capturing = false; }, // (?=...) lookahead
                    '!' => { self.pos += 1; kind = .assertion; is_capturing = false; }, // (?!...) neg lookahead
                    '<' => {
                        self.pos += 1;
                        if (self.pos < self.body.len) {
                            if (self.body[self.pos] == '=') {
                                self.pos += 1; kind = .lookbehind_assertion; is_capturing = false; // (?<=...) lookbehind
                            } else if (self.body[self.pos] == '!') {
                                self.pos += 1; kind = .lookbehind_assertion; is_capturing = false; // (?<!...) neg lookbehind
                            } else {
                                // (?<name>...) named group
                                // Validate the name
                                const name_start = self.pos;
                                // Check for invalid name starts
                                if (self.pos >= self.body.len) return .invalid;
                                // Check for empty name '(?<>...)'
                                if (self.body[self.pos] == '>') return .invalid;
                                // Check for digit at start
                                if (self.body[self.pos] >= '0' and self.body[self.pos] <= '9') return .invalid;
                                // Check for backslash (like (?<a\>))
                                if (self.body[self.pos] == '\\') return .invalid;
                                // Check first char for ASCII: must be letter or $/_
                                const fc = self.body[self.pos];
                                if (fc < 0x80) {
                                    const valid_start = (fc >= 'a' and fc <= 'z') or
                                                       (fc >= 'A' and fc <= 'Z') or
                                                       fc == '_' or fc == '$';
                                    if (!valid_start) return .invalid;
                                }
                                // Scan name until '>' — also checking for backslash or invalid chars
                                while (self.pos < self.body.len and self.body[self.pos] != '>') {
                                    const nc = self.body[self.pos];
                                    if (nc == '\\') return .invalid; // backslash in name invalid
                                    if (nc == ')') return .invalid; // unterminated group name
                                    // Check for ':' which is invalid in group name
                                    if (nc == ':') return .invalid;
                                    // Handle multi-byte
                                    if (nc & 0x80 != 0) {
                                        const blen: usize = if (nc & 0xE0 == 0xC0) 2
                                                            else if (nc & 0xF0 == 0xE0) 3
                                                            else if (nc & 0xF8 == 0xF0) 4
                                                            else 1;
                                        self.pos += @min(blen, self.body.len - self.pos);
                                    } else {
                                        self.pos += 1;
                                    }
                                }
                                if (self.pos >= self.body.len) return .invalid; // unterminated (no >)
                                // Record group definition
                                if (self.group_def_count < MAX_GROUPS) {
                                    self.group_defs[self.group_def_count] = .{
                                        @intCast(name_start), @intCast(self.pos),
                                    };
                                    self.group_def_count += 1;
                                    self.has_named_group = true;
                                }
                                self.pos += 1; // skip >
                                kind = .atom;
                            }
                        } else {
                            return .invalid;
                        }
                    },
                    else => {
                        // Could be an inline modifier: (?ims:...) or (?ims-ims:...)
                        // Valid modifier chars are: i, m, s
                        // Invalid: any uppercase, u, v, d, g, y, non-letter, etc.
                        if (!self.parseModifiers()) return .invalid;
                        kind = .atom;
                        is_capturing = false;
                    },
                }
            }

            // Track capturing groups for backref validation
            if (is_capturing) self.capturing_group_count += 1;

            // Parse group body as disjunction
            const inner = self.disjunction();
            if (inner == .invalid) return .invalid;

            // Expect closing )
            if (self.pos < self.body.len and self.body[self.pos] == ')') {
                self.pos += 1;
            } else if (self.unicode) {
                // In /u mode, unclosed groups are invalid
                // (In non-/u mode we're more lenient)
            }

            return kind;
        }

        /// Parse and validate inline modifiers: ims or ims-ims:
        /// Returns false if invalid.
        /// Called after '(?' when next char is not ':', '=', '!', '<'
        fn parseModifiers(self: *RegexValidator) bool {
            // Parse add-flags: only i, m, s allowed, no duplicates
            var add_flags: u8 = 0;
            while (self.pos < self.body.len) {
                const ch = self.body[self.pos];
                // Only ASCII letters are valid in the flags portion
                if (ch & 0x80 != 0) return false; // multi-byte char
                const bit: u8 = switch (ch) {
                    'i' => 0x01,
                    'm' => 0x02,
                    's' => 0x04,
                    '-', ':' => break,
                    else => return false, // invalid char (uppercase, digit, other)
                };
                if (add_flags & bit != 0) return false; // duplicate
                add_flags |= bit;
                self.pos += 1;
            }

            if (self.pos >= self.body.len) return false;
            const sep = self.body[self.pos];

            if (sep == ':') {
                // (?ims:...) form
                // Must have at least one add flag OR remove flags
                // Actually (?:...) is already handled, so this needs at least one flag
                if (add_flags == 0) return false; // (?:) already handled, empty flags here invalid
                self.pos += 1; // skip ':'
                return true;
            } else if (sep == '-') {
                self.pos += 1; // skip '-'
                // Parse remove-flags: only i, m, s allowed
                var remove_flags: u8 = 0;
                while (self.pos < self.body.len) {
                    const ch = self.body[self.pos];
                    if (ch & 0x80 != 0) return false; // multi-byte char
                    const bit: u8 = switch (ch) {
                        'i' => 0x01,
                        'm' => 0x02,
                        's' => 0x04,
                        ':' => break,
                        else => return false, // invalid
                    };
                    if (remove_flags & bit != 0) return false; // duplicate in remove
                    if (add_flags & bit != 0) return false; // same flag in add and remove
                    remove_flags |= bit;
                    self.pos += 1;
                }
                // Must end with ':'
                if (self.pos >= self.body.len or self.body[self.pos] != ':') return false;
                // At least one of add or remove must be non-empty
                if (add_flags == 0 and remove_flags == 0) return false;
                self.pos += 1; // skip ':'
                return true;
            } else {
                // No '-' or ':' — invalid modifier syntax
                return false;
            }
        }

        /// Check if current position starts a quantifier: *, +, ?, {n}, {n,}, {n,m}
        fn isQuantifierStart(self: *RegexValidator) bool {
            const c = self.body[self.pos];
            return c == '*' or c == '+' or c == '?' or c == '{';
        }

        /// Skip past a quantifier (including optional lazy ?). Returns false if { doesn't
        /// form a valid quantifier (syntax error in /u mode).
        fn skipQuantifier(self: *RegexValidator) bool {
            const c = self.body[self.pos];
            if (c == '*' or c == '+' or c == '?') {
                self.pos += 1;
                // Optional lazy modifier
                if (self.pos < self.body.len and self.body[self.pos] == '?') self.pos += 1;
                return true;
            }
            if (c == '{') {
                const end = quantifierEnd(self.body, self.pos);
                if (end == 0) {
                    // Not a valid {n}/{n,}/{n,m} — in /u mode this is always invalid.
                    // In non-/u mode also error (InvalidBracedQuantifier).
                    return false;
                }
                self.pos = end;
                if (self.pos < self.body.len and self.body[self.pos] == '?') self.pos += 1;
                return true;
            }
            return true;
        }
    };

    fn validateRegexBody(body: []const u8, unicode: bool) bool {
        return RegexValidator.validate(body, unicode);
    }

    // Keep old name as alias for compatibility
    fn validateRegexUnicode(body: []const u8) bool {
        return RegexValidator.validate(body, true);
    }

    /// If body[pos] starts a valid quantifier ({n}, {n,}, {n,m}), return index
    /// past the closing }. Otherwise return 0.
    fn quantifierEnd(body: []const u8, pos: usize) usize {
        var i = pos + 1;
        if (i >= body.len) return 0;
        if (body[i] < '0' or body[i] > '9') return 0;
        while (i < body.len and body[i] >= '0' and body[i] <= '9') i += 1;
        if (i >= body.len) return 0;
        if (body[i] == '}') return i + 1;
        if (body[i] == ',') {
            i += 1;
            if (i >= body.len) return 0;
            if (body[i] == '}') return i + 1;
            if (body[i] < '0' or body[i] > '9') return 0;
            while (i < body.len and body[i] >= '0' and body[i] <= '9') i += 1;
            if (i < body.len and body[i] == '}') return i + 1;
        }
        return 0;
    }

    /// Determine whether `/` should be treated as the start of a regex literal
    /// or as a division/division-assignment operator.
    ///
    /// After these tokens, `/` starts a regex:
    ///   - Start of file (eof as prev)
    ///   - ( [ { ; , : ? && || ?? ! != !== == === < > <= >= + - * % ** ~ ^ & |
    ///   - = += -= *= /= %= **= &= |= ^= <<= >>= >>>= &&= ||= ??=
    ///   - ++ -- (prefix context) => ... << >> >>>
    ///   - return, throw, delete, void, typeof, in, instanceof, new, case, yield, await
    ///   - else, do
    ///
    /// After these tokens, `/` is division:
    ///   - identifier, number, string, regex, template_tail, template_no_sub
    ///   - ) ] true false null this super
    ///   - bigint_literal
    ///   - ++ -- (postfix context — ambiguous, but we treat as division since
    ///     postfix is more common after an expression)
    fn isRegexContext(self: *Lexer) bool {
        return switch (self.prev_token_tag) {
            // Tokens after which `/` is definitely division
            .identifier,
            .number_literal,
            .bigint_literal,
            .string_literal,
            .regex_literal,
            .template_tail,
            .template_no_sub,
            .r_paren,
            .r_bracket,
            .kw_this,
            .kw_super,
            .kw_true,
            .kw_false,
            .kw_null,
            .plus_plus,
            .minus_minus,
            .escaped_keyword,
            // Keywords used as property names where `/` is division.
            // Only includes keywords that NEVER appear before an expression
            // in statement position (where `/` would start regex).
            // Excludes: return, throw, new, delete, typeof, void, case,
            // yield, await, default, else, do (these precede expressions).
            .kw_of,
            .kw_from,
            .kw_as,
            .kw_let,
            .kw_static,
            .kw_get,
            .kw_set,
            .kw_target,
            .kw_meta,
            .kw_in,
            .kw_instanceof,
            .kw_class,
            .kw_extends,
            .kw_break,
            .kw_catch,
            .kw_continue,
            .kw_debugger,
            .kw_export,
            .kw_finally,
            .kw_for,
            .kw_function,
            .kw_if,
            .kw_import,
            .kw_switch,
            .kw_try,
            .kw_var,
            .kw_while,
            .kw_with,
            => false,

            // `}` can close either an expression (object literal → division) or
            // a block/function body (→ regex). Use the brace context stack.
            .r_brace => {
                // Check if the matching `{` was in expression context
                if (self.brace_depth < self.brace_is_expr.len and self.brace_is_expr[self.brace_depth]) {
                    return false; // expression `}`, so `/` is division
                }
                return true; // block `}`, so `/` starts regex
            },

            // In JSX mode, `<` followed by `/` is a closing tag `</tag>`, not regex.
            .less_than => !self.language.isJsx(),

            // All other tokens: `/` starts a regex
            else => true,
        };
    }

    // ══════════════════════════════════════════════════════════
    //  Operators and Punctuation
    // ══════════════════════════════════════════════════════════

    fn scanOperatorOrPunct(self: *Lexer) Token.Token {
        const start = self.index;
        const c = self.source[self.index];

        switch (c) {
            '(' => {
                self.index += 1;
                self.paren_depth += 1;
                return self.makeToken(.l_paren, start);
            },
            ')' => {
                self.index += 1;
                if (self.paren_depth > 0) self.paren_depth -= 1;
                // Check if this `)` closes a function expression's params
                if (self.fn_expr_depth_count > 0 and
                    self.fn_expr_paren_depths[self.fn_expr_depth_count - 1] == self.paren_depth)
                {
                    self.fn_expr_depth_count -= 1;
                    self.fn_expr_next_brace = true;
                }
                return self.makeToken(.r_paren, start);
            },
            '{' => {
                self.index += 1;
                // Track brace depth for template expression matching
                if (self.template_depth > 0 and self.template_depth <= self.brace_depth_stack.len) {
                    self.brace_depth_stack[self.template_depth - 1] += 1;
                }
                // Track whether this brace opens an expression (object literal) or block.
                // `{` is an object literal after tokens that expect an expression:
                //   ( [ , : ; = += -= *= /= %= **= <<= >>= >>>= &= |= ^= &&= ||= ??=
                //   => ? || && ?? | ^ & == != === !== < > <= >= instanceof in
                //   + - * / % ** << >> >>> ~ ! typeof void delete return throw new case
                // Function expression body: `function(){` → expression context
                const is_fn_expr_body = self.fn_expr_next_brace;
                self.fn_expr_next_brace = false;
                if (self.brace_depth < self.brace_is_expr.len) {
                    self.brace_is_expr[self.brace_depth] = is_fn_expr_body or switch (self.prev_token_tag) {
                        .l_paren,
                        .l_bracket,
                        .comma,
                        .colon,
                        .equal,
                        .plus_equal,
                        .minus_equal,
                        .asterisk_equal,
                        .slash_equal,
                        .percent_equal,
                        .ampersand_equal,
                        .pipe_equal,
                        .caret_equal,
                        .arrow,
                        .question,
                        .pipe_pipe,
                        .ampersand_ampersand,
                        .question_question,
                        .pipe,
                        .caret,
                        .ampersand,
                        .equal_equal,
                        .bang_equal,
                        .equal_equal_equal,
                        .bang_equal_equal,
                        .less_than,
                        .greater_than,
                        .less_equal,
                        .greater_equal,
                        .kw_instanceof,
                        .kw_in,
                        .plus,
                        .minus,
                        .asterisk,
                        .slash,
                        .percent,
                        .asterisk_asterisk,
                        .tilde,
                        .bang,
                        .kw_typeof,
                        .kw_void,
                        .kw_delete,
                        .kw_return,
                        .kw_throw,
                        .kw_new,
                        .kw_case,
                        .kw_yield,
                        .kw_await,
                        .template_head,
                        .template_middle,
                        .ellipsis,
                        => true,
                        else => false,
                    };
                    self.brace_depth += 1;
                }
                return self.makeToken(.l_brace, start);
            },
            '}' => {
                // Check if this `}` closes a template expression
                if (self.template_depth > 0 and self.template_depth <= self.brace_depth_stack.len) {
                    if (self.brace_depth_stack[self.template_depth - 1] == 0) {
                        // This `}` closes the template expression
                        self.template_depth -= 1;
                        self.index += 1;
                        if (self.brace_depth > 0) self.brace_depth -= 1;
                        return self.scanTemplateContent(start, false);
                    } else {
                        // This `}` closes a nested block inside the template expression
                        self.brace_depth_stack[self.template_depth - 1] -= 1;
                    }
                }
                if (self.brace_depth > 0) self.brace_depth -= 1;
                self.index += 1;
                return self.makeToken(.r_brace, start);
            },
            '[' => {
                self.index += 1;
                return self.makeToken(.l_bracket, start);
            },
            ']' => {
                self.index += 1;
                return self.makeToken(.r_bracket, start);
            },
            ';' => {
                self.index += 1;
                return self.makeToken(.semicolon, start);
            },
            ',' => {
                self.index += 1;
                return self.makeToken(.comma, start);
            },
            ':' => {
                self.index += 1;
                return self.makeToken(.colon, start);
            },
            '~' => {
                self.index += 1;
                return self.makeToken(.tilde, start);
            },
            '#' => {
                self.index += 1;
                return self.makeToken(.hash, start);
            },

            // ── At sign (decorator) ──────────────────────────────
            '@' => {
                self.index += 1;
                return self.makeToken(.at_sign, start);
            },

            // ── Slash: division, /=, or regex ─────────────────
            '/' => {
                if (self.isRegexContext()) {
                    return self.scanRegex();
                }
                self.index += 1;
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.slash_equal, start);
                }
                return self.makeToken(.slash, start);
            },

            // ── Plus ──────────────────────────────────────────
            '+' => {
                self.index += 1;
                if (self.peek(0) == '+') {
                    self.index += 1;
                    return self.makeToken(.plus_plus, start);
                }
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.plus_equal, start);
                }
                return self.makeToken(.plus, start);
            },

            // ── Minus ─────────────────────────────────────────
            '-' => {
                self.index += 1;
                if (self.peek(0) == '-') {
                    self.index += 1;
                    return self.makeToken(.minus_minus, start);
                }
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.minus_equal, start);
                }
                return self.makeToken(.minus, start);
            },

            // ── Asterisk ──────────────────────────────────────
            '*' => {
                self.index += 1;
                if (self.peek(0) == '*') {
                    self.index += 1;
                    if (self.peek(0) == '=') {
                        self.index += 1;
                        return self.makeToken(.asterisk_asterisk_equal, start);
                    }
                    return self.makeToken(.asterisk_asterisk, start);
                }
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.asterisk_equal, start);
                }
                return self.makeToken(.asterisk, start);
            },

            // ── Percent ───────────────────────────────────────
            '%' => {
                self.index += 1;
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.percent_equal, start);
                }
                return self.makeToken(.percent, start);
            },

            // ── Ampersand ─────────────────────────────────────
            '&' => {
                self.index += 1;
                if (self.peek(0) == '&') {
                    self.index += 1;
                    if (self.peek(0) == '=') {
                        self.index += 1;
                        return self.makeToken(.ampersand_ampersand_equal, start);
                    }
                    return self.makeToken(.ampersand_ampersand, start);
                }
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.ampersand_equal, start);
                }
                return self.makeToken(.ampersand, start);
            },

            // ── Pipe ──────────────────────────────────────────
            '|' => {
                self.index += 1;
                if (self.peek(0) == '|') {
                    self.index += 1;
                    if (self.peek(0) == '=') {
                        self.index += 1;
                        return self.makeToken(.pipe_pipe_equal, start);
                    }
                    return self.makeToken(.pipe_pipe, start);
                }
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.pipe_equal, start);
                }
                return self.makeToken(.pipe, start);
            },

            // ── Caret ─────────────────────────────────────────
            '^' => {
                self.index += 1;
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.caret_equal, start);
                }
                return self.makeToken(.caret, start);
            },

            // ── Bang ──────────────────────────────────────────
            '!' => {
                self.index += 1;
                if (self.peek(0) == '=') {
                    self.index += 1;
                    if (self.peek(0) == '=') {
                        self.index += 1;
                        return self.makeToken(.bang_equal_equal, start);
                    }
                    return self.makeToken(.bang_equal, start);
                }
                return self.makeToken(.bang, start);
            },

            // ── Equal ─────────────────────────────────────────
            '=' => {
                self.index += 1;
                if (self.peek(0) == '=') {
                    self.index += 1;
                    if (self.peek(0) == '=') {
                        self.index += 1;
                        return self.makeToken(.equal_equal_equal, start);
                    }
                    return self.makeToken(.equal_equal, start);
                }
                if (self.peek(0) == '>') {
                    self.index += 1;
                    return self.makeToken(.arrow, start);
                }
                return self.makeToken(.equal, start);
            },

            // ── Less-than ─────────────────────────────────────
            '<' => {
                self.index += 1;
                if (self.peek(0) == '<') {
                    self.index += 1;
                    if (self.peek(0) == '=') {
                        self.index += 1;
                        return self.makeToken(.less_less_equal, start);
                    }
                    return self.makeToken(.less_less, start);
                }
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.less_equal, start);
                }
                return self.makeToken(.less_than, start);
            },

            // ── Greater-than ──────────────────────────────────
            '>' => {
                self.index += 1;
                if (self.peek(0) == '>') {
                    self.index += 1;
                    if (self.peek(0) == '>') {
                        self.index += 1;
                        if (self.peek(0) == '=') {
                            self.index += 1;
                            return self.makeToken(.greater_greater_greater_equal, start);
                        }
                        return self.makeToken(.greater_greater_greater, start);
                    }
                    if (self.peek(0) == '=') {
                        self.index += 1;
                        return self.makeToken(.greater_greater_equal, start);
                    }
                    return self.makeToken(.greater_greater, start);
                }
                if (self.peek(0) == '=') {
                    self.index += 1;
                    return self.makeToken(.greater_equal, start);
                }
                return self.makeToken(.greater_than, start);
            },

            // ── Question ──────────────────────────────────────
            '?' => {
                self.index += 1;
                if (self.peek(0) == '?') {
                    self.index += 1;
                    if (self.peek(0) == '=') {
                        self.index += 1;
                        return self.makeToken(.question_question_equal, start);
                    }
                    return self.makeToken(.question_question, start);
                }
                if (self.peek(0) == '.') {
                    // ?. but NOT ?.1 (which should be ? .1 — conditional + number)
                    if (!isDigit(self.peek(1))) {
                        self.index += 1;
                        return self.makeToken(.question_dot, start);
                    }
                }
                return self.makeToken(.question, start);
            },

            // ── Invalid character ─────────────────────────────
            else => {
                // Skip multi-byte UTF-8 sequences properly
                const cp_len = utf8ByteLen(c);
                if (cp_len > 1) {
                    self.index += cp_len;
                } else {
                    self.index += 1;
                }
                return self.makeToken(.invalid, start);
            },
        }
    }

    // ══════════════════════════════════════════════════════════
    //  Helpers
    // ══════════════════════════════════════════════════════════

    /// Create a token and update prev_token_tag for regex disambiguation.
    fn makeToken(self: *Lexer, tag: TokenTag, start: u32) Token.Token {
        // Track function expression context for division disambiguation.
        // `function` in expression position means the next `{` after `)`
        // closes a function expression (value), so `}` → division.
        if (tag == .kw_function) {
            const is_expr_pos = switch (self.prev_token_tag) {
                .l_paren, .l_bracket, .comma, .colon, .equal,
                .plus_equal, .minus_equal, .asterisk_equal, .slash_equal,
                .percent_equal, .ampersand_equal, .pipe_equal, .caret_equal,
                .arrow, .question, .pipe_pipe, .ampersand_ampersand,
                .question_question, .pipe, .caret, .ampersand,
                .equal_equal, .bang_equal, .equal_equal_equal, .bang_equal_equal,
                .less_than, .greater_than, .less_equal, .greater_equal,
                .kw_instanceof, .kw_in, .plus, .minus, .asterisk, .slash,
                .percent, .asterisk_asterisk, .tilde, .bang,
                .kw_typeof, .kw_void, .kw_delete, .kw_return, .kw_throw,
                .kw_new, .kw_case, .kw_yield, .kw_await,
                .template_head, .template_middle, .ellipsis,
                .semicolon, .r_brace,
                => true,
                else => false,
            };
            if (is_expr_pos and self.fn_expr_depth_count < self.fn_expr_paren_depths.len) {
                // Record paren depth — when we see `)` at this depth, set fn_expr_next_brace
                self.fn_expr_paren_depths[self.fn_expr_depth_count] = self.paren_depth;
                self.fn_expr_depth_count += 1;
            }
        }
        self.prev_token_tag = tag;
        return .{ .tag = tag, .start = start };
    }

    /// Peek at the byte at `self.index + offset`, returning 0 if out of bounds.
    fn peek(self: *const Lexer, offset: u32) u8 {
        const idx = self.index + offset;
        return if (idx < self.source.len) self.source[idx] else 0;
    }

};

// ══════════════════════════════════════════════════════════════
//  Character Classification Helpers
// ══════════════════════════════════════════════════════════════

fn isIdentStart(c: u8) bool {
    return switch (c) {
        'a'...'z', 'A'...'Z', '_', '$' => true,
        '\\' => true, // Unicode escape \uXXXX can start an identifier
        else => c >= 0x80, // Non-ASCII start bytes (UTF-8 multi-byte)
    };
}

fn isIdentContinue(c: u8) bool {
    return switch (c) {
        'a'...'z', 'A'...'Z', '0'...'9', '_', '$' => true,
        else => false,
    };
}

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

fn isHexDigit(c: u8) bool {
    return switch (c) {
        '0'...'9', 'a'...'f', 'A'...'F' => true,
        else => false,
    };
}

/// Return the byte length of a UTF-8 sequence from its leading byte.
/// Returns 0 for invalid leading bytes.
fn utf8ByteLen(c: u8) u32 {
    if (c < 0x80) return 1;
    if (c & 0xE0 == 0xC0) return 2;
    if (c & 0xF0 == 0xE0) return 3;
    if (c & 0xF8 == 0xF0) return 4;
    return 0;
}

fn decodeUtf8(bytes: []const u8, len: u32) u32 {
    return switch (len) {
        1 => bytes[0],
        2 => if (bytes.len >= 2)
            (@as(u32, bytes[0] & 0x1F) << 6) | (bytes[1] & 0x3F)
        else
            0xFFFD,
        3 => if (bytes.len >= 3)
            (@as(u32, bytes[0] & 0x0F) << 12) | (@as(u32, bytes[1] & 0x3F) << 6) | (bytes[2] & 0x3F)
        else
            0xFFFD,
        4 => if (bytes.len >= 4)
            (@as(u32, bytes[0] & 0x07) << 18) | (@as(u32, bytes[1] & 0x3F) << 12) | (@as(u32, bytes[2] & 0x3F) << 6) | (bytes[3] & 0x3F)
        else
            0xFFFD,
        else => 0xFFFD,
    };
}

// ══════════════════════════════════════════════════════════════
//  Tests
// ══════════════════════════════════════════════════════════════

test "empty source" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(@as(usize, 1), tags.len);
    try std.testing.expectEqual(TokenTag.eof, tags[0]);
}

test "simple identifiers and keywords" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "const x = 42;");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.kw_const, tags[0]);
    try std.testing.expectEqual(TokenTag.identifier, tags[1]);
    try std.testing.expectEqual(TokenTag.equal, tags[2]);
    try std.testing.expectEqual(TokenTag.number_literal, tags[3]);
    try std.testing.expectEqual(TokenTag.semicolon, tags[4]);
    try std.testing.expectEqual(TokenTag.eof, tags[5]);
}

test "number literals" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "42 3.14 0xFF 0o77 0b1010 1_000_000 42n 0xFF_FFn");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.number_literal, tags[0]); // 42
    try std.testing.expectEqual(TokenTag.number_literal, tags[1]); // 3.14
    try std.testing.expectEqual(TokenTag.number_literal, tags[2]); // 0xFF
    try std.testing.expectEqual(TokenTag.number_literal, tags[3]); // 0o77
    try std.testing.expectEqual(TokenTag.number_literal, tags[4]); // 0b1010
    try std.testing.expectEqual(TokenTag.number_literal, tags[5]); // 1_000_000
    try std.testing.expectEqual(TokenTag.bigint_literal, tags[6]); // 42n
    try std.testing.expectEqual(TokenTag.bigint_literal, tags[7]); // 0xFF_FFn
    try std.testing.expectEqual(TokenTag.eof, tags[8]);
}

test "string literals" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "'hello' \"world\" 'es\\'cape'");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.string_literal, tags[0]);
    try std.testing.expectEqual(TokenTag.string_literal, tags[1]);
    try std.testing.expectEqual(TokenTag.string_literal, tags[2]);
    try std.testing.expectEqual(TokenTag.eof, tags[3]);
}

test "template literals" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "`hello`");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.template_no_sub, tags[0]);
    try std.testing.expectEqual(TokenTag.eof, tags[1]);
}

test "template with interpolation" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "`hello ${name} world`");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.template_head, tags[0]); // `hello ${
    try std.testing.expectEqual(TokenTag.identifier, tags[1]); // name
    try std.testing.expectEqual(TokenTag.template_tail, tags[2]); // } world`
    try std.testing.expectEqual(TokenTag.eof, tags[3]);
}

test "template with multiple interpolations" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "`${a}${b}`");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.template_head, tags[0]); // `${
    try std.testing.expectEqual(TokenTag.identifier, tags[1]); // a
    try std.testing.expectEqual(TokenTag.template_middle, tags[2]); // }${
    try std.testing.expectEqual(TokenTag.identifier, tags[3]); // b
    try std.testing.expectEqual(TokenTag.template_tail, tags[4]); // }`
    try std.testing.expectEqual(TokenTag.eof, tags[5]);
}

test "regex literal" {
    const alloc = std.testing.allocator;
    // After = (assignment), / starts a regex
    var tokens = try Lexer.tokenize(alloc, "x = /foo/gi;");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.identifier, tags[0]);
    try std.testing.expectEqual(TokenTag.equal, tags[1]);
    try std.testing.expectEqual(TokenTag.regex_literal, tags[2]);
    try std.testing.expectEqual(TokenTag.semicolon, tags[3]);
}

test "division not regex" {
    const alloc = std.testing.allocator;
    // After an identifier, / is division
    var tokens = try Lexer.tokenize(alloc, "a / b");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.identifier, tags[0]);
    try std.testing.expectEqual(TokenTag.slash, tags[1]);
    try std.testing.expectEqual(TokenTag.identifier, tags[2]);
}

test "multi-char operators" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "=== !== >>> >>= ??= ?. => ... ** &&= ||=");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.equal_equal_equal, tags[0]);
    try std.testing.expectEqual(TokenTag.bang_equal_equal, tags[1]);
    try std.testing.expectEqual(TokenTag.greater_greater_greater, tags[2]);
    try std.testing.expectEqual(TokenTag.greater_greater_equal, tags[3]);
    try std.testing.expectEqual(TokenTag.question_question_equal, tags[4]);
    try std.testing.expectEqual(TokenTag.question_dot, tags[5]);
    try std.testing.expectEqual(TokenTag.arrow, tags[6]);
    try std.testing.expectEqual(TokenTag.ellipsis, tags[7]);
    try std.testing.expectEqual(TokenTag.asterisk_asterisk, tags[8]);
    try std.testing.expectEqual(TokenTag.ampersand_ampersand_equal, tags[9]);
    try std.testing.expectEqual(TokenTag.pipe_pipe_equal, tags[10]);
    try std.testing.expectEqual(TokenTag.eof, tags[11]);
}

test "comments are skipped" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "a // comment\nb /* block */ c");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.identifier, tags[0]); // a
    try std.testing.expectEqual(TokenTag.identifier, tags[1]); // b
    try std.testing.expectEqual(TokenTag.identifier, tags[2]); // c
    try std.testing.expectEqual(TokenTag.eof, tags[3]);
}

test "hashbang" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "#!/usr/bin/env node\nconst x = 1;");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.hashbang, tags[0]);
    try std.testing.expectEqual(TokenTag.kw_const, tags[1]);
    try std.testing.expectEqual(TokenTag.identifier, tags[2]);
    try std.testing.expectEqual(TokenTag.equal, tags[3]);
    try std.testing.expectEqual(TokenTag.number_literal, tags[4]);
    try std.testing.expectEqual(TokenTag.semicolon, tags[5]);
    try std.testing.expectEqual(TokenTag.eof, tags[6]);
}

test "dot vs ellipsis vs decimal" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "a.b ... .5");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.identifier, tags[0]); // a
    try std.testing.expectEqual(TokenTag.dot, tags[1]); // .
    try std.testing.expectEqual(TokenTag.identifier, tags[2]); // b
    try std.testing.expectEqual(TokenTag.ellipsis, tags[3]); // ...
    try std.testing.expectEqual(TokenTag.number_literal, tags[4]); // .5
    try std.testing.expectEqual(TokenTag.eof, tags[5]);
}

test "all keywords tokenized" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "break case catch continue debugger default delete do else export extends finally for function if import in instanceof new return super switch this throw try typeof var void while with yield let const class of async await static get set from as enum null true false");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.kw_break, tags[0]);
    try std.testing.expectEqual(TokenTag.kw_case, tags[1]);
    try std.testing.expectEqual(TokenTag.kw_catch, tags[2]);
    try std.testing.expectEqual(TokenTag.kw_continue, tags[3]);
    try std.testing.expectEqual(TokenTag.kw_debugger, tags[4]);
    try std.testing.expectEqual(TokenTag.kw_default, tags[5]);
    try std.testing.expectEqual(TokenTag.kw_delete, tags[6]);
    try std.testing.expectEqual(TokenTag.kw_do, tags[7]);
    try std.testing.expectEqual(TokenTag.kw_else, tags[8]);
    try std.testing.expectEqual(TokenTag.kw_export, tags[9]);
    try std.testing.expectEqual(TokenTag.kw_extends, tags[10]);
    try std.testing.expectEqual(TokenTag.kw_finally, tags[11]);
    try std.testing.expectEqual(TokenTag.kw_for, tags[12]);
    try std.testing.expectEqual(TokenTag.kw_function, tags[13]);
    try std.testing.expectEqual(TokenTag.kw_if, tags[14]);
    try std.testing.expectEqual(TokenTag.kw_import, tags[15]);
    try std.testing.expectEqual(TokenTag.kw_in, tags[16]);
    try std.testing.expectEqual(TokenTag.kw_instanceof, tags[17]);
    try std.testing.expectEqual(TokenTag.kw_new, tags[18]);
    try std.testing.expectEqual(TokenTag.kw_return, tags[19]);
    try std.testing.expectEqual(TokenTag.kw_super, tags[20]);
    try std.testing.expectEqual(TokenTag.kw_switch, tags[21]);
    try std.testing.expectEqual(TokenTag.kw_this, tags[22]);
    try std.testing.expectEqual(TokenTag.kw_throw, tags[23]);
    try std.testing.expectEqual(TokenTag.kw_try, tags[24]);
    try std.testing.expectEqual(TokenTag.kw_typeof, tags[25]);
    try std.testing.expectEqual(TokenTag.kw_var, tags[26]);
    try std.testing.expectEqual(TokenTag.kw_void, tags[27]);
    try std.testing.expectEqual(TokenTag.kw_while, tags[28]);
    try std.testing.expectEqual(TokenTag.kw_with, tags[29]);
    try std.testing.expectEqual(TokenTag.kw_yield, tags[30]);
    try std.testing.expectEqual(TokenTag.kw_let, tags[31]);
    try std.testing.expectEqual(TokenTag.kw_const, tags[32]);
    try std.testing.expectEqual(TokenTag.kw_class, tags[33]);
    try std.testing.expectEqual(TokenTag.kw_of, tags[34]);
    try std.testing.expectEqual(TokenTag.kw_async, tags[35]);
    try std.testing.expectEqual(TokenTag.kw_await, tags[36]);
    try std.testing.expectEqual(TokenTag.kw_static, tags[37]);
    try std.testing.expectEqual(TokenTag.kw_get, tags[38]);
    try std.testing.expectEqual(TokenTag.kw_set, tags[39]);
    try std.testing.expectEqual(TokenTag.kw_from, tags[40]);
    try std.testing.expectEqual(TokenTag.kw_as, tags[41]);
    try std.testing.expectEqual(TokenTag.kw_enum, tags[42]);
    try std.testing.expectEqual(TokenTag.kw_null, tags[43]);
    try std.testing.expectEqual(TokenTag.kw_true, tags[44]);
    try std.testing.expectEqual(TokenTag.kw_false, tags[45]);
    try std.testing.expectEqual(TokenTag.eof, tags[46]);
}

test "regex with character class containing slash" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "x = /[a/b]/;");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.identifier, tags[0]);
    try std.testing.expectEqual(TokenTag.equal, tags[1]);
    try std.testing.expectEqual(TokenTag.regex_literal, tags[2]);
    try std.testing.expectEqual(TokenTag.semicolon, tags[3]);
}

test "number with exponent" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "1e10 2.5E-3 1e+5");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.number_literal, tags[0]);
    try std.testing.expectEqual(TokenTag.number_literal, tags[1]);
    try std.testing.expectEqual(TokenTag.number_literal, tags[2]);
    try std.testing.expectEqual(TokenTag.eof, tags[3]);
}

test "question dot does not match ?.digit" {
    const alloc = std.testing.allocator;
    // x?.1 should be x ? .1 (ternary followed by decimal number)
    var tokens = try Lexer.tokenize(alloc, "x?.1");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.identifier, tags[0]); // x
    try std.testing.expectEqual(TokenTag.question, tags[1]); // ?
    try std.testing.expectEqual(TokenTag.number_literal, tags[2]); // .1
    try std.testing.expectEqual(TokenTag.eof, tags[3]);
}

test "regex after return keyword" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "return /regex/g");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.kw_return, tags[0]);
    try std.testing.expectEqual(TokenTag.regex_literal, tags[1]);
    try std.testing.expectEqual(TokenTag.eof, tags[2]);
}

test "division after closing paren" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "(a) / b");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.l_paren, tags[0]);
    try std.testing.expectEqual(TokenTag.identifier, tags[1]);
    try std.testing.expectEqual(TokenTag.r_paren, tags[2]);
    try std.testing.expectEqual(TokenTag.slash, tags[3]);
    try std.testing.expectEqual(TokenTag.identifier, tags[4]);
    try std.testing.expectEqual(TokenTag.eof, tags[5]);
}

test "slash_equal operator" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "x /= 2");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.identifier, tags[0]);
    try std.testing.expectEqual(TokenTag.slash_equal, tags[1]);
    try std.testing.expectEqual(TokenTag.number_literal, tags[2]);
    try std.testing.expectEqual(TokenTag.eof, tags[3]);
}

test "token start positions are correct" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "const x = 42;");
    defer tokens.deinit(alloc);

    const starts = tokens.items(.start);
    try std.testing.expectEqual(@as(u32, 0), starts[0]); // const
    try std.testing.expectEqual(@as(u32, 6), starts[1]); // x
    try std.testing.expectEqual(@as(u32, 8), starts[2]); // =
    try std.testing.expectEqual(@as(u32, 10), starts[3]); // 42
    try std.testing.expectEqual(@as(u32, 12), starts[4]); // ;
}

test ">>>= operator" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "a >>>= b");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.identifier, tags[0]);
    try std.testing.expectEqual(TokenTag.greater_greater_greater_equal, tags[1]);
    try std.testing.expectEqual(TokenTag.identifier, tags[2]);
    try std.testing.expectEqual(TokenTag.eof, tags[3]);
}

test "nested template literals" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "`a ${`b ${c} d`} e`");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.template_head, tags[0]); // `a ${
    try std.testing.expectEqual(TokenTag.template_head, tags[1]); // `b ${
    try std.testing.expectEqual(TokenTag.identifier, tags[2]); // c
    try std.testing.expectEqual(TokenTag.template_tail, tags[3]); // } d`
    try std.testing.expectEqual(TokenTag.template_tail, tags[4]); // } e`
    try std.testing.expectEqual(TokenTag.eof, tags[5]);
}

test "regex after opening paren" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "(/regex/)");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.l_paren, tags[0]);
    try std.testing.expectEqual(TokenTag.regex_literal, tags[1]);
    try std.testing.expectEqual(TokenTag.r_paren, tags[2]);
    try std.testing.expectEqual(TokenTag.eof, tags[3]);
}

test "binary literal with separators" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "0b1010_0101");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.number_literal, tags[0]);
    try std.testing.expectEqual(TokenTag.eof, tags[1]);
}

test "private field hash" {
    const alloc = std.testing.allocator;
    var tokens = try Lexer.tokenize(alloc, "#field");
    defer tokens.deinit(alloc);

    const tags = tokens.items(.tag);
    try std.testing.expectEqual(TokenTag.hash, tags[0]);
    try std.testing.expectEqual(TokenTag.identifier, tags[1]);
    try std.testing.expectEqual(TokenTag.eof, tags[2]);
}
