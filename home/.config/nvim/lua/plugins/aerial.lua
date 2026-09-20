return {
  "stevearc/aerial.nvim",
  opts = {
    -- Jump to symbol in source window as the cursor moves through the outline
    autojump = true,
    -- Highlight the symbol in the source buffer while hovering it in Aerial
    highlight_on_hover = true,
  },
  -- Optional dependencies
  keys = {
    { "<leader>A", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial Outline" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
