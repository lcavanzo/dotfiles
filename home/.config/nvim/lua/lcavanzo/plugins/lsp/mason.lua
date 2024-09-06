return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"tsserver",
				"html",
				"lua_ls",
				"gopls",
				"pyright",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint", -- python linter
				"ruff",
				"pyright",
				"debugpy",
				"delve",
				"eslint_d", -- js linter
				"gofumpt",
				"goimports",
			},
		})
		-- automatically install ensure_installed servers
		require("mason-lspconfig").setup_handlers({
			-- Will be called for each installed server that doesn't have
			-- a dedicated handler.
			--
			function(server_name) -- default handler (optional)
				-- https://github.com/neovim/nvim-lspconfig/pull/3232
				if server_name == "tsserver" then
					server_name = "ts_ls"
				end
				local capabilities = require("cmp_nvim_lsp").default_capabilities()
				require("lspconfig")[server_name].setup({

					capabilities = capabilities,
				})
			end,
		})
	end,
}
