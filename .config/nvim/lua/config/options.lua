local options = {
  --clipboard      = "unnamed,unnamedplus",   --- Copy-paste between vim and everything else
  cmdheight      = 0,                       --- Give more space for displaying messages
  completeopt    = "menu,menuone,noselect", --- Better autocompletion
  cursorline     = true,                    --- Highlight of current line
  colorcolumn    = '101',
  emoji          = false,                   --- Fix emoji display
  -- don't think i need these?
  --foldcolumn     = "0",
  --foldnestmax    = 0,
  --foldlevel      = 99,                      --- Using ufo provider need a large value
  foldlevelstart = 99,                      --- Expand all folds by default
  ignorecase     = true,                    --- Needed for smartcase
  smartcase      = true,                    --- Uses case in search when you type a capital
  --laststatus     = 3,                       --- Have a global statusline at the bottom instead of one for each window
  mouse          = "a",                     --- Enable mouse
  number         = true,                    --- Shows current line number
  numberwidth    = 5,
  pumheight      = 10,                      --- Max num of items in completion menu
  relativenumber = true,                    --- Enables relative number
  scrolloff      = 3,                       --- Always keep space when scrolling to bottom/top edge
  smoothscroll   = true,                    --- Scroll smoothly when possible
  showtabline    = 2,                       --- Always show tabs
  signcolumn     = "yes:2",                 --- Add extra sign column next to line number
  expandtab      = true,                    --- Use spaces instead of tabs
  smartindent    = true,                    --- Makes indenting smart
  smarttab       = true,                    --- Makes tabbing smarter will realize you have 2 vs 4
  tabstop        = 4,                       --- Insert 4 spaces for a tab
  shiftwidth     = 0,                       --- Use tabstop value when shifting with >> <<
  softtabstop    = -1,                      --- Insert spaces for tab per shiftwidth
  splitright     = true,                    --- Vertical splits will automatically be to the right
  --swapfile       = false,                   --- Swap not needed
  termguicolors  = true,                    --- Correct terminal colors
  timeoutlen     = 500,                     --- Faster completion (cannot be lower than 200 because then commenting doesn't work)
  undofile       = true,                    --- Sets undo to file
  updatetime     = 100,                     --- Faster completion
  viminfo        = "'1000",                 --- Increase the size of file history
  wildignore     = "*node_modules/**",      --- Don't search inside Node.js modules (works for gutentag)
  wrap           = false,                   --- Display long lines as just one line
  --writebackup    = false,                   --- Not needed
  -- Neovim defaults
  --autoindent     = true,                    --- Good auto indent
  --backspace      = "indent,eol,start",      --- Making sure backspace works
  --backup         = false,                   --- Recommended by coc
  --- Concealed text is completely hidden unless it has a custom replacement character defined (needed for dynamically showing tailwind classes)
  conceallevel   = 2,
  concealcursor  = "",                      --- Set to an empty string to expand tailwind class when on cursorline 
  encoding       = "utf-8",                 --- The encoding displayed
  --errorbells     = false,                   --- Disables sound effect for errors
  fileencoding   = "utf-8",                 --- The encoding written to file
  incsearch      = true,                    --- Start searching before pressing enter
  --showmode       = false,                   --- Don't show things like -- INSERT -- anymore
}

local globals = {
  mapleader                   = ' ',        --- Map leader key to SPC
  --maplocalleader              = ',',        --- Map local leader key to comma
  --speeddating_no_mappings     = 1,          --- Disable default mappings for speeddating
}

--vim.opt.shortmess:append('c');
--vim.opt.formatoptions:remove('c');
--vim.opt.formatoptions:remove('r');
vim.opt.formatoptions:remove('o');
-- remove statusline clutter
--vim.opt.fillchars:append('stl: ');
--vim.opt.fillchars:append('eob: ');
--vim.opt.fillchars:append('fold: ');
--vim.opt.fillchars:append('foldopen: ');
--vim.opt.fillchars:append('foldsep: ');
--vim.opt.fillchars:append('foldclose:');


for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end
