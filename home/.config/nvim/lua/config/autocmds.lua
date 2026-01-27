-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- Automatically remove trailing whitespace from lines in a file just before you save it.
local TrimWhiteSpaceGrp = vim.api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = TrimWhiteSpaceGrp,
  pattern = "*",
  callback = function(ev)
    -- 1. Filter: Don't strip on markdown or text files
    local ignore_filetypes = { ["markdown"] = true, ["text"] = true }
    if ignore_filetypes[vim.bo[ev.buf].filetype] then
      return
    end

    -- 2. Save Cursor: Don't let the cursor jump
    local save_cursor = vim.fn.getpos(".")

    -- 3. Strip: remove trailing whitespace
    pcall(function()
      vim.cmd([[%s/\s\+$//e]])
    end)

    -- 4. Restore Cursor: Put it back where it was
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
  group = cursorGrp,
  callback = function()
    if vim.fn.winnr() ~= 0 then
      vim.cmd("set cursorline")
    else
      vim.cmd("set nocursorline")
    end
  end,
})

-- sync clipboards because I'm easily confused
local bufcheck = vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = bufcheck,
  pattern = "*",
  callback = function()
    vim.fn.setreg("+", vim.fn.getreg("*"))
  end,
})

-- Autosave when leaving a buffer or when focus of neovim client (window) is lost.
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_command("silent update")
    end
  end,
})
