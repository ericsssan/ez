#!/usr/bin/env node
"use strict";
/**
 * ez-language-server — LSP server for ez linter
 *
 * Start via:
 *   ez-language-server          (direct binary)
 *   ez lsp                      (subcommand)
 *
 * Transport: stdio JSON-RPC 2.0
 *
 * Editor config examples:
 *
 *   Neovim (nvim-lspconfig):
 *     require("lspconfig").ez.setup({
 *       cmd = { "ez-language-server" },
 *       filetypes = { "javascript", "typescript", "jsx", "tsx" },
 *     })
 *
 *   VS Code (tasks.json / extension):
 *     command: "ez-language-server"
 *     transport: "stdio"
 *
 *   Helix (languages.toml):
 *     [language-server.ez]
 *     command = "ez-language-server"
 */

require("../js/lsp-server");
