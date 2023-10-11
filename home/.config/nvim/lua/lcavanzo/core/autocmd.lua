local api = vim.api

-- This file is automatically loaded by lazyvim.config.init.
local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
	command = [[:%s/\s\+$//e]],
	group = TrimWhiteSpaceGrp,
})

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- detect typst filetype
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.typ" },
	callback = function()
		vim.api.nvim_command("set filetype=typst")
	end,
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- go to last loc when opening a buffer
api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	pattern = "*",
	command = "set cursorline",
	group = cursorGrp,
})
api.nvim_create_autocmd(
	{ "InsertEnter", "WinLeave" },
	{ pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	-- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
	{
		pattern = { "*.txt", "*.md", "*.tex" },
		callback = function()
			vim.opt.spell = true
			vim.opt.spelllang = "en,de"
		end,
	}
)

-- sync clipboards because I'm easily confused
api.nvim_create_autocmd("TextYankPost", {
	group = bufcheck,
	pattern = "*",
	callback = function()
		vim.fn.setreg("+", vim.fn.getreg("*"))
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
