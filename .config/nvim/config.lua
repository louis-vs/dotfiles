require('lualine').setup {}

require('kanagawa').setup {}

-- kanagawa setup must be called before loading
vim.cmd("colorscheme kanagawa")

require("nvim-autopairs").setup {}

require('nvim-treesitter.configs').setup {
    autotag = {
        enable = true,
    },
    endwise = {
        enable = true,
    },
}

-- disable netrw for nvim-tree
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup()
local nvim_tree = require("nvim-tree.api")
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>NvimTreeToggle<CR>', { noremap = true })

-- installing language servers
require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").clangd.setup {
    cmd = { 'clangd', '--enable-config' }
}

local cmp = require('cmp')
cmp.setup {
    sources = cmp.config.sources({
            { name = 'nvim_lsp' },
        }, {
            { name = 'buffer' },
        }
    ),
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                end
                cmp.confirm()
            else
                fallback()
            end
        end, {"i","s",}),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
  },
}

-- Set cmp configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = 'buffer' },
    })
})

-- better tabs
require('tabby.tabline').use_preset('active_wins_at_tail', { })
