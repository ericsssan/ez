const std = @import("std");
const ast_mod = @import("ast.zig");
const Ast = ast_mod.Ast;
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const SubRange = ast_mod.SubRange;
const ExtraIndex = ast_mod.ExtraIndex;
const TokenIndex = ast_mod.TokenIndex;
const FnData = ast_mod.FnData;
const ClassData = ast_mod.ClassData;
const ArrowData = ast_mod.ArrowData;
const ForData = ast_mod.ForData;
const ForInOfData = ast_mod.ForInOfData;
const TryData = ast_mod.TryData;
const ImportData = ast_mod.ImportData;
const IfData = ast_mod.IfData;
const Conditional = ast_mod.Conditional;
const MethodData = ast_mod.MethodData;
const scope_mod = @import("scope.zig");
const ScopeTree = scope_mod.ScopeTree;
const ScopeId = scope_mod.ScopeId;
const ScopeKind = scope_mod.ScopeKind;
const ScopeFlags = scope_mod.ScopeFlags;
const symbol_mod = @import("symbol.zig");
const SymbolTable = symbol_mod.SymbolTable;
const SymbolId = symbol_mod.SymbolId;
const SymbolFlags = symbol_mod.SymbolFlags;
const BindingKind = symbol_mod.BindingKind;
const ref_mod = @import("reference.zig");
const ReferenceTable = ref_mod.ReferenceTable;
const ReferenceId = ref_mod.ReferenceId;
const ReferenceKind = ref_mod.ReferenceKind;
const Span = @import("span.zig").Span;
const Diagnostic = @import("diagnostic.zig").Diagnostic;
const Severity = @import("diagnostic.zig").Severity;

// ── Semantic Result ────────────────────────────────────────

/// The result of semantic analysis: populated scope tree, symbol table,
/// reference table, and any diagnostics produced during the walk.
pub const SemanticResult = struct {
    scopes: ScopeTree,
    symbols: SymbolTable,
    references: ReferenceTable,
    diagnostics: []const Diagnostic,

    pub fn deinit(self: *SemanticResult, allocator: std.mem.Allocator) void {
        self.scopes.deinit();
        self.symbols.deinit();
        self.references.deinit();
        allocator.free(self.diagnostics);
        self.* = undefined;
    }
};

// ── Semantic Analyzer ──────────────────────────────────────

