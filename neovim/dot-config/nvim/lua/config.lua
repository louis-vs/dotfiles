require('lualine').setup {}

require('kanagawa').setup {}

-- kanagawa setup must be called before loading
vim.cmd("colorscheme kanagawa")

require("nvim-autopairs").setup {}

require('nvim-treesitter.configs').setup {
    auto_install = true,
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

require('nvim-tree').setup {
    sync_root_with_cwd = true,
    filters = {
        git_ignored = false,
        custom = {  '^.DS_Store$' },
    },
    update_focused_file = {
        enable = true,
    }
}
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>NvimTreeToggle<CR>', { noremap = true })

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
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        -- super tab (selection and jump)
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm { select = true }
            elseif luasnip.jumpable(1) then
                luasnip.jump(1)
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
  window = {
    documentation = cmp.config.window.bordered()
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

-- automatic refactoring
--require('refactoring').setup()

-- better looking tabline
require('tabby.tabline').use_preset('active_wins_at_tail', { })

-- manage language servers
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {
        "clangd",
        "lua_ls",
        "tsserver",
        "eslint",
    },
    automatic_installation = true,
}

-- configure language servers
-- make sure to advertise completion capabilities to LSPs
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- add folding capabilities (with ufo)
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
        }
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    ["clangd"] = function ()
        require("lspconfig").clangd.setup {
            capabilities = capabilities,
            cmd = { 'clangd', '--enable-config' },
        }
    end,
    ["lua_ls"] = function ()
        require'lspconfig'.lua_ls.setup {
            capabilities = capabilities,
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
    ["tsserver"] = function ()
        require'lspconfig'.tsserver.setup {
            capabilities = capabilities,
            settings = {
                typescript = {
                    indentSize = vim.o.shiftwidth,
                    convertTabsToSpaces = vim.o.expandtab,
                    tabSize = vim.o.tabstop,
                    inlayHints = {
                        includeInlayParameterNameHints = "literal",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = false,
                        includeInlayVariableTypeHints = false,
                        includeInlayPropertyDeclarationTypeHints = false,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
                javascript = {
                    indentSize = vim.o.shiftwidth,
                    convertTabsToSpaces = vim.o.expandtab,
                    tabSize = vim.o.tabstop,
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
                completions = {
                    completeFunctionCalls = true,
                }
            }
        }
    end,
}

-- see :help lspconfig-keybindings
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- NB see :help lsp-defaults
        -- it is not necessary to rebind gd/gD, K, etc.
        local opts = { silent = true, noremap = true, buffer = ev.buf }
        vim.keymap.set('n', '<leader>q', function()
            vim.lsp.buf.code_action { apply = true }
        end, opts)
        vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>R', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>T', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>F', vim.lsp.buf.format, opts)
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

        vim.o.scl = 'yes:1'
    end,
})

-- diagnostics
vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
}


require('obsidian').setup {
    dir = '~/MEGA/NOTES',
    notes_subdir = '+working',
    completion = {
        nvim_cmp = true,
        -- Trigger completion at 2 chars
        min_chars = 2,
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = 'notes_subdir',

        -- Whether to add the output of the node_id_func to new notes in autocompletion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        prepend_note_id = false,
    },
    open_app_foreground = true,
}

-- ufo folding
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true


-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Option 2: nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually (see above)
require('ufo').setup()
