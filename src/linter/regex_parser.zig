// Minimal regex AST + parser for lint rules.  Inspired by regexpp's API but
// trimmed to what the no-* regex rules need: alternation, grouping
// (capturing / non-capturing / named / look(ahead|behind) ±), atoms with
// their source ranges, character classes (simple + range, no v-flag set
// ops), quantifiers, and the common escape sequences.  Each node carries
// `start`/`end` byte offsets into the pattern slice it was parsed from.
//
// The parser is intentionally lenient: it never throws on malformed input
// — every unexpected character lowers to a Character atom so callers
// (which mostly care about structural relationships, not full
// validity) keep getting useful tree snapshots.  When a true syntax
// error needs to be surfaced, callers can re-validate via no-invalid-regexp.

const std = @import("std");

pub const Span = struct {
    start: u32,
    end: u32,
};

pub const Flags = struct {
    unicode: bool = false, // u
    unicode_sets: bool = false, // v
    ignore_case: bool = false, // i
    multiline: bool = false, // m
    sticky: bool = false, // y
    global: bool = false, // g
    dot_all: bool = false, // s
    has_indices: bool = false, // d

    pub fn fromString(s: []const u8) Flags {
        var f: Flags = .{};
        for (s) |c| switch (c) {
            'u' => f.unicode = true,
            'v' => f.unicode_sets = true,
            'i' => f.ignore_case = true,
            'm' => f.multiline = true,
            'y' => f.sticky = true,
            'g' => f.global = true,
            's' => f.dot_all = true,
            'd' => f.has_indices = true,
            else => {},
        };
        return f;
    }
};

pub const Pattern = struct {
    alternatives: []Alternative,
    /// Capturing groups in source order (1-indexed via [n - 1]).
    groups: []*Group,
    /// All backreferences in source order — useful for rules that visit
    /// references and look up the target group by index or name.
    backrefs: []*Backreference,
    flags: Flags,
    start: u32,
    end: u32,
};

pub const Alternative = struct {
    terms: []Term,
    start: u32,
    end: u32,
};

pub const Term = struct {
    atom: Atom,
    quantifier: ?Quantifier,
    start: u32,
    end: u32,
};

pub const Quantifier = struct {
    min: u32,
    max: u32, // std.math.maxInt(u32) means unbounded
    greedy: bool,
};

pub const AtomKind = enum {
    character,
    char_set, // \d, \w, \s, \D, \W, \S, .
    char_class,
    group,
    assertion, // ^, $, \b, \B, lookahead/lookbehind
    backref,
    quoted_string_disjunction, // \q{...} (v-flag) — opaque placeholder
};

pub const Atom = union(AtomKind) {
    character: Character,
    char_set: CharSet,
    char_class: *CharacterClass,
    group: *Group,
    assertion: Assertion,
    backref: *Backreference,
    quoted_string_disjunction: Span,
};

pub const Character = struct {
    /// Decoded codepoint.  Anything we can't reduce to a single codepoint
    /// (e.g. `\d` shorthand) is exposed via CharSet instead.
    codepoint: u32,
    start: u32,
    end: u32,
};

pub const CharSetKind = enum {
    any, // .
    digit, // \d
    non_digit, // \D
    word, // \w
    non_word, // \W
    space, // \s
    non_space, // \S
    unicode_prop, // \p{...} or \P{...}
};

pub const CharSet = struct {
    kind: CharSetKind,
    /// For unicode_prop, the raw text between the braces — left as a slice
    /// so callers can decide whether to interpret.
    prop_name: ?[]const u8 = null,
    negated: bool = false,
    start: u32,
    end: u32,
};

pub const CharacterClass = struct {
    negated: bool,
    elements: []ClassElement,
    start: u32,
    end: u32,
};

pub const ClassElement = union(enum) {
    character: Character,
    range: ClassRange,
    char_set: CharSet,
    nested: *CharacterClass, // v-flag only
};

pub const ClassRange = struct {
    min: Character,
    max: Character,
    start: u32,
    end: u32,
};

pub const GroupKind = enum {
    capturing,
    non_capturing,
    named,
    lookahead,
    neg_lookahead,
    lookbehind,
    neg_lookbehind,
};

