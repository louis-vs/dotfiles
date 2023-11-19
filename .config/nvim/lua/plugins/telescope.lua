local actions    = require('telescope.actions')
local previewers = require('telescope.previewers')
local builtin    = require('telescope.builtin')

require('telescope').load_extension('fzf')
require('telescope').load_extension('repo')
--require('telescope').load_extension('git_worktree')

local git_icons = {
  added = "",
  changed = "󰏬",
  copied = ">",
  deleted = "",
  renamed = "➡",
  unmerged = "‡",
  untracked = "?",
}

require('telescope').setup {
  defaults = {
    border            = true,
    hl_result_eol     = true,
    multi_icon        = '',
    vimgrep_arguments = { },
    layout_config     = {
      horizontal = {
        preview_cutoff = 120,
      },
      prompt_position = "top",
    },
    file_sorter       = require('telescope.sorters').get_fzy_sorter,
    prompt_prefix     = '  ',
    color_devicons    = true,
    git_icons         = git_icons,
    sorting_strategy  = "ascending",
    file_previewer    = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer    = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer  = require('telescope.previewers').vim_buffer_qflist.new,
    mappings          = {
      i = {
        -- ["<C-h>"] = "which_key",
      },
      n = { }
    }
  },
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}

