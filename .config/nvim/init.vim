let mapleader=" "

" PLUGINS

" auto install vim-plug
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

" auto install missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" load plugins
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

if !has('nvim')
    " editorconfig
    Plug 'editorconfig/editorconfig-vim'
    " status bar
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " NERDTree file browser
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

    " nice vim plugins replaced with treesitter-smart ones:
    " bracket matching and auto-close
    Plug 'jiangmiao/auto-pairs'
    " close blocks in e.g. ruby, vimscript
    Plug 'tpope/vim-endwise'
endif

" basic syntax highlighting for all languages
Plug 'sheerun/vim-polyglot'

" rainbow brackets
Plug 'luochen1990/rainbow'

" extended csv support
Plug 'chrisbra/csv.vim'

" LaTeX
Plug 'lervag/vimtex'

" git support (using :Git)
Plug 'tpope/vim-fugitive'

" goyo, for distraction-free document editing
Plug 'junegunn/goyo.vim'
" close XML-style tags automatically
Plug 'alvan/vim-closetag'
" quickly surround text objects
Plug 'tpope/vim-surround'
" make '.' behave better with plugins
Plug 'tpope/vim-repeat'

" autoformat code
Plug 'sbdchd/neoformat'

" debugging within vim!
Plug 'puremourning/vimspector'

" fuzzyfinder!
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

if has('nvim')
    " smart code structure analysis
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " auto close brackets
    Plug 'windwp/nvim-autopairs'
    " auto close, rename XML-style tags
    Plug 'windwp/nvim-ts-autotag'
    " auto close blocks with 'end'
    Plug 'RRethy/nvim-treesitter-endwise'
    " better tabs
    "Plug 'romgrk/barbar.nvim'
    Plug 'nanozuki/tabby.nvim'
    " Kanagawa theme
    Plug 'rebelot/kanagawa.nvim'
    " statusline
    Plug 'nvim-lualine/lualine.nvim'
    " language servers
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    " completion
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    " snippets
    Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'rafamadriz/friendly-snippets'
    " nvim-tree file browser
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-tree/nvim-web-devicons'
endif

call plug#end()

" BASIC SETTINGS
set title
"set clipboard+=unnamedplus
set mouse=a
set go=a
set nowrap

" scrolling
set scrolloff=3

" autocompletion
set wildmode=longest,list,full

" spelling
set spelllang=en,cjk
autocmd FileType markdown setlocal spell
map <leader>s :set spell!<CR>
hi SpellBad ctermbg=88 

" indentation
set tabstop=4
set softtabstop=-1
set shiftwidth=0
set shiftround " round indentation to multiples of 'shiftwidth' when shifting
set expandtab
set smartindent
set breakindent " indent word-wrapped lines as much as parent line
filetype plugin indent on

" filetype-specific indentation
autocmd FileType make setlocal noexpandtab
autocmd FileType css setlocal tabstop=2
autocmd FileType rb setlocal tabstop=2

" indentation mappings
" maintain selection when indenting
vnoremap > >gv
vnoremap < <gv

" theming
function! LightTheme()
    set background=light
    hi Normal ctermfg=black ctermbg=white 
    hi LineNr ctermfg=grey ctermbg=237
    hi CursorLineNr ctermbg=241
    hi CursorLine cterm=NONE ctermbg=237
    hi ColorColumn ctermbg=236
endfunction
map <leader>tl :call LightTheme()<CR>

function! DarkTheme()
    set background=dark
    hi Normal ctermfg=white ctermbg=black 
    hi LineNr ctermfg=grey ctermbg=237
    hi SignColumn ctermfg=grey ctermbg=237
    hi CursorLineNr ctermbg=241
    hi CursorLine cterm=NONE ctermbg=237
    hi ColorColumn ctermbg=236
    hi Pmenu ctermbg=237 ctermfg=white
    hi PmenuSel ctermfg=242 ctermbg=0
    hi PmenuSbar ctermbg=248
    hi PmenuThumb ctermbg=237
endfunction
map <leader>td :call DarkTheme()<CR>

" line numbers and highlighting
function! s:goyo_leave()
    set number
    set scl=auto:1
    set numberwidth=5
    set cursorline
    set colorcolumn=101
    "call DarkTheme()
endfunction
call s:goyo_leave()

" TODO: refactor this mess slightly
function! s:goyo_enter()
    set noshowmode
endfunction

" shortcut split navigation
nor <C-h> <C-w>h
nor <C-j> <C-w>j
nor <C-k> <C-w>k
nor <C-l> <C-w>l
nor <C-S-h> <C-w>H
nor <C-S-j> <C-w>J
nor <C-S-k> <C-w>K
nor <C-S-l> <C-w>L

