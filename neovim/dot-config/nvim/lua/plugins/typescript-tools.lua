local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = "rounded",
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

require("typescript-tools").setup({
  handlers = handlers,
  settings = {
    separate_diagnostic_server = true,
    complete_function_calls = true,
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeCompletionsForModuleExports = true,
      quotePreference = "auto",
    },
    tsserver_plugins = {
      "@styled/typescript-styled-plugin",
    },
    jsx_close_tag = {
      enable = true,
    }
  },
})
