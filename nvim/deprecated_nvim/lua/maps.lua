local keymap = vim.keymap
local opts = {noremap = true, silent = true}

keymap.set('n', 'x', '"_x')

-- Increment/decrement
--keymap.set('n', '+', '<C-a>')
--keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Buffers
keymap.set('n', 'sm', ':bnext<CR>', opts)
keymap.set('n', 'sn', ':bprevious<CR>', opts)
keymap.set('n', 'sx', ':bdelete<CR>', opts)

-- Split window
keymap.set('n', 'sp', ':split<Return><C-w>w', {silent = true})
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', {silent = true})

-- Move window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')
