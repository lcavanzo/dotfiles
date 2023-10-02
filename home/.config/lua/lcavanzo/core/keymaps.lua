vim.g.mapleader = " "

vim.keymap.set('i', 'jj', '<ESC>', opts)

-- Clear search highlight
vim.keymap.set('n', '<leader>l', ':noh<return><esc>', opts)

-- Quick save command
vim.keymap.set('n', '<leader>s', ':write<CR>', opts)

-- Quick refresh the currenlty file
vim.keymap.set('n', '<leader>e', ':edit<CR>', opts)

-- Quick quit command
vim.keymap.set('n', '<leader>q', ':quit<CR>', opts)
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', opts)

-- Buffers
--vim.keymap.set('n', '<leader>m', ':bnext<CR>', opts)
--vim.keymap.set('n', '<leader>n', ':bprevious<CR>', opts)
--vim.keymap.set('n', '<leader>x', ':bdelete<CR>', opts)

-- Vim Tabs
vim.keymap.set('n', '<leader>t', ':tabnew<CR>', opts)
vim.keymap.set('n', '<leader>c', ':tabclose<CR>', opts)
vim.keymap.set('n', '<leader>n', ':tabnext<CR>', opts)
vim.keymap.set('n', '<leader>m', ':tabprevious<CR>', opts)

-- togle listchar display
vim.keymap.set('n', '<leader>d', ':setinvlist<CR>', opts)




vim.keymap.set('i', 'jj', '<ESC>', opts)

-- Clear search highlight
vim.keymap.set('n', '<leader>l', ':noh<return><esc>', opts)

-- Quick save command
vim.keymap.set('n', '<leader>s', ':write<CR>', opts)

-- Quick refresh the currenlty file
vim.keymap.set('n', '<leader>e', ':edit<CR>', opts)

-- Quick quit command
vim.keymap.set('n', '<leader>q', ':quit<CR>', opts)
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', opts)

-- Buffers
--vim.keymap.set('n', '<leader>m', ':bnext<CR>', opts)
--vim.keymap.set('n', '<leader>n', ':bprevious<CR>', opts)
--vim.keymap.set('n', '<leader>x', ':bdelete<CR>', opts)

-- Vim Tabs
vim.keymap.set('n', '<leader>t', ':tabnew<CR>', opts)
vim.keymap.set('n', '<leader>c', ':tabclose<CR>', opts)
vim.keymap.set('n', '<leader>n', ':tabnext<CR>', opts)
vim.keymap.set('n', '<leader>m', ':tabprevious<CR>', opts)

-- togle listchar display
vim.keymap.set('n', '<leader>d', ':setinvlist<CR>', opts)

