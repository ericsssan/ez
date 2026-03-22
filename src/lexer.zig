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
pub const Lexer = struct {
    source: []const u8,
    index: u32,
    tokens: TokenList,
    allocator: std.mem.Allocator,
    prev_token_tag: TokenTag,
    template_depth: u32,

    /// Initialize a new lexer. Call `next()` repeatedly or use `tokenize()`.
    pub fn init(allocator: std.mem.Allocator, source: []const u8) Lexer {
        return .{
            .source = source,
            .index = 0,
            .tokens = .{},
            .allocator = allocator,
            .prev_token_tag = .eof,
            .template_depth = 0,
        };
    }

    /// Tokenize the entire source, returning a MultiArrayList of tokens.
    /// The final token is always `.eof`.
    pub fn tokenize(allocator: std.mem.Allocator, source: []const u8) !TokenList {
        var self = init(allocator, source);

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
        self.index += 2;
        while (self.index + 1 < self.source.len) {
            if (self.source[self.index] == '*' and self.source[self.index + 1] == '/') {
                self.index += 2;
                return;
            }
            self.index += 1;
        }
        // Unterminated block comment — advance to end
        self.index = @intCast(self.source.len);
    }

    // ══════════════════════════════════════════════════════════
    //  Hashbang
    // ══════════════════════════════════════════════════════════

    fn scanHashbang(self: *Lexer) Token.Token {
        const start = self.index;
        // Skip #!
        self.index += 2;
        while (self.index < self.source.len and self.source[self.index] != '\n') {
            self.index += 1;
        }
        return self.makeToken(.hashbang, start);
    }

    // ══════════════════════════════════════════════════════════
    //  Identifiers and Keywords (SIMD-accelerated)
    // ══════════════════════════════════════════════════════════

    fn scanIdentifierOrKeyword(self: *Lexer) Token.Token {
        const start = self.index;
        self.index += 1; // skip first char (already validated as ident start)

        // SIMD scan of ASCII identifier continuation chars
        self.scanIdentChunksSIMD();

        // Scalar fallback for any remaining chars or Unicode escapes
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (isIdentContinue(c)) {
                self.index += 1;
            } else if (c == '\\' and self.peek(1) == 'u') {
                // Unicode escape in identifier: \uXXXX or \u{XXXX}
                self.skipUnicodeEscape();
            } else if (c >= 0x80) {
                // Multi-byte UTF-8 identifier character
                const cp_len = utf8ByteLen(c);
                if (cp_len == 0) break;
                self.index += cp_len;
            } else {
                break;
            }
        }

        const text = self.source[start..self.index];

        // Keyword lookup
        if (keywords.get(text)) |kw_tag| {
            return self.makeToken(kw_tag, start);
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

    fn skipUnicodeEscape(self: *Lexer) void {
        // \uXXXX or \u{XXXX}
        self.index += 2; // skip \u
        if (self.index < self.source.len and self.source[self.index] == '{') {
            self.index += 1;
            while (self.index < self.source.len and self.source[self.index] != '}') {
                self.index += 1;
            }
            if (self.index < self.source.len) self.index += 1; // skip }
        } else {
            // Exactly 4 hex digits
            var count: u32 = 0;
            while (count < 4 and self.index < self.source.len and isHexDigit(self.source[self.index])) {
                self.index += 1;
                count += 1;
            }
        }
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
                    self.scanHexDigits();
                    if (self.index < self.source.len and self.source[self.index] == 'n') {
                        is_bigint = true;
                        self.index += 1;
                    }
                    return self.makeToken(if (is_bigint) .bigint_literal else .number_literal, start);
                },
                'o', 'O' => {
                    // Octal literal: 0o77
                    self.index += 2;
                    self.scanOctalDigits();
                    if (self.index < self.source.len and self.source[self.index] == 'n') {
                        is_bigint = true;
                        self.index += 1;
                    }
                    return self.makeToken(if (is_bigint) .bigint_literal else .number_literal, start);
                },
                'b', 'B' => {
                    // Binary literal: 0b1010
                    self.index += 2;
                    self.scanBinaryDigits();
                    if (self.index < self.source.len and self.source[self.index] == 'n') {
                        is_bigint = true;
                        self.index += 1;
                    }
                    return self.makeToken(if (is_bigint) .bigint_literal else .number_literal, start);
                },
                else => {},
            }
        }

        // Decimal literal (may start with . from caller)
        self.scanDecimalDigits();

        // Fractional part
        if (self.index < self.source.len and self.source[self.index] == '.') {
            self.index += 1;
            self.scanDecimalDigits();
        }

        // Exponent part
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
                self.scanDecimalDigits();
            }
        }

        // BigInt suffix
        if (self.index < self.source.len and self.source[self.index] == 'n') {
            is_bigint = true;
            self.index += 1;
        }

        return self.makeToken(if (is_bigint) .bigint_literal else .number_literal, start);
    }

    fn scanDecimalDigits(self: *Lexer) void {
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (isDigit(c)) {
                self.index += 1;
            } else if (c == '_') {
                // Numeric separator: valid between digits
                self.index += 1;
            } else {
                break;
            }
        }
    }

    fn scanHexDigits(self: *Lexer) void {
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (isHexDigit(c)) {
                self.index += 1;
            } else if (c == '_') {
                self.index += 1;
            } else {
                break;
            }
        }
    }

    fn scanOctalDigits(self: *Lexer) void {
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c >= '0' and c <= '7') {
                self.index += 1;
            } else if (c == '_') {
                self.index += 1;
            } else {
                break;
            }
        }
    }

    fn scanBinaryDigits(self: *Lexer) void {
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c == '0' or c == '1') {
                self.index += 1;
            } else if (c == '_') {
                self.index += 1;
            } else {
                break;
            }
        }
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
                    } else {
                        self.index += 1;
                    }
                }
                continue;
            }
            // Unescaped newline terminates the string (error, but we still emit the token)
            if (c == '\n' or c == '\r') {
                return self.makeToken(.string_literal, start);
            }
            self.index += 1;
        }

        // Unterminated string
        return self.makeToken(.string_literal, start);
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
                self.template_depth += 1;
                if (is_head) {
                    return self.makeToken(.template_head, start);
                } else {
                    return self.makeToken(.template_middle, start);
                }
            }

            if (c == '\\') {
                // Escape sequence — skip the next character
                self.index += 1;
                if (self.index < self.source.len) {
                    self.index += 1;
                }
                continue;
            }

            self.index += 1;
        }

        // Unterminated template literal
        if (is_head) {
            return self.makeToken(.template_no_sub, start);
        } else {
            return self.makeToken(.template_tail, start);
        }
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
                // Escape — skip next char
                self.index += 1;
                if (self.index < self.source.len) {
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
                self.index += 1; // skip closing /
                // Scan optional flags: g, i, m, s, u, v, y, d
                while (self.index < self.source.len and isIdentContinue(self.source[self.index])) {
                    self.index += 1;
                }
                return self.makeToken(.regex_literal, start);
            }

            // Unescaped newline terminates the regex (error)
            if (c == '\n' or c == '\r') {
                return self.makeToken(.regex_literal, start);
            }

            self.index += 1;
        }

        // Unterminated regex
        return self.makeToken(.regex_literal, start);
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
            => false,

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
                return self.makeToken(.l_paren, start);
            },
            ')' => {
                self.index += 1;
                return self.makeToken(.r_paren, start);
            },
            '{' => {
                self.index += 1;
                return self.makeToken(.l_brace, start);
            },
            '}' => {
                // Check if this `}` closes a template expression
                if (self.template_depth > 0) {
                    self.template_depth -= 1;
                    self.index += 1;
                    // Resume scanning the template body
                    return self.scanTemplateContent(start, false);
                }
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
