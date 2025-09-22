-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim auto format
vim.g.autoformat = true

-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.backup = false -- Disable backup files
opt.backupskip = { "/tmp/*", "/private/tmp/*" } -- Specify backup files to skip
opt.backspace = { "start", "eol", "indent" } -- Define backspace behavior
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.encoding = "utf-8" -- Set encoding to UTF-8
opt.fileencoding = "utf-8" -- Set file encoding to UTF-8
opt.foldmethod = "indent"
opt.formatoptions = "jcqlnt" -- tcqj
opt.incsearch = true -- Enable incremental searching
opt.laststatus = 3 -- global statusline
opt.listchars = { eol = "↵", tab = ">-" } -- Configure list characters (eol = '↵', tab = '>-')
--opt.path:append({ "**" }) -- Configure the search path to search down into subfolders
opt.pumheight = 5 -- Maximum number of entries in a popup
opt.shiftwidth = 4 -- Size of an indent
opt.showmatch = true -- Highlight matching parentheses
opt.softtabstop = 4 -- Set the default soft tabstop to 4 spaces
opt.swapfile = false -- Disable swap file
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Specify the undo directory
opt.tabstop = 4 -- Number of spaces tabs count for
opt.wildmode = "longest:full,full" -- Command-line completion mode

-----------------------------------------------------------
-- below options are in testing mode
--opt.showcmd = true -- Show command in status line
--opt.cmdheight = 1 -- Set the command line height
--opt.breakindent = true -- Enable automatic indentation of wrapped lines
--opt.hlsearch = false -- Disable highlighting of search results

-----------------------------------------------------------
-- Optionals
-----------------------------------------------------------
--opt.lazyredraw = false -- Enable lazy redraw for faster scrolling