pub const Group = struct {
    kind: GroupKind,
    /// 1-based index for capturing/named groups, else 0.
    index: u32 = 0,
    /// Slice into the pattern source for named groups (the identifier).
    name: ?[]const u8 = null,
    alternatives: []Alternative,
    start: u32,
    end: u32,
};

pub const AssertionKind = enum {
    line_start, // ^
    line_end, // $
    word_boundary, // \b
    non_word_boundary, // \B
    // lookarounds are modelled as Group atoms with the matching GroupKind
    // — separating them here would mean two ways to represent the same
    // construct, and rules want the inner alternatives anyway.
};

pub const Assertion = struct {
    kind: AssertionKind,
    start: u32,
    end: u32,
};

pub const Backreference = struct {
    /// Reference target.  `index = 0` means we couldn't resolve a target
    /// (e.g. forward reference at parse time before the group exists, or a
    /// named reference that doesn't bind to a group); callers handle the
    /// resolution themselves.
    target: union(enum) {
        index: u32,
        name: []const u8,
    },
    /// Resolved group pointer once parsing completes; null when the
    /// referenced group doesn't exist in the pattern.
    resolved: ?*Group = null,
    start: u32,
    end: u32,
};

// ── Parser ────────────────────────────────────────────────

pub const ParseOptions = struct {
    flags: Flags = .{},
};

/// Top-level entry point.  Allocates the entire AST in `arena` and returns
/// a Pattern node owned by the caller (via the arena).
pub fn parse(arena: std.mem.Allocator, pattern: []const u8, opts: ParseOptions) !Pattern {
    var p = Parser{
        .arena = arena,
        .src = pattern,
        .pos = 0,
        .flags = opts.flags,
        .groups = .empty,
        .backrefs = .empty,
        .group_index_counter = 0,
    };
    const alts = try p.parseAlternatives(0, .top);
    // Resolve backreferences now that all groups are known.
    for (p.backrefs.items) |br| {
        switch (br.target) {
            .index => |idx| {
                if (idx > 0 and idx <= p.groups.items.len) {
                    br.resolved = p.groups.items[idx - 1];
                }
            },
            .name => |n| {
                for (p.groups.items) |g| {
                    if (g.name) |gname| if (std.mem.eql(u8, gname, n)) {
                        br.resolved = g;
                        break;
                    };
                }
            },
        }
    }
    return Pattern{
        .alternatives = alts,
        .groups = try p.groups.toOwnedSlice(arena),
        .backrefs = try p.backrefs.toOwnedSlice(arena),
        .flags = opts.flags,
        .start = 0,
        .end = @intCast(pattern.len),
    };
}

const ParseContext = enum { top, group };

