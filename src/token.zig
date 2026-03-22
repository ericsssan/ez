const std = @import("std");

/// JavaScript/ES2024 token types.
pub const Tag = enum(u8) {
    // ── Literals ──────────────────────────────────────────────
    number_literal,
    bigint_literal,
    string_literal,
    template_head, // `...${
    template_middle, // }...${
    template_tail, // }...`
    template_no_sub, // `...` (no interpolation)
    regex_literal,

    // ── Identifier ────────────────────────────────────────────
    identifier,

    // ── Keywords ──────────────────────────────────────────────
    kw_break,
    kw_case,
    kw_catch,
    kw_continue,
    kw_debugger,
    kw_default,
    kw_delete,
    kw_do,
    kw_else,
    kw_export,
    kw_extends,
    kw_finally,
    kw_for,
    kw_function,
    kw_if,
    kw_import,
    kw_in,
    kw_instanceof,
    kw_new,
    kw_return,
    kw_super,
    kw_switch,
    kw_this,
    kw_throw,
    kw_try,
    kw_typeof,
    kw_var,
    kw_void,
    kw_while,
    kw_with,
    kw_yield,
    kw_let,
    kw_const,
    kw_class,
    kw_of,
    kw_async,
    kw_await,
    kw_static,
    kw_get,
    kw_set,
    kw_from,
    kw_as,
    kw_enum,
    kw_null,
    kw_true,
    kw_false,
    kw_target,
    kw_meta,

    // ── Punctuation ───────────────────────────────────────────
    l_paren, // (
    r_paren, // )
    l_brace, // {
    r_brace, // }
    l_bracket, // [
    r_bracket, // ]
    semicolon, // ;
    comma, // ,
    dot, // .
    ellipsis, // ...
    question, // ?
    question_dot, // ?.
    colon, // :
    arrow, // =>
    hash, // #

    // ── Operators ─────────────────────────────────────────────
    plus, // +
    minus, // -
    asterisk, // *
    slash, // /
    percent, // %
    asterisk_asterisk, // **

    ampersand, // &
    pipe, // |
    caret, // ^
    tilde, // ~
    bang, // !

    less_than, // <
    greater_than, // >
    less_less, // <<
    greater_greater, // >>
    greater_greater_greater, // >>>

    // ── Assignment operators ──────────────────────────────────
    equal, // =
    plus_equal, // +=
    minus_equal, // -=
    asterisk_equal, // *=
    slash_equal, // /=
    percent_equal, // %=
    asterisk_asterisk_equal, // **=
    ampersand_equal, // &=
    pipe_equal, // |=
    caret_equal, // ^=
    less_less_equal, // <<=
    greater_greater_equal, // >>=
    greater_greater_greater_equal, // >>>=
    ampersand_ampersand_equal, // &&=
    pipe_pipe_equal, // ||=
    question_question_equal, // ??=

    // ── Comparison/Logical operators ──────────────────────────
    equal_equal, // ==
    bang_equal, // !=
    equal_equal_equal, // ===
    bang_equal_equal, // !==
    less_equal, // <=
    greater_equal, // >=

    ampersand_ampersand, // &&
    pipe_pipe, // ||
    question_question, // ??

    // ── Update operators ──────────────────────────────────────
    plus_plus, // ++
    minus_minus, // --

    // ── Special ───────────────────────────────────────────────
    eof,
    invalid,
    hashbang, // #!...

    /// Returns the keyword text for keyword tags, null otherwise.
    pub fn lexeme(self: Tag) ?[]const u8 {
        return switch (self) {
            .kw_break => "break",
            .kw_case => "case",
            .kw_catch => "catch",
            .kw_continue => "continue",
            .kw_debugger => "debugger",
            .kw_default => "default",
            .kw_delete => "delete",
            .kw_do => "do",
            .kw_else => "else",
            .kw_export => "export",
            .kw_extends => "extends",
            .kw_finally => "finally",
            .kw_for => "for",
            .kw_function => "function",
            .kw_if => "if",
            .kw_import => "import",
            .kw_in => "in",
            .kw_instanceof => "instanceof",
            .kw_new => "new",
            .kw_return => "return",
            .kw_super => "super",
            .kw_switch => "switch",
            .kw_this => "this",
            .kw_throw => "throw",
            .kw_try => "try",
            .kw_typeof => "typeof",
            .kw_var => "var",
            .kw_void => "void",
            .kw_while => "while",
            .kw_with => "with",
            .kw_yield => "yield",
            .kw_let => "let",
            .kw_const => "const",
            .kw_class => "class",
            .kw_of => "of",
            .kw_async => "async",
            .kw_await => "await",
            .kw_static => "static",
            .kw_get => "get",
            .kw_set => "set",
            .kw_from => "from",
            .kw_as => "as",
            .kw_enum => "enum",
            .kw_null => "null",
            .kw_true => "true",
            .kw_false => "false",
            .kw_target => "target",
            .kw_meta => "meta",

            .l_paren => "(",
            .r_paren => ")",
            .l_brace => "{",
            .r_brace => "}",
            .l_bracket => "[",
            .r_bracket => "]",
            .semicolon => ";",
            .comma => ",",
            .dot => ".",
            .ellipsis => "...",
            .question => "?",
            .question_dot => "?.",
            .colon => ":",
            .arrow => "=>",
            .hash => "#",

            .plus => "+",
            .minus => "-",
            .asterisk => "*",
            .slash => "/",
            .percent => "%",
            .asterisk_asterisk => "**",
            .ampersand => "&",
            .pipe => "|",
            .caret => "^",
            .tilde => "~",
            .bang => "!",
            .less_than => "<",
            .greater_than => ">",
            .less_less => "<<",
            .greater_greater => ">>",
            .greater_greater_greater => ">>>",

            .equal => "=",
            .plus_equal => "+=",
            .minus_equal => "-=",
            .asterisk_equal => "*=",
            .slash_equal => "/=",
            .percent_equal => "%=",
            .asterisk_asterisk_equal => "**=",
            .ampersand_equal => "&=",
            .pipe_equal => "|=",
            .caret_equal => "^=",
            .less_less_equal => "<<=",
            .greater_greater_equal => ">>=",
            .greater_greater_greater_equal => ">>>=",
            .ampersand_ampersand_equal => "&&=",
            .pipe_pipe_equal => "||=",
            .question_question_equal => "??=",

            .equal_equal => "==",
            .bang_equal => "!=",
            .equal_equal_equal => "===",
            .bang_equal_equal => "!==",
            .less_equal => "<=",
            .greater_equal => ">=",
            .ampersand_ampersand => "&&",
            .pipe_pipe => "||",
            .question_question => "??",

            .plus_plus => "++",
            .minus_minus => "--",

            .eof => "<eof>",
            .invalid => "<invalid>",

            .number_literal,
            .bigint_literal,
            .string_literal,
            .template_head,
            .template_middle,
            .template_tail,
            .template_no_sub,
            .regex_literal,
            .identifier,
            .hashbang,
            => null,
        };
    }

    /// Returns true if this tag is an assignment operator.
    pub fn isAssignment(self: Tag) bool {
        return switch (self) {
            .equal,
            .plus_equal,
            .minus_equal,
            .asterisk_equal,
            .slash_equal,
            .percent_equal,
            .asterisk_asterisk_equal,
            .ampersand_equal,
            .pipe_equal,
            .caret_equal,
            .less_less_equal,
            .greater_greater_equal,
            .greater_greater_greater_equal,
            .ampersand_ampersand_equal,
            .pipe_pipe_equal,
            .question_question_equal,
            => true,
            else => false,
        };
    }

    /// Returns true if this tag is a keyword.
    pub fn isKeyword(self: Tag) bool {
        return switch (self) {
            .kw_break,
            .kw_case,
            .kw_catch,
            .kw_continue,
            .kw_debugger,
            .kw_default,
            .kw_delete,
            .kw_do,
            .kw_else,
            .kw_export,
            .kw_extends,
            .kw_finally,
            .kw_for,
            .kw_function,
            .kw_if,
            .kw_import,
            .kw_in,
            .kw_instanceof,
            .kw_new,
            .kw_return,
            .kw_super,
            .kw_switch,
            .kw_this,
            .kw_throw,
            .kw_try,
            .kw_typeof,
            .kw_var,
            .kw_void,
            .kw_while,
            .kw_with,
            .kw_yield,
            .kw_let,
            .kw_const,
            .kw_class,
            .kw_of,
            .kw_async,
            .kw_await,
            .kw_static,
            .kw_get,
            .kw_set,
            .kw_from,
            .kw_as,
            .kw_enum,
            .kw_null,
            .kw_true,
            .kw_false,
            .kw_target,
            .kw_meta,
            => true,
            else => false,
        };
    }
};

