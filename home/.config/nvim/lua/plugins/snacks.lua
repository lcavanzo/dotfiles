return {
  {
    "snacks.nvim",
    keys = {
      -- snacks.scopee keymaps-----------------------------------
      {
        "mn",
        function()
          require("snacks.scope").jump({ bottom = false })
        end,
        desc = "jump to top edge of scope",
      },
      -- Change this keymap
      {
        "mm",
        function()
          require("snacks.scope").jump({ bottom = true })
        end,
        desc = "jump to bottom edge of scope",
      },
      ------------------------------------------------------------
      {
        "<leader>sf",
        function()
          Snacks.picker.lsp_symbols({})
        end,
        desc = "LSP Symbols",
      },
      -- {
      --   "<leader>sl",
      --   function()
      --     Snacks.picker.lsp_symbols({ layout = { preset = "vscode", preview = "main" } })
      --   end,
      --   desc = "Symbols",
      -- },
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ cwd = vim.fn.getcwd() })
        end,
        desc = "Find Files (CWD Only)",
      },
      {
        "<leader>fF",
        function()
          Snacks.picker.files({ cwd = LazyVim.root() })
        end,
        desc = "Find Files (Root Dir)",
      },
      -- snacks.picker keymaps-----------------------------------
      -- I use this keymap with mini.files, but snacks explorer was taking over
      -- https://github.com/folke/snacks.nvim/discussions/949
      { "<leader>e", false },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep({
            -- Exclude results from grep picker
            -- I think these have to be specified in gitignore syntax
            exclude = { "dictionaries/words.txt" },
          })
        end,
        desc = "Grep",
      },
      -- Open git log in vertical view
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log({
            finder = "git_log",
            format = "git_log",
            preview = "git_show",
            confirm = "git_checkout",
            layout = "vertical",
          })
        end,
        desc = "Git Log",
      },
      -- -- Iterate through incomplete tasks in Snacks_picker
      {
        -- -- You can confirm in your teminal lamw26wmal with:
        -- -- rg "^\s*-\s\[ \]" test-markdown.md
        "<leader>ti",
        function()
          Snacks.picker.grep({
            prompt = " ",
            -- pass your desired search as a static pattern
            search = "^\\s*- \\[ \\]",
            -- we enable regex so the pattern is interpreted as a regex
            regex = true,
            -- no “live grep” needed here since we have a fixed pattern
            live = false,
            -- restrict search to the current working directory
            dirs = { vim.fn.getcwd() },
            -- include files ignored by .gitignore
            args = { "--no-ignore" },
            -- Start in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "grep",
            format = "file",
            show_empty = true,
            supports_live = false,
            layout = "ivy",
          })
        end,
        desc = "[P]Search for incomplete tasks",
      },
      -- -- Iterate throuth completed tasks in Snacks_picker lamw26wmal
      {
        "<leader>tc",
        function()
          Snacks.picker.grep({
            prompt = " ",
            -- pass your desired search as a static pattern
            search = "^\\s*- \\[x\\]",
            -- we enable regex so the pattern is interpreted as a regex
            regex = true,
            -- no “live grep” needed here since we have a fixed pattern
            live = false,
            -- restrict search to the current working directory
            dirs = { vim.fn.getcwd() },
            -- include files ignored by .gitignore
            args = { "--no-ignore" },
            -- Start in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "grep",
            format = "file",
            show_empty = true,
            supports_live = false,
            layout = "ivy",
          })
        end,
        desc = "[P]Search for complete tasks",
      },
      -- -- List git branches with Snacks_picker to quickly switch to a new branch
      {
        "<leader>gb",
        function()
          Snacks.picker.git_branches({
            layout = "select",
          })
        end,
        desc = "Branches",
      },
      -- -- Remap git blame
      {
        "<leader>gz",
        function()
          Snacks.picker.git_log_line({
            layout = "select",
          })
        end,
        desc = "Git Blame",
      },
      -- Used in LazyVim to view the different keymaps, this by default is
      -- configured as <leader>sk but I run it too often
      -- Sometimes I need to see if a keymap is already taken or not
      {
        "<leader>?",
        function()
          Snacks.picker.keymaps({
            layout = "vertical",
          })
        end,
        desc = "Keymaps",
      },
      -- -- File picker
      -- {
      --   "<leader><leader>",
      --   function()
      --     Snacks.picker.files({
      --       finder = "files",
      --       format = "file",
      --       show_empty = true,
      --       supports_live = true,
      --       -- In case you want to override the layout for this keymap
      --       -- layout = "vscode",
      --     })
      --   end,
      --   desc = "Find Files",
      -- },
      -- Navigate my buffers
      {
        "<leader>,",
        function()
          Snacks.picker.buffers({
            -- I always want my buffers picker to start in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "buffers",
            format = "buffer",
            hidden = false,
            unloaded = true,
            current = true,
            sort_lastused = true,
            win = {
              input = {
                keys = {
                  ["d"] = "bufdelete",
                },
              },
              list = { keys = { ["d"] = "bufdelete" } },
            },
            -- In case you want to override the layout for this keymap
            -- layout = "ivy",
          })
        end,
        desc = "[P]Snacks picker buffers",
      },
      ------------------------------------------------------------
    },
    opts = {
      zen = {
        win = {
          width = 120, -- Width of your focused window (adjust this to your liking)
          backdrop = { transparent = false, blend = 90 }, -- Optional: dim the sides darker
        },

        -- "toggles" handles what gets hidden when you enter Zen mode
        toggles = {
          dim = false, -- Dim the content that is not in the active scope
          git_signs = false, -- Turn off git signs
          diagnostics = true, -- Turn off diagnostics if you want pure text
          mini_diff_signs = false,
          inlay_hints = false,
        },
        show = {
          statusline = false, -- Hide statusline
          tabline = false, -- Hide tabline
        },
      },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 150 }, -- "step" is per-line, "total" is max time
          -- Lower "total" to 150 or 100 to make 'gg' feel instant
        },
        -- If you still feel lag, you can tweak the easing:
        -- easing = "linear",
      },
      scope = { enabled = true },
      indent = { enabled = true },
      dashboard = {
        preset = {
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          header = [[
         	          ▀████▀▄▄              ▄█
		            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█
		    ▄        █          ▀▀▀▀▄  ▄▀
		   ▄▀ ▀▄      ▀▄              ▀▄▀
		  ▄▀    █     █▀   ▄█▀▄      ▄█
		  ▀▄     ▀▄  █     ▀██▀     ██▄█
		   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █
		    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀
		   █   █  █      ▄▄           ▄▀
]],
       -- stylua: ignore
       ---@type snacks.dashboard.Item[]
       keys = {
         { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
         { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
         { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
         { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
         { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
         { icon = " ", key = "s", desc = "Restore Session", section = "session" },
         { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
         { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
         { icon = " ", key = "q", desc = "Quit", action = ":qa" },
       },
        },
      },
    },
  },
}
