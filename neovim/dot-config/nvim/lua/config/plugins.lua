return {
  -- Themes
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      require('kanagawa').setup {
        overrides = function (colors)
          return {
            RainbowDelimeterRed = { fg = colors.palette.autumnRed },
            RainbowDelimeterYellow = { fg = colors.palette.carpYellow },
            RainbowDelimeterBlue = { fg = colors.palette.dragonBlue },
            RainbowDelimeterOrange = { fg = colors.palette.surimiOrange },
            RainbowDelimeterGreen = { fg = colors.palette.springGreen },
            RainbowDelimeterViolet = { fg = colors.palette.oniViolet },
            RainbowDelimeterCyan = { fg = colors.palette.waveAqua1 },
            EndOfBuffer = { link = 'Whitespace' },
          }
        end,
      }

      vim.cmd("colorscheme kanagawa")
    end,
  },
  -- common dependency
  { "nvim-lua/plenary.nvim" },

  -- cool icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    config = function()
      require("plugins.treesitter")
    end,
    dependencies = {
      "hiphish/rainbow-delimiters.nvim",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
    },
  },

  -- rainbows!
  {
    "hiphish/rainbow-delimiters.nvim",
    main = "rainbow-delimiters.setup",
    opts = {
      highlight = {
        --'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    },
  },

  -- Navigating (Telescope/Tree/Refactor)
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    config = function()
      require("plugins.telescope")
    end,
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "cljoly/telescope-repo.nvim" },
    },
  },

  -- file browsing
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeOpen",
      "NvimTreeClose",
      "NvimTreeToggle",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
    },
    keys = {
      { "<leader>n", "<cmd>lua require('nvim-tree.api').tree.toggle()<CR>", desc = "NvimTree" },
    },
    config = function()
      require("plugins.tree")
    end,
  },

  -- keep cursor in same place when using >, <, = and maintain selection
  {
    "gbprod/stay-in-place.nvim",
    lazy = false,
    config = true,
  },

  -- LSP Base
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>/m", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },

  -- LSP Cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("plugins.cmp")
    end,
    dependencies = {
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "zbirenbaum/copilot-cmp",
      -- snippets
      "saadparwaiz1/cmp_luasnip",
      {
          "L3MON4D3/LuaSnip",
          -- follow latest release.
          version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
          -- install jsregexp (optional!).
          --build = "make install_jsregexp", -- this is bugged until my PR gets merged
          dependencies = "rafamadriz/friendly-snippets",
      },
      {
        "David-Kunz/cmp-npm",
        config = true,
      },
      "petertriho/cmp-git",
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
  },

  -- LSP Addons
  {
    "pmizio/typescript-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("plugins.typescript-tools")
    end,
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("plugins.conform")
    end,
    keys = {
      {
        "<leader>cf",
        function()
          require'conform'.format({async = true})
        end,
        desc = "Format buffer" }
    }
  },

  -- replacement for VSCode peek to see definitions etc. at a glance
  {
    "dnlhc/glance.nvim",
    config = true,
    cmd = { "Glance" },
    keys = {
      { "gd", "<cmd>Glance definitions<CR>",      desc = "LSP Definition" },
      { "gr", "<cmd>Glance references<CR>",       desc = "LSP References" },
      { "gm", "<cmd>Glance implementations<CR>",  desc = "LSP Implementations" },
      { "gy", "<cmd>Glance type_definitions<CR>", desc = "LSP Type Definitions" },
    },
  },

  -- auto refactor when you move things in nvim-tree
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-tree.lua" },
    },
    config = function()
      require("lsp-file-operations").setup()
    end
  },

  -- General
  -- auto commenting
  --{
  --  "numToStr/Comment.nvim",
  --  lazy = false,
  --  dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
  --  config = true,
  --},
  -- TODO better terminal
  --{
  --  "akinsho/toggleterm.nvim",
  --  lazy = false,
  --  branch = "main",
  --  config = function()
  --    require("plugins.toggleterm")
  --  end,
  --  keys = {
  --    { "<Leader>at", "<cmd>ToggleTerm direction=float<CR>", desc = "terminal float" }
  --  }
  --},
  -- make '.' behave better with plugins
  { "tpope/vim-repeat",           lazy = false },
  -- make <C-A> <C-X> work on dates
  { "tpope/vim-speeddating",      lazy = false },
  -- easily make markdown tables
  --{ "dhruvasagar/vim-table-mode", ft = { "markdown" } },
  {
    "folke/todo-comments.nvim",
    lazy = false,
    event = "BufEnter",
    config = function()
      require("plugins.todo-comments")
    end,
  },
  -- TODO better nvim-specific version of Goyo
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    config = function()
      require("plugins.zen")
    end,
  },
  -- find new keybindings!
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- better statusline
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- don't fuck up window layout after bdel etc.
  {
    "echasnovski/mini.bufremove",
    version = "*", -- change to false for latest
    config = function()
      require("mini.bufremove").setup {
        set_vim_settings = false,
      }
    end,
    keys = {
      { "<Leader>bd", "<cmd>lua MiniBufremove.delete<CR>", desc = "unshow and delete current buffer" },
    },
  },
  -- notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup{ }
    end,
    init = function()
      local banned_messages = {
        "No information available",
        "LSP[tsserver] Inlay Hints request failed. Requires TypeScript 4.4+.",
        "LSP[tsserver] Inlay Hints request failed. File not opened in the editor.",
      }
      vim.notify = function(msg, ...)
        for _, banned in ipairs(banned_messages) do
          if msg == banned then
            return
          end
        end
        return require("notify")(msg, ...)
      end
    end,
  },
  -- a wrapper around neovim :mksession
  -- call with <Leader>/s_ commands
  {
    "Shatur/neovim-session-manager",
    lazy = false,
    config = function()
      require("plugins.session-manager")
    end,
    keys = {
      { "<Leader>/sc", "<cmd>SessionManager load_session<CR>",             desc = "choose session" },
      { "<Leader>/sr", "<cmd>SessionManager delete_session<CR>",           desc = "remove session" },
      { "<Leader>/sd", "<cmd>SessionManager load_current_dir_session<CR>", desc = "load current dir session" },
      { "<Leader>/sl", "<cmd>SessionManager load_last_session<CR>",        desc = "load last session" },
      { "<Leader>/ss", "<cmd>SessionManager save_current_session<CR>",     desc = "save session" },
    },
  },
  -- lua version of Tim Pope's classic plugin
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true,
  },
  -- fancy folds (note that setup is called manually in lsp.config)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = false,
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "open all folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "close count folds" },
    },
  },
  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
      require("plugins.indent")
    end,
  },

  -- Snippets & Language & Syntax
  -- auto close brackets with TS
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.autopairs")
    end,
  },
  -- fast highlighting
  {
    "NvChad/nvim-colorizer.lua",
    config = true,
  },
  -- add tailwind colours to cmp results
  --{
  --  "js-everts/cmp-tailwind-colors",
  --  config = true,
  --},
  -- auto fold long class attributes
  --{
  --  "razak17/tailwind-fold.nvim",
  --  opts = {
  --    min_chars = 50,
  --  },
  --  dependencies = { "nvim-treesitter/nvim-treesitter" },
  --  ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  --},
  {
    "NMAC427/guess-indent.nvim",
    config = true,
  },

  -- Git
  -- togglable git highlighting and virtual text
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.gitsigns")
    end,
    keys = {
      { "<Leader>ghd", desc = "diff hunk" },
      { "<Leader>ghp", desc = "preview" },
      { "<Leader>ghR", desc = "reset buffer" },
      { "<Leader>ghr", desc = "reset hunk" },
      { "<Leader>ghs", desc = "stage hunk" },
      { "<Leader>ghS", desc = "stage buffer" },
      { "<Leader>ght", desc = "toggle deleted" },
      { "<Leader>ghu", desc = "undo stage" },
    }
  },

  -- Testing TODO
  --{
  --  "rcarriga/neotest",
  --  dependencies = {
  --    "nvim-lua/plenary.nvim",
  --    "nvim-treesitter/nvim-treesitter",
  --    "antoinemadec/FixCursorHold.nvim",
  --    "haydenmeade/neotest-jest",
  --  },
  --  config = function()
  --    require("plugins.neotest")
  --  end,
  --},
  --{
  --  "andythigpen/nvim-coverage",
  --  dependencies = "nvim-lua/plenary.nvim",
  --  cmd = {
  --    "Coverage",
  --    "CoverageSummary",
  --    "CoverageLoad",
  --    "CoverageShow",
  --    "CoverageHide",
  --    "CoverageToggle",
  --    "CoverageClear",
  --  },
  --  config = function()
  --    require("coverage").setup()
  --  end,
  --},

  -- DAP TODO
  --{
  --  "mfussenegger/nvim-dap",
  --  config = function()
  --    require("plugins.dap")
  --  end,
  --  keys = {
  --    "<Leader>da",
  --    "<Leader>db",
  --    "<Leader>dc",
  --    "<Leader>dd",
  --    "<Leader>dh",
  --    "<Leader>di",
  --    "<Leader>do",
  --    "<Leader>dO",
  --    "<Leader>dt",
  --  },
  --  dependencies = {
  --    "theHamsta/nvim-dap-virtual-text",
  --    "rcarriga/nvim-dap-ui",
  --    "mxsdev/nvim-dap-vscode-js",
  --  },
  --},
  --{
  --  "LiadOz/nvim-dap-repl-highlights",
  --  config = true,
  --  dependencies = {
  --    "mfussenegger/nvim-dap",
  --    "nvim-treesitter/nvim-treesitter",
  --  },
  --  build = function()
  --    if not require("nvim-treesitter.parsers").has_parser("dap_repl") then
  --      vim.cmd(":TSInstall dap_repl")
  --    end
  --  end,
  --},
  {
      'lervag/vimtex',
      config = function ()
          vim.go.vimtex_view_method = 'skim'
          vim.go.vimtext_compiler_progname = 'nvr'
      end,
  },
  { 'tpope/vim-fugitive' },
  { 'puremourning/vimspector' },
  -- better looking tabline
  {
      'nanozuki/tabby.nvim',
      lazy = false,
      config = function ()
          require('tabby.tabline').use_preset('tab_with_top_win', { })
      end,
  },
  { 'epwalsh/obsidian.nvim' },
  {
      'chrisbra/csv.vim',
      config = function ()
          vim.g.csv_bind_B = 1
      end,
  },
  {
    'obreitwi/vim-sort-folds',
    cmd = 'SortFolds',
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
    event = "VeryLazy",
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("plugins.copilot")
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("refactoring").setup()
      -- load refactoring Telescope extension
      require("telescope").load_extension("refactoring")
    end,
    keys = {
      {
        "<leader>rr",
        function() require('telescope').extensions.refactoring.refactors() end,
        mode = { 'n', 'x' },
      }
    },
  },
}
