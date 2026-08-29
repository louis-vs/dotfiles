return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          mirror = false,
          preview_cutoff = 120,
        },
        prompt_position = "top",
      },
      mappings = {
        i = {
          ["<c-t>"] = require("telescope.actions").select_tab,
        },
      },
    },
  },
}