/// Token with its tag and start position in source.
pub const Token = struct {
    tag: Tag,
    start: u32,
};

/// Keyword lookup map: text -> TokenTag
pub const keywords = std.StaticStringMap(Tag).initComptime(.{
    .{ "break", .kw_break },
    .{ "case", .kw_case },
    .{ "catch", .kw_catch },
    .{ "continue", .kw_continue },
    .{ "debugger", .kw_debugger },
    .{ "default", .kw_default },
    .{ "delete", .kw_delete },
    .{ "do", .kw_do },
    .{ "else", .kw_else },
    .{ "export", .kw_export },
    .{ "extends", .kw_extends },
    .{ "finally", .kw_finally },
    .{ "for", .kw_for },
    .{ "function", .kw_function },
    .{ "if", .kw_if },
    .{ "import", .kw_import },
    .{ "in", .kw_in },
    .{ "instanceof", .kw_instanceof },
    .{ "new", .kw_new },
    .{ "return", .kw_return },
    .{ "super", .kw_super },
    .{ "switch", .kw_switch },
    .{ "this", .kw_this },
    .{ "throw", .kw_throw },
    .{ "try", .kw_try },
    .{ "typeof", .kw_typeof },
    .{ "var", .kw_var },
    .{ "void", .kw_void },
    .{ "while", .kw_while },
    .{ "with", .kw_with },
    .{ "yield", .kw_yield },
    .{ "let", .kw_let },
    .{ "const", .kw_const },
    .{ "class", .kw_class },
    .{ "of", .kw_of },
    .{ "async", .kw_async },
    .{ "await", .kw_await },
    .{ "static", .kw_static },
    .{ "get", .kw_get },
    .{ "set", .kw_set },
    .{ "from", .kw_from },
    .{ "as", .kw_as },
    .{ "enum", .kw_enum },
    .{ "null", .kw_null },
    .{ "true", .kw_true },
    .{ "false", .kw_false },
});

/// Index into token array.
pub const Index = u32;

pub fn isIdentChar(c: u8) bool {
    return switch (c) {
        'a'...'z', 'A'...'Z', '0'...'9', '_', '$' => true,
        else => false,
    };
}

pub fn isNumericChar(c: u8) bool {
    return switch (c) {
        '0'...'9', 'a'...'f', 'A'...'F', 'x', 'X', 'o', 'O', '.', '_', 'n' => true,
        else => false,
    };
}

comptime {
    // Ensure Tag fits in one byte for efficient storage
    std.debug.assert(@sizeOf(Tag) == 1);
}
