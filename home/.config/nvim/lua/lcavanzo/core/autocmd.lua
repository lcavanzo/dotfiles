vim.cmd("autocmd!")

-- Leader
vim.cmd('let mapleader=" "')

-- cmd
vim.cmd("set termguicolors")
vim.cmd("set hidden")
vim.cmd("set noswapfile")
vim.cmd("set noerrorbells")

-- Folds
vim.cmd("set foldmethod=syntax") -- or indent
vim.cmd("set foldlevelstart=99")

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})
