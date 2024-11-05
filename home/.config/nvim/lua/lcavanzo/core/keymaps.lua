vim.g.mapleader = " "

-- Insert mode: Use 'jk' to quickly exit insert mode
vim.keymap.set("i", "kj", "<ESC>", { desc = "Exit insert mode with 'jj'" })

-- Normal mode: Save the current file with '<leader>s'
vim.keymap.set("n", "<leader>s", ":write<CR>", { desc = "Save the current file with '<leader>s'" })

-- Normal mode: Refresh the currently open file with '<leader>e'
vim.keymap.set("n", "<leader>re", ":edit<CR>", { desc = "Refresh the currently open file with '<leader>e'" })
vim.keymap.set("n", "<leader>e", ":edit", { desc = "open file with '<leader>e'" })

-- Normal mode: Quit Vim with '<leader>q', or force quit with '<leader>Q'
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Quit Vim with '<leader>q', or force quit with '<leader>Q'" })
vim.keymap.set("n", "QQ", ":qa!<CR>", { desc = "Force quit Vim with 'QQ'" })
vim.keymap.set("n", "WW", ":w!<enter>", { desc = "Save file" })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
vim.keymap.set({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })

-- In visual mode, after going to the end of the line, come back 1 character
vim.keymap.set("v", "gl", "$h", { desc = "[P]Go to the end of the line" })

-- Normal mode: Uncomment the following lines to navigate between buffers
-- vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true, desc = "Switch to the next buffer" })
-- vim.keymap.set(
-- 	"n",
-- 	"<S-H>>",
-- 	":bprevious<CR>",
-- 	{ noremap = true, silent = true, desc = "Switch to the previous buffer" }
-- )" tab and shift-tab keys to navigate buffers back and forth
-- opt-tab and shift-opt-tab keys to navigate tab pages
-- vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true, desc = "Switch to the next buffer" })
-- vim.keymap.set(
-- 	"n",
-- 	"<S-TAB>",
-- 	":bprevious<CR>",
-- 	{ noremap = true, silent = true, desc = "Switch to the previous buffer" }
-- )

-- Normal mode: Toggle 'listchar' display with '<leader>d'
vim.keymap.set("n", "<leader>i", ":set invlist<CR>", { desc = "Toggle 'listchar' display with '<leader>d'" })

-- Split window
vim.keymap.set("n", "w-", ":split<Return><C-w>w", { silent = true })
vim.keymap.set("n", "w|", ":vsplit<Return><C-w>w", { silent = true })

-- -- Move to window using the <ctrl> hjkl keys
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", silent = true })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", silent = true })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", silent = true })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", silent = true })

-- vim.keymap.set("n", "<C-h>", function()
-- 	print("Ctrl+h pressed")
-- end, { silent = true })
-- vim.keymap.set("n", "<C-j>", function()
-- 	print("Ctrl+j pressed")
-- end, { silent = true })
-- vim.keymap.set("n", "<C-k>", function()
-- 	print("Ctrl+k pressed")
-- end, { silent = true })
-- vim.keymap.set("n", "<C-l>", function()
-- 	print("Ctrl+l pressed")
-- end, { silent = true })

-- Create a resize mode
vim.api.nvim_create_augroup("ResizeMode", { clear = true })

-- Function to handle resizing
local function resize_window(direction, amount)
	if direction == "horizontal" then
		vim.cmd("vertical resize " .. (vim.fn.winwidth(0) + amount))
	else
		vim.cmd("resize " .. (vim.fn.winheight(0) + amount))
	end
end

-- Function to exit resize mode
local function exit_resize_mode()
	vim.api.nvim_clear_autocmds({ group = "ResizeMode" })
	for _, key in ipairs({ "h", "j", "k", "l", "<Esc>" }) do
		pcall(vim.keymap.del, "n", key, { buffer = true })
	end
	print("Exited resize mode")
end

-- Variable to track if we're in resize mode
local resize_mode_active = false

-- Set up the resize mode
vim.keymap.set("n", "<leader>r", function()
	if resize_mode_active then
		exit_resize_mode()
		resize_mode_active = false
	else
		resize_mode_active = true
		print("Resize mode: h/l - width, j/k - height, <Esc> to exit")

		-- Set up autocmd to exit resize mode when cursor moves
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = "ResizeMode",
			callback = function()
				exit_resize_mode()
				resize_mode_active = false
			end,
			once = true,
		})

		-- Set up temporary keymaps for resize mode
		local opts = { buffer = true, silent = true }
		local resize_mappings = {
			h = function()
				resize_window("horizontal", -2)
			end,
			l = function()
				resize_window("horizontal", 2)
			end,
			j = function()
				resize_window("vertical", -2)
			end,
			k = function()
				resize_window("vertical", 2)
			end,
			["<Esc>"] = function()
				exit_resize_mode()
				resize_mode_active = false
			end,
		}

		for key, func in pairs(resize_mappings) do
			vim.keymap.set("n", key, func, opts)
		end
	end
