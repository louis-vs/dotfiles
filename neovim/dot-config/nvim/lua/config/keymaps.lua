-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local silent = { silent = true }

-- Diagnostics
map("n", "gl", function()
  vim.diagnostic.open_float({ border = "rounded", max_width = 100, source = true })
end, silent)

-- Don't yank on delete char
map("n", "x", '"_x', silent)
map("n", "X", '"_X', silent)
map("v", "x", '"_x', silent)
map("v", "X", '"_X', silent)

-- tabs
map("n", "<leader>tl", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader>tf", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
