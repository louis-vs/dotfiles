return {
  "neovim/nvim-lspconfig",
  opts = {
    document_highlight = { enabled = false },
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
