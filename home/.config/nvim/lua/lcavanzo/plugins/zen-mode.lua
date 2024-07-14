return {
	{
		"folke/zen-mode.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			window = {
				backdrop = 0.95,
				width = 120, -- width of the Zen window
				height = 1, -- height of the Zen window
			},
		},
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 1,
					width = 300,
				},
			})
			local keymap = vim.keymap

			keymap.set("n", "<leader>mm", "<cmd>ZenMode<CR>", { desc = "Zen Mode" }) -- save workspace session for current working directory
		end,
	},
}
