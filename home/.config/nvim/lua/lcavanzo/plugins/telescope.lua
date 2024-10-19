return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"LukasPietzschmann/telescope-tabs",
		"nvim-telescope/telescope-frecency.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local fb_actions = telescope.extensions.file_browser.actions

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
						["<leader>v"] = actions.select_vertical,
						["<leader>h"] = actions.select_horizontal,
						["<leader>t"] = actions.select_tab,
						["<leader>z"] = function(prompt_bufnr)
							require("telescope.actions").select_default(prompt_bufnr)
							require("telescope.builtin").resume()
						end,
						["<leader>tr"] = function(prompt_bufnr)
							require("telescope.actions").select_tab(prompt_bufnr)
							require("telescope.builtin").resume()
						end,
					},
					n = {
						["<C-c>"] = actions.close,
						["<C-y>"] = actions.select_default,
						["<C-h>"] = actions.which_key,
						["d"] = require("telescope.actions").delete_buffer,
						["<leader>v"] = actions.select_vertical,
						["<leader>h"] = actions.select_horizontal,
						["<leader>t"] = actions.select_tab,
						["<leader>z"] = function(prompt_bufnr)
							require("telescope.actions").select_default(prompt_bufnr)
							require("telescope.builtin").resume()
						end,
						["<leader>tr"] = function(prompt_bufnr)
							require("telescope.actions").select_tab(prompt_bufnr)
							require("telescope.builtin").resume()
						end,
					},
				},
				path_display = {
					shorten = {
						len = 1,
						exclude = { 1, -1 },
					},
				},
				-- path_display = {
				-- 	filename_first = {
				-- 		reverse_directories = true,
				-- 	},
				-- },
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
			extensions = {
				file_browser = {
					hidden = {
						file_browser = true,
						folder_browser = true,
					},
					hijack_netrw = true,
					mappings = {
						["n"] = {
							["n"] = fb_actions.create,
							["r"] = fb_actions.rename,
							["d"] = fb_actions.remove,
							["m"] = fb_actions.move,
							["c"] = fb_actions.copy,
						},
					},
				},
				frecency = {
					show_scores = false, -- Default: false

					-- If `true`, it shows confirmation dialog before any entries are removed from the DB
					-- If you want not to be bothered with such things and to remove stale results silently
					-- set db_safe_mode=false and auto_validate=true
					-- This fixes an issue I had in which I couldn't close the floating
					-- window because I couldn't focus it
					db_safe_mode = false, -- Default: true

					-- If `true`, it removes stale entries count over than db_validate_threshold
					auto_validate = true, -- Default: true

					-- It will remove entries when stale ones exist more than this count
					db_validate_threshold = 10, -- Default: 10

					-- Show the path of the active filter before file paths.
					-- So if I'm in the `dotfiles-latest` directory it will show me that
					-- before the name of the file
					show_filter_column = false, -- Default: true

					-- I declare a workspace which I will use when calling frecency if I
					-- want to search for files in a specific path
					workspaces = {},
					path_display = function(opts, path)
						local tail = require("telescope.utils").path_tail(path)
						local parent = path:match("(.*/)")
						return string.format("%s ", tail)
					end,
				},
			},
		})

		telescope.load_extension("ui-select")
		telescope.load_extension("noice")
		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")
		telescope.load_extension("telescope-tabs")
		telescope.load_extension("neoclip")
		telescope.load_extension("frecency")
		-- set keymaps
		local builtin = require("telescope.builtin")
		-- vim.keymap.set("n", "<leader>f?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
		-- vim.keymap.set("n", "<leader>fbf", builtin.current_buffer_fuzzy_find, { desc = "[S]earch [G]rep in Buffer" })
		-- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set(
			"n",
			"<leader>b",
			-- Notice that I start it in normal mode to navigate similarly to bufexplorer,
			-- the ivy theme is also similar to bufexplorer and tmux sessions
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal theme=ivy<cr>",
			{ desc = "[P]Open telescope buffers" }
		)

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
		vim.keymap.set("n", "<leader>frr", builtin.resume, { desc = "[R]esume Telescope Search" })
		vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Telescope Marks" })
		vim.keymap.set(
			"n",
			"<leader>ftl",
			builtin.treesitter,
			{ desc = "Lists Function names, variables, from Treesitter!" }
		)
		vim.keymap.set("n", "<leader>fF", ":Telescope frecency<cr>", { noremap = true }, { desc = "Find files" })

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
		vim.keymap.set("n", "<leader>fG", builtin.git_status, { desc = "Search [G]it [S]tatus" })
		vim.keymap.set("n", "<leader>fz", builtin.git_commits, { desc = "Search [G]it [L]og" })
		vim.keymap.set("n", "<leader>fc", builtin.git_branches, { desc = "[G]it Branches" })
	end,
}
