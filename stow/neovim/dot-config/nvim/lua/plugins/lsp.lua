return {
  "neovim/nvim-lspconfig",
  opts = {
    document_highlight = { enabled = false },
    inlay_hints = { enabled = false },
    servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off",
            },
          },
        },
      },
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand("~/Library/asdf/shims/ruby-lsp") },
      },
      rubocop = {
        mason = false,
        cmd = { vim.fn.expand("~/Library/asdf/shims/rubocop"), "--lsp" },
      },
    },
  },
}
