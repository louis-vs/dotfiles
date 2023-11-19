local git_icons = {
	unstaged = "",
	staged = "",
	unmerged = "",
	renamed = "➜",
	untracked = "",
	deleted = "",
	ignored = "◌",
}

require("nvim-tree").setup({
	-- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
	sync_root_with_cwd = true,
	--false by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree
	respect_buf_cwd = false,
	-- show lsp diagnostics in the signcolumn
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	renderer = {
		group_empty = true,
		highlight_git = true,
		highlight_opened_files = "none",
		--root_folder_label = ":~",
		indent_markers = {
			enable = false,
			icons = {
				corner = "└ ",
				edge = "│ ",
				none = "  ",
			},
		},
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
				modified = true,
			},
			glyphs = {
				git = git_icons,
			},
		},
	},
	-- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
	update_focused_file = {
		-- enables the feature
		enable = true,
		-- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
		-- only relevant when `update_focused_file.enable` is true
		update_root = false,
		-- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
		-- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
		ignore_list = {},
	},
	filters = {
        git_ignored = false,
		dotfiles = false,
		custom = { '^.DS_Store$' },
	},
	view = {
		-- width of the window, can be either a number (columns) or a string in `%`
		width = 30,
		-- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
		side = "left",
		number = false,
		relativenumber = false,
	},
})

vim.api.nvim_set_keymap(
    'n',
    '<leader>n',
    '<cmd>NvimTreeToggle<CR>',
    { noremap = true, silent = true })
