return {
  "stevearc/aerial.nvim",
  opts = {},
  -- Optional dependencies
  keys = {
    { "<leader>A", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial Outline" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
