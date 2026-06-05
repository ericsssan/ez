//! JSDoc comment parser — comment-parser-compatible, structured binary output.
//!
//! Mirrors the 4-stage pipeline of npm `comment-parser` (which `@es-joy/jsdoccomment`
//! wraps). Output is a `Block` struct populated from arena-allocated slices into the
//! original comment text. A separate serializer writes it as packed binary records
//! that the JS side reads directly without JSON.parse.
//!
//! Pipeline:
//!   1. source-parser:  raw text → Line[]   (start/delimiter/postDelimiter/end/description per line)
//!   2. block-parser:   Line[]   → Section[]  (description section + per-@tag sections)
//!   3. spec-parser:    Section  → Tag        (extract tag/type/name from tag section, mutate its lines)
//!   4. assemble:       Section[] → Block

const std = @import("std");

pub const Tokens = struct {
    start: []const u8 = "",
    delimiter: []const u8 = "",
    post_delimiter: []const u8 = "",
    tag: []const u8 = "",
    post_tag: []const u8 = "",
    name: []const u8 = "",
    post_name: []const u8 = "",
    type: []const u8 = "",
    post_type: []const u8 = "",
    description: []const u8 = "",
    end: []const u8 = "",
    line_end: []const u8 = "",
};

pub const Line = struct {
    number: u32,
    source: []const u8,
    tokens: Tokens,
};

pub const Problem = struct {
    code: []const u8,
    message: []const u8,
    line: u32,
    critical: u8,
};

pub const Tag = struct {
    tag: []const u8,
    name: []const u8 = "",
    type: []const u8 = "",
    description: []const u8 = "",
    default: []const u8 = "",
    optional: bool = false,
    has_default: bool = false,
    source: []Line = &.{},
    problems: []Problem = &.{},
};

pub const Block = struct {
    description: []const u8 = "",
    tags: []Tag = &.{},
    source: []Line = &.{},
    problems: []Problem = &.{},
};

// ── Helpers ────────────────────────────────────────────────────────────────

inline fn isSpace(c: u8) bool {
    return c == ' ' or c == '\t';
}

inline fn isWS(c: u8) bool {
    return c == ' ' or c == '\t' or c == '\r' or c == '\n';
}

fn trimLeft(s: []const u8) []const u8 {
    var i: usize = 0;
    while (i < s.len and isSpace(s[i])) i += 1;
    return s[i..];
}

fn trimRight(s: []const u8) []const u8 {
    var i = s.len;
    while (i > 0 and isSpace(s[i - 1])) i -= 1;
    return s[0..i];
}

fn trim(s: []const u8) []const u8 {
    return trimRight(trimLeft(s));
}

// Trim ALL whitespace including \n / \r — used for cross-line description aggregation.
fn trimWS(s: []const u8) []const u8 {
    var i: usize = 0;
    while (i < s.len and isWS(s[i])) i += 1;
    var j = s.len;
    while (j > i and isWS(s[j - 1])) j -= 1;
    return s[i..j];
}

fn countLeadingSpace(s: []const u8) usize {
    var i: usize = 0;
    while (i < s.len and isSpace(s[i])) i += 1;
    return i;
}

// noTypes / noNames: tag classes whose spec-parser skips type/name extraction.
fn isNoTypesTag(tag: []const u8) bool {
    const list = [_][]const u8{
        "default", "defaultvalue", "description", "example",
        "file",    "fileoverview", "license",     "overview",
        "see",     "summary",
    };
    for (list) |t| if (std.mem.eql(u8, tag, t)) return true;
    return false;
}

fn isNoNamesTag(tag: []const u8) bool {
    const list = [_][]const u8{
        "access",   "author",  "default",  "defaultvalue", "description",
        "example",  "exception", "file",   "fileoverview",  "kind",
        "license",  "overview", "return",  "returns",      "since",
        "summary",  "throws",   "version", "variation",
    };
    for (list) |t| if (std.mem.eql(u8, tag, t)) return true;
    return false;
}

// ── Stage 1: source-parser ────────────────────────────────────────────────
// Splits raw `/** ... */` text into Lines with start/delimiter/postDelimiter
// and description fields filled. tag/type/name remain empty (filled by spec-parser).

