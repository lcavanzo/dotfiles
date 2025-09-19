return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "obsidian-vault",
				path = "/Users/lcavanzo/git/obsidian-vault",
			},
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		notes_subdir = "limbo",
		new_notes_location = "limbo",
		attachments = {
			img_folder = "99_Assets/attachments",
		},
		daily_notes = {
			template = "note",
		},
		mappings = {
			-- "Obsidian follow"
			["<leader>of"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- ----- OBSIDIAN MAPPINGS -----
			["<leader>oc"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { desc = "Obsidian Check Checkbox" },
			},
			["<leader>ot"] = {
				action = "<cmd>ObsidianTemplate<CR>",
				opts = { desc = "Insert Obsidian Template" },
			},
			["<leader>oo"] = {
				action = "<cmd>ObsidianOpen<CR>",
				opts = { desc = "Open in Obsidian App" },
			},
			["<leader>ob"] = {
				action = "<cmd>ObsidianBacklinks<CR>",
				opts = { desc = "Show ObsidianBacklinks" },
			},
			["<leader>ol"] = {
				action = "<cmd>ObsidianLinks<CR>",
				opts = { desc = "Show ObsidianLinks" },
			},
			["<leader>on"] = {
				action = "<cmd>ObsidianNew<CR>",
				opts = { desc = "Create New Note" },
			},
			["<leader>os"] = {
				action = "<cmd>ObsidianSearch<CR>",
				opts = { desc = "Search Obsidian" },
			},
			["<leader>oq"] = {
				action = "<cmd>ObsidianQuickSwitch<CR>",
				opts = { desc = "Quick Switch" },
			},
		},
		note_id_func = function(title)
			return title
		end,
		note_frontmatter_func = function(note)
			local date_str = os.date("%Y-%m-%d")
			local out = { id = note.id, aliases = note.aliases, tags = note.tags, date = date_str }

			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
	},
}
