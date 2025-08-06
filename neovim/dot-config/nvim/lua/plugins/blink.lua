return {
  "saghen/blink.cmp",
  ---
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {

    -- experimental signature help support
    -- signature = { enabled = true },

    keymap = {
      preset = "super-tab",
      -- manually override tab to prevent buggy lazyvim code running
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      --["<C-y>"] = { "select_and_accept" },
    },
    --menu = {
    --  direction_priority = { 's' },
    --  draw = {
    --    treesitter = { "lsp" },
    --  },
    --},
  },
}
