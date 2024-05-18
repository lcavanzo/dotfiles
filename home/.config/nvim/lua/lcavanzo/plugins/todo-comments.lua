return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		cmd = { "TodoTelescope" },
		event = "LazyFile",
		config = true,
		vim.keymap.set("n", "<leader>fto", "<cmd>TodoTelescope<cr>", { desc = "TODO" }),
		-- vim.keymap.set("n", "<leader>fTo", "<cmd>TodoTelescope keywords=FIXME,FIX<cr>", { desc = "TODO/Fix/Fixme" }),
	},
}
