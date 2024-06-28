return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({

			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--iglob",
					"!package-lock.json",
				},
				mappings = {
					i = {
						["<C-y>"] = actions.select_default,
						["<C-h>"] = actions.which_key,
					},
					n = {
						["<C-c>"] = actions.close,
						["<C-y>"] = actions.select_default,
						["<C-h>"] = actions.which_key,
					},
				},
				-- path_display = { "truncate " },
				path_display = {
					shorten = {
						len = 1,
						exclude = { 1, -1 },
					},
				},
				sorting_strategy = "ascending",
				file_ignore_patterns = { "node_modules", "^./.git/" },
			},
			pickers = {
				live_grep = {
					layout_config = {
						width = 0.95,
					},
				},
				find_files = {
					hidden = true,
					follow = true,
				},
			},
		})

		telescope.load_extension("ui-select")
		telescope.load_extension("noice")
		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")
		-- set keymaps
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>f?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
		vim.keymap.set("n", "<leader>fbb", builtin.buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set("n", "<leader>fu", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[S]earch  in [C]urrent buffer" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>fht", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>fh", builtin.command_history, { desc = "Neovim [H]istory" })
		vim.keymap.set("n", "<leader>fbf", builtin.current_buffer_fuzzy_find, { desc = "[S]earch [G]rep in Buffer" })
		vim.keymap.set("n", "<leader>frr", builtin.resume, { desc = "[R]esume Telescope Search" })
		vim.keymap.set(
			"n",
			"<leader>ft",
			builtin.treesitter,
			{ desc = "Lists Function names, variables, from Treesitter!" }
		)

		vim.keymap.set("n", "<leader>fre", ":Telescope registers<cr>", { noremap = true }, { desc = "Registers" })

		vim.keymap.set(
			"n",
			"<leader>fv",
			":Telescope file_browser path=%:p:h select_buffer=true<CR>",
			{ noremap = true },
			{ desc = "[P]roject [V]iew" }
		)

		vim.keymap.set("n", "<leader>fG", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "[S]earch [G]rep >" })
		vim.keymap.set("n", "<leader>fp", builtin.spell_suggest, { desc = "[S][P]ell" })

		-- LSP commands
		vim.keymap.set("n", "<leader>fld", builtin.lsp_definitions, { desc = "[G]o to lsp_definitions" })
		-- Git commands
		vim.keymap.set("n", "<leader>fi", builtin.git_files, { desc = "Search [G]it [F]iles" })
		vim.keymap.set("n", "<leader>fs", builtin.git_status, { desc = "Search [G]it [S]tatus" })
		vim.keymap.set("n", "<leader>fz", builtin.git_commits, { desc = "Search [G]it [L]og" })
		vim.keymap.set("n", "<leader>fc", builtin.git_branches, { desc = "[G]it Branches" })
	end,
}
