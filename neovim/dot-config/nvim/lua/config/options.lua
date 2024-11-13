-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options hereby
local opt = vim.opt
opt.clipboard      = ""
opt.completeopt    = "menu,menuone,noselect" --- Better autocompletion
opt.cursorline     = true                    --- Highlight of current line
opt.colorcolumn    = '101'
opt.emoji          = false                   --- Fix emoji display
opt.foldlevel      = 99                      --- Using ufo provider need a large value
opt.foldlevelstart = 99                      --- Expand all folds by default
opt.ignorecase     = true                    --- Needed for smartcase
opt.smartcase      = true                    --- Uses case in search when you type a capital
opt.laststatus     = 2                       --- Have a global statusline at the bottom instead of one for each window
opt.mouse          = "a"                     --- Enable mouse
opt.number         = true                    --- Shows current line number
opt.numberwidth    = 5
opt.pumheight      = 10                      --- Max num of items in completion menu
opt.relativenumber = false                    --- Enables relative number
opt.scrolloff      = 4                       --- Always keep space when scrolling to bottom/top edge
opt.smoothscroll   = true                    --- Scroll smoothly when possible
opt.showtabline    = 2                       --- Always show tabs
opt.sidescrolloff  = 8                       --- Always keep space when scrolling to side edge
opt.signcolumn     = "yes:1"                 --- Add extra sign column next to line number
opt.expandtab      = true                    --- Use spaces instead of tabs
opt.smartindent    = true                    --- Makes indenting smart
opt.smarttab       = true                    --- Makes tabbing smarter will realize you have 2 vs 4
opt.tabstop        = 4                       --- Insert 4 spaces for a tab
opt.shiftwidth     = 0                       --- Use tabstop value when shifting with >> <<
opt.softtabstop    = -1                      --- Insert spaces for tab per shiftwidth
opt.splitright     = true                    --- Vertical splits will automatically be to the right
--swapfile       = false                   --- Swap not needed
opt.termguicolors  = true                    --- Correct terminal colors
opt.undofile       = true                    --- Sets undo to file
opt.updatetime     = 100                     --- Faster completion
opt.viminfo        = "'1000"                 --- Increase the size of file history
opt.wildignore     = "*node_modules/**"      --- Don't search inside Node.js modules (works for gutentag)
opt.wrap           = false                   --- Display long lines as just one line
opt.conceallevel   = 2
opt.concealcursor  = ""                      --- Set to an empty string to expand tailwind class when on cursorline 
opt.incsearch      = true                    --- Start searching before pressing enter

vim.g.lazyvim_picker = "telescope"
vim.g.autoformat = false
