-----------------------------------------------------------
-- General
-----------------------------------------------------------
vim.opt.encoding = 'utf-8'       -- Set encoding to UTF-8
vim.opt.fileencoding = 'utf-8'   -- Set file encoding to UTF-8
vim.opt.relativenumber = true    -- Show relative line numbers
vim.opt.title = true             -- Show the title of the current window in the terminal title
vim.opt.backup = false           -- Disable backup files
vim.opt.inccommand = 'split'     -- Enable incremental command line completion
vim.opt.ignorecase = true        -- Enable case-insensitive searching (unless /C or capital letter in search)
vim.opt.path:append { '**' }     -- Configure the search path to search down into subfolders
vim.opt.list = true              -- Enable line numbering and list mode
vim.opt.nu = true                -- Enable line numbering
vim.o.mouse = "a"                -- Enable mouse support
vim.o.undofile = true            -- Enable undo file
vim.opt.wrap = false             -- Disable line wrapping
vim.opt.swapfile = false         -- Disable swap file
vim.o.clipboard = 'unnamedplus'  -- Configure clipboard options
vim.o.smartcase = true           -- Enable smart case for searching
vim.opt.incsearch = true         -- Enable incremental searching
vim.o.updatetime = 250           -- Decrease update and timeout intervals
vim.o.timeoutlen = 300           -- Decrease update and timeout intervals
vim.opt.termguicolors = true     -- Enable termguicolors
opt.completeopt = 'menuone,noinsert,noselect'          -- Configure completion options
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }    -- Specify backup files to skip
vim.opt.listchars = { eol = '↵', tab = '>-'}           -- Configure list characters (eol = '↵', tab = '>-')
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Specify the undo directory

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
vim.opt.showcmd = true      -- Show command in status line
vim.opt.cmdheight = 1       -- Set the command line height
vim.opt.laststatus = 2      -- Set the last status line to always show
vim.opt.scrolloff = 10      -- Set scrolloff to 10 lines
vim.opt.breakindent = true  -- Enable automatic indentation of wrapped lines
opt.showmatch = true        -- Highlight matching parentheses
opt.foldmethod = 'marker'   -- Enable folding using markers
opt.splitright = true       -- Open vertical splits to the right
opt.splitbelow = true       -- Open horizontal splits to the bottom

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
vim.opt.autoindent = true       -- Enable auto-indentation
vim.opt.smartindent = true      -- Enable smart indenting
vim.opt.hlsearch = false        -- Disable highlighting of search results
vim.opt.expandtab = true        -- Expand tabs to spaces
vim.opt.smarttab = true         -- Use smart tabs
vim.opt.shiftwidth = 4          -- Set the default shift width to 4 spaces
vim.opt.tabstop = 4             -- Set the default tabstop to 4 spaces
vim.opt.softtabstop = 4         -- Set the default soft tabstop to 4 spaces
vim.opt.wrap = false            -- Disable line wrapping
vim.opt.signcolumn = 'yes'      -- Show sign column
vim.opt.backspace = { 'start', 'eol', 'indent' } -- Define backspace behavior

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true          -- Enable hidden buffers
opt.history = 1000         -- Set the maximum number of lines in history
opt.lazyredraw = true      -- Enable lazy redraw for faster scrolling
opt.synmaxcol = 240        -- Set the maximum column for syntax highlighting
opt.updatetime = 250       -- Set the wait time (in ms) to trigger an event
vim.opt.colorcolumn = "80" -- Set color column to 80 characters
