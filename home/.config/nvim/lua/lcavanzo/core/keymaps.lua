vim.g.mapleader = " "

-- Insert mode: Use 'jj' to quickly exit insert mode
vim.keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with 'jj'" })

-- Normal mode: Save the current file with '<leader>s'
vim.keymap.set("n", "<leader>s", ":write<CR>", { desc = "Save the current file with '<leader>s'" })

-- Normal mode: Refresh the currently open file with '<leader>e'
vim.keymap.set("n", "<leader>re", ":edit<CR>", { desc = "Refresh the currently open file with '<leader>e'" })
vim.keymap.set("n", "<leader>e", ":edit", { desc = "open file with '<leader>e'" })

-- Normal mode: Quit Vim with '<leader>q', or force quit with '<leader>Q'
vim.keymap.set("n", "<leader>qq", ":quit<CR>", { desc = "Quit Vim with '<leader>q', or force quit with '<leader>Q'" })
vim.keymap.set("n", "<leader>QQ", ":qa!<CR>", { desc = "Force quit Vim with '<leader>Q'" })

-- Normal mode: Manage Vim tabs
vim.keymap.set("n", "<leader>tt", ":tabnew<CR>", { desc = "Create a new tab with '<leader>t'" })
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>", { desc = "Close the current tab with '<leader>c'" })
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "Switch to the next tab with '<leader>n'" })
vim.keymap.set("n", "<leader>tm", ":tabprevious<CR>", { desc = "Switch to the previous tab with '<leader>m'" })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
vim.keymap.set({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })

-- Normal mode: Uncomment the following lines to navigate between buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Switch to the next buffer with '<leader>['" })
vim.keymap.set("n", "<leader>bm", ":bprevious<CR>", { desc = "Switch to the previous buffer with '<leader>]'" })
vim.keymap.set("n", "<leader>bx", ":bdelete<CR>", { desc = "Delete the current buffer with '<leader>x'" })

-- Normal mode: Toggle 'listchar' display with '<leader>d'
vim.keymap.set("n", "<leader>i", ":set invlist<CR>", { desc = "Toggle 'listchar' display with '<leader>d'" })

-- Split window
vim.keymap.set("n", "<leader>w-", ":split<Return><C-w>w", { silent = true })
vim.keymap.set("n", "<leader>w|", ":vsplit<Return><C-w>w", { silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", silent = true })

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
