-- Setup installer & lsp configs
local mason_ok, mason = pcall(require, "mason")
local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")

if not mason_ok or not mason_lsp_ok then
  return
end

mason.setup({
  ui = {
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = "rounded",
  },
})

mason_lsp.setup({
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = {
    "clangd",
    "bashls",
    "cssls",
    "tsserver",
    "eslint",
    "graphql",
    "html",
    "jsonls",
    "lua_ls",
    "prismals",
    "ruby_ls",
  },
  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
  --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  automatic_installation = true,
})

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = "rounded",
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

local function on_attach(client, bufnr)
  -- set up buffer keymaps, etc.
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- needed for UFO lsp folding to work
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

mason_lsp.setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
        }
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    ["clangd"] = function ()
        require("lspconfig").clangd.setup {
            on_attach = on_attach,
            capabilitieUfoCursorFoldedLines = capabilities,
            cmd = { 'clangd', '--enable-config' },
        }
    end,
    ["lua_ls"] = function ()
        require'lspconfig'.lua_ls.setup{
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
            settings = require("lsp.servers.lua_ls").settings,
        }
    end,
    ["eslint"] = function ()
        require'lspconfig'.eslint.setup {
            capabilities = capabilities,
            handlers = handlers,
            on_attach = require("lsp.servers.eslint").on_attach,
            settings = require("lsp.servers.eslint").settings,
        }
    end,
    ["jsonls"] = function ()
        require'lspconfig'.jsonls.setup {
            capabilities = capabilities,
            handlers = handlers,
            on_attach = on_attach,
            settings = require("lsp.servers.jsonls").settings,
        }
    end,
    ["tsserver"] = function () end, -- leave config to typescript-tools
}

-- ufo must be setup after lsp

local function ufo_config_handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0

  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end

  table.insert(newVirtText, { suffix, 'MoreMsg' })

  return newVirtText
end

require("ufo").setup {
  fold_virt_text_handler = ufo_config_handler,
  --close_fold_kinds = { "imports" },
}