const Parser = struct {
    arena: std.mem.Allocator,
    src: []const u8,
    pos: u32,
    flags: Flags,
    groups: std.ArrayList(*Group),
    backrefs: std.ArrayList(*Backreference),
    group_index_counter: u32,

    fn peek(self: *Parser) ?u8 {
        if (self.pos >= self.src.len) return null;
        return self.src[self.pos];
    }

    fn advance(self: *Parser) ?u8 {
        const c = self.peek() orelse return null;
        self.pos += 1;
        return c;
    }

    fn consume(self: *Parser, c: u8) bool {
        if (self.peek() == c) {
            self.pos += 1;
            return true;
        }
        return false;
    }

    fn parseAlternatives(self: *Parser, start: u32, ctx: ParseContext) std.mem.Allocator.Error![]Alternative {
        var alts: std.ArrayList(Alternative) = .empty;
        const alt0_start = self.pos;
        var alt_terms = try self.parseTerms(ctx);
        try alts.append(self.arena, .{
            .terms = alt_terms,
            .start = alt0_start,
            .end = self.pos,
        });
        while (self.peek() == '|') {
            self.pos += 1;
            const next_start = self.pos;
            alt_terms = try self.parseTerms(ctx);
            try alts.append(self.arena, .{
                .terms = alt_terms,
                .start = next_start,
                .end = self.pos,
            });
        }
        _ = start;
        return alts.toOwnedSlice(self.arena);
    }

    fn parseTerms(self: *Parser, ctx: ParseContext) ![]Term {
        var terms: std.ArrayList(Term) = .empty;
        while (self.peek()) |c| {
            if (c == '|') break;
            if (ctx == .group and c == ')') break;
            const term = (try self.parseTerm()) orelse break;
            try terms.append(self.arena, term);
        }
        return terms.toOwnedSlice(self.arena);
    }

    fn parseTerm(self: *Parser) !?Term {
        const start = self.pos;
        const atom_opt = try self.parseAtom();
        if (atom_opt) |atom| {
            const after_atom = self.pos;
            const quant = try self.parseQuantifier();
            return Term{
                .atom = atom,
                .quantifier = quant,
                .start = start,
                .end = if (quant != null) self.pos else after_atom,
            };
        }
        return null;
    }

    fn parseAtom(self: *Parser) !?Atom {
        const c = self.peek() orelse return null;
        // Anchors / assertions
        if (c == '^') {
            const s = self.pos;
            self.pos += 1;
            return Atom{ .assertion = .{ .kind = .line_start, .start = s, .end = self.pos } };
        }
        if (c == '$') {
            const s = self.pos;
            self.pos += 1;
            return Atom{ .assertion = .{ .kind = .line_end, .start = s, .end = self.pos } };
        }
        if (c == '.') {
            const s = self.pos;
            self.pos += 1;
            return Atom{ .char_set = .{ .kind = .any, .start = s, .end = self.pos } };
        }
        if (c == '(') return try self.parseGroup();
        if (c == '[') return try self.parseCharClass();
        if (c == '\\') return try self.parseEscape();
        // Closing `)` or `]` or quantifier chars at the start of a term: bail.
        if (c == ')' or c == ']' or c == '|') return null;
        if (c == '*' or c == '+' or c == '?' or c == '{') {
            // Dangling quantifier — emit as a literal char rather than failing
            // (lenient mode); no-invalid-regexp will catch real errors.
            const s = self.pos;
            self.pos += 1;
            return Atom{ .character = .{ .codepoint = c, .start = s, .end = self.pos } };
        }
        // Literal character — decode UTF-8 to keep codepoint width correct.
        const s = self.pos;
        const cp_info = decodeUtf8At(self.src, self.pos);
        self.pos += cp_info.len;
        return Atom{ .character = .{ .codepoint = cp_info.codepoint, .start = s, .end = self.pos } };
    }

    fn parseQuantifier(self: *Parser) !?Quantifier {
        const c = self.peek() orelse return null;
        var min: u32 = 0;
        var max: u32 = 0;
        const greedy_default = true;
        switch (c) {
            '*' => { self.pos += 1; min = 0; max = std.math.maxInt(u32); },
            '+' => { self.pos += 1; min = 1; max = std.math.maxInt(u32); },
            '?' => { self.pos += 1; min = 0; max = 1; },
            '{' => {
                // {N}, {N,}, {N,M} — lenient: bail on malformed forms
                // (return null so the `{` becomes a literal char in an
                // earlier atom).  This branch only fires when the previous
                // atom consumed a real character; if {N..} doesn't parse,
                // we leave `{` for the next term.
                const save = self.pos;
                self.pos += 1;
                if (!readUInt(self, &min)) { self.pos = save; return null; }
                if (self.consume('}')) {
                    max = min;
                } else if (self.consume(',')) {
                    if (self.consume('}')) {
                        max = std.math.maxInt(u32);
                    } else {
                        if (!readUInt(self, &max)) { self.pos = save; return null; }
                        if (!self.consume('}')) { self.pos = save; return null; }
                    }
                } else {
                    self.pos = save;
                    return null;
                }
            },
            else => return null,
        }
        var greedy = greedy_default;
        if (self.peek() == '?') {
            self.pos += 1;
            greedy = false;
        }
        return Quantifier{ .min = min, .max = max, .greedy = greedy };
    }

    fn parseGroup(self: *Parser) !?Atom {
        const start = self.pos;
        std.debug.assert(self.src[self.pos] == '(');
        self.pos += 1;
        var kind: GroupKind = .capturing;
        var name: ?[]const u8 = null;
        if (self.consume('?')) {
            const k_opt = self.peek();
            if (k_opt == null) {
                kind = .non_capturing;
            } else switch (k_opt.?) {
                ':' => { self.pos += 1; kind = .non_capturing; },
                '=' => { self.pos += 1; kind = .lookahead; },
                '!' => { self.pos += 1; kind = .neg_lookahead; },
                '<' => {
                    self.pos += 1;
                    const after_lt = self.peek() orelse 0;
                    if (after_lt == '=') { self.pos += 1; kind = .lookbehind; }
                    else if (after_lt == '!') { self.pos += 1; kind = .neg_lookbehind; }
                    else {
                        kind = .named;
                        name = readIdentName(self);
                        _ = self.consume('>');
                    }
                },
                else => {
                    // Modifier or unrecognised — eat until `:` or `)` and
                    // treat as non-capturing.
                    while (self.peek()) |x| {
                        self.pos += 1;
                        if (x == ':' or x == ')') break;
                    }
                    kind = .non_capturing;
                },
            }
        }
        var index: u32 = 0;
        if (kind == .capturing or kind == .named) {
            self.group_index_counter += 1;
            index = self.group_index_counter;
        }
        const group_ptr = try self.arena.create(Group);
        group_ptr.* = .{
            .kind = kind,
            .index = index,
            .name = name,
            .alternatives = &.{},
            .start = start,
            .end = start,
        };
        if (kind == .capturing or kind == .named) {
            try self.groups.append(self.arena, group_ptr);
        }
        group_ptr.alternatives = try self.parseAlternatives(self.pos, .group);
        _ = self.consume(')');
        group_ptr.end = self.pos;
        return Atom{ .group = group_ptr };
    }

    fn parseEscape(self: *Parser) !?Atom {
        const start = self.pos;
        std.debug.assert(self.src[self.pos] == '\\');
        self.pos += 1;
        const c = self.peek() orelse {
            // Lone trailing `\` — emit as literal.
            return Atom{ .character = .{ .codepoint = '\\', .start = start, .end = self.pos } };
        };
        // Character classes via shorthand.
        const shorthand: ?CharSet = switch (c) {
            'd' => .{ .kind = .digit,     .start = start, .end = start + 2 },
            'D' => .{ .kind = .non_digit, .start = start, .end = start + 2 },
            'w' => .{ .kind = .word,      .start = start, .end = start + 2 },
            'W' => .{ .kind = .non_word,  .start = start, .end = start + 2 },
            's' => .{ .kind = .space,     .start = start, .end = start + 2 },
            'S' => .{ .kind = .non_space, .start = start, .end = start + 2 },
            else => null,
        };
        if (shorthand) |cs| { self.pos += 1; return Atom{ .char_set = cs }; }
        // Assertions
        if (c == 'b') { self.pos += 1; return Atom{ .assertion = .{ .kind = .word_boundary, .start = start, .end = self.pos } }; }
        if (c == 'B') { self.pos += 1; return Atom{ .assertion = .{ .kind = .non_word_boundary, .start = start, .end = self.pos } }; }
        // Backref by number — `\N` where N is one or more digits, and the
        // first digit is 1-9 (a leading 0 is an octal escape, not a backref).
        if (c >= '1' and c <= '9') {
            var n: u32 = 0;
            while (self.peek()) |d| {
                if (d < '0' or d > '9') break;
                n = n * 10 + (d - '0');
                self.pos += 1;
            }
            const br = try self.arena.create(Backreference);
            br.* = .{ .target = .{ .index = n }, .start = start, .end = self.pos };
            try self.backrefs.append(self.arena, br);
            return Atom{ .backref = br };
        }
        // Named backref `\k<name>`
        if (c == 'k' and self.pos + 1 < self.src.len and self.src[self.pos + 1] == '<') {
            self.pos += 2; // skip `k<`
            const name = readIdentName(self);
            _ = self.consume('>');
            const br = try self.arena.create(Backreference);
            br.* = .{ .target = .{ .name = name }, .start = start, .end = self.pos };
            try self.backrefs.append(self.arena, br);
            return Atom{ .backref = br };
        }
        // Hex/unicode escapes → Character
        if (c == 'x') {
            self.pos += 1;
            if (self.pos + 2 <= self.src.len) {
                const cp = parseHexFixed(self.src[self.pos .. self.pos + 2]) orelse 'x';
                self.pos += 2;
                return Atom{ .character = .{ .codepoint = cp, .start = start, .end = self.pos } };
            }
            return Atom{ .character = .{ .codepoint = 'x', .start = start, .end = self.pos } };
        }
        if (c == 'u') {
            self.pos += 1;
            if (self.peek() == '{' and self.flags.unicode or self.flags.unicode_sets) {
                self.pos += 1;
                var cp: u32 = 0;
                while (self.peek()) |d| {
                    const v = hexDigit(d) orelse break;
                    cp = (cp << 4) | v;
                    self.pos += 1;
                }
                _ = self.consume('}');
                return Atom{ .character = .{ .codepoint = cp, .start = start, .end = self.pos } };
            }
            if (self.pos + 4 <= self.src.len) {
                const cp = parseHexFixed(self.src[self.pos .. self.pos + 4]) orelse 'u';
                self.pos += 4;
                return Atom{ .character = .{ .codepoint = cp, .start = start, .end = self.pos } };
            }
            return Atom{ .character = .{ .codepoint = 'u', .start = start, .end = self.pos } };
        }
        // Unicode property escape (treated as opaque CharSet under u/v).
        if ((c == 'p' or c == 'P') and self.flags.unicode or self.flags.unicode_sets) {
            const negated = c == 'P';
            self.pos += 1;
            if (self.consume('{')) {
                const name_start = self.pos;
                while (self.peek()) |x| {
                    if (x == '}') break;
                    self.pos += 1;
                }
                const name = self.src[name_start..self.pos];
                _ = self.consume('}');
                return Atom{ .char_set = .{
                    .kind = .unicode_prop,
                    .prop_name = name,
                    .negated = negated,
                    .start = start,
                    .end = self.pos,
                } };
            }
        }
        // Default: consume the next code unit and treat as a literal char.
        const cp_info = decodeUtf8At(self.src, self.pos);
        self.pos += cp_info.len;
        return Atom{ .character = .{ .codepoint = cp_info.codepoint, .start = start, .end = self.pos } };
    }

    fn parseCharClass(self: *Parser) std.mem.Allocator.Error!?Atom {
        const start = self.pos;
        std.debug.assert(self.src[self.pos] == '[');
        self.pos += 1;
        var negated = false;
        if (self.consume('^')) negated = true;
        var elements: std.ArrayList(ClassElement) = .empty;
        while (self.peek()) |c| {
            if (c == ']') break;
            const elem = try self.parseClassElement();
            try elements.append(self.arena, elem);
        }
        _ = self.consume(']');
        const cc = try self.arena.create(CharacterClass);
        cc.* = .{
            .negated = negated,
            .elements = try elements.toOwnedSlice(self.arena),
            .start = start,
            .end = self.pos,
        };
        return Atom{ .char_class = cc };
    }

    fn parseClassElement(self: *Parser) !ClassElement {
        const first = try self.parseClassAtom();
        // Look for `-` range, but only when followed by another class atom
        // (not `]`).
        if (self.peek() == '-' and self.pos + 1 < self.src.len and self.src[self.pos + 1] != ']') {
            self.pos += 1; // consume '-'
            // Only Character-on-both-sides forms a range; any other shape
            // (e.g. shorthand class on a side) means `-` is literal.
            if (first == .character) {
                const second = try self.parseClassAtom();
                if (second == .character) {
                    return ClassElement{ .range = .{
                        .min = first.character,
                        .max = second.character,
                        .start = first.character.start,
                        .end = second.character.end,
                    } };
                }
                // Wrong shape — return the second atom; the leading `-`
                // gets dropped (rare edge; rules don't depend on it).
                return second;
            }
        }
        return first;
    }

    fn parseClassAtom(self: *Parser) !ClassElement {
        const c = self.peek() orelse return ClassElement{ .character = .{ .codepoint = 0, .start = self.pos, .end = self.pos } };
        if (c == '\\') {
            // Inside a class, escape forms differ subtly (no anchors, no
            // backrefs).  Delegate to parseEscape; if it returns a backref
            // or assertion, demote to a literal char to stay safe.
            const atom_opt = try self.parseEscape();
            if (atom_opt) |atom| switch (atom) {
                .character => |ch| return ClassElement{ .character = ch },
                .char_set => |cs| return ClassElement{ .char_set = cs },
                else => {
                    // Demote: rebuild a Character from the source range.
                    const sp = switch (atom) {
                        .group => |g| Span{ .start = g.start, .end = g.end },
                        .backref => |b| Span{ .start = b.start, .end = b.end },
                        .assertion => |a| Span{ .start = a.start, .end = a.end },
                        else => Span{ .start = self.pos, .end = self.pos },
                    };
                    return ClassElement{ .character = .{
                        .codepoint = if (sp.start + 1 < self.src.len) self.src[sp.start + 1] else 0,
                        .start = sp.start,
                        .end = sp.end,
                    } };
                },
            };
        }
        // v-flag nested class
        if (c == '[' and self.flags.unicode_sets) {
            const nested_atom = try self.parseCharClass();
            if (nested_atom) |atom| switch (atom) {
                .char_class => |cc| return ClassElement{ .nested = cc },
                else => {},
            };
        }
        const s = self.pos;
        const cp_info = decodeUtf8At(self.src, self.pos);
        self.pos += cp_info.len;
        return ClassElement{ .character = .{ .codepoint = cp_info.codepoint, .start = s, .end = self.pos } };
    }
};

