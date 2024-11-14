-- replacement for VSCode peek to see definitions etc. at a glance
return {
  {
    "dnlhc/glance.nvim",
    config = true,
    cmd = { "Glance" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()
      vim.list_extend(Keys, {
        { "gd", "<cmd>Glance definitions<CR>", desc = "Goto Definition", has = "definition" },
        { "gr", "<cmd>Glance references<CR>", desc = "References" },
        { "gm", "<cmd>Glance implementations<CR>", desc = "Goto I[m]plementation" },
        { "gy", "<cmd>Glance type_definitions<CR>", desc = "Goto T[y]pe Definition" },
      })
    end,
  },
}
