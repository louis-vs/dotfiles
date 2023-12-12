local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = "rounded",
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

require("typescript-tools").setup({
  --on_attach = function(client, bufnr)
  --  if vim.fn.has("nvim-0.10") then
  --    -- Enable inlay hints
  --    vim.lsp.inlay_hint(bufnr, true)
  --  end
  --end,
  handlers = handlers,
  settings = {
    separate_diagnostic_server = true,
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
      enable = false,
    }
  },
})
