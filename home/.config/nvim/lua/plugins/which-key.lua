return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = { mode = { "n", "v" }, { "<leader>r", group = "Replace" } },
    },
    keys = {
      { "<leader>?", false },
      { "<c-w><space>", false },
    },
  },
}