/// A single-pass AST walker that builds scopes, declares symbols, and
/// resolves identifier references. After analysis, the caller receives a
/// `SemanticResult` containing the fully populated tables.
pub const SemanticAnalyzer = struct {
    ast: *const Ast,
    scopes: ScopeTree,
    symbols: SymbolTable,
    references: ReferenceTable,
    diagnostics: std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,

    /// The scope that is currently being visited.
    current_scope: ScopeId,

    /// Track exported names for duplicate detection and undeclared export validation.
    exported_names: std.ArrayList(ExportEntry) = .empty,

    const ExportEntry = struct {
        exported_name: []const u8, // the exported name (for duplicate detection)
        local_name: []const u8, // the local binding name (for undeclared detection)
        node: NodeIndex, // for error reporting
        is_re_export: bool, // export { x } from '...' doesn't need local binding
    };

    // ── Lifecycle ──────────────────────────────────────────

    pub fn init(allocator: std.mem.Allocator, ast: *const Ast) SemanticAnalyzer {
        return .{
            .ast = ast,
            .scopes = ScopeTree.init(allocator),
            .symbols = SymbolTable.init(allocator),
            .references = ReferenceTable.init(allocator),
            .diagnostics = .empty,
            .allocator = allocator,
            .current_scope = .none,
        };
    }

    pub fn deinit(self: *SemanticAnalyzer) void {
        self.scopes.deinit();
        self.symbols.deinit();
        self.references.deinit();
        self.diagnostics.deinit(self.allocator);
        self.exported_names.deinit(self.allocator);
    }

    /// Main entry point. Walks the AST and populates scopes/symbols/references.
    pub fn analyze(allocator: std.mem.Allocator, ast: *const Ast) !SemanticResult {
        var self = SemanticAnalyzer.init(allocator, ast);
        errdefer self.deinit();
        // exported_names is a temporary used only during analysis; always free it.
        defer self.exported_names.deinit(allocator);

        const root_data = self.ast.nodeData(.root);
        try self.visitRoot(.root, root_data);
        try self.validateExports();

        return .{
            .scopes = self.scopes,
            .symbols = self.symbols,
            .references = self.references,
            .diagnostics = try self.diagnostics.toOwnedSlice(self.allocator),
        };
    }

    // ── Scope helpers ──────────────────────────────────────

    fn enterScope(self: *SemanticAnalyzer, scope_kind: ScopeKind, node: NodeIndex) !ScopeId {
        const id = try self.scopes.addScope(scope_kind, self.current_scope, node);
        self.current_scope = id;
        return id;
    }

    fn leaveScope(self: *SemanticAnalyzer) void {
        self.current_scope = self.scopes.parent(self.current_scope);
    }

    // ── Declaration helpers ────────────────────────────────

    /// Declare a binding in the given scope. Checks for illegal redeclarations
    /// and emits diagnostics as needed.
    fn declareBinding(
        self: *SemanticAnalyzer,
        name: []const u8,
        node: NodeIndex,
        binding_kind: BindingKind,
        scope: ScopeId,
    ) !SymbolId {
        // Check for redeclaration in the target scope.
        if (self.findSymbolInScope(name, scope)) |existing_id| {
            const existing_kind = self.symbols.getBindingKind(existing_id);
            if (!self.isRedeclarationAllowed(existing_kind, binding_kind)) {
                try self.diagnostics.append(self.allocator, .{
                    .message = "Identifier has already been declared",
                    .span = self.ast.nodeSpan(node),
                    .severity = .@"error",
                });
                // Still declare it so analysis can continue.
            }
        }

        const symbol_flags = symbol_mod.flagsFromBindingKind(binding_kind);
        return self.symbols.addSymbol(name, symbol_flags, binding_kind, scope, node);
    }

    /// Check whether redeclaring `existing` with `new` in the same scope is legal.
    fn isRedeclarationAllowed(_: *const SemanticAnalyzer, existing: BindingKind, new: BindingKind) bool {
        // var + var  => OK
        // function_decl + var  => OK
        // var + function_decl  => OK
        // function_decl + function_decl  => OK
        // parameter + var  => OK (var in function body shadows parameter)
        // Everything else in the same scope => error
        return existing.canRedeclare() and new.canRedeclare();
    }

    /// Find a symbol by name in a specific scope (not walking up the chain).
    fn findSymbolInScope(self: *const SemanticAnalyzer, name: []const u8, scope: ScopeId) ?SymbolId {
        const count = self.symbols.count();
        if (count == 0) return null;
        var i: u32 = count;
        while (i > 0) {
            i -= 1;
            const id = SymbolId.fromInt(i);
            if (self.symbols.getScope(id).toInt() == scope.toInt()) {
                if (std.mem.eql(u8, self.symbols.getName(id), name)) {
                    return id;
                }
            }
        }
        return null;
    }

    // ── Reference resolution ───────────────────────────────

    /// Walk up the scope chain looking for a symbol with the given name.
    fn resolveReference(self: *SemanticAnalyzer, name: []const u8, ref_id: ReferenceId) void {
        var scope = self.current_scope;
        while (scope.isValid()) {
            if (self.findSymbolInScope(name, scope)) |sym_id| {
                self.references.resolve(ref_id, sym_id);
                // Update symbol usage flags based on reference kind.
                const kind = self.references.getKind(ref_id);
                if (kind.isRead()) self.symbols.markRead(sym_id);
                if (kind.isWrite()) self.symbols.markWritten(sym_id);
                if (kind == .type_of) self.symbols.markTypeOf(sym_id);
                return;
            }
            scope = self.scopes.parent(scope);
        }
        // Unresolved — leave ref as .none (implicit global).
    }

    // ── Visitor dispatch ───────────────────────────────────

    fn visitNode(self: *SemanticAnalyzer, idx: NodeIndex) std.mem.Allocator.Error!void {
        if (idx == .none or idx == .root) return;

        const tag = self.ast.nodeTag(idx);
        const data = self.ast.nodeData(idx);

        switch (tag) {
            // ── Program (only entered from analyze(), never recursively) ──
            .root => {},

            // ── Scope-creating statements ──────────────────
            .block_stmt => try self.visitBlockStmt(idx, data),
            .for_stmt => try self.visitForStmt(data),
            .for_in_stmt, .for_of_stmt, .for_await_of_stmt => try self.visitForInOfStmt(data),
            .switch_stmt => try self.visitSwitchStmt(idx, data),
            .catch_clause => try self.visitCatchClause(idx, data),
            .with_stmt => try self.visitWithStmt(idx, data),
            .static_block => try self.visitStaticBlock(idx, data),

            // ── Function declarations ──────────────────────
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
                try self.visitFnDecl(idx, data, tag);
            },

            // ── Function expressions ───────────────────────
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
                try self.visitFnExpr(idx, data, tag);
            },

            // ── Arrow functions ────────────────────────────
            .arrow_fn, .async_arrow_fn => try self.visitArrowFn(idx, data),

            // ── Class ──────────────────────────────────────
            .class_decl => try self.visitClassDecl(idx, data),
            .class_expr => try self.visitClassExpr(idx, data),

            // ── Declarations ───────────────────────────────
            .var_decl => try self.visitVarDecl(data, .@"var"),
            .let_decl => try self.visitVarDecl(data, .let),
            .const_decl => try self.visitVarDecl(data, .@"const"),

            // ── Imports ────────────────────────────────────
            .import_decl => try self.visitImportDecl(data),
            .import_specifier => try self.visitImportSpecifier(idx),
            .import_default_specifier => try self.visitImportDefaultSpecifier(idx),
            .import_namespace_specifier => try self.visitImportNamespaceSpecifier(idx),

            // ── Exports ────────────────────────────────────
            .export_named => {
                // export_named is overloaded:
                // - export { x, y } → lhs/rhs encode SubRange of specifiers
                // - export var/let/const/function/class → lhs = declaration node, rhs = .none
                if (data.rhs == .none) {
                    // lhs is a declaration node
                    try self.visitNode(data.lhs);
                } else {
                    // lhs/rhs encode SubRange of specifiers
                    try self.visitSubRangeFromData(data);
                    // Track exported names for validation
                    try self.trackExportSpecifiers(idx, data);
                }
            },
            .export_default_expr => try self.visitNode(data.lhs),
            .export_default_fn => try self.visitNode(data.lhs),
            .export_default_class => try self.visitNode(data.lhs),

            // ── Identifier references ──────────────────────
            .identifier => try self.visitIdentifier(idx),

            // ── Assignments ────────────────────────────────
            .assign => try self.visitAssignment(data, .write),
            .add_assign, .sub_assign, .mul_assign, .div_assign,
            .mod_assign, .exp_assign, .and_assign, .or_assign,
            .xor_assign, .shl_assign, .shr_assign, .ushr_assign,
            .logical_and_assign, .logical_or_assign, .nullish_assign,
            => try self.visitAssignment(data, .read_write),

            // ── Update expressions ─────────────────────────
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => {
                try self.visitUpdateExpr(data);
            },

            // ── typeof ─────────────────────────────────────
            .typeof_expr => try self.visitTypeofExpr(data),

            // ── Control flow with children ─────────────────
            .if_stmt => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .if_else_stmt => {
                try self.visitNode(data.lhs);
                const if_data = self.ast.extraData(IfData, @intFromEnum(data.rhs));
                try self.visitNode(if_data.consequent);
                try self.visitNode(if_data.alternate);
            },
            .while_stmt => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .do_while_stmt => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .try_stmt => try self.visitTryStmt(data),
            .labeled_stmt => try self.visitNode(data.lhs),
            .return_stmt => try self.visitNode(data.lhs),
            .throw_stmt => try self.visitNode(data.lhs),
            .expression_stmt => try self.visitNode(data.lhs),

            // ── Switch cases ───────────────────────────────
            .switch_case => {
                try self.visitNode(data.lhs);
                // Case body is a SubRange stored in rhs as extra index.
                const body_range = self.readSubRange(@intFromEnum(data.rhs));
                try self.visitSubRange(body_range);
            },
            .switch_default => {
                const body_range = self.readSubRange(@intFromEnum(data.rhs));
                try self.visitSubRange(body_range);
            },

            // ── Expressions with children ──────────────────
            .conditional => {
                try self.visitNode(data.lhs);
                const cond = self.ast.extraData(Conditional, @intFromEnum(data.rhs));
                try self.visitNode(cond.consequent);
                try self.visitNode(cond.alternate);
            },
            .call_expr, .new_expr, .optional_call_expr => {
                try self.visitNode(data.lhs);
                if (data.rhs != .none) {
                    const args_range = self.readSubRange(@intFromEnum(data.rhs));
                    try self.visitSubRange(args_range);
                }
            },
            .member_expr, .optional_member_expr => {
                try self.visitNode(data.lhs);
            },
            .computed_member_expr, .optional_computed_member_expr => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .sequence_expr => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .array_literal => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .object_literal => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .template_literal => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .tagged_template => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .property => {
                // Only visit value (rhs) — key (lhs) is not a reference
                try self.visitNode(data.rhs);
            },
            .computed_property => {
                // Computed key IS an expression — visit both
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .shorthand_property => {
                try self.visitNode(data.lhs);
            },
            .spread_element, .rest_element => {
                try self.visitNode(data.lhs);
            },
            .grouping_expr => try self.visitNode(data.lhs),
            .import_expr => try self.visitNode(data.lhs),

            // ── Unary expressions ──────────────────────────
            .unary_plus, .unary_minus, .bitwise_not, .logical_not,
            .void_expr, .delete_expr, .await_expr, .yield_expr, .yield_delegate,
            => try self.visitNode(data.lhs),

            // ── Binary expressions ─────────────────────────
            .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .instanceof_expr, .in_expr,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right, .unsigned_shift_right,
            .logical_and, .logical_or, .nullish_coalesce,
            => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },

            // ── Patterns (in binding positions) ────────────
            .assignment_pattern => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },
            .array_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },
            .object_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },

            // ── Declarator (handled by visitVarDecl) ──────
            .declarator => {
                // When visited standalone (e.g., from a for-in binding), just visit children.
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },

            // ── Class members ──────────────────────────────
            .method_def, .computed_method_def => try self.visitMethodDef(idx, data),
            .getter_def, .computed_getter_def => try self.visitMethodDef(idx, data),
            .setter_def, .computed_setter_def => try self.visitMethodDef(idx, data),
            .constructor_def => try self.visitMethodDef(idx, data),
            .property_def, .computed_property_def => {
                try self.visitNode(data.lhs);
                try self.visitNode(data.rhs);
            },

            // ── Formal parameters (handled by fn visitors) ─
            .formal_parameters => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                try self.visitSubRange(range);
            },

            // ── TypeScript declarations ──────────────────────
            .ts_interface_decl => {
                const iface_data = self.ast.extraData(ast_mod.InterfaceData, @intFromEnum(data.lhs));
                if (iface_data.extends_start != iface_data.extends_end) {
                    try self.visitSubRange(.{ .start = iface_data.extends_start, .end = iface_data.extends_end });
                }
                if (iface_data.body_start != iface_data.body_end) {
                    try self.visitSubRange(.{ .start = iface_data.body_start, .end = iface_data.body_end });
                }
            },
            .ts_type_alias_decl => {},
            .ts_enum_decl => {
                const enum_data = self.ast.extraData(ast_mod.EnumData, @intFromEnum(data.lhs));
                try self.visitSubRange(.{ .start = enum_data.members_start, .end = enum_data.members_end });
            },
            .ts_enum_member => try self.visitNode(data.rhs),
            .ts_namespace_decl, .ts_module_decl => try self.visitNode(data.rhs),

            // ── TypeScript types (skip) ──────────────────────
            .ts_type_annotation, .ts_type_reference, .ts_type_predicate,
            .ts_union_type, .ts_intersection_type, .ts_tuple_type,
            .ts_array_type, .ts_function_type, .ts_constructor_type,
            .ts_type_literal, .ts_mapped_type, .ts_conditional_type,
            .ts_infer_type, .ts_typeof_type, .ts_keyof_type,
            .ts_indexed_access_type, .ts_template_literal_type,
            .ts_type_query, .ts_parenthesized_type,
            .ts_parameter_property,
            => {},

            // ── TypeScript expressions ───────────────────────
            .ts_as_expr, .ts_satisfies_expr => try self.visitNode(data.lhs),
            .ts_non_null_expr => try self.visitNode(data.lhs),
            .ts_type_assertion => try self.visitNode(data.rhs),

            // ── JSX ──────────────────────────────────────────
            .jsx_element => {
                const jsx_data = self.ast.extraData(ast_mod.JsxElementData, @intFromEnum(data.lhs));
                try self.visitNode(jsx_data.opening);
                try self.visitSubRange(.{ .start = jsx_data.children_start, .end = jsx_data.children_end });
                try self.visitNode(jsx_data.closing);
            },
            .jsx_self_closing, .jsx_opening_element => {
                const jsx_open = self.ast.extraData(ast_mod.JsxOpeningData, @intFromEnum(data.lhs));
                try self.visitNode(jsx_open.name);
                try self.visitSubRange(.{ .start = jsx_open.attrs_start, .end = jsx_open.attrs_end });
            },
            .jsx_closing_element => try self.visitNode(data.lhs),
            .jsx_attribute => try self.visitNode(data.rhs),
            .jsx_spread_attribute => try self.visitNode(data.lhs),
            .jsx_expression_container => try self.visitNode(data.lhs),
            .jsx_fragment => {
                try self.visitSubRange(.{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) });
            },
            .jsx_text_node => {},

            // ── Leaf nodes / no-ops ────────────────────────
            .empty_stmt, .break_stmt, .break_label, .continue_stmt,
            .continue_label, .debugger_stmt, .this_expr, .super_expr,
            .number_literal, .string_literal, .boolean_literal,
            .null_literal, .regex_literal, .bigint_literal,
            .template_element, .import_meta,
            .export_all, .export_specifier,
            .error_node,
            => {},

            .new_target => {
                // new.target is valid inside functions, class field initializers, and static blocks
                var scope = self.current_scope;
                var in_valid_context = false;
                while (scope.isValid()) {
                    const k = self.scopes.kind(scope);
                    if (k == .function or k == .static_block or k == .class) {
                        in_valid_context = true;
                        break;
                    }
                    scope = self.scopes.parent(scope);
                }
                if (!in_valid_context) {
                    try self.diagnostics.append(self.allocator, .{
                        .message = "'new.target' is only valid inside functions",
                        .span = self.ast.nodeSpan(idx),
                        .severity = .@"error",
                    });
                }
            },
        }
    }

    // ── Export tracking ────────────────────────────────────

    fn trackExportSpecifiers(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        const token_tags = self.ast.tokens.items(.tag);

        // Determine if this is a re-export by checking if there's a `from` keyword after
        // the closing brace. Walk tokens from the export keyword to find `}` then `from`.
        const main_token = self.ast.nodes.items(.main_token)[idx.toInt()];
        var is_re_export = false;
        {
            var ti = main_token;
            while (ti < token_tags.len) : (ti += 1) {
                if (token_tags[ti] == .r_brace) {
                    if (ti + 1 < token_tags.len and token_tags[ti + 1] == .kw_from) {
                        is_re_export = true;
                    }
                    break;
                }
            }
        }

        var i = range.start;
        while (i < range.end) : (i += 1) {
            const spec_idx: NodeIndex = @enumFromInt(self.ast.extra_data[i]);
            const spec_data = self.ast.nodes.items(.data)[spec_idx.toInt()];
            const local_token: TokenIndex = @intFromEnum(spec_data.lhs);
            const exported_token: TokenIndex = @intFromEnum(spec_data.rhs);

            const exported_name = self.ast.tokenText(exported_token);
            const local_name = self.ast.tokenText(local_token);

            try self.exported_names.append(self.allocator, .{
                .exported_name = exported_name,
                .local_name = local_name,
                .node = spec_idx,
                .is_re_export = is_re_export,
            });
        }
    }

    fn validateExports(self: *SemanticAnalyzer) !void {
        // Check for duplicate exported names
        for (self.exported_names.items, 0..) |entry, i| {
            for (self.exported_names.items[0..i]) |prev| {
                if (std.mem.eql(u8, entry.exported_name, prev.exported_name)) {
                    try self.diagnostics.append(self.allocator, .{
                        .message = "Duplicate export name",
                        .span = self.ast.nodeSpan(entry.node),
                        .severity = .@"error",
                    });
                    break;
                }
            }
        }

        // Check for undeclared export locals (only for non-re-exports)
        for (self.exported_names.items) |entry| {
            if (entry.is_re_export) continue;
            // Check if the local name is declared in module/global scope
            const root_scope_id: ScopeId = @enumFromInt(0);
            if (self.findSymbolInScope(entry.local_name, root_scope_id) == null) {
                try self.diagnostics.append(self.allocator, .{
                    .message = "Export is not defined",
                    .span = self.ast.nodeSpan(entry.node),
                    .severity = .@"error",
                });
            }
        }
    }

    // ── Specific visitors ──────────────────────────────────

    fn visitRoot(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        _ = try self.enterScope(.global, idx);
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        try self.visitSubRange(range);
        self.leaveScope();
    }

    fn visitBlockStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        _ = try self.enterScope(.block, idx);
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        try self.visitSubRange(range);
        self.leaveScope();
    }

    fn visitForStmt(self: *SemanticAnalyzer, data: Node.Data) !void {
        // for (init; cond; update) body
        // Create a block scope for let/const in the init clause.
        const for_data = self.ast.extraData(ForData, @intFromEnum(data.lhs));
        _ = try self.enterScope(.block, data.rhs);
        try self.visitNode(for_data.init);
        try self.visitNode(for_data.condition);
        try self.visitNode(for_data.update);
        try self.visitNode(data.rhs);
        self.leaveScope();
    }

    fn visitForInOfStmt(self: *SemanticAnalyzer, data: Node.Data) !void {
        const fiof_data = self.ast.extraData(ForInOfData, @intFromEnum(data.lhs));
        _ = try self.enterScope(.block, fiof_data.body);
        try self.visitNode(fiof_data.binding);
        try self.visitNode(fiof_data.expr);
        try self.visitNode(fiof_data.body);
        self.leaveScope();
    }

    fn visitSwitchStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        try self.visitNode(data.lhs); // discriminant — visited in outer scope
        _ = try self.enterScope(.switch_stmt, idx);
        const cases_range = self.readSubRange(@intFromEnum(data.rhs));
        try self.visitSubRange(cases_range);
        self.leaveScope();
    }

    fn visitCatchClause(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        _ = try self.enterScope(.catch_clause, idx);
        // Declare catch parameter if present.
        if (data.lhs != .none) {
            try self.extractBindingNames(data.lhs, self.current_scope, .catch_param);
        }
        try self.visitNode(data.rhs); // body block
        self.leaveScope();
    }

    fn visitWithStmt(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        try self.visitNode(data.lhs); // object expr in outer scope
        _ = try self.enterScope(.with_stmt, idx);
        try self.visitNode(data.rhs); // body
        self.leaveScope();
    }

    fn visitStaticBlock(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        _ = try self.enterScope(.static_block, idx);
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        try self.visitSubRange(range);
        self.leaveScope();
    }

    // ── Functions ──────────────────────────────────────────

    fn visitFnDecl(
        self: *SemanticAnalyzer,
        idx: NodeIndex,
        data: Node.Data,
        tag: Node.Tag,
    ) !void {
        const fn_data = self.ast.extraData(FnData, @intFromEnum(data.lhs));

        // Declare the function name in the current (outer) scope — hoisted.
        if (fn_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(fn_data.name));
            _ = try self.declareBinding(name, fn_data.name, .function_decl, self.current_scope);
        }

        // Enter function scope.
        const fn_scope = try self.enterScope(.function, idx);
        self.applyFnFlags(fn_scope, tag);

        // Declare params.
        try self.visitParams(SubRange{ .start = fn_data.params, .end = fn_data.params_end });

        // Visit body.
        try self.visitNode(fn_data.body);

        self.leaveScope();
    }

    fn visitFnExpr(
        self: *SemanticAnalyzer,
        idx: NodeIndex,
        data: Node.Data,
        tag: Node.Tag,
    ) !void {
        const fn_data = self.ast.extraData(FnData, @intFromEnum(data.lhs));

        // Enter function scope.
        const fn_scope = try self.enterScope(.function, idx);
        self.applyFnFlags(fn_scope, tag);

        // Optionally declare the function name inside its own scope.
        if (fn_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(fn_data.name));
            _ = try self.declareBinding(name, fn_data.name, .function_decl, self.current_scope);
        }

        try self.visitParams(SubRange{ .start = fn_data.params, .end = fn_data.params_end });
        try self.visitNode(fn_data.body);

        self.leaveScope();
    }

    fn visitArrowFn(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const arrow_data = self.ast.extraData(ArrowData, @intFromEnum(data.lhs));

        // Arrow functions create a function scope but have no `this`/`arguments`.
        const fn_scope = try self.enterScope(.function, idx);
        var scope_flags = self.scopes.getFlags(fn_scope);
        scope_flags.has_arguments = false;
        scope_flags.has_this_binding = false;
        self.scopes.setFlags(fn_scope, scope_flags);

        try self.visitParams(SubRange{ .start = arrow_data.params_start, .end = arrow_data.params_end });
        try self.visitNode(arrow_data.body);

        self.leaveScope();
    }

    fn applyFnFlags(self: *SemanticAnalyzer, fn_scope: ScopeId, tag: Node.Tag) void {
        var scope_flags = self.scopes.getFlags(fn_scope);
        switch (tag) {
            .async_fn_decl, .async_fn_expr => {
                scope_flags.is_async = true;
            },
            .generator_fn_decl, .generator_fn_expr => {
                scope_flags.is_generator = true;
            },
            .async_generator_fn_decl, .async_generator_fn_expr => {
                scope_flags.is_async = true;
                scope_flags.is_generator = true;
            },
            else => {},
        }
        self.scopes.setFlags(fn_scope, scope_flags);
    }

    fn visitParams(self: *SemanticAnalyzer, range: SubRange) !void {
        const items = self.ast.extraSlice(range);
        for (items) |raw| {
            const param_idx: NodeIndex = @enumFromInt(raw);
            if (param_idx == .none) continue;
            try self.extractBindingNames(param_idx, self.current_scope, .parameter);
        }
    }

    // ── Classes ────────────────────────────────────────────

    fn visitClassDecl(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const class_data = self.ast.extraData(ClassData, @intFromEnum(data.lhs));

        // Declare the class name in the outer scope (TDZ).
        if (class_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(class_data.name));
            _ = try self.declareBinding(name, class_data.name, .class_decl, self.current_scope);
        }

        // Visit superclass in outer scope.
        try self.visitNode(class_data.super_class);

        // Enter class scope (always strict).
        _ = try self.enterScope(.class, idx);

        // Optionally declare the class name inside its own scope for self-reference.
        if (class_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(class_data.name));
            _ = try self.declareBinding(name, class_data.name, .@"const", self.current_scope);
        }

        const body_range = SubRange{ .start = class_data.body_start, .end = class_data.body_end };
        try self.visitSubRange(body_range);

        self.leaveScope();
    }

    fn visitClassExpr(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        const class_data = self.ast.extraData(ClassData, @intFromEnum(data.lhs));

        // Visit superclass in outer scope.
        try self.visitNode(class_data.super_class);

        // Enter class scope.
        _ = try self.enterScope(.class, idx);

        // Optionally declare the class name inside its own scope.
        if (class_data.name != .none) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(class_data.name));
            _ = try self.declareBinding(name, class_data.name, .@"const", self.current_scope);
        }

        const body_range = SubRange{ .start = class_data.body_start, .end = class_data.body_end };
        try self.visitSubRange(body_range);

        self.leaveScope();
    }

    fn visitMethodDef(self: *SemanticAnalyzer, idx: NodeIndex, data: Node.Data) !void {
        // Visit the key expression (it may contain computed identifiers).
        try self.visitNode(data.lhs);

        // rhs is extra index to MethodData containing params + body.
        const method_data = self.ast.extraData(MethodData, @intFromEnum(data.rhs));

        const fn_scope = try self.enterScope(.function, idx);
        _ = fn_scope;
        try self.visitParams(SubRange{ .start = method_data.params_start, .end = method_data.params_end });
        try self.visitNode(method_data.body);
        self.leaveScope();
    }

    // ── Variable declarations ──────────────────────────────

    fn visitVarDecl(self: *SemanticAnalyzer, data: Node.Data, binding_kind: BindingKind) !void {
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        const items = self.ast.extraSlice(range);
        for (items) |raw| {
            const decl_idx: NodeIndex = @enumFromInt(raw);
            if (decl_idx == .none) continue;
            try self.visitDeclarator(decl_idx, binding_kind);
        }
    }

    fn visitDeclarator(self: *SemanticAnalyzer, idx: NodeIndex, binding_kind: BindingKind) !void {
        const data = self.ast.nodeData(idx);

        // Determine the scope where this binding should be declared.
        const target_scope = if (binding_kind == .@"var")
            self.scopes.nearestVarScope(self.current_scope)
        else
            self.current_scope;

        // lhs = binding pattern or identifier.
        if (data.lhs != .none) {
            try self.extractBindingNames(data.lhs, target_scope, binding_kind);
        }

        // rhs = initializer — visit for references.
        if (data.rhs != .none) {
            try self.visitNode(data.rhs);
        }
    }

    // ── Imports ────────────────────────────────────────────

    fn visitImportDecl(self: *SemanticAnalyzer, data: Node.Data) !void {
        if (data.lhs == .none) return;
        const import_data = self.ast.extraData(ImportData, @intFromEnum(data.lhs));
        const specifiers_range = SubRange{
            .start = import_data.specifiers_start,
            .end = import_data.specifiers_end,
        };
        try self.visitSubRange(specifiers_range);
    }

    fn visitImportSpecifier(self: *SemanticAnalyzer, idx: NodeIndex) !void {
        // import { x as y } — rhs = local name token.
        const data = self.ast.nodeData(idx);
        const local_token = @intFromEnum(data.rhs);
        const name = self.ast.tokenText(local_token);
        _ = try self.declareBinding(name, idx, .import_binding, self.current_scope);
    }

    fn visitImportDefaultSpecifier(self: *SemanticAnalyzer, idx: NodeIndex) !void {
        // import x — lhs = local name token.
        const data = self.ast.nodeData(idx);
        const local_token = @intFromEnum(data.lhs);
        const name = self.ast.tokenText(local_token);
        _ = try self.declareBinding(name, idx, .import_binding, self.current_scope);
    }

    fn visitImportNamespaceSpecifier(self: *SemanticAnalyzer, idx: NodeIndex) !void {
        // import * as x — lhs = local name token.
        const data = self.ast.nodeData(idx);
        const local_token = @intFromEnum(data.lhs);
        const name = self.ast.tokenText(local_token);
        _ = try self.declareBinding(name, idx, .import_binding, self.current_scope);
    }

    // ── Identifier references ──────────────────────────────

    fn visitIdentifier(self: *SemanticAnalyzer, idx: NodeIndex) !void {
        const name = self.ast.tokenText(self.ast.nodeMainToken(idx));
        const ref_id = try self.references.addReference(
            .read,
            idx,
            self.current_scope,
        );
        self.resolveReference(name, ref_id);
    }

    // ── Assignments ────────────────────────────────────────

    fn visitAssignment(self: *SemanticAnalyzer, data: Node.Data, kind: ReferenceKind) !void {
        // If the LHS is a simple identifier, create a write (or read_write) reference.
        if (data.lhs != .none and self.ast.nodeTag(data.lhs) == .identifier) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
            const ref_id = try self.references.addReference(
                kind,
                data.lhs,
                self.current_scope,
            );
            self.resolveReference(name, ref_id);
        } else {
            try self.visitNode(data.lhs);
        }
        try self.visitNode(data.rhs);
    }

    // ── Update expressions (++, --) ────────────────────────

    fn visitUpdateExpr(self: *SemanticAnalyzer, data: Node.Data) !void {
        if (data.lhs != .none and self.ast.nodeTag(data.lhs) == .identifier) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
            const ref_id = try self.references.addReference(
                .read_write,
                data.lhs,
                self.current_scope,
            );
            self.resolveReference(name, ref_id);
        } else {
            try self.visitNode(data.lhs);
        }
    }

    // ── typeof ─────────────────────────────────────────────

    fn visitTypeofExpr(self: *SemanticAnalyzer, data: Node.Data) !void {
        if (data.lhs != .none and self.ast.nodeTag(data.lhs) == .identifier) {
            const name = self.ast.tokenText(self.ast.nodeMainToken(data.lhs));
            const ref_id = try self.references.addReference(
                .type_of,
                data.lhs,
                self.current_scope,
            );
            self.resolveReference(name, ref_id);
        } else {
            try self.visitNode(data.lhs);
        }
    }

    // ── Try/catch ──────────────────────────────────────────

    fn visitTryStmt(self: *SemanticAnalyzer, data: Node.Data) !void {
        // lhs = try block, rhs = extra index to TryData
        try self.visitNode(data.lhs);
        const try_data = self.ast.extraData(TryData, @intFromEnum(data.rhs));
        // catch clause (which creates its own scope via visitCatchClause)
        if (try_data.catch_body != .none) {
            // Build a synthetic catch_clause visit: param + body.
            _ = try self.enterScope(.catch_clause, try_data.catch_body);
            if (try_data.catch_param != .none) {
                try self.extractBindingNames(try_data.catch_param, self.current_scope, .catch_param);
            }
            try self.visitNode(try_data.catch_body);
            self.leaveScope();
        }
        // finally block
        try self.visitNode(try_data.finally_body);
    }

    // ── Binding extraction (handles destructuring) ─────────

    /// Recursively extract binding names from a pattern node and declare
    /// each name in the given scope with the given binding kind.
    fn extractBindingNames(
        self: *SemanticAnalyzer,
        node: NodeIndex,
        scope: ScopeId,
        binding_kind: BindingKind,
    ) !void {
        if (node == .none or node == .root) return;

        const tag = self.ast.nodeTag(node);
        const data = self.ast.nodeData(node);

        switch (tag) {
            .identifier => {
                const name = self.ast.tokenText(self.ast.nodeMainToken(node));
                _ = try self.declareBinding(name, node, binding_kind, scope);
            },
            // TS type annotation wraps a binding: `x: Type` — extract from lhs
            .ts_type_annotation => {
                if (data.lhs != .none) try self.extractBindingNames(data.lhs, scope, binding_kind);
            },
            .array_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const items = self.ast.extraSlice(range);
                for (items) |raw| {
                    const elem: NodeIndex = @enumFromInt(raw);
                    try self.extractBindingNames(elem, scope, binding_kind);
                }
            },
            .object_pattern => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const items = self.ast.extraSlice(range);
                for (items) |raw| {
                    const prop: NodeIndex = @enumFromInt(raw);
                    if (prop == .none) continue;
                    const prop_tag = self.ast.nodeTag(prop);
                    const prop_data = self.ast.nodeData(prop);
                    switch (prop_tag) {
                        // { key: value } — value is the binding.
                        .property => {
                            try self.extractBindingNames(prop_data.rhs, scope, binding_kind);
                        },
                        // { x } shorthand — x is both key and binding.
                        .shorthand_property => {
                            try self.extractBindingNames(prop_data.lhs, scope, binding_kind);
                        },
                        // { [computed]: value } — value is the binding.
                        .computed_property => {
                            // Visit computed key for references.
                            try self.visitNode(prop_data.lhs);
                            try self.extractBindingNames(prop_data.rhs, scope, binding_kind);
                        },
                        // ...rest
                        .rest_element => {
                            try self.extractBindingNames(prop_data.lhs, scope, binding_kind);
                        },
                        else => {
                            try self.extractBindingNames(prop, scope, binding_kind);
                        },
                    }
                }
            },
            .assignment_pattern => {
                // target = default — declare the target, visit default for references.
                try self.extractBindingNames(data.lhs, scope, binding_kind);
                try self.visitNode(data.rhs);
            },
            .rest_element => {
                try self.extractBindingNames(data.lhs, scope, binding_kind);
            },
            else => {
                // Not a recognized pattern — skip to avoid infinite recursion.
                // TS-specific node types and other non-pattern nodes are ignored here.
            },
        }
    }

    // ── SubRange helpers ───────────────────────────────────

    fn visitSubRange(self: *SemanticAnalyzer, range: SubRange) !void {
        const items = self.ast.extraSlice(range);
        for (items) |raw| {
            const child: NodeIndex = @enumFromInt(raw);
            try self.visitNode(child);
        }
    }

    fn visitSubRangeFromData(self: *SemanticAnalyzer, data: Node.Data) !void {
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        try self.visitSubRange(range);
    }

    /// Read a SubRange stored at an extra_data index.
    /// The SubRange is encoded as two consecutive u32 values: start, end.
    fn readSubRange(self: *const SemanticAnalyzer, index: ExtraIndex) SubRange {
        return .{
            .start = self.ast.extra_data[index],
            .end = self.ast.extra_data[index + 1],
        };
    }
};
