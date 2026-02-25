return {
  "zion-off/mole.nvim",
  -- cmd tells Lazy to load the plugin when you run these commands
  cmd = { "MoleStart", "MoleAdd", "MoleOpen" },
  event = "VeryLazy",
  keys = {
    { "<leader>ms", "<cmd>MoleStart<cr>", desc = "Mole: Start Study Session" },
    { "<leader>ma", "<cmd>MoleAdd<cr>", desc = "Mole: Annotate Code" },
    { "<leader>mp", "<cmd>MoleOpen<cr>", desc = "Mole: Open Current Plan" },
    { "<leader>mt", "<cmd>MoleToggle<cr>", desc = "Mole: Toggle window" },
    {
      "<leader>mg",
      function()
        local mole_dir = vim.fn.stdpath("data") .. "/mole/"
        Snacks.picker.grep({
          cwd = mole_dir,
          title = "Mole Notes",
        })
      end,
      desc = "Search Mole Notes",
    },
  },
  config = function()
    require("mole").setup({
      template_path = vim.fn.stdpath("data") .. "/mole/",
    })
  end,
}
