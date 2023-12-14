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
                }
            end,
        }

        vim.cmd("colorscheme kanagawa")
    end,
  },
  { "nvim-lua/plenary.nvim" },
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
    },
  },
  {
      "hiphish/rainbow-delimiters.nvim",
      main = "rainbow-delimiters.setup",
      config = true,
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
      --{ "cljoly/telescope-repo.nvim" },
    },
  },
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
    config = true, -- run require("stay-in-place").setup()
  },
  -- automate useful refactoring patterns
  --{
  --  "ThePrimeagen/refactoring.nvim",
  --  dependencies = {
  --    "nvim-lua/plenary.nvim",
  --    "nvim-treesitter/nvim-treesitter",
  --  },
  --  cmd = "Refactor",
  --  keys = {
  --    { "<leader>re", ":Refactor extract ",              mode = "x",          desc = "Extract function" },
  --    { "<leader>rf", ":Refactor extract_to_file ",      mode = "x",          desc = "Extract function to file" },
  --    { "<leader>rv", ":Refactor extract_var ",          mode = "x",          desc = "Extract variable" },
  --    { "<leader>ri", ":Refactor inline_var",            mode = { "x", "n" }, desc = "Inline variable" },
  --    { "<leader>rI", ":Refactor inline_func",           mode = "n",          desc = "Inline function" },
  --    { "<leader>rb", ":Refactor extract_block",         mode = "n",          desc = "Extract block" },
  --    { "<leader>rf", ":Refactor extract_block_to_file", mode = "n",          desc = "Extract block to file" },
  --  },
  --  config = true
  --},

  -- LSP Base
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    servers = nil,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
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
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc", -- math calculation
      -- snippets
      "saadparwaiz1/cmp_luasnip",
      {
          "L3MON4D3/LuaSnip",
          -- follow latest release.
          version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
          -- install jsregexp (optional!).
          build = "make install_jsregexp",
          dependencies = "rafamadriz/friendly-snippets",
      },
      {
        "David-Kunz/cmp-npm",
        config = true,
      },
      "petertriho/cmp-git",
    },
  },

  -- LSP Addons
  {
    "pmizio/typescript-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "typescript", "typescriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("plugins.typescript-tools")
    end,
  },
  { "onsails/lspkind-nvim" },
  -- automatically convert JS string to template string when ${} added
  --{
  --  "axelvc/template-string.nvim",
  --  event = "InsertEnter",
  --  ft = {
  --    "javascript",
  --    "typescript",
  --    "javascriptreact",
  --    "typescriptreact",
  --  },
  --  config = true, -- run require("template-string").setup()
  --},
  -- typescript type checking using tsc
  --{
  --  "dmmulroy/tsc.nvim",
  --  cmd = { "TSC" },
  --  config = true,
  --},
  -- replacement for VSCode peek to see definitions etc. at a glance
  --{
  --  "dnlhc/glance.nvim",
  --  config = true,
  --  cmd = { "Glance" },
  --  keys = {
  --    { "gd", "<cmd>Glance definitions<CR>",      desc = "LSP Definition" },
  --    { "gr", "<cmd>Glance references<CR>",       desc = "LSP References" },
  --    { "gm", "<cmd>Glance implementations<CR>",  desc = "LSP Implementations" },
  --    { "gy", "<cmd>Glance type_definitions<CR>", desc = "LSP Type Definitions" },
  --  },
  --},
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
  -- quick switches (e.g. true->false) with :Switch
  --{ "AndrewRadev/switch.vim", lazy = false },
  -- auto split / join arrays etc.
  --{
  --  "Wansmer/treesj",
  --  lazy = true,
  --  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  --  keys = {
  --    { "gJ", "<cmd>TSJToggle<CR>", desc = "Toggle Split/Join" },
  --  },
  --  config = function()
  --    require("treesj").setup({
  --      use_default_keymaps = false,
  --    })
  --  end,
  --},
  -- auto commenting
  --{
  --  "numToStr/Comment.nvim",
  --  lazy = false,
  --  dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
  --  config = true,
  --},
  -- create fancy comments for e.g. a config file
  --{
  --  "LudoPinelli/comment-box.nvim",
  --  lazy = false,
  --  keys = {
  --    { "<leader>ac", "<cmd>lua require('comment-box').lbox()<CR>", desc = "comment box" },
  --    { "<leader>ac", "<cmd>lua require('comment-box').lbox()<CR>", mode = "v",          desc = "comment box" },
  --  }
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
  --{ "tpope/vim-repeat",           lazy = false },
  -- make <C-A> <C-X> work on dates
  { "tpope/vim-speeddating",      lazy = false },
  -- easily make markdown tables
  { "dhruvasagar/vim-table-mode", ft = { "markdown" } },
  {
    "folke/todo-comments.nvim",
    lazy = false,
    event = "BufEnter",
    config = function()
      require("plugins.todo-comments")
    end,
  },
  -- TODO better nvim-specific version of Goyo
  --{
  --  "folke/zen-mode.nvim",
  --  cmd = { "ZenMode" },
  --  config = function()
  --    require("plugins.zen")
  --  end,
  --},
  -- better jumps
  -- TODO look into this one
  --{
  --  "folke/flash.nvim",
  --  event = "VeryLazy",
  --  opts = {
  --    char = {
  --      keys = { "f", "F", "t", "T" },
  --    }
  --  },
  --  keys = {
  --    {
  --      "s",
  --      mode = { "n", "x", "o" },
  --      function()
  --        require("flash").jump()
  --      end,
  --    },
  --  },
  --},
  -- TODO find new keybindings!
  --{
  --  "folke/which-key.nvim",
  --  event = "VeryLazy",
  --  config = true,
  --},
  -- better statusline TODO
  --{
  --  "ecosse3/galaxyline.nvim",
  --  config = function()
  --    require("plugins.galaxyline")
  --  end,
  --  event = "VeryLazy",
  --},
  -- don't fuck up window layout after bdel etc.
  {
    "echasnovski/mini.bufremove",
    version = "*",
    config = function()
      require("mini.bufremove").setup({
        silent = true,
      })
    end,
  },
  -- TODO notifications might be nice
  --{
  --  "rcarriga/nvim-notify",
  --  config = function()
  --    require("notify").setup({
  --      background_colour = "#000000",
  --    })
  --  end,
  --  init = function()
  --    local banned_messages = {
  --      "No information available",
  --      "LSP[tsserver] Inlay Hints request failed. Requires TypeScript 4.4+.",
  --      "LSP[tsserver] Inlay Hints request failed. File not opened in the editor.",
  --    }
  --    vim.notify = function(msg, ...)
  --      for _, banned in ipairs(banned_messages) do
  --        if msg == banned then
  --          return
  --        end
  --      end
  --      return require("notify")(msg, ...)
  --    end
  --  end,
  --},
  -- nice NPM/Yarn shortcuts
  --{
  --  "vuki656/package-info.nvim",
  --  event = "BufEnter package.json",
  --  config = true,
  --},
  -- TODO look into this one
  --{
  --  "airblade/vim-rooter",
  --  event = "VeryLazy",
  --  config = function()
  --    vim.g.rooter_patterns = EcoVim.plugins.rooter.patterns
  --    vim.g.rooter_silent_chdir = 1
  --    vim.g.rooter_resolve_links = 1
  --  end,
  --},
  -- TODO a wrapper around neovim :mksession
  --{
  --  "Shatur/neovim-session-manager",
  --  lazy = false,
  --  config = function()
  --    require("plugins.session-manager")
  --  end,
  --  keys = {
  --    { "<Leader>/sc", "<cmd>SessionManager load_session<CR>",             desc = "choose session" },
  --    { "<Leader>/sr", "<cmd>SessionManager delete_session<CR>",           desc = "remove session" },
  --    { "<Leader>/sd", "<cmd>SessionManager load_current_dir_session<CR>", desc = "load current dir session" },
  --    { "<Leader>/sl", "<cmd>SessionManager load_last_session<CR>",        desc = "load last session" },
  --    { "<Leader>/ss", "<cmd>SessionManager save_current_session<CR>",     desc = "save session" },
  --  }
  --},
  -- lua version of Tim Pope's classic plugin
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true,
  },
  -- dim inactive windows (TODO check if I actually want this)
  --{
  --  "sunjon/shade.nvim",
  --  config = function()
  --    require("shade").setup()
  --    require("shade").toggle()
  --  end,
  --},
  -- fancy folds (note that setup is called manually in lsp.config)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    end,
  },
  -- indent guides
  --{
  --  "lukas-reineke/indent-blankline.nvim",
  --  event = "BufReadPre",
  --  main = "ibl",
  --  config = function()
  --    require("plugins.indent")
  --  end,
  --},

  -- Snippets & Language & Syntax
  -- auto close brackets with TS
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.autopairs")
    end,
  },
  { 'windwp/nvim-ts-autotag' },
  { 'RRethy/nvim-treesitter-endwise' },
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
  -- shortcut to show actual CSS generated by tailwind
  --{
  --  "MaximilianLloyd/tw-values.nvim",
  --  keys = {
  --    { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
  --  },
  --  opts = {
  --    border = "rounded", -- Valid window border style,
  --    show_unknown_classes = true                   -- Shows the unknown classes popup
  --  }
  --},

  -- Git
  -- togglable git highlighting and virtual text
  --{
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
          require('tabby.tabline').use_preset('active_wins_at_tail', { })
      end,
  },
  { 'epwalsh/obsidian.nvim' },
  { 'nvim-lualine/lualine.nvim', lazy = false, config = true },
  {
      'chrisbra/csv.vim',
      config = function ()
          vim.g.csv_bind_B = 1
      end,
  },
}
