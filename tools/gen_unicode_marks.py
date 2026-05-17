#!/usr/bin/env python3
# Generate combining-mark ranges from Unicode DerivedGeneralCategory.txt.
# Run via: python3 tools/gen_unicode_marks.py > src/parser/unicode_marks.zig
import re
import sys

SRC = "/tmp/DGC.txt"


def emit_ranges(categories):
    rx = re.compile(r'^([0-9A-F]+)(?:\.\.([0-9A-F]+))?\s*;\s*(\S+)')
    raw = []
    with open(SRC) as f:
        for line in f:
            m = rx.match(line)
            if not m:
                continue
            if m.group(3) not in categories:
                continue
            start = int(m.group(1), 16)
            end = int(m.group(2) or m.group(1), 16)
            raw.append((start, end))
    # Merge adjacent.
    raw.sort()
    out = []
    for s, e in raw:
        if out and s <= out[-1][1] + 1:
            out[-1] = (out[-1][0], max(out[-1][1], e))
        else:
            out.append((s, e))
    return out


print("// AUTO-GENERATED from Unicode 16.0 DerivedGeneralCategory.txt")
print("// Categories: Mn, Mc, Me (combining marks)")
print("// Regenerate via tools/gen_unicode_marks.py")
print()
print("const Range = struct { start: u32, end: u32 };")
print()
print("pub const combining_mark_ranges = [_]Range{")
for s, e in emit_ranges({"Mn", "Mc", "Me"}):
    print(f"    .{{ .start = 0x{s:04X}, .end = 0x{e:04X} }},")
print("};")
print()
print("pub fn isCombiningMark(cp: u32) bool {")
print("    var lo: usize = 0;")
print("    var hi: usize = combining_mark_ranges.len;")
print("    while (lo < hi) {")
print("        const mid = lo + (hi - lo) / 2;")
print("        const r = combining_mark_ranges[mid];")
print("        if (cp < r.start) {")
print("            hi = mid;")
print("        } else if (cp > r.end) {")
print("            lo = mid + 1;")
print("        } else {")
print("            return true;")
print("        }")
print("    }")
print("    return false;")
print("}")
