vim.g.mapleader = " "

-- Insert mode: Use 'jj' to quickly exit insert mode
vim.keymap.set('i', 'jj', '<ESC>', { desc = "Exit insert mode with 'jj'" })

-- Normal mode: Clear search highlights when pressing '<leader>l'
vim.keymap.set('n', '<leader>l', ':noh<return><esc>', { desc = "Clear search highlights with '<leader>l'" })

-- Normal mode: Save the current file with '<leader>s'
vim.keymap.set('n', '<leader>s', ':write<CR>', { desc = "Save the current file with '<leader>s'" })

-- Normal mode: Refresh the currently open file with '<leader>e'
vim.keymap.set('n', '<leader>e', ':edit<CR>', { desc = "Refresh the currently open file with '<leader>e'" })

-- Normal mode: Quit Vim with '<leader>q', or force quit with '<leader>Q'
vim.keymap.set('n', '<leader>q', ':quit<CR>', { desc = "Quit Vim with '<leader>q', or force quit with '<leader>Q'" })
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = "Force quit Vim with '<leader>Q'" })

-- Normal mode: Uncomment the following lines to navigate between buffers
--vim.keymap.set('n', '<leader>m', ':bnext<CR>', { desc = "Switch to the next buffer with '<leader>m'" })
--vim.keymap.set('n', '<leader>n', ':bprevious<CR>', { desc = "Switch to the previous buffer with '<leader>n'" })
--vim.keymap.set('n', '<leader>x', ':bdelete<CR>', { desc = "Delete the current buffer with '<leader>x'" })

-- Normal mode: Manage Vim tabs
vim.keymap.set('n', '<leader>t', ':tabnew<CR>', { desc = "Create a new tab with '<leader>t'" })
vim.keymap.set('n', '<leader>c', ':tabclose<CR>', { desc = "Close the current tab with '<leader>c'" })
vim.keymap.set('n', '<leader>n', ':tabnext<CR>', { desc = "Switch to the next tab with '<leader>n'" })
vim.keymap.set('n', '<leader>m', ':tabprevious<CR>', { desc = "Switch to the previous tab with '<leader>m'" })

-- Normal mode: Toggle 'listchar' display with '<leader>d'
vim.keymap.set('n', '<leader>d', ':set invlist<CR>', { desc = "Toggle 'listchar' display with '<leader>d'" })