end, { silent = true, desc = "Toggle resize mode" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

vim.keymap.set("n", ";wf", ":noautocmd w<CR>", { desc = "Save without formatting" })

-- Jumplist Navigation
-- vim.keymap.set("n", "<leader>j", "<C-O>", { noremap = true, silent = true }) -- Older jump
-- vim.keymap.set("n", "<leader>i", "<C-I>", { noremap = true, silent = true }) -- Newer jump
vim.keymap.set("n", "<leader>j", "``", { desc = "Jump back between Jumplist" })

-- mappings, to add normal j/k motions to the jumplist whenever I jump more that 2 lines
vim.keymap.set(
	"n",
	"j",
	[[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']],
	{ noremap = true, expr = true }
)

vim.keymap.set(
	"n",
	"k",
	[[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']],
	{ noremap = true, expr = true }
)

--- test keymap => :verbose nmap <D-Up>

-- double semicolon expands to the cwd when typing a command
vim.keymap.set("c", ";;", function()
	return vim.fn.getcmdtype() == ":" and vim.fn.expand("%:h") .. "/" or ";;"
end, { expr = true })

-- Yanking with `y` goes to the unnamed register, accessible only within Vim.
-- The system clipboard allows sharing data between Vim and other applications.
-- Yanking with `"+y` copies text to both the unnamed register and system clipboard.
-- The `"+` register represents the system clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[P]Yank to system clipboard" })

-- Replaces the word I'm currently on, opens a terminal so that I start typing the new word
-- It replaces the word globally across the entire file
vim.keymap.set(
	"n",
	"<leader>su",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[P]Replace word I'm currently on GLOBALLY" }
)

-- Replaces the current word with the same word in uppercase, globally
vim.keymap.set(
	"n",
	"<leader>sU",
	[[:%s/\<<C-r><C-w>\>/<C-r>=toupper(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
	{ desc = "[P]GLOBALLY replace word I'm on with UPPERCASE" }
)

-- Replaces the current word with the same word in lowercase, globally
vim.keymap.set(
	"n",
	"<leader>sL",
	[[:%s/\<<C-r><C-w>\>/<C-r>=tolower(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
	{ desc = "[P]GLOBALLY replace word I'm on with lowercase" }
)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- moves the selected lines down/up one line.
-- Then it reselects the moved text.
-- It re-indents the text to maintain proper indentation.
-- Finally, it selects the text again, allowing for repeated presses.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- The first keeps the cursor position stable when joining lines.
vim.keymap.set("n", "J", "mzJ`z")

-- center the view and open folds when moving between search results.
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- copies) the selected text or object to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- yanks the whole line to the system clipboard.
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- sends the deleted text to the "black hole" register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- quick way to perform global search and replace operations.
vim.keymap.set("n", "<leader>%", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "zd", "<C-d>zz", { noremap = true, desc = "Scroll down half-page and center" })
vim.keymap.set("n", "zu", "<C-u>zz", { noremap = true, desc = "Scroll up half-page and center" })

vim.keymap.set("n", "zn", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "zp", "<cmd>cprev<CR>zz")

-- Set up a keymap to refresh the current buffer
vim.keymap.set("n", "<leader>B", function()
	-- Reloads the file to reflect the changes
	vim.cmd("edit!")
	print("Buffer reloaded")
end, { desc = "[P]Reload current buffer" })

vim.keymap.set("n", "<TAB>", "<cmd>e #<CR>", { noremap = true, desc = "Switch between current and latest buffer" })

-- Make the file you run the command on, executable, so you don't have to go out to the command line
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set("n", "<leader>fx", '<cmd>!chmod +x "%"<CR>', { silent = true, desc = "Make file executable" })
vim.keymap.set("n", "<leader>fX", '<cmd>!chmod -x "%"<CR>', { silent = true, desc = "Remove executable flag" })

-- If this is a bash script, make it executable, and execute it in a tmux pane on the right
-- Using a tmux pane allows me to easily select text
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set("n", "<leader>cb", function()
	local file = vim.fn.expand("%") -- Get the current file name
	local first_line = vim.fn.getline(1) -- Get the first line of the file
	if string.match(first_line, "^#!/") then -- If first line contains shebang
		local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands

		-- Execute the script on a tmux pane on the right. On my mac I use zsh, so
		-- running this script with bash to not execute my zshrc file after
		-- vim.cmd("silent !tmux split-window -h -l 60 'bash -c \"" .. escaped_file .. "; exec bash\"'")
		-- `-l 60` specifies the size of the tmux pane, in this case 60 columns
		vim.cmd(
			"silent !tmux split-window -h -l 60 'bash -c \""
				.. escaped_file
				.. "; echo; echo Press any key to exit...; read -n 1; exit\"'"
		)
	else
		vim.cmd("echo 'Not a script. Shebang line not found.'")
	end
end, { desc = "[P]BASH, execute file" })

-- Toggle spelling
vim.keymap.set("n", "<leader>ns", ":set spell!<CR>")

-- Next misspelled word
vim.keymap.set("n", "z[", "]s", { noremap = true, desc = "Next misspelled word" })

-- Previous misspelled word
vim.keymap.set("n", "z]", "[s", { noremap = true, desc = "Previous misspelled word" })

-- Execute normal mode mapping from insert mode and return to insert
vim.keymap.set("i", "<C-o>", "<C-o><C-\\><C-n>", { noremap = true })
-- ############################################################################
--                             Image section
-- ############################################################################

-- Paste images
-- I use a Ctrl keymap so that I can paste images in insert mode
-- I tried using <C-v> but duh, that's used for visual block mode
-- so don't do it
vim.keymap.set({ "n", "v", "i" }, "<C-a>", function()
	-- Call the paste_image function from the Lua API
	-- Using the plugin's Lua API (require("img-clip").paste_image()) instead of the
	-- PasteImage command because the Lua API returns a boolean value indicating
	-- whether an image was pasted successfully or not.
	-- The PasteImage command does not
	-- https://github.com/HakonHarnes/img-clip.nvim/blob/main/README.md#api
	local pasted_image = require("img-clip").paste_image()
	if pasted_image then
		-- "Update" saves only if the buffer has been modified since the last save
		vim.cmd("update")
		print("Image pasted and file saved")
		-- Only if updated I'll refresh the images by clearing them first
		-- I'm using [[ ]] to escape the special characters in a command
		require("image").clear()
		-- vim.cmd([[lua require("image").clear()]])
		-- Reloads the file to reflect the changes
		vim.cmd("edit!")
		-- Switch to the line below
		vim.cmd("normal! o")
		-- Switch back to command mode or normal mode
		vim.cmd("startinsert")
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("- ", true, false, true), "i", true)
	else
		print("No image pasted. File not updated.")
	end
end, { desc = "[P]Paste image from system clipboard" })

-- ############################################################################

-- Open image under cursor in the Preview app (macOS)
vim.keymap.set("n", "<leader>io", function()
	local function get_image_path()
		-- Get the current line
		local line = vim.api.nvim_get_current_line()
		-- Pattern to match image path in Markdown
		local image_pattern = "%[.-%]%((.-)%)"
		-- Extract relative image path
		local _, _, image_path = string.find(line, image_pattern)

		return image_path
	end

	-- Get the image path
	local image_path = get_image_path()

	if image_path then
		-- Check if the image path starts with "http" or "https"
		if string.sub(image_path, 1, 4) == "http" then
			print("URL image, use 'gx' to open it in the default browser.")
		else
			-- Construct absolute image path
			local current_file_path = vim.fn.expand("%:p:h")
			local absolute_image_path = current_file_path .. "/" .. image_path

			-- Construct command to open image in Preview
			local command = "open -a Preview " .. vim.fn.shellescape(absolute_image_path)
			-- Execute the command
			local success = os.execute(command)

			if success then
				print("Opened image in Preview: " .. absolute_image_path)
			else
				print("Failed to open image in Preview: " .. absolute_image_path)
			end
		end
	else
		print("No image found under the cursor")
	end
end, { desc = "[P](macOS) Open image under cursor in Preview" })

-- ############################################################################

-- Open image under cursor in Finder (macOS)
--
-- THIS ONLY WORKS IF YOU'RE NNNNNOOOOOOTTTTT USING ABSOLUTE PATHS,
-- BUT INSTEAD YOURE USING RELATIVE PATHS
--
-- If using absolute paths, use the default `gx` to open the image instead
vim.keymap.set("n", "<leader>if", function()
	local function get_image_path()
		-- Get the current line
		local line = vim.api.nvim_get_current_line()
		-- Pattern to match image path in Markdown
		local image_pattern = "%[.-%]%((.-)%)"
		-- Extract relative image path
		local _, _, image_path = string.find(line, image_pattern)

		return image_path
	end

	-- Get the image path
	local image_path = get_image_path()

	if image_path then
		-- Check if the image path starts with "http" or "https"
		if string.sub(image_path, 1, 4) == "http" then
			print("URL image, use 'gx' to open it in the default browser.")
		else
			-- Construct absolute image path
			local current_file_path = vim.fn.expand("%:p:h")
			local absolute_image_path = current_file_path .. "/" .. image_path

			-- Open the containing folder in Finder and select the image file
			local command = "open -R " .. vim.fn.shellescape(absolute_image_path)
			local success = vim.fn.system(command)

			if success == 0 then
				print("Opened image in Finder: " .. absolute_image_path)
			else
				print("Failed to open image in Finder: " .. absolute_image_path)
			end
		end
	else
		print("No image found under the cursor")
	end
end, { desc = "[P](macOS) Open image under cursor in Finder" })

-- ############################################################################

-- Delete image file under cursor using trash app (macOS)
vim.keymap.set("n", "<leader>id", function()
	local function get_image_path()
		-- Get the current line
		local line = vim.api.nvim_get_current_line()
		-- Pattern to match image path in Markdown
		local image_pattern = "%[.-%]%((.-)%)"
		-- Extract relative image path
		local _, _, image_path = string.find(line, image_pattern)

		return image_path
	end
	-- Get the image path
	local image_path = get_image_path()
	if image_path then
		-- Check if the image path starts with "http" or "https"
		if string.sub(image_path, 1, 4) == "http" then
			vim.api.nvim_echo({
				{ "URL image cannot be deleted from disk.", "WarningMsg" },
			}, false, {})
		else
			-- Construct absolute image path
			local current_file_path = vim.fn.expand("%:p:h")
			local absolute_image_path = current_file_path .. "/" .. image_path
			-- Check if trash utility is installed
			if vim.fn.executable("trash") == 0 then
				vim.api.nvim_echo({
					{ "- Trash utility not installed. Make sure to install it first\n", "ErrorMsg" },
					{ "- In macOS run `brew install trash`\n", nil },
				}, false, {})
				return
			end
			-- Prompt for confirmation before deleting the image
			vim.ui.select({ "yes", "no" }, { prompt = "Delete image file? " }, function(choice)
				if choice == "yes" then
					-- Delete the image file using trash app
					local success, _ = pcall(function()
						vim.fn.system({ "trash", vim.fn.fnameescape(absolute_image_path) })
					end)
					if success then
						vim.api.nvim_echo({
							{ "Image file deleted from disk:\n", "Normal" },
							{ absolute_image_path, "Normal" },
						}, false, {})
						-- I'll refresh the images, but will clear them first
						require("image").clear()
						-- I'm using [[ ]] to escape the special characters in a command
						-- vim.cmd([[lua require("image").clear()]])
						-- Reloads the file to reflect the changes
						vim.cmd("edit!")
						-- Delete the line the cursor is at
						vim.cmd("normal! dd")
					else
						vim.api.nvim_echo({
							{ "Failed to delete image file:\n", "ErrorMsg" },
							{ absolute_image_path, "ErrorMsg" },
						}, false, {})
					end
				else
					vim.api.nvim_echo({
						{ "Image deletion canceled.", "Normal" },
					}, false, {})
				end
			end)
		end
	else
		vim.api.nvim_echo({
			{ "No image found under the cursor", "WarningMsg" },
		}, false, {})
	end
end, { desc = "[P](macOS) Delete image file under cursor" })

-- ############################################################################

-- Refresh the images in the current buffer
-- Useful if you delete an actual image file and want to see the changes
-- without having to re-open neovim
vim.keymap.set("n", "<leader>ir", function()
	-- First I clear the images
	require("image").clear()
	-- I'm using [[ ]] to escape the special characters in a command
	-- vim.cmd([[lua require("image").clear()]])
	-- Reloads the file to reflect the changes
	vim.cmd("edit!")
	print("Images refreshed")
end, { desc = "[P]Refresh images" })

-- ############################################################################

-- Set up a keymap to clear all images in the current buffer
vim.keymap.set("n", "<leader>ic", function()
	-- This is the command that clears the images
	require("image").clear()
	-- I'm using [[ ]] to escape the special characters in a command
	-- vim.cmd([[lua require("image").clear()]])
	print("Images cleared")
end, { desc = "[P]Clear images" })

-- ############################################################################
-- TMP for adding double ticks
vim.keymap.set("n", "<leader>'", "i`` <Esc>i", { desc = "Add double backticks and place cursor between" })