// ── Helpers ──────────────────────────────────────────────

const Utf8Info = struct { codepoint: u32, len: u32 };

fn decodeUtf8At(src: []const u8, pos: u32) Utf8Info {
    if (pos >= src.len) return .{ .codepoint = 0, .len = 0 };
    const b0 = src[pos];
    if (b0 < 0x80) return .{ .codepoint = b0, .len = 1 };
    var len: u32 = 1;
    if ((b0 & 0xE0) == 0xC0) {
        len = 2;
    } else if ((b0 & 0xF0) == 0xE0) {
        len = 3;
    } else if ((b0 & 0xF8) == 0xF0) {
        len = 4;
    }
    if (pos + len > src.len) return .{ .codepoint = b0, .len = 1 };
    const decoded = std.unicode.utf8Decode(src[pos .. pos + len]) catch return .{ .codepoint = b0, .len = 1 };
    return .{ .codepoint = decoded, .len = len };
}

fn hexDigit(c: u8) ?u32 {
    return switch (c) {
        '0'...'9' => c - '0',
        'a'...'f' => c - 'a' + 10,
        'A'...'F' => c - 'A' + 10,
        else => null,
    };
}

fn parseHexFixed(s: []const u8) ?u32 {
    var v: u32 = 0;
    for (s) |c| {
        const d = hexDigit(c) orelse return null;
        v = (v << 4) | d;
    }
    return v;
}

