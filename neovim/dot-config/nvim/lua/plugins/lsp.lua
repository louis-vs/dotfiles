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
    },
  },
}
