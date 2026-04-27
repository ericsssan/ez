import sys, re
def emit_ranges(prop, src):
    out = []
    rx = re.compile(r'^([0-9A-F]+)(?:\.\.([0-9A-F]+))?\s*;\s*' + prop + r'\s')
    with open(src) as f:
        for line in f:
            m = rx.match(line)
            if not m:
                continue
            start = m.group(1)
            end = m.group(2) or start
            out.append(f"    .{{ .start = 0x{start}, .end = 0x{end} }},")
    return out

src = "/tmp/DerivedCoreProperties.txt"
print("// AUTO-GENERATED from Unicode 16.0 DerivedCoreProperties.txt")
print("// Source: https://www.unicode.org/Public/16.0.0/ucd/DerivedCoreProperties.txt")
print("// Do not edit by hand — regenerate via tools/gen_unicode_id.py")
print()
print("const Range = struct { start: u32, end: u32 };")
print()
print("pub const id_start_ranges = [_]Range{")
for line in emit_ranges("ID_Start", src):
    print(line)
print("};")
print()
print("pub const id_continue_ranges = [_]Range{")
for line in emit_ranges("ID_Continue", src):
    print(line)
print("};")
print("""
pub fn isIdStart(cp: u32) bool {
    return rangeContains(&id_start_ranges, cp);
}

pub fn isIdContinue(cp: u32) bool {
    return rangeContains(&id_continue_ranges, cp);
}

/// ZWNJ (U+200C) and ZWJ (U+200D) are valid as identifier-continue per
/// ECMAScript spec but classified as Cf — not in UCD ID_Continue.
pub fn isIdContinueJS(cp: u32) bool {
    if (cp == 0x200C or cp == 0x200D) return true;
    return rangeContains(&id_continue_ranges, cp);
}

fn rangeContains(ranges: []const Range, cp: u32) bool {
    var lo: usize = 0;
    var hi: usize = ranges.len;
    while (lo < hi) {
        const mid = (lo + hi) / 2;
        const r = ranges[mid];
        if (cp < r.start) {
            hi = mid;
        } else if (cp > r.end) {
            lo = mid + 1;
        } else {
            return true;
        }
    }
    return false;
}
""")