fn readUInt(p: *Parser, out: *u32) bool {
    var v: u32 = 0;
    var any = false;
    while (p.peek()) |c| {
        if (c < '0' or c > '9') break;
        v = v * 10 + (c - '0');
        p.pos += 1;
        any = true;
    }
    if (!any) return false;
    out.* = v;
    return true;
}

fn readIdentName(p: *Parser) []const u8 {
    const start = p.pos;
    while (p.peek()) |c| {
        if (c == '>' or c == ')') break;
        if (c < 0x20) break;
        p.pos += 1;
    }
    return p.src[start..p.pos];
}

// ── Useless-backreference analysis ────────────────────────

pub const UselessKind = enum {
    nested,
    forward,
    backward,
    disjunctive,
    into_negative_lookaround,
};

pub const UselessBackref = struct {
    bref: *Backreference,
    group: *Group,
    kind: UselessKind,
};

/// Walk `pat` and report every backreference that can never match.
/// Mirrors ESLint's no-useless-backreference algorithm; see the rule for
/// the original (`tests/conformance/eslint/lib/rules/no-useless-backreference.js`).
pub fn analyzeUselessBackrefs(arena: std.mem.Allocator, pat: *const Pattern) ![]UselessBackref {
    var group_paths = std.AutoHashMapUnmanaged(*Group, []PathEntry).empty;
    var bref_paths = std.AutoHashMapUnmanaged(*Backreference, []PathEntry).empty;
    defer group_paths.deinit(arena);
    defer bref_paths.deinit(arena);
    var stack: std.ArrayList(PathEntry) = .empty;
    try walkAlternatives(arena, pat.alternatives, &stack, &group_paths, &bref_paths);
    var out: std.ArrayList(UselessBackref) = .empty;
    for (pat.backrefs) |bref| {
        const grp = bref.resolved orelse continue;
        const bp = bref_paths.get(bref) orelse continue;
        const gp = group_paths.get(grp) orelse continue;
        if (classifyBackref(bref, grp, bp, gp)) |kind| {
            try out.append(arena, .{ .bref = bref, .group = grp, .kind = kind });
        }
    }
    return out.toOwnedSlice(arena);
}

