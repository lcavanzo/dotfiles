local data = vim.fn.stdpath('data')

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'


vim.opt.relativenumber = true
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = 'fish'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.signcolumn = 'yes'

-- listchar
vim.opt.listchars = {eol = '↵', tab = '>-'}
vim.opt.list = true


-- Add asterisks in block comments
vim.opt.formatoptions:append { 'r' }


vim.wo.number = true


-- mouse
vim.o.mouse = "a"

-- Undo files
vim.o.undofile = true
vim.o.undodir = vim.fn.expand(data .. '/undo//')


-- Bigger history
vim.g.history = 3000
