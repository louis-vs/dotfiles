return {
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "<C-S-p>",
          jump_next = "<C-S-n>",
          accept = "<CR>",
          refresh = "<Leader>rr",
          open = false,
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 50,
        keymap = {
          accept = "<C-CR>",
          accept_word = "<C-S-CR>",
          accept_line = false,
          next = "<C-S-n>",
          prev = "<C-S-p>",
          dismiss = "<C-S-c>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node", -- Node.js version must be > 18.x
      server_opts_overrides = {},
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local colors = {
        [""] = LazyVim.ui.fg("Special"),
        ["Normal"] = LazyVim.ui.fg("Special"),
        ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
        ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
      }
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local icon = LazyVim.config.icons.kinds.Copilot
          local status = require("copilot.api").status.data
          return icon .. (status.message or "")
        end,
        cond = function()
          if not package.loaded["copilot"] then
            return
          end
          local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
          if not ok then
            return false
          end
          return ok and #clients > 0
        end,
        color = function()
          if not package.loaded["copilot"] then
            return
          end
          local status = require("copilot.api").status.data
          return colors[status.status] or colors[""]
        end,
      })
    end,
  },
}