pub const PathEntry = struct {
    /// Either points to a Group or an Alternative — exactly one is non-null.
    group: ?*Group = null,
    alt: ?*Alternative = null,
};

fn walkAlternatives(
    arena: std.mem.Allocator,
    alts: []Alternative,
    stack: *std.ArrayList(PathEntry),
    group_paths: *std.AutoHashMapUnmanaged(*Group, []PathEntry),
    bref_paths: *std.AutoHashMapUnmanaged(*Backreference, []PathEntry),
) std.mem.Allocator.Error!void {
    for (alts) |*alt| {
        try stack.append(arena, .{ .alt = alt });
        for (alt.terms) |t| {
            switch (t.atom) {
                .group => |g| {
                    // Record this group's path (snapshot of the stack as
                    // it stood when the parent CONTAINED the group; i.e.
                    // exclude the group itself).
                    try group_paths.put(arena, g, try arena.dupe(PathEntry, stack.items));
                    try stack.append(arena, .{ .group = g });
                    try walkAlternatives(arena, g.alternatives, stack, group_paths, bref_paths);
                    _ = stack.pop();
                },
                .backref => |br| {
                    try bref_paths.put(arena, br, try arena.dupe(PathEntry, stack.items));
                },
                .char_class => |cc| {
                    // Char classes don't contain groups or backrefs (in our
                    // model), but we'd still need to recurse for v-flag
                    // nesting — no rules need that yet.
                    _ = cc;
                },
                else => {},
            }
        }
        _ = stack.pop();
    }
}

