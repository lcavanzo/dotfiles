return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local function footer()
			local plugins = #vim.tbl_keys(require("lazy").plugins())
			local v = vim.version()
			local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
			local platform = vim.fn.has("win32") == 1 and "" or ""
			return string.format("󰂖 %d  %s %d.%d.%d  %s", plugins, platform, v.major, v.minor, v.patch, datetime)
		end

		-- Set header
		dashboard.section.header.val = {

			-- "                                                     ",
			-- "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			-- "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			-- "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			-- "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			-- "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			-- "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			-- "                                                     ",
			--
			--   '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
			--   '⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡖⠁⠀⠀⠀⠀⠀⠀⠈⢲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
			--   '⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀ ',
			--   '⠀⠀⠀⠀⠀⠀⠀⣸⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠀⠀⠀⠀ ',
			--   '⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⢀⣀⣤⣤⣤⣤⣀⡀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀ ',
			--   '⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣔⢿⡿⠟⠛⠛⠻⢿⡿⣢⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀ ',
			--   '⠀⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣷⣤⣀⡀⢀⣀⣤⣾⣿⣿⣿⣷⣶⣤⡀⠀⠀⠀⠀ ',
			--   '⠀⠀⢠⣾⣿⡿⠿⠿⠿⣿⣿⣿⣿⡿⠏⠻⢿⣿⣿⣿⣿⠿⠿⠿⢿⣿⣷⡀⠀⠀ ',
			--   '⠀⢠⡿⠋⠁⠀⠀⢸⣿⡇⠉⠻⣿⠇⠀⠀⠸⣿⡿⠋⢰⣿⡇⠀⠀⠈⠙⢿⡄⠀ ',
			--   '⠀⡿⠁⠀⠀⠀⠀⠘⣿⣷⡀⠀⠰⣿⣶⣶⣿⡎⠀⢀⣾⣿⠇⠀⠀⠀⠀⠈⢿⠀ ',
			--   '⠀⡇⠀⠀⠀⠀⠀⠀⠹⣿⣷⣄⠀⣿⣿⣿⣿⠀⣠⣾⣿⠏⠀⠀⠀⠀⠀⠀⢸⠀ ',
			--   '⠀⠁⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⢇⣿⣿⣿⣿⡸⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠈⠀ ',
			--   '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
			--   '⠀⠀⠀⠐⢤⣀⣀⢀⣀⣠⣴⣿⣿⠿⠋⠙⠿⣿⣿⣦⣄⣀⠀⠀⣀⡠⠂⠀⠀⠀ ',
			--   '⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠉⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠋⠁⠀⠀⠀⠀⠀ ',

			-- "                    .                   ",
			-- "                   .:.                  ",
			-- "                  .:::.                 ",
			-- "                 .:::::.                ",
			-- "                .:::::::.               ",
			-- "               ..::::::::               ",
			-- "               .:::::::::..             ",
			-- "              :.          :             ",
			-- "             :::.       .:::            ",
			-- "            :::::.     .:::::.          ",
			-- "            :::::.     .:::::.          ",
			-- "          .:::::::.   .:::::::.         ",
			-- "         .::::::::::.::::::::::.        ",
			-- "          -%  %-+@%==@@==# .@:          ",
			-- "          -@####%%%%%%@%####@:          ",
			-- "          -@##@@*------#@@##@:          ",
			-- "           .@#@@=-#..%:+@@#@            ",
			-- "           :@##- :+  *: -##@.           ",
			-- "           :@#@-        =@#@.           ",
			-- "             @#@%=.--.=%%%%             ",
			-- "              %#*#@@@@#*#*              ",
			-- "              %#+======+#*              ",
			-- "            :%=*#**==**#*=%:            ",
			-- "           .@@@#*=::::+*#@@@            ",
			-- "          -@+*%@#*%%%%*%@%*+@:          ",
			-- "          -@@@@@=      +@@@@@:          ",

			"          ▀████▀▄▄              ▄█ ",
			"            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ",
			"    ▄        █          ▀▀▀▀▄  ▄▀  ",
			"   ▄▀ ▀▄      ▀▄              ▀▄▀  ",
			"  ▄▀    █     █▀   ▄█▀▄      ▄█    ",
			"  ▀▄     ▀▄  █     ▀██▀     ██▄█   ",
			"   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ",
			"    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ",
			"   █   █  █      ▄▄           ▄▀   ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button(
				"SPC fv",
				"  > File Explorer",
				":Telescope file_browser path=%:p:h select_buffer=true<CR>"
			),
			dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  > Find Text", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("r", "  > Recent Files", ":Telescope oldfiles<CR>"),
			dashboard.button("c", "  > Settings", "<cmd>edit ~/.config/nvim/init.lua| :cd %:p:h <CR>"),

			--dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("l", "  > Vim Marks", ":Telescope marks<CR>"),
			dashboard.button("p", "󰂖  > Plugins", "<Cmd>Lazy<CR>"),
			dashboard.button("t", "  > Install language tools", "<cmd>Mason<CR>"),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

		dashboard.section.footer.val = footer()
	end,
}
