local javascriptFormatters = { { "prettierd", "prettier", "eslint" } }

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = javascriptFormatters,
    typescript = javascriptFormatters,
    javascriptreact = javascriptFormatters,
    typescriptreact = javascriptFormatters,
    ruby = { "rubocop" },
    eruby = { "erb-format" }
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
})
