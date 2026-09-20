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

local augroup = vim.api.nvim_create_augroup("ToggleRelativeNumber", { clear = true })

-- Disable relative line numbers when entering Insert Mode
vim.api.nvim_create_autocmd("InsertEnter", {
  group = augroup,
  desc = "Disable relative line numbers in Insert mode",
  callback = function()
    -- Only change it if standard numbers are already enabled for this buffer
    if vim.opt.number:get() then
      vim.opt.relativenumber = false
    end
  end,
})

-- Enable relative line numbers when leaving Insert Mode
vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  desc = "Enable relative line numbers in Normal mode",
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = true
    end
  end,
})

-- Quickfix/location-list live preview: jump to the entry under the cursor as
-- you move through the list (j/k), instead of needing <CR>. Focus stays in
-- the qf/loclist window so you can keep scrolling through results.
local QfAutoPreviewGrp = vim.api.nvim_create_augroup("QfAutoPreview", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = QfAutoPreviewGrp,
  pattern = "qf",
  desc = "Auto-preview quickfix/loclist entry on cursor move",
  callback = function(ev)
    -- Clear any previously-attached CursorMoved autocmd for this buffer
    -- first, so re-opening/refreshing the quickfix list doesn't stack
    -- duplicate callbacks on the same buffer.
    pcall(vim.api.nvim_clear_autocmds, { group = QfAutoPreviewGrp, event = "CursorMoved", buffer = ev.buf })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = QfAutoPreviewGrp,
      buffer = ev.buf,
      callback = function()
        local qf_win = vim.api.nvim_get_current_win()
        local win_info = vim.fn.getwininfo(qf_win)[1]
        local is_loclist = win_info ~= nil and win_info.loclist == 1
        local line = vim.fn.line(".")

        pcall(function()
          if is_loclist then
            vim.cmd("silent! " .. line .. "ll")
          else
            vim.cmd("silent! " .. line .. "cc")
          end
          -- We're now focused in the source window (cc/ll switches focus).
          -- Center the view so the jump is visible even when the target
          -- line was already inside the current scroll range.
          vim.cmd("normal! zz")
        end)

        -- Return focus to the quickfix/loclist window so j/k keep working
        if vim.api.nvim_win_is_valid(qf_win) then
          vim.api.nvim_set_current_win(qf_win)
        end
      end,
    })
  end,
})
