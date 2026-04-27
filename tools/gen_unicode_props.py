import re

# ECMA-262 24.x.x: list of binary Unicode properties recognized in \p{}
BINARY_PROPS = [
    "ASCII", "ASCII_Hex_Digit", "AHex", "Alphabetic", "Alpha", "Any", "Assigned",
    "Bidi_Control", "Bidi_C", "Bidi_Mirrored", "Bidi_M",
    "Case_Ignorable", "CI", "Cased",
    "Changes_When_Casefolded", "CWCF", "Changes_When_Casemapped", "CWCM",
    "Changes_When_Lowercased", "CWL", "Changes_When_NFKC_Casefolded", "CWKCF",
    "Changes_When_Titlecased", "CWT", "Changes_When_Uppercased", "CWU",
    "Dash", "Default_Ignorable_Code_Point", "DI", "Deprecated", "Dep",
    "Diacritic", "Dia",
    "Emoji", "Emoji_Component", "EComp", "Emoji_Modifier", "EMod",
    "Emoji_Modifier_Base", "EBase", "Emoji_Presentation", "EPres",
    "Extended_Pictographic", "ExtPict", "Extender", "Ext",
    "Grapheme_Base", "Gr_Base", "Grapheme_Extend", "Gr_Ext",
    "Hex_Digit", "Hex", "ID_Continue", "IDC", "ID_Start", "IDS",
    "IDS_Binary_Operator", "IDSB", "IDS_Trinary_Operator", "IDST",
    "Ideographic", "Ideo",
    "Join_Control", "Join_C", "Logical_Order_Exception", "LOE",
    "Lowercase", "Lower", "Math",
    "Noncharacter_Code_Point", "NChar", "Pattern_Syntax", "Pat_Syn",
    "Pattern_White_Space", "Pat_WS",
    "Quotation_Mark", "QMark", "Radical", "Regional_Indicator", "RI",
    "Sentence_Terminal", "STerm",
    "Soft_Dotted", "SD", "Terminal_Punctuation", "Term",
    "Unified_Ideograph", "UIdeo", "Uppercase", "Upper",
    "Variation_Selector", "VS", "White_Space", "WSpace", "space",
    "XID_Continue", "XIDC", "XID_Start", "XIDS",
]

# Property of strings (v-flag)
PROPS_OF_STRINGS = [
    "Basic_Emoji", "Emoji_Keycap_Sequence", "RGI_Emoji", "RGI_Emoji_Flag_Sequence",
    "RGI_Emoji_Modifier_Sequence", "RGI_Emoji_Tag_Sequence", "RGI_Emoji_ZWJ_Sequence",
]

# Non-binary properties accepted with `=`: General_Category, Script, Script_Extensions
NON_BINARY_PROPS_AND_ALIASES = {
    "General_Category": ["gc", "General_Category"],
    "Script": ["sc", "Script"],
    "Script_Extensions": ["scx", "Script_Extensions"],
}

def parse_aliases(path):
    """Parse PropertyValueAliases.txt. Returns dict: prop_short -> set of all aliases."""
    out = {}
    with open(path) as f:
        for line in f:
            if line.startswith("#") or not line.strip():
                continue
            parts = [p.strip() for p in line.split("#", 1)[0].split(";")]
            if len(parts) < 3:
                continue
            prop = parts[0]
            aliases = set()
            for alias in parts[1:]:
                if alias and alias != "n/a":
                    aliases.add(alias)
            out.setdefault(prop, set()).update(aliases)
    return out

aliases = parse_aliases("/tmp/PropertyValueAliases.txt")

# Collect General_Category values (gc + L, M, N, etc.)
gc_values = sorted(aliases.get("gc", set()))
sc_values = sorted(aliases.get("sc", set()))

print('// AUTO-GENERATED from Unicode 16.0 PropertyValueAliases.txt')
print('// ECMA-262 24.x.x: recognized property/value names for \\p{...} regex escapes.')
print('// Do not edit by hand — regenerate via tools/gen_unicode_props.py')
print()
print('const std = @import("std");')
print()

def emit_string_set(name, items):
    print(f'pub const {name} = [_][]const u8{{')
    for it in sorted(set(items)):
        print(f'    "{it}",')
    print('};')
    print()

emit_string_set("binary_properties", BINARY_PROPS)
emit_string_set("binary_properties_of_strings", PROPS_OF_STRINGS)
emit_string_set("general_category_values", gc_values)
emit_string_set("script_values", sc_values)

# Non-binary property names + aliases
non_binary_names = []
for canonical, lst in NON_BINARY_PROPS_AND_ALIASES.items():
    non_binary_names.extend(lst)
emit_string_set("non_binary_property_names", non_binary_names)

print('''
fn isInSet(set: []const []const u8, name: []const u8) bool {
    for (set) |s| {
        if (std.mem.eql(u8, s, name)) return true;
    }
    return false;
}

pub fn isBinaryProperty(name: []const u8) bool {
    return isInSet(&binary_properties, name);
}

pub fn isBinaryPropertyOfStrings(name: []const u8) bool {
    return isInSet(&binary_properties_of_strings, name);
}

pub fn isNonBinaryPropertyName(name: []const u8) bool {
    return isInSet(&non_binary_property_names, name);
}

pub fn isGeneralCategoryValue(name: []const u8) bool {
    return isInSet(&general_category_values, name);
}

pub fn isScriptValue(name: []const u8) bool {
    return isInSet(&script_values, name);
}

/// Check that `name=value` (or just `name` for binary) is a valid property
/// reference inside \\p{...}. v_mode enables property-of-strings.
pub fn isValidPropertyRef(name: []const u8, value: ?[]const u8, v_mode: bool) bool {
    if (value) |v| {
        // name=value form
        if (!isNonBinaryPropertyName(name)) return false;
        if (std.mem.eql(u8, name, "General_Category") or std.mem.eql(u8, name, "gc")) {
            return isGeneralCategoryValue(v);
        }
        if (std.mem.eql(u8, name, "Script") or std.mem.eql(u8, name, "sc") or
            std.mem.eql(u8, name, "Script_Extensions") or std.mem.eql(u8, name, "scx"))
        {
            return isScriptValue(v);
        }
        return false;
    } else {
        // name-only: binary property OR (in v-mode) property-of-strings OR
        // (loose-matching) a General_Category short value.
        if (isBinaryProperty(name)) return true;
        if (isGeneralCategoryValue(name)) return true;
        if (v_mode and isBinaryPropertyOfStrings(name)) return true;
        return false;
    }
}
''')
