require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { { "prettierd", "prettier", "eslint" } },
    ruby = { "rubocop" },
    eruby = { "erb-format" }
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
})
