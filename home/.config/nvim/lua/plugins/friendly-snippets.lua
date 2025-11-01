return {
  {
    "rafamadriz/friendly-snippets",
    -- 1. Explicitly declare dependency on LuaSnip
    dependencies = { "L3MON4D3/LuaSnip" },

    config = function()
      -- 2. This code will now run *after* LuaSnip is fully loaded
      require("luasnip.loaders.from_vscode").lazy_load()

      require("luasnip.loaders.from_vscode").lazy_load({
        paths = {
          vim.fn.stdpath("config") .. "/snippets",
        },
      })
    end,
  },
}
