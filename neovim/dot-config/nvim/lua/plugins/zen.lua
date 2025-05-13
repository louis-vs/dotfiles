return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    {
      "<leader>uz",
      "<cmd>ZenMode<CR>",
      desc = "Enter Zen Mode",
    },
  },
  opts = {
    window = {
      backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
      -- height and width can be:
      -- * an absolute number of cells when > 1
      -- * a percentage of the width / height of the editor when <= 1
      -- * a function that returns the width or the height
      width = 120, -- width of the Zen window
      height = 1, -- height of the Zen window
      -- by default, no options are changed for the Zen window
      -- uncomment any of the options below, or add other vim.wo options you want to apply
      options = {
        signcolumn = "no",
        number = false,
        -- relativenumber = false,
        -- cursorline = false,
        -- cursorcolumn = false,
        colorcolumn = "",
        foldcolumn = "0",
        -- list = false, -- disable whitespace characters
        wrap = true,
        linebreak = true,
      },
    },
    plugins = {
      -- disable some global vim options (vim.o...)
      -- comment the lines to not apply the options
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        showcmd = false, -- disables the command in the last line of the screen
        -- you may turn on/off statusline in zen mode by setting 'laststatus'
        -- statusline will be shown only if 'laststatus' == 3
        laststatus = 0, -- turn off the statusline in zen mode
      },
      twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
      gitsigns = { enabled = false }, -- disables git signs
      tmux = { enabled = false }, -- disables the tmux statusline
      todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
      -- this will change the font size on alacritty when in zen mode
      -- requires  Alacritty Version 0.10.0 or higher
      -- uses `alacritty msg` subcommand to change font size
      alacritty = {
        enabled = false,
        font = "14", -- font size
      },
    },
    -- callback where you can add custom code when the Zen window opens
    --on_open = function()
    --  vim.keymap.set({ "n", "v" }, "j", "gj", { silent = true })
    --  vim.keymap.set({ "n", "v" }, "k", "gk", { silent = true })
    --  vim.keymap.set({ "n", "v" }, "0", "g0", { silent = true })
    --  vim.keymap.set({ "n", "v" }, "^", "g^", { silent = true })
    --  vim.keymap.set({ "n", "v" }, "$", "g$", { silent = true })
    --end,
    -- callback where you can add custom code when the Zen window closes
    --on_close = function()
    --  vim.keymap.del({ "n", "v" }, "j")
    --  vim.keymap.del({ "n", "v" }, "k")
    --  vim.keymap.del({ "n", "v" }, "0")
    --  vim.keymap.del({ "n", "v" }, "^")
    --  vim.keymap.del({ "n", "v" }, "$")
    --end,
  },
}