" word wrap
let s:wrap_enabled = 0
function! ToggleWrap()
    if s:wrap_enabled
        set nowrap
        set nolinebreak
        unmap j
        unmap k
        unmap 0
        unmap ^
        unmap $
        let s:wrap_enabled = 0
    else
        set wrap
        set linebreak
        nnoremap j gj
        nnoremap k gk
        nnoremap 0 g0
        nnoremap ^ g^
        nnoremap $ g$
        vnoremap j gj
        vnoremap k gk
        vnoremap 0 g0
        vnoremap ^ g^
        vnoremap $ g$
        let s:wrap_enabled = 1
    endif
endfunction
nor <leader>w :call ToggleWrap()<CR>

" word and character count
nor <leader>cw  :w !wc -w<CR>
nor <leader>cc  :w !wc -c<CR>
nor <leader>ctw :w !texcount -1 -<CR>

" autocommands relating to the neovim terminal
augroup neovim_terminal
    autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" PLUGIN SETTINGS

" VIM-only
if !has('nvim')
    " NERDTree
    map <leader>n :NERDTreeToggle<CR>
    let NERDTreeShowHidden=1
    " Exit Vim if NERDTree is the only window left.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
        \ quit | endif
    " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
    autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
        \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
    " Open the existing NERDTree on each new tab (this breaks with VimTeX autocompilation)
    " autocmd BufWinEnter * silent NERDTreeMirror
    
    let NERDTreeIgnore=['^.DS_Store$', '\~$']
    
    let g:NERDTreeGitStatusUseNerdFonts = 1
    
    " Airline
    let g:airline_theme='powerlineish'
    let g:airline_powerline_fonts = 1
endif

" rainbow brackets
let g:rainbow_active = 1

" autoformat code
nor <leader>fm :Neoformat<CR>
let g:neoformat_c_clangformat = {
            \ 'exe': 'clang-format',
            \ 'args': ['-assume-filename=' . expand('"%"'),
            \          '-style="{IndentWidth: 4, ColumnLimit: 100, BreakBeforeBraces: Allman }"'],
            \ 'stdin': 1,
            \ }

" Goyo
nor <leader>g :Goyo<CR>
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" vim-closetag
let g:closetag_filenames = '*.html,.xhtml,*.jsx,*.tsx,*.erb'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.erb'
let g:closetag_emptyTags_caseSensitive = 1

" VimTeX
let g:vimtex_view_method = 'skim'
"let g:vimtex_view_general_options = '--noraise --unique file:@pdf\#src:@line@tex'
let g:vimtex_compiler_progname = 'nvr' " Enable nvr for neovim to have backsearch (THIS NEEDS pip3 install neovim-remote)

" csv.vim
let g:csv_bind_B = 1

" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_base_dir = stdpath("config") . '/vimspector'

" NVIM plugin config
if has('nvim')
    " tabs with barbar
    "nor <silent>    gt <Cmd>BufferNext<CR>
    "nor <silent>    gT <Cmd>BufferPrevious<CR>
    "command Bc :BufferClose

    " if git commit is run in the integrated terminal, use nvr to edit commit
    " message
    let $GIT_EDITOR = 'nvr -cc split --remote-wait'
    " make sure that once the commit message buffer is hidden it is deleted
    " and you return to the commit
    autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

    " load lua options
    source <sfile>:h/config.lua

    " mappings
    nnoremap <silent> <leader>q <cmd>lua vim.lsp.buf.code_action()<CR>
endif

" CHADTree
"nor <leader>n <cmd>CHADopen<cr>
"let g:chadtree_settings = {
"    \"theme": {
"        \"text_colour_set": "nord",
"        \"icon_colour_set": "github"
"    \},
"    \"view": {
"        \"sort_by": ["is_folder", "file_name"],
"        \"width": 35
"    \}
"\}
" coq
" Set recommended to false
"let g:coq_settings = {
"    \"match.max_results": 5,
"    \"display.mark_highlight_group": "Pmenu",
"    \"display.preview.border": [ 
"        \["", "NormalFloat"],
"        \["", "NormalFloat"],
"        \["", "NormalFloat"],
"        \[" ", "NormalFloat"],
"        \["", "NormalFloat"],
"        \["", "NormalFloat"],
"        \["", "NormalFloat"],
"        \[" ", "NormalFloat"]
"    \],
"    \"keymap": {
"        \"recommended": v:false,
"        \"jump_to_mark": "<c-n>",
"        \"pre_select": v:true
"    \}
"\}

" coq keybindings
"nor <leader>a  :COQnow<CR>
"ino <silent><expr> <CR>    pumvisible() ? "\<C-e>\<CR>" : "\<CR>"
"ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
"ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
"ino <silent><expr> <BS>    pumvisible() ? "\<C-e>\<BS>"  : "\<BS>"
"ino <silent><expr> <Tab>   pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<Tab>"

" ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

" get around incompatibility with vim-endwise whilst allowing <CR> to break out 
" of coq suggestions
"inoremap <silent> <CR> <C-r>=<SID>coc_confirm()<CR>
"function! s:coc_confirm() abort
"  if pumvisible()
"    return "\<C-e>\<CR>"
"  else
"    return "\<CR>"
"  endif
"endfunction
