return {
	"folke/zen-mode.nvim",
	config = function()
		local zen_mode = require("zen-mode")

		-- Default configuration
		zen_mode.setup({
			window = {
				backdrop = 0.95,
				width = 120,
				height = 1,
			},
		})

		-- Define different configurations
		local zen_configs = {
			default = {
				window = {
					backdrop = 0.95,
					width = 120,
					height = 1,
				},
			},
			wide = {
				window = {
					backdrop = 1,
					width = 300,
					height = 1,
				},
			},
			focus = {
				window = {
					backdrop = 1,
					width = 80, -- Narrow width for focused writing
					height = 1,
				},
			},
		}

		-- Create commands for different modes
		vim.api.nvim_create_user_command("ZenDefault", function()
			zen_mode.toggle(zen_configs.default)
		end, {})

		vim.api.nvim_create_user_command("ZenWide", function()
			zen_mode.toggle(zen_configs.wide)
		end, {})

		vim.api.nvim_create_user_command("ZenFocus", function()
			zen_mode.toggle(zen_configs.focus)
		end, {})

		-- Set up keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>md", "<cmd>ZenDefault<CR>", { desc = "Zen Mode Default" })
		keymap.set("n", "<leader>mw", "<cmd>ZenWide<CR>", { desc = "Zen Mode Wide" })
		keymap.set("n", "<leader>mf", "<cmd>ZenFocus<CR>", { desc = "Zen Mode Focus" })
	end,
}
