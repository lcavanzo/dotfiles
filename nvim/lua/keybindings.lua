-- keymap mode, shortcut, action, config
local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- *****************************************************************************
-- Mappings
-- *****************************************************************************

keymap('i', 'jj', '<ESC>', opts)

-- Clear search highlight
keymap('n', '<leader>l', ':noh<return><esc>', opts)

-- Quick save command
keymap('n', '<leader>s', ':write<CR>', opts)

-- Quick refresh the currenlty file
keymap('n', '<leader>e', ':edit<CR>', opts)

-- Quick quit command
keymap('n', '<leader>q', ':quit<CR>', opts)
keymap('n', '<leader>Q', ':qa!<CR>', opts)

-- Buffers
keymap('n', '<leader>m', ':bnext<CR>', opts)
keymap('n', '<leader>n', ':bprevious<CR>', opts)
keymap('n', '<leader>x', ':bdelete<CR>', opts)

-- Vim Tabs
keymap('n', '<leader>t', ':tabnew<CR>', opts)
keymap('n', '<leader>c', ':tabclose<CR>', opts)
keymap('n', '<leader>r', ':tabnext<CR>', opts)
keymap('n', '<leader>y', ':tabprevious<CR>', opts)

-- togle listchar display
keymap('n', '<leader>d', ':setinvlist<CR>', opts)

