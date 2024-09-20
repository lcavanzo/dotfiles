return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	-- opts = {
	--     setup = {
	--         -- disable jdtls config from lspconfig
	--         jdtls = function()
	--             return true
	--         end,
	--     }
	-- },
	config = function()
		-- Disable diagnostic messages for lspconfig
		local function toggle_diagnostic_virtual_text()
			local current_value = vim.diagnostic.config().virtual_text
			vim.diagnostic.config({ virtual_text = not current_value })

			if not current_value then
				print("Diagnostic virtual text enabled")
			else
				print("Diagnostic virtual text disabled")
			end
		end
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local opts = { noremap = true, silent = true }
		local on_attach = function(client, bufnr)
			opts.buffer = bufnr

			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end

				--vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end
			vim.keymap.set(
				"n",
				"<leader>tw",
				toggle_diagnostic_virtual_text,
				{ desc = "Toggle Diagnostic Virtual Text" }
			)

			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
			vim.keymap.set(
				"n",
				"gs",
				require("telescope.builtin").lsp_document_symbols,
				{ desc = "[G]o to [D]ocument [S]ymbols" }
			)

			-- See `:help K` for why this keymap
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
			vim.keymap.set("n", "<C-d>", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })

			-- -- Lesser used LSP unctionality
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[W]orkspace [A]dd Folder" })
			vim.keymap.set(
				"n",
				"<leader>wr",
				vim.lsp.buf.remove_workspace_folder,
				{ desc = "[W]orkspace [R]emove Folder" }
			)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, { desc = "[W]orkspace [L]ist Folders" })
			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				vim.lsp.buf.format()
			end, { desc = "Format current buffer with LSP" })
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure typescript server with plugin
		lspconfig["ts_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure graphql language server
		lspconfig["graphql"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		-- configure yaml server
		lspconfig["yamlls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure python server
		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
		lspconfig["ruff"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- lspconfig["jdtls"].setup({
		--     capabilities = capabilities,
		--     on_attach = on_attach,
		-- })

		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				gopls = {
					gofumpt = true,
				},
			},
			flags = {
				debounce_text_changes = 150,
			},
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		vim.diagnostic.config({
			virtual_text = false,
			severity_sort = true,
			float = {
				style = "minimal",
				border = "rounded",
				header = "",
				prefix = "",
			},
		})

		vim.diagnostic.config({
			virtual_text = true,
		})
	end,
}
