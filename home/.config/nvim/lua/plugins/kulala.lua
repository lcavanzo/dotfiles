-- https://github.com/dont-be-evil-company/kulala.nvim  (docs: https://kulala.app/usage)
--
-- Replaces rest.nvim (disabled in disabled.lua) – both want *.http and <leader>R.
return {
  {
    "dont-be-evil-company/kulala.nvim",
    ft = { "http", "rest" },
    event = { "SessionLoadPost" }, -- restore request history with sessions
    -- Stubs so these work from any buffer before the plugin is loaded;
    -- kulala sets the real mappings itself (global_keymaps = true).
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rb", desc = "Open scratchpad" },
      { "<leader>Ro", desc = "Open kulala" },
    },
    opts = {
      kulala_core = {
        timeout = 60000, -- ms
      },
      -- environment picked from http-client.env.json when a buffer opens
      default_env = "dev",
      environment_scope = "b", -- per buffer; "g" = shared by every buffer

      ui = {
        display_mode = "split", -- "split" | "float"  (toggle with | in the result window)
        split_direction = "right",
        default_view = "body", -- "body" | "headers" | "headers_body" | "verbose"
        winbar = true,
        default_winbar_panes = { "body", "headers", "verbose", "script_output", "report" },
        show_request_summary = true,
        max_response_size = 512 * 1024, -- default is 32 KB, too small for real APIs
      },

      lsp = {
        enable = true, -- completion for headers, variables, request names
        keymaps = false, -- keep LazyVim's own LSP maps (K, gd, <leader>ca…)
      },

      -- Enable the default keymaps under <leader>R (see kulala/README.md)
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps = true, -- result-window keymaps (H, B, V, ]…)
    },
  },

  -- which-key group label
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = { { "<leader>R", group = "kulala (http)" } },
    },
  },
}
