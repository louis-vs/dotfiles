return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      "jq",
      prettier = {
        disabled_filetypes = { "json" }, -- Disable prettier for JSON
      },
    },
    formatters_by_ft = {
      json = { "jq" },
    },
  },
}
