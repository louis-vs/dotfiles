local keymap = vim.keymap.set
local silent = { silent = true }


-- Keep visual mode indenting
keymap("v", "<", "<gv", silent)
keymap("v", ">", ">gv", silent)

-- Better window movement
keymap("n", "<C-h>", "<C-w>h", silent)
keymap("n", "<C-j>", "<C-w>j", silent)
keymap("n", "<C-k>", "<C-w>k", silent)
keymap("n", "<C-l>", "<C-w>l", silent)

-- Toggle wrap
keymap("n", "<Leader>w", ":set wrap!<CR>:set linebreak!<CR>", silent) -- TODO fix this to also use gj and gk instead of j and k


-- Don't yank on delete char
keymap("n", "x", '"_x', silent)
keymap("n", "X", '"_X', silent)
keymap("v", "x", '"_x', silent)
keymap("v", "X", '"_X', silent)

-- Quickfix navigation
keymap("n", "<Space>,", ":cp<CR>", silent)
keymap("n", "<Space>.", ":cn<CR>", silent)
--
-- Open links under cursor in browser with gx
if vim.fn.has('macunix') == 1 then
  keymap("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", silent)
else
  keymap("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape('<cWORD>')<CR>", silent)
end

-- Remove highlights
keymap("n", "<CR>", ":noh<CR><CR>", silent)

-- Find word/file across project
keymap("n", "<Leader>tf", "<CMD>Telescope find_files<CR>")
keymap("n", "<Leader>ts", "<CMD>Telescope grep_string<CR>")
keymap("n", "<Leader>tg", "<CMD>Telescope live_grep<CR>")
keymap("n", "<Leader>tt", "<CMD>Telescope<CR>")

-- Buffer shortcuts
keymap("n", "<Leader>bb", "<CMD>b#<CR>")


-- LSP
-- keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", silent) -- Replaced with Glance plugin
-- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>", silent) -- Replaced with Glance plugin
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("v", "<leader>ca", "<cmd>'<,'>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", silent)
keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", silent)
keymap("v", "<leader>cf", function()
  local start_row, _ = table.unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, _ = table.unpack(vim.api.nvim_buf_get_mark(0, ">"))

	vim.lsp.buf.format({
		range = {
			["start"] = { start_row, 0 },
			["end"] = { end_row, 0 },
		},
		async = true,
	})
end, silent)
keymap("n", "<leader>cl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)
keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)
keymap("n", "L", "<cmd>lua vim.lsp.buf.signature_help()<CR>", silent)
keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next({ float = { border = 'rounded', max_width = 100 }})<CR>", silent)
keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'rounded', max_width = 100 }})<CR>", silent)
keymap("n", "K", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end)
