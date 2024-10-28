require("copilot").setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "<C-S-p>",
      jump_next = "<C-S-n>",
      accept = "<CR>",
      refresh = "<Leader>rr",
      open = false,
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 50,
    keymap = {
      accept = "<C-CR>",
      accept_word = "<C-S-CR>",
      accept_line = false,
      next = "<C-S-n>",
      prev = "<C-S-p>",
      dismiss = "<C-S-c>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})
