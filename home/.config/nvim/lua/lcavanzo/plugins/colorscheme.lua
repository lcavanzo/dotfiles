return {
	{
		"catppuccin/nvim",
		name = "catppucin",
		priority = 1000, -- make sure to load this before all the other start plugins
		opts = {
			transparent_background = true,
		},
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme catppuccin-mocha]])
		end,
	},
}
