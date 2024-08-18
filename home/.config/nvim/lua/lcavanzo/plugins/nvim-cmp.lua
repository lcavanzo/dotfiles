return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")

		local luasnip = require("luasnip")

		local lspkind = require("lspkind")
		local i = luasnip.insert_node
		local s = luasnip.snippet
		local t = luasnip.text_node
		local f = luasnip.function_node

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		-- Clear existing snippets to avoid duplicates
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = "~/.config/nvim/lua/lcavanzo/plugins/snippets",
			priority = 1001,
		})
		require("luasnip.loaders.from_vscode").lazy_load({ priority = 999 })

		-- Function to check if we're in a snippet
		local function in_snippet()
			local session = luasnip.session
			if not session then
				return false
			end
			return session.current_nodes[vim.api.nvim_get_current_buf()] ~= nil
		end

		vim.keymap.set({ "i" }, "<C-E>", function()
			if luasnip.expandable() then
				luasnip.expand()
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if in_snippet() and luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				-- If we're not in a snippet, or can't jump, use default Tab behavior
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			if in_snippet() and luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				-- If we're not in a snippet, or can't jump backwards, use default Shift-Tab behavior
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
			end
		end, { silent = true })

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noinsert,noselect",
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-k>"] = cmp.mapping.scroll_docs(-4),
				["<C-j>"] = cmp.mapping.scroll_docs(4),
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
				{ name = "nvim-cmp" },
				{ name = "nvim-lua" },
			}),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})
	end,
}
