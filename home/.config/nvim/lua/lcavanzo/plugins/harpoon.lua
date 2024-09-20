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

			keymap.set("n", "<leader>ha", function()
				harpoon:list():add()
			end, { desc = "Mark file with harpoon" })

			keymap.set("n", "<leader>hs", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "View all projects marks" })

			-- Toggle previous & next buffers stored within Harpoon list
			keymap.set("n", "<leader>hp", function()
				harpoon:list():prev()
			end, { desc = "Go to previous harpoon mark" })

			keymap.set("n", "<leader>hn", function()
				harpoon:list():next()
			end, { desc = "Go to next harpoon mark" })

			keymap.set("n", "<leader>h1", function()
				harpoon:list():select(1)
			end, { desc = "Go to harpoon mark 1" })
			keymap.set("n", "<leader>h2", function()
				harpoon:list():select(2)
			end, { desc = "Go to harpoon mark 2" })
			keymap.set("n", "<leader>h3", function()
				harpoon:list():select(3)
			end, { desc = "Go to harpoon mark 3" })
			keymap.set("n", "<leader>h4", function()
				harpoon:list():select(4)
			end, { desc = "Go to harpoon mark 4" })

			-- basic telescope configuration
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			keymap.set("n", "<leader>hh", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Open harpoon window" })

			harpoon:extend({
				UI_CREATE = function(cx)
					keymap.set("n", "<leader>v", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr })

					keymap.set("n", "<leader>h", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr })

					keymap.set("n", "<leader>t", function()
						harpoon.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr })
				end,
			})
		end,
	},
}
