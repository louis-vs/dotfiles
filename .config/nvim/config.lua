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
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>NvimTreeToggle<CR>', { noremap = true })

-- installing language servers
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "clangd", "lua_ls" },
    automatic_installation = true,
}

require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    ["clangd"] = function ()
        require("lspconfig").clangd.setup {
            cmd = { 'clangd', '--enable-config' }
        }
    end,
    ["lua_ls"] = function ()
        require'lspconfig'.lua_ls.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }
    end,
}

-- load snippets from friendly-snippets into luasnip
require("luasnip.loaders.from_vscode").lazy_load()
local luasnip = require("luasnip")

-- completion icons for LSP properties
local kind_icons = {
  Text = "󰉿",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
  Field = " ",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
  Snippet = "",
	Color = "󰏘",
	File = "󰈙",
  Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
  Struct = "",
	Event = "",
	Operator = "󰆕",
  TypeParameter = " ",
	Misc = " ",
}

local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    sources = cmp.config.sources ({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    }),
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        -- super tab (selection and jump)
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm { select = true }
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            --elseif check_backspace() then
            --    fallback()
            else
                fallback()
            end
        end, { "i", "s", }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s", }),
  },
  formatting = {
      format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
          -- Source
          vim_item.menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  nvim_lua = "[Lua]",
                  latex_symbols = "[LaTeX]",
              })[entry.source.name]
          return vim_item
      end
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