fn classifyBackref(
    bref: *Backreference,
    grp: *Group,
    brefPath: []const PathEntry,
    groupPath: []const PathEntry,
) ?UselessKind {
    // Nested: group appears in bref's ancestor chain.
    for (brefPath) |e| {
        if (e.group != null and e.group.? == grp) return .nested;
    }
    // Find LCA index in both paths (count how many leading entries match).
    // Paths share a common prefix; we want the last matching pair.
    var lca: usize = 0;
    while (lca < brefPath.len and lca < groupPath.len) : (lca += 1) {
        const a = brefPath[lca];
        const b = groupPath[lca];
        const same =
            (a.group != null and b.group != null and a.group.? == b.group.?) or
            (a.alt != null and b.alt != null and a.alt.? == b.alt.?);
        if (!same) break;
    }
    // groupCut: groupPath[lca..]
    const group_cut = groupPath[lca..];
    // First entry past the LCA on the group side; if it's an alternative
    // then the backref and group sit in different alternatives of the
    // same group (disjunctive).
    if (group_cut.len > 0 and group_cut[0].alt != null) {
        return .disjunctive;
    }
    // Lowest common ancestor lookaround (walk back UP through the common
    // prefix looking for a lookaround group).
    var lookaround_kind: ?GroupKind = null;
    var i: usize = lca;
    while (i > 0) {
        i -= 1;
        const e = brefPath[i];
        if (e.group) |g| switch (g.kind) {
            .lookahead, .neg_lookahead, .lookbehind, .neg_lookbehind => {
                lookaround_kind = g.kind;
                break;
            },
            else => {},
        };
    }
    const is_backward = lookaround_kind != null and
        (lookaround_kind.? == .lookbehind or lookaround_kind.? == .neg_lookbehind);
    if (!is_backward and bref.end <= grp.start) return .forward;
    if (is_backward and grp.end <= bref.start) return .backward;
    // groupCut contains a negative lookaround.
    for (group_cut) |e| {
        if (e.group) |g| switch (g.kind) {
            .neg_lookahead, .neg_lookbehind => return .into_negative_lookaround,
            else => {},
        };
    }
    return null;
}

