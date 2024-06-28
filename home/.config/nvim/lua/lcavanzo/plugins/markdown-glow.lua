return {
	"ellisonleao/glow.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Glow",
	config = function()
		require("glow").setup({
			-- Other Glow configuration options here if needed
		})

		-- Move keymap definition outside setup()
		vim.keymap.set("n", "<leader>mk", "<cmd>Glow<CR>", { desc = "Markdown Preview" })
	end,
}
