return {
	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			keymap.set("n", "<leader>H", function()
				harpoon:list():add()
			end, { desc = "Mark file with harpoon" })

			for i = 1, 5 do
				vim.keymap.set("n", "<leader>" .. i, function()
					harpoon:list():select(i)
				end, { desc = "Harpoon to File " .. i })
			end

			keymap.set("n", "<leader>h", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "View all harpoon marks" })
			harpoon:extend({
				UI_CREATE = function(cx)
					keymap.set("n", "v", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr })

					keymap.set("n", "h", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr })
				end,
			})
		end,
	},
}