// ── Tests ────────────────────────────────────────────────

const testing = std.testing;

test "simple capturing group + backref" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const pat = try parse(arena_state.allocator(), "(a)\\1", .{});
    try testing.expectEqual(@as(usize, 1), pat.groups.len);
    try testing.expectEqual(@as(usize, 1), pat.backrefs.len);
    try testing.expectEqual(@as(u32, 1), pat.groups[0].index);
    switch (pat.backrefs[0].target) {
        .index => |i| try testing.expectEqual(@as(u32, 1), i),
        .name => unreachable,
    }
    try testing.expect(pat.backrefs[0].resolved != null);
    try testing.expectEqual(pat.groups[0], pat.backrefs[0].resolved.?);
}

test "forward reference unresolved targets nonexistent group" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const pat = try parse(arena_state.allocator(), "\\2(a)", .{});
    try testing.expectEqual(@as(usize, 1), pat.groups.len);
    try testing.expectEqual(@as(usize, 1), pat.backrefs.len);
    // \2 with only one group: resolved should be null.
    try testing.expect(pat.backrefs[0].resolved == null);
}

test "named group + named backref" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const pat = try parse(arena_state.allocator(), "(?<foo>a)\\k<foo>", .{});
    try testing.expectEqual(@as(usize, 1), pat.groups.len);
    try testing.expect(pat.groups[0].name != null);
    try testing.expectEqualStrings("foo", pat.groups[0].name.?);
    try testing.expectEqual(@as(usize, 1), pat.backrefs.len);
    try testing.expect(pat.backrefs[0].resolved != null);
}

test "character class with range" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const pat = try parse(arena_state.allocator(), "[a-z0-9]", .{});
    try testing.expectEqual(@as(usize, 1), pat.alternatives.len);
    const terms = pat.alternatives[0].terms;
    try testing.expectEqual(@as(usize, 1), terms.len);
    const cc = terms[0].atom.char_class;
    try testing.expectEqual(@as(usize, 2), cc.elements.len);
    try testing.expect(cc.elements[0] == .range);
    try testing.expect(cc.elements[1] == .range);
}

test "useless backref: forward, nested, disjunctive, intoNegativeLookaround, backward" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const cases = [_]struct { src: []const u8, expected: UselessKind }{
        .{ .src = "\\1(a)", .expected = .forward },
        .{ .src = "(\\1a)", .expected = .nested },
        .{ .src = "(a)|\\1", .expected = .disjunctive },
        .{ .src = "(?!(a))\\1", .expected = .into_negative_lookaround },
        .{ .src = "(?<=(a)\\1)", .expected = .backward },
    };
    for (cases) |c| {
        const pat = try parse(arena, c.src, .{});
        const problems = try analyzeUselessBackrefs(arena, &pat);
        try testing.expectEqual(@as(usize, 1), problems.len);
        try testing.expectEqual(c.expected, problems[0].kind);
    }
}

test "alternation in lookahead" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const pat = try parse(arena_state.allocator(), "(?=a|b)", .{});
    const terms = pat.alternatives[0].terms;
    try testing.expectEqual(@as(usize, 1), terms.len);
    const g = terms[0].atom.group;
    try testing.expectEqual(GroupKind.lookahead, g.kind);
    try testing.expectEqual(@as(usize, 2), g.alternatives.len);
}
