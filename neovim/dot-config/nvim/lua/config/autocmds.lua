-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable autoformat for some files
--vim.api.nvim_create_autocmd({ "BufEnter" }, {
--  pattern = { "options.lua" },
--  callback = function()
--    vim.b.autoformat = false
--  end,
--})

-- Disable highlight on yank
vim.api.nvim_create_augroup("lazyvim_highlight_yank", { clear = true })

-- Disable highlight of inline code blocks
-- (I can't work out a better way of doing this)
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "markdown",
  command = "hi @markup.raw.markdown_inline ctermbg=none guibg=none",
})

-- enable highlight colors
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "javascript", "typescript", "css", "html" },
  command = "HighlightColors On",
})

-- Disable copilot in certain folders
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { vim.fn.expand("~") .. "/Work/Faculty/*" },
  command = "Copilot disable",
})
