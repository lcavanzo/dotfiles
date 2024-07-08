-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
--local fish_path = "/opt/homebrew/bin/fish"

-- This will hold the configuration.
local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- Settings
--config.default_prog = { fish_path, "-l" }

config.color_scheme = "Tokyo Night"
config.font = wezterm.font_with_fallback({
	{ family = "JetBrains Mono", scale = 1.2, weight = "Bold" },
})
config.font_size = 13

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE" -- REVIEW
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 20000
config.default_workspace = "local"

-- -- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.6,
}

-- Disabling keys, workign only with personal stuff
config.disable_default_key_bindings = true
-- Keys
config.leader = { key = "a", mods = "SUPER", timeout_milliseconds = 1000 }
config.keys = {

	-- Pane keybindings
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") }, -- REVIEW

	-- Debuging
	{ key = "L", mods = "LEADER", action = act.ShowDebugOverlay },

	-- Set behavior as a linux terminal
	{ key = "c", mods = "SUPER", action = act.SendKey({ key = "c", mods = "CTRL" }) }, -- ctrl-c
	{ key = "l", mods = "SUPER", action = act.SendKey({ key = "l", mods = "CTRL" }) }, -- ctrl-l
	{ key = "d", mods = "SUPER", action = act.SendKey({ key = "d", mods = "CTRL" }) }, -- ctrl-d
	{ key = "r", mods = "SUPER", action = act.SendKey({ key = "r", mods = "CTRL" }) }, -- ctrl-d
	{ key = "w", mods = "SUPER", action = act.SendKey({ key = "w", mods = "CTRL" }) }, -- ctrl-d

	-- Scroll Promtp
	{ key = "p", mods = "SUPER", action = act.SendKey({ key = "UpArrow" }) }, -- ctrl-d
	{ key = "n", mods = "SUPER", action = act.SendKey({ key = "DownArrow" }) }, -- ctrl-d

	-- increase/decrese font
	{ key = "+", mods = "SUPER", action = act.IncreaseFontSize }, -- ctrl-d
	{ key = "-", mods = "SUPER", action = act.DecreaseFontSize }, -- ctrl-d

	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode }, -- REVIEW

	-- Show all the available option in Wezterm
	{ key = "Space", mods = "LEADER", action = act.ActivateCommandPalette },

	-- Tab keybindings
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") }, -- New tab
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Key table for moving tabs around
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },

	-- Scroll down 1 line
	{ key = "k", mods = "SUPER", action = act.ScrollByLine(-1) },
	{ key = "j", mods = "SUPER", action = act.ScrollByLine(1) },

	-- Workspace -- REVIEW all the workspaces stuff
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "W",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},

	-- We can make separate keybindings for resizing panes
	-- But Wezterm offers custom "mode" in the name of "KeyTable"
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

-- Tab bar
-- I don't like the look of "fancy" tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
wezterm.on("update-status", function(window, pane)
	-- Workspace name
	local stat = window:active_workspace()
	local stat_color = "#f7768e"
	-- It's a little silly to have workspace name all the time
	-- Utilize this to display LDR or current key table name
	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = "#7dcfff"
	end
	if window:leader_is_active() then
		stat = "LDR"
		stat_color = "#bb9af7"
	end

	local basename = function(s)
		-- Nothing a little regex can't fix
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	-- Current working directory
	local cwd = pane:get_current_working_dir()
	if cwd then
		if type(cwd) == "userdata" then
			-- Wezterm introduced the URL object in 20240127-113634-bbcac864
			cwd = basename(cwd.file_path)
		else
			-- 20230712-072601-f4abf8fd or earlier version
			cwd = basename(cwd)
		end
	else
		cwd = ""
	end

	-- Current command
	local cmd = pane:get_foreground_process_name()
	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
	cmd = cmd and basename(cmd) or ""

	-- Time
	local time = wezterm.strftime("%H:%M")

	-- Left status (left of the tab line)
	window:set_left_status(wezterm.format({
		{ Foreground = { Color = stat_color } },
		{ Text = "  " },
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " |" },
	}))

	-- Right status
	window:set_right_status(wezterm.format({
		-- Wezterm has a built-in nerd fonts
		-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Foreground = { Color = "#e0af68" } },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		"ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = "  " },
	}))
end)
-- [[ Appearance setting for when I need to take pretty screenshots - disable the previous
--  fancy view
-- config.enable_tab_bar = false
-- config.window_padding = {
-- 	left = "0.5cell",
-- 	right = "0.5cell",
-- 	top = "0.5cell",
-- 	bottom = "0cell",
-- }
-- ]])

-- and finally, return the configuration to wezterm
return config
