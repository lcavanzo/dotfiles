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
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "Create a new tab with '<leader>t'" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close the current tab with '<leader>c'" })
vim.keymap.set("n", "<leader>t[", ":tabnext<CR>", { desc = "Switch to the next tab with '<leader>n'" })
vim.keymap.set("n", "<leader>t]", ":tabprevious<CR>", { desc = "Switch to the previous tab with '<leader>m'" })

-- Normal mode: Uncomment the following lines to navigate between buffers
vim.keymap.set("n", "<leader>b[", ":bnext<CR>", { desc = "Switch to the next buffer with '<leader>['" })
vim.keymap.set("n", "<leader>b]", ":bprevious<CR>", { desc = "Switch to the previous buffer with '<leader>]'" })
vim.keymap.set("n", "<leader>bx", ":bdelete<CR>", { desc = "Delete the current buffer with '<leader>x'" })

-- Normal mode: Toggle 'listchar' display with '<leader>d'
vim.keymap.set("n", "<leader>i", ":set invlist<CR>", { desc = "Toggle 'listchar' display with '<leader>d'" })

-- Split window
vim.keymap.set("n", "<leader>w-", ":split<Return><C-w>w", { silent = true })
vim.keymap.set("n", "<leader>w|", ":vsplit<Return><C-w>w", { silent = true })

-- Move to window using the <ctrl> hjkl keys
-- TODO Fix this, is annoying to press twice control
-- press only once control
vim.keymap.set("", "<D-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("", "<D-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("", "<D-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
----- Not sure why only works in this way :(
vim.keymap.set("", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<leader>wk", "<cmd>resize +5<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>wj", "<cmd>resize -5<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>wl", "<cmd>vertical resize +5<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<leader>wh", "<cmd>vertical resize -5<cr>", { desc = "Increase window width" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

vim.keymap.set("n", ";wf", ":noautocmd w<CR>", { desc = "Save without formatting" })
vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Jumplist Navigation
-- vim.keymap.set("n", "<leader>j", "<C-O>", { noremap = true, silent = true }) -- Older jump
-- vim.keymap.set("n", "<leader>i", "<C-I>", { noremap = true, silent = true }) -- Newer jump
vim.keymap.set("n", "<leader>i", "``", { noremap = true, silent = true })

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
