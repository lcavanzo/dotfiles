-- https://github.com/rest-nvim/rest.nvim
-- HTTP client for .http files. Needs curl, and luarocks (or lazy.nvim's hererocks) for its rock deps.
return {
  "rest-nvim/rest.nvim",
  ft = "http",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
  init = function()
    -- rest.nvim is configured via this global, no setup() call
    vim.g.rest_nvim = {
      request = {
        skip_ssl_verification = false,
      },
      response = {
        hooks = {
          format = true, -- format JSON/XML bodies with jq/tidy if available
        },
      },
      ui = {
        winbar = true,
        keybinds = { prev = "H", next = "L" }, -- switch result pane tabs
      },
    }
  end,
  keys = {
    { "<leader>R", "", desc = "+rest", ft = "http" },
    { "<leader>Rr", "<cmd>Rest run<cr>", desc = "Run request under cursor", ft = "http" },
    { "<leader>Rl", "<cmd>Rest last<cr>", desc = "Re-run last request", ft = "http" },
    { "<leader>Ro", "<cmd>Rest open<cr>", desc = "Open result pane", ft = "http" },
    { "<leader>Re", "<cmd>Rest env select<cr>", desc = "Select env file", ft = "http" },
    { "<leader>RE", "<cmd>Rest env show<cr>", desc = "Show env file", ft = "http" },
    { "<leader>RL", "<cmd>Rest logs<cr>", desc = "Show logs", ft = "http" },
  },
}