fn splitLinesAlloc(allocator: std.mem.Allocator, text: []const u8) ![][]const u8 {
    var list = std.ArrayListUnmanaged([]const u8).empty;
    errdefer list.deinit(allocator);
    var i: usize = 0;
    var line_start: usize = 0;
    while (i < text.len) : (i += 1) {
        if (text[i] == '\n') {
            // strip trailing \r if CRLF
            const end = if (i > line_start and text[i - 1] == '\r') i - 1 else i;
            try list.append(allocator, text[line_start..end]);
            line_start = i + 1;
        }
    }
    if (line_start <= text.len) {
        try list.append(allocator, text[line_start..text.len]);
    }
    return list.toOwnedSlice(allocator);
}

/// Parse the raw comment text into Line[] with source-level tokens filled.
fn sourceParse(allocator: std.mem.Allocator, text: []const u8) ![]Line {
    const raw_lines = try splitLinesAlloc(allocator, text);
    defer allocator.free(raw_lines);

    var out = try allocator.alloc(Line, raw_lines.len);
    var seen_open: bool = false;
    var seen_close: bool = false;

    for (raw_lines, 0..) |raw, idx| {
        var ln: Line = .{ .number = @intCast(idx), .source = raw, .tokens = .{} };

        // Compute start = leading whitespace
        const lead = countLeadingSpace(raw);
        ln.tokens.start = raw[0..lead];
        var rest = raw[lead..];

        // Identify delimiter:
        //  - `/**` opens the block (only on first line)
        //  - `*` continues the block
        //  - `*/` closes (followed possibly by lineEnd)
        if (!seen_open and std.mem.startsWith(u8, rest, "/**")) {
            seen_open = true;
            // delimiter is /** plus any extra * (e.g. /***)
            var d_end: usize = 3;
            while (d_end < rest.len and rest[d_end] == '*') d_end += 1;
            ln.tokens.delimiter = rest[0..d_end];
            rest = rest[d_end..];

            // Possible single-line: /** ... */
            if (std.mem.endsWith(u8, rest, "*/")) {
                seen_close = true;
                rest = rest[0 .. rest.len - 2];
                ln.tokens.end = "*/";
            }
        } else if (std.mem.endsWith(u8, rest, "*/") and !seen_close) {
            // closing-only line: ` */` or ` * something */`
            seen_close = true;
            // strip end
            const stripped = rest[0 .. rest.len - 2];
            // If line is just `*/` with optional `*` prefix, treat as pure closing.
            const before_close = trimRight(stripped);
            if (before_close.len > 0 and before_close[before_close.len - 1] == '*') {
                // ` * ... */` shape — delimiter = `*`, description before it
                ln.tokens.delimiter = before_close[before_close.len - 1 .. before_close.len];
                rest = before_close[0 .. before_close.len - 1];
                // postDelimiter = whitespace immediately following the *
                // (we don't have that since trimRight ate it; keep empty)
            } else {
                // pure ` */` — no delimiter, no description
                rest = "";
            }
            ln.tokens.end = "*/";
        } else if (rest.len > 0 and rest[0] == '*') {
            // continuation `* ...`
            ln.tokens.delimiter = rest[0..1];
            rest = rest[1..];
        }

        // postDelimiter = leading whitespace after delimiter
        const pd = countLeadingSpace(rest);
        ln.tokens.post_delimiter = rest[0..pd];
        rest = rest[pd..];

        // Whatever remains is description (trimmed of trailing whitespace,
        // which becomes part of the lineEnd in comment-parser; we drop trailing
        // whitespace silently here since lineEnd is rarely-accessed).
        ln.tokens.description = trimRight(rest);

        out[idx] = ln;
    }
    return out;
}

// ── Stage 2: block-parser ─────────────────────────────────────────────────
// Group lines into description section + per-@tag sections.
// A line "starts" a new tag section if its description begins with `@<tag>`.

const Section = struct {
    /// Empty for description section; the tag identifier (without @) for tag sections.
    tag: []const u8,
    /// Indices into the global `lines` array.
    line_indices: []u32,
};

