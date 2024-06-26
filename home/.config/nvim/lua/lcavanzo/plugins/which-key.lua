return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		local wk = require("which-key")

		wk.setup({
			window = {
				border = "single",
				margin = { 1, 1, 1, 1 },
			},
			layout = {
				width = { min = 20, max = 40 },
			},
		})

		wk.register({
			s = { name = "Search" },
			d = { name = "Debug" },
			u = { name = "Utils" },
			g = { name = "Git" },
			w = { name = "Wiki" },
			h = { name = "Jump" },
			l = {
				name = "LSP",
				w = { name = "Workspaces" },
			},
		}, { prefix = "<Leader>" })
	end,
}