fn detectAtTag(desc: []const u8) ?[]const u8 {
    if (desc.len < 2 or desc[0] != '@') return null;
    var i: usize = 1;
    while (i < desc.len) {
        const c = desc[i];
        // tag chars: identifiers + `:` for namespacing (some codebases use @some:tag)
        const is_word = (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
            (c >= '0' and c <= '9') or c == '_' or c == '$' or c == ':' or c == '-';
        if (!is_word) break;
        i += 1;
    }
    if (i == 1) return null;
    return desc[1..i];
}

fn blockParse(allocator: std.mem.Allocator, lines: []Line) ![]Section {
    var sections = std.ArrayListUnmanaged(Section).empty;
    errdefer sections.deinit(allocator);

    // Description section is always first (may be empty).
    var current_indices = std.ArrayListUnmanaged(u32).empty;
    var current_tag: []const u8 = "";

    for (lines, 0..) |ln, i| {
        const tag = detectAtTag(ln.tokens.description);
        if (tag) |t| {
            // Flush current section.
            const slice = try current_indices.toOwnedSlice(allocator);
            try sections.append(allocator, .{ .tag = current_tag, .line_indices = slice });
            current_tag = t;
            current_indices = std.ArrayListUnmanaged(u32).empty;
        }
        try current_indices.append(allocator, @intCast(i));
    }
    // Flush final section.
    const slice = try current_indices.toOwnedSlice(allocator);
    try sections.append(allocator, .{ .tag = current_tag, .line_indices = slice });

    return sections.toOwnedSlice(allocator);
}

// ── Stage 3: spec-parser ──────────────────────────────────────────────────
// For each tag section, extract tag/type/name/default/description and mutate
// the section's first line tokens to record the breakdown.
//
// Format on the first line: `@<tag> {<type>} <name> - <description>` (any subset)
//   - `{type}` is matched with brace counting (handles `{Object<string, T>}`)
//   - `[name=default]` indicates optional + default value
//   - The hyphen before description is optional

fn extractType(s: []const u8) ?struct { type_text: []const u8, after: []const u8 } {
    var i: usize = 0;
    while (i < s.len and isSpace(s[i])) i += 1;
    if (i >= s.len or s[i] != '{') return null;
    var depth: u32 = 1;
    var j: usize = i + 1;
    while (j < s.len) : (j += 1) {
        const c = s[j];
        if (c == '{') depth += 1
        else if (c == '}') {
            depth -= 1;
            if (depth == 0) {
                // type_text excludes braces
                return .{ .type_text = s[i + 1 .. j], .after = s[j + 1 ..] };
            }
        }
    }
    return null;
}

fn extractName(s: []const u8) ?struct {
    name: []const u8, // bare name (no brackets)
    default: []const u8,
    optional: bool,
    has_default: bool,
    after: []const u8,
} {
    var i: usize = 0;
    while (i < s.len and isSpace(s[i])) i += 1;
    if (i >= s.len) return null;

    // Optional `[name]` or `[name=default]`
    if (s[i] == '[') {
        var depth: u32 = 1;
        var j: usize = i + 1;
        while (j < s.len) : (j += 1) {
            const c = s[j];
            if (c == '[') depth += 1
            else if (c == ']') {
                depth -= 1;
                if (depth == 0) break;
            }
        }
        if (j >= s.len) return null;
        const inner = s[i + 1 .. j];
        const eq_idx = std.mem.indexOfScalar(u8, inner, '=');
        if (eq_idx) |k| {
            return .{
                .name = trim(inner[0..k]),
                .default = trim(inner[k + 1 ..]),
                .optional = true,
                .has_default = true,
                .after = s[j + 1 ..],
            };
        }
        return .{
            .name = trim(inner),
            .default = "",
            .optional = true,
            .has_default = false,
            .after = s[j + 1 ..],
        };
    }

    // Plain name: identifier-ish chars (incl. `.`, `[`, `]`, `'`, `"` for namepaths)
    // Simpler: everything up to first whitespace.
    var k: usize = i;
    while (k < s.len and !isSpace(s[k])) k += 1;
    if (k == i) return null;
    return .{
        .name = s[i..k],
        .default = "",
        .optional = false,
        .has_default = false,
        .after = s[k..],
    };
}

fn specParse(allocator: std.mem.Allocator, lines: []Line, section: Section) !Tag {
    // Section line indices reference into `lines`; mutate line tokens in place.
    if (section.line_indices.len == 0) return Tag{ .tag = "", .source = &.{} };

    const first_idx = section.line_indices[0];
    var first = &lines[first_idx];
    const desc = first.tokens.description;

    // Tag token: `@<name>`
    const tag_name = detectAtTag(desc) orelse "";
    const tag_token = if (tag_name.len > 0) desc[0 .. tag_name.len + 1] else "";
    var rest = desc[tag_token.len..];

    // postTag = whitespace
    const ptw = countLeadingSpace(rest);
    const post_tag = rest[0..ptw];
    rest = rest[ptw..];

    // type {...}
    var type_text: []const u8 = "";
    var post_type: []const u8 = "";
    var name_text: []const u8 = "";
    var post_name: []const u8 = "";
    var default_text: []const u8 = "";
    var optional: bool = false;
    var has_default: bool = false;

    const has_type = !isNoTypesTag(tag_name);
    const has_name = !isNoNamesTag(tag_name);

    if (has_type) {
        if (extractType(rest)) |t| {
            type_text = t.type_text;
            // Reconstruct the slice of original (with braces) for the token field
            // by slicing `rest` from start to the brace closing position.
            // After extract, t.after starts immediately after the `}`.
            const consumed = rest.len - t.after.len;
            // post_type = leading whitespace AFTER the `}`.
            const ptlen = countLeadingSpace(t.after);
            post_type = t.after[0..ptlen];
            // type token in tokens.type should INCLUDE the braces (as comment-parser does)
            _ = consumed;
            rest = t.after[ptlen..];
        }
    }

    if (has_name) {
        if (extractName(rest)) |n| {
            name_text = n.name;
            default_text = n.default;
            optional = n.optional;
            has_default = n.has_default;
            const pnlen = countLeadingSpace(n.after);
            post_name = n.after[0..pnlen];
            rest = n.after[pnlen..];
        }
    }

    // Remaining is the first-line description portion.
    const first_line_desc = rest;

    // Mutate the first line's tokens to record the breakdown.
    first.tokens.tag = tag_token;
    first.tokens.post_tag = post_tag;
    if (type_text.len > 0) {
        // Reconstruct full `{type_text}` slice that lives within `desc`.
        // type_text's first byte is at `desc.ptr + (offset)`. Compute the surrounding
        // braces by walking 1 byte back and 1 byte forward inside `desc`.
        const t_start_ptr = @intFromPtr(type_text.ptr) - 1;
        const t_len = type_text.len + 2;
        const t_slice: []const u8 = @as([*]const u8, @ptrFromInt(t_start_ptr))[0..t_len];
        first.tokens.type = t_slice;
    }
    first.tokens.post_type = post_type;
    first.tokens.name = name_text;
    first.tokens.post_name = post_name;
    first.tokens.description = first_line_desc;

    // Aggregate description across the section's lines (joined with newline).
    // Also collect Line slice for tag.source.
    var src_lines = try allocator.alloc(Line, section.line_indices.len);
    var desc_buf = std.ArrayListUnmanaged(u8).empty;
    defer desc_buf.deinit(allocator);

    for (section.line_indices, 0..) |li, k| {
        src_lines[k] = lines[li];
        // For the first line, the description has been narrowed to the post-name slice
        // (`first_line_desc`) above; for subsequent lines, use the full description.
        const ln_desc = if (k == 0) first_line_desc else lines[li].tokens.description;
        if (ln_desc.len == 0) continue;
        if (desc_buf.items.len > 0) try desc_buf.append(allocator, '\n');
        try desc_buf.appendSlice(allocator, ln_desc);
    }
    const aggregated_desc = try desc_buf.toOwnedSlice(allocator);

    return Tag{
        .tag = tag_name,
        .name = name_text,
        .type = type_text,
        .description = trimWS(aggregated_desc),
        .default = default_text,
        .optional = optional,
        .has_default = has_default,
        .source = src_lines,
        .problems = &.{},
    };
}

// ── Stage 4: assemble ─────────────────────────────────────────────────────

pub fn parseToBlock(allocator: std.mem.Allocator, text: []const u8) !Block {
    const lines = try sourceParse(allocator, text);
    const sections = try blockParse(allocator, lines);
    defer allocator.free(sections);

    // First section is always the description section.
    var description_text: []const u8 = "";
    var tags_list = std.ArrayListUnmanaged(Tag).empty;
    errdefer tags_list.deinit(allocator);

    if (sections.len > 0 and sections[0].tag.len == 0) {
        // Build description by joining the description-section lines' descriptions.
        var buf = std.ArrayListUnmanaged(u8).empty;
        defer buf.deinit(allocator);
        for (sections[0].line_indices) |li| {
            const d = lines[li].tokens.description;
            if (d.len == 0) continue;
            if (buf.items.len > 0) try buf.append(allocator, '\n');
            try buf.appendSlice(allocator, d);
        }
        description_text = trimWS(try buf.toOwnedSlice(allocator));
    }

    const tag_sections_start: usize = if (sections.len > 0 and sections[0].tag.len == 0) 1 else 0;
    for (sections[tag_sections_start..]) |sec| {
        const tag = try specParse(allocator, lines, sec);
        try tags_list.append(allocator, tag);
    }

    // free section line_indices arrays (tag.source already cloned into src_lines)
    for (sections) |sec| allocator.free(sec.line_indices);

    const tags = try tags_list.toOwnedSlice(allocator);

    return Block{
        .description = description_text,
        .tags = tags,
        .source = lines,
        .problems = &.{},
    };
}

// ── Binary serializer ─────────────────────────────────────────────────────
//
// Layout (offsets are u32 byte positions inside a host arena/buffer; we return
// slices from the same allocator and let the caller compute byte offsets):
//
//   string_pool  : []u8            — UTF-8 bytes; all strings encoded as (off, len)
//   line_records : []LineRecord    — one entry per source line across all blocks
//   tag_records  : []TagRecord     — one entry per tag across all blocks
//   block_records: []BlockRecord   — one entry per /** comment, ordered to match
//                                    `source_offsets` (the lookup-key array)
//
// Block.source / Tag.source slices index into `line_records`. Tag ranges sit
// inside their owning Block's range — same total LineRecord storage, no dup.

pub const SlicePtr = extern struct { off: u32, len: u32 };

pub const BlockRecord = extern struct {
    description: SlicePtr,
    tags_start: u32,
    tags_count: u32,
    source_start: u32,
    source_count: u32,
    problems_start: u32, // currently always 0; reserved
    problems_count: u32, // currently always 0; reserved
};

comptime {
    std.debug.assert(@sizeOf(BlockRecord) == 32);
}

pub const TagRecord = extern struct {
    tag: SlicePtr,
    name: SlicePtr,
    type: SlicePtr,
    description: SlicePtr,
    default: SlicePtr,
    flags: u32, // bit0 = optional, bit1 = has_default
    source_start: u32,
    source_count: u32,
    problems_start: u32,
    problems_count: u32,
};

comptime {
    std.debug.assert(@sizeOf(TagRecord) == 60);
}

pub const LineRecord = extern struct {
    number: u32,
    source: SlicePtr,
    // 12 Tokens fields, in the order the JS side reads them:
    //   start, delimiter, postDelimiter, tag, postTag,
    //   name, postName, type, postType, description, end, lineEnd
    tokens_start: SlicePtr,
    tokens_delimiter: SlicePtr,
    tokens_post_delimiter: SlicePtr,
    tokens_tag: SlicePtr,
    tokens_post_tag: SlicePtr,
    tokens_name: SlicePtr,
    tokens_post_name: SlicePtr,
    tokens_type: SlicePtr,
    tokens_post_type: SlicePtr,
    tokens_description: SlicePtr,
    tokens_end: SlicePtr,
    tokens_line_end: SlicePtr,
};

comptime {
    std.debug.assert(@sizeOf(LineRecord) == 4 + 8 + 12 * 8); // 108
}

pub const Serialized = struct {
    block_records: []BlockRecord,
    tag_records: []TagRecord,
    line_records: []LineRecord,
    string_pool: []u8,
};

const PoolBuilder = struct {
    bytes: std.ArrayListUnmanaged(u8),

    fn put(self: *PoolBuilder, allocator: std.mem.Allocator, s: []const u8) !SlicePtr {
        if (s.len == 0) return SlicePtr{ .off = 0, .len = 0 };
        const off: u32 = @intCast(self.bytes.items.len);
        try self.bytes.appendSlice(allocator, s);
        return SlicePtr{ .off = off, .len = @intCast(s.len) };
    }
};

fn writeLineRecord(allocator: std.mem.Allocator, pool: *PoolBuilder, ln: Line) !LineRecord {
    return LineRecord{
        .number = ln.number,
        .source = try pool.put(allocator, ln.source),
        .tokens_start = try pool.put(allocator, ln.tokens.start),
        .tokens_delimiter = try pool.put(allocator, ln.tokens.delimiter),
        .tokens_post_delimiter = try pool.put(allocator, ln.tokens.post_delimiter),
        .tokens_tag = try pool.put(allocator, ln.tokens.tag),
        .tokens_post_tag = try pool.put(allocator, ln.tokens.post_tag),
        .tokens_name = try pool.put(allocator, ln.tokens.name),
        .tokens_post_name = try pool.put(allocator, ln.tokens.post_name),
        .tokens_type = try pool.put(allocator, ln.tokens.type),
        .tokens_post_type = try pool.put(allocator, ln.tokens.post_type),
        .tokens_description = try pool.put(allocator, ln.tokens.description),
        .tokens_end = try pool.put(allocator, ln.tokens.end),
        .tokens_line_end = try pool.put(allocator, ln.tokens.line_end),
    };
}

/// Serialize a slice of parsed Blocks into packed records.
/// Block ordering must match the caller's source_offsets array.
pub fn serialize(allocator: std.mem.Allocator, blocks: []const Block) !Serialized {
    var pool = PoolBuilder{ .bytes = std.ArrayListUnmanaged(u8).empty };
    var lines = std.ArrayListUnmanaged(LineRecord).empty;
    var tags = std.ArrayListUnmanaged(TagRecord).empty;
    var blocks_out = try allocator.alloc(BlockRecord, blocks.len);

    for (blocks, 0..) |block, bi| {
        const desc_ptr = try pool.put(allocator, block.description);
        const block_source_start: u32 = @intCast(lines.items.len);

        // Emit ALL block.source LineRecords in order. Tag.source line ranges
        // are subranges of this — we map by pointer-equality below.
        for (block.source) |ln| {
            const lr = try writeLineRecord(allocator, &pool, ln);
            try lines.append(allocator, lr);
        }
        const block_source_count: u32 = @intCast(block.source.len);

        const block_tags_start: u32 = @intCast(tags.items.len);
        for (block.tags) |tag| {
            const tag_token = try pool.put(allocator, tag.tag);
            const name_token = try pool.put(allocator, tag.name);
            const type_token = try pool.put(allocator, tag.type);
            const tag_desc = try pool.put(allocator, tag.description);
            const default_tok = try pool.put(allocator, tag.default);

            // Find tag.source's location within block.source by comparing the
            // first line's number (line numbers are unique within a block).
            var tag_source_start: u32 = 0;
            const tag_source_count: u32 = @intCast(tag.source.len);
            if (tag.source.len > 0) {
                const first_num = tag.source[0].number;
                for (block.source, 0..) |bsln, idx| {
                    if (bsln.number == first_num) {
                        tag_source_start = block_source_start + @as(u32, @intCast(idx));
                        break;
                    }
                }
            }

            var flags: u32 = 0;
            if (tag.optional) flags |= 1;
            if (tag.has_default) flags |= 2;

            try tags.append(allocator, TagRecord{
                .tag = tag_token,
                .name = name_token,
                .type = type_token,
                .description = tag_desc,
                .default = default_tok,
                .flags = flags,
                .source_start = tag_source_start,
                .source_count = tag_source_count,
                .problems_start = 0,
                .problems_count = 0,
            });
        }
        const block_tags_count: u32 = @intCast(block.tags.len);

        blocks_out[bi] = BlockRecord{
            .description = desc_ptr,
            .tags_start = block_tags_start,
            .tags_count = block_tags_count,
            .source_start = block_source_start,
            .source_count = block_source_count,
            .problems_start = 0,
            .problems_count = 0,
        };
    }

    return Serialized{
        .block_records = blocks_out,
        .tag_records = try tags.toOwnedSlice(allocator),
        .line_records = try lines.toOwnedSlice(allocator),
        .string_pool = try pool.bytes.toOwnedSlice(allocator),
    };
}

// ── Tests ────────────────────────────────────────────────────────────────

test "parse single-line param" {
    const a = std.testing.allocator;
    var arena = std.heap.ArenaAllocator.init(a);
    defer arena.deinit();
    const block = try parseToBlock(arena.allocator(), "/** @param {string} name - the name */");
    try std.testing.expectEqual(@as(usize, 1), block.tags.len);
    try std.testing.expectEqualStrings("param", block.tags[0].tag);
    try std.testing.expectEqualStrings("name", block.tags[0].name);
    try std.testing.expectEqualStrings("string", block.tags[0].type);
}

test "parse multi-tag block" {
    const a = std.testing.allocator;
    var arena = std.heap.ArenaAllocator.init(a);
    defer arena.deinit();
    const text =
        \\/**
        \\ * Description here.
        \\ * @param {number} x - the x
        \\ * @returns {void}
        \\ */
    ;
    const block = try parseToBlock(arena.allocator(), text);
    try std.testing.expectEqualStrings("Description here.", block.description);
    try std.testing.expectEqual(@as(usize, 2), block.tags.len);
    try std.testing.expectEqualStrings("param", block.tags[0].tag);
    try std.testing.expectEqualStrings("returns", block.tags[1].tag);
    try std.testing.expectEqualStrings("x", block.tags[0].name);
    try std.testing.expectEqualStrings("number", block.tags[0].type);
    try std.testing.expectEqualStrings("void", block.tags[1].type);
    try std.testing.expectEqualStrings("", block.tags[1].name);
}

test "parse optional param with default" {
    const a = std.testing.allocator;
    var arena = std.heap.ArenaAllocator.init(a);
    defer arena.deinit();
    const block = try parseToBlock(arena.allocator(), "/** @param {string} [name='foo'] description */");
    try std.testing.expectEqual(@as(usize, 1), block.tags.len);
    try std.testing.expectEqualStrings("name", block.tags[0].name);
    try std.testing.expect(block.tags[0].optional);
    try std.testing.expect(block.tags[0].has_default);
    try std.testing.expectEqualStrings("'foo'", block.tags[0].default);
}

test "serialize binary roundtrip" {
    const a = std.testing.allocator;
    var arena = std.heap.ArenaAllocator.init(a);
    defer arena.deinit();
    const aa = arena.allocator();

    const block = try parseToBlock(aa, "/** @param {string} name - the name */");
    const blocks = [_]Block{block};
    const out = try serialize(aa, &blocks);

    try std.testing.expectEqual(@as(usize, 1), out.block_records.len);
    const br = out.block_records[0];
    try std.testing.expectEqual(@as(u32, 1), br.tags_count);

    const tr = out.tag_records[br.tags_start];
    const tag_str = out.string_pool[tr.tag.off .. tr.tag.off + tr.tag.len];
    try std.testing.expectEqualStrings("param", tag_str);

    const name_str = out.string_pool[tr.name.off .. tr.name.off + tr.name.len];
    try std.testing.expectEqualStrings("name", name_str);

    const type_str = out.string_pool[tr.type.off .. tr.type.off + tr.type.len];
    try std.testing.expectEqualStrings("string", type_str);
}
