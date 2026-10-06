-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.lazyvim_keymaps_disabled = {
  ["<C-s>"] = true,
  ["<leader>qq"] = true,
  ["<leader>l"] = true,
  ["<leader>fT"] = true,
  ["<leader>ft"] = true,
  ["<c-_>"] = true,
  ["<leader>?"] = true,
}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local is_mac = vim.fn.has("mac") == 1

-- NVIM 0.13: `Q` and `gQ` are now claimed by native multiple-cursor support
-- (Q = add/remove cursor, gQ = restore cleared cursors). Neither is mapped
-- here, so nothing conflicts, but Q no longer means "replay last macro" by
-- default. Uncomment below if you want the old replay-macro behavior back:
-- vim.keymap.set("n", "Q", function()
--   local reg = vim.fn.reg_recorded()
--   return reg == "" and "" or ("@" .. reg)
-- end, { expr = true, desc = "Replay last recorded macro (pre-0.13 Q)" })

-- Go to first and last Char
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

-- Insert mode: Use 'kj' to quickly exit insert mode
vim.keymap.set("i", "kj", "<ESC>", { desc = "Exit insert mode with 'kj'" })

-- Save / quit
vim.keymap.set("n", "<leader>s", ":write<CR>", { desc = "Save the current file" })
vim.keymap.set("n", "<leader>ww", ":noautocmd w<CR>", { desc = "Save without formatting" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Quit, or force quit with '<leader>Q'" })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit Vim" })

-- Move lines (visual mode)
vim.keymap.set("v", "<c-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set(
  "v",
  "<c-k>",
  ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
  { desc = "Move selection up" }
)

-- Undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Lazy
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Beginning and end of line movement
vim.keymap.set({ "n", "v" }, "gh", "^", { desc = "Go to beginning of line" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })

-- Toggle 'listchars' display
vim.keymap.set("n", "<leader>ue", ":set invlist<CR>", { desc = "Toggle 'listchars'" })

-- Jumplist navigation
vim.keymap.set("n", "<leader>j", "``", { desc = "Jump back in jumplist" })

-- Clipboard yank
-- NOTE: this was previously defined twice (once with desc, once without);
-- the duplicate has been removed so the description sticks in which-key.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })

-- Uppercase word and insert at end
vim.keymap.set("n", "<leader>U", "viwUea", { desc = "Uppercase word and insert at end" })

-- Paste over visual selection without clobbering the register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection without yanking it" })

-- Delete into black hole register (doesn't touch clipboard)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without overwriting clipboard" })

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Center view and open folds when jumping between search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Smooth half-page scroll (neoscroll)
local neoscroll = require("neoscroll")
vim.keymap.set("n", "zj", function()
  neoscroll.scroll(0.5, { move_cursor = true, duration = 250 })
end, { desc = "Smooth scroll down half-page" })
vim.keymap.set("n", "zk", function()
  neoscroll.scroll(-0.5, { move_cursor = true, duration = 250 })
end, { desc = "Smooth scroll up half-page" })

-- Search/replace limited to current file
-- https://github.com/MagicDuck/grug-far.nvim?tab=readme-ov-file#-cookbook
vim.keymap.set(
  { "v", "n" },
  "<leader>s1",
  '<cmd>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })<cr>',
  { noremap = true, silent = true, desc = "Search/replace in current file" }
)

vim.keymap.set("n", "zn", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "zp", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })

-- Toggle between current and last buffer
vim.keymap.set("n", "<tab>", "<C-6>", { desc = "Switch to last buffer" })

-- Reload current buffer from disk
vim.keymap.set("n", "<leader>bB", function()
  vim.cmd("edit!")
  print("Buffer reloaded")
end, { desc = "Reload current buffer" })

-- Make current file executable (quoted for paths with spaces)
vim.keymap.set("n", "<leader>fx", '<cmd>!chmod +x "%"<CR>', { silent = true, desc = "Make file executable" })
vim.keymap.set("n", "<leader>fX", '<cmd>!chmod -x "%"<CR>', { silent = true, desc = "Remove executable flag" })

-- Add double backticks and place cursor between
vim.keymap.set("n", "<leader>'", "i`` <Esc>hi", { desc = "Add double backticks and place cursor between" })

-- Duplicate a line and comment out the first
vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p", { desc = "Duplicate line, comment original" })

-- If this is a script with a shebang, run it in a tmux pane on the right
-- (uses `bash -c` explicitly so it doesn't source your interactive shell rc)
vim.keymap.set("n", "<leader>cb", function()
  local file = vim.fn.expand("%:p")
  local first_line = vim.fn.getline(1)
  if string.match(first_line, "^#!/") then
    local escaped_file = vim.fn.shellescape(file)
    vim.cmd(
      "silent !tmux split-window -h -l 60 'bash -c \""
        .. escaped_file
        .. "; echo; echo Press any key to exit...; read -n 1; exit\"'"
    )
  else
    vim.cmd("echo 'Not a script. Shebang line not found.'")
  end
end, { desc = "Run script in tmux pane (right)" })

-- Run a normal-mode command from insert mode and return to insert
vim.keymap.set("i", "<C-o>", "<C-o><C-\\><C-n>", { noremap = true, desc = "Exit insert mode fully" })
-- NOTE: this changes <C-o>'s normal meaning ("run one normal command, then
-- return to insert") into a hard exit from insert mode. That's intentional
-- if you never use the one-shot behavior, but worth knowing it's not stock.
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })

-- ############################################################################
--                             Image section (Markdown)
-- ############################################################################
-- These shell out to macOS-only tools (`open`, `trash`/Homebrew) and are
-- guarded behind `is_mac` so they're inert (rather than silently erroring)
-- when this config runs on Linux.

-- Image under the cursor, as a path relative to the current file's folder
-- (what the handlers below expect). Understands both link styles used in the
-- vault: markdown `![alt](path)` (URL-encoded paths are decoded) and Obsidian
-- wikilinks `![[name.avif|alt]]` (looked up in 99_Assets, then the whole vault).
local vault_root = vim.fn.expand("~/git/obsidian-vault/obsidian-vault")

local function relative_to_current_dir(target)
  local from = vim.split(vim.fn.expand("%:p:h"), "/", { plain = true, trimempty = true })
  local to = vim.split(target, "/", { plain = true, trimempty = true })
  local common = 0
  while common < #from and common < #to and from[common + 1] == to[common + 1] do
    common = common + 1
  end
  local parts = {}
  for _ = common + 1, #from do
    table.insert(parts, "..")
  end
  for i = common + 1, #to do
    table.insert(parts, to[i])
  end
  return table.concat(parts, "/")
end

local function image_ref_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local path = line:match("%[.-%]%((.-)%)")
  if path then
    return (path:gsub("%%(%x%x)", function(hex)
      return string.char(tonumber(hex, 16))
    end))
  end
  local name = line:match("!%[%[([^%]|#]+)")
  if not name then
    return nil
  end
  local base = vim.fs.basename(name)
  local found = vim.fs.find(base, { path = vault_root .. "/99_Assets", type = "file", limit = 1 })[1]
    or vim.fs.find(base, { path = vault_root, type = "file", limit = 1 })[1]
  return found and relative_to_current_dir(found) or nil
end

if is_mac then
  local function get_image_path()
    return image_ref_under_cursor()
  end

  -- Open image under cursor in Preview
  vim.keymap.set("n", "<leader>io", function()
    local image_path = get_image_path()
    if not image_path then
      print("No image found under the cursor")
      return
    end
    if string.sub(image_path, 1, 4) == "http" then
      print("URL image, use 'gx' to open it in the default browser.")
      return
    end
    local current_file_path = vim.fn.expand("%:p:h")
    local absolute_image_path = current_file_path .. "/" .. image_path
    local command = "open -a Preview " .. vim.fn.shellescape(absolute_image_path)
    local success = os.execute(command)
    if success then
      print("Opened image in Preview: " .. absolute_image_path)
    else
      print("Failed to open image in Preview: " .. absolute_image_path)
    end
  end, { desc = "[macOS] Open image under cursor in Preview" })

  -- Open image under cursor in Finder (relative paths only; use `gx` for absolute)
  vim.keymap.set("n", "<leader>if", function()
    local image_path = get_image_path()
    if not image_path then
      print("No image found under the cursor")
      return
    end
    if string.sub(image_path, 1, 4) == "http" then
      print("URL image, use 'gx' to open it in the default browser.")
      return
    end
    local current_file_path = vim.fn.expand("%:p:h")
    local absolute_image_path = current_file_path .. "/" .. image_path
    local success = vim.fn.system("open -R " .. vim.fn.shellescape(absolute_image_path))
    if success == 0 then
      print("Opened image in Finder: " .. absolute_image_path)
    else
      print("Failed to open image in Finder: " .. absolute_image_path)
    end
  end, { desc = "[macOS] Open image under cursor in Finder" })

  -- Delete image file under cursor via `trash` (brew install trash)
  vim.keymap.set("n", "<leader>id", function()
    local image_path = get_image_path()
    if not image_path then
      vim.api.nvim_echo({ { "No image found under the cursor", "WarningMsg" } }, false, {})
      return
    end
    if string.sub(image_path, 1, 4) == "http" then
      vim.api.nvim_echo({ { "URL image cannot be deleted from disk.", "WarningMsg" } }, false, {})
      return
    end
    local current_file_path = vim.fn.expand("%:p:h")
    local absolute_image_path = current_file_path .. "/" .. image_path
    if vim.fn.executable("trash") == 0 then
      vim.api.nvim_echo({
        { "- Trash utility not installed. Make sure to install it first\n", "ErrorMsg" },
        { "- In macOS run `brew install trash`\n", nil },
      }, false, {})
      return
    end
    vim.ui.select({ "yes", "no" }, { prompt = "Delete image file? " }, function(choice)
      if choice == "yes" then
        local success = pcall(function()
          vim.fn.system({ "trash", vim.fn.fnameescape(absolute_image_path) })
        end)
        if success then
          vim.api.nvim_echo(
            { { "Image file deleted from disk:\n", "Normal" }, { absolute_image_path, "Normal" } },
            false,
            {}
          )
          require("image").clear()
          vim.cmd("edit!")
          vim.cmd("normal! dd")
        else
          vim.api.nvim_echo(
            { { "Failed to delete image file:\n", "ErrorMsg" }, { absolute_image_path, "ErrorMsg" } },
            false,
            {}
          )
        end
      else
        vim.api.nvim_echo({ { "Image deletion canceled.", "Normal" } }, false, {})
      end
    end)
  end, { desc = "[macOS] Delete image file under cursor" })
else
  -- Linux equivalents: swap `open` for `xdg-open`, and use `gio trash` (part
  -- of glib2, present on virtually every desktop distro) instead of `trash`.
  local function get_image_path()
    return image_ref_under_cursor()
  end

  vim.keymap.set("n", "<leader>io", function()
    local image_path = get_image_path()
    if not image_path then
      print("No image found under the cursor")
      return
    end
    if string.sub(image_path, 1, 4) == "http" then
      print("URL image, use 'gx' to open it in the default browser.")
      return
    end
    local current_file_path = vim.fn.expand("%:p:h")
    local absolute_image_path = current_file_path .. "/" .. image_path
    os.execute("xdg-open " .. vim.fn.shellescape(absolute_image_path) .. " >/dev/null 2>&1 &")
    print("Opened image: " .. absolute_image_path)
  end, { desc = "[Linux] Open image under cursor" })

  vim.keymap.set("n", "<leader>id", function()
    local image_path = get_image_path()
    if not image_path then
      vim.api.nvim_echo({ { "No image found under the cursor", "WarningMsg" } }, false, {})
      return
    end
    local current_file_path = vim.fn.expand("%:p:h")
    local absolute_image_path = current_file_path .. "/" .. image_path
    if vim.fn.executable("gio") == 0 then
      vim.api.nvim_echo({
        { "- `gio` not found. Install glib2 (usually preinstalled) or adjust this keymap.\n", "ErrorMsg" },
      }, false, {})
      return
    end
    vim.ui.select({ "yes", "no" }, { prompt = "Delete image file? " }, function(choice)
      if choice == "yes" then
        vim.fn.system({ "gio", "trash", absolute_image_path })
        vim.cmd("edit!")
        vim.cmd("normal! dd")
        print("Image file trashed: " .. absolute_image_path)
      end
    end)
  end, { desc = "[Linux] Delete image file under cursor" })
end

-- NVIM 0.13: native terminal image rendering via vim.ui.img. This works the
-- same way on macOS and Linux (no `open`/`xdg-open` branching needed), as
-- long as your terminal supports the underlying image protocol — check with
-- `:checkhealth vim.health`. Once you've confirmed that on your setup, this
-- can likely replace `<leader>io` above as your day-to-day preview keymap;
-- left as a separate mapping for now rather than replacing it outright,
-- since `vim.ui.img` is new enough that terminal support still varies.
-- NOTE: `vim.ui.img` is still marked experimental and its exact function
-- name may shift before final release — check `:help vim.ui.img` on your
-- installed build and adjust `vim.ui.img.show(...)` below if it's changed.
if vim.ui.img then
  vim.keymap.set("n", "<leader>iv", function()
    local image_path = image_ref_under_cursor()
    if not image_path then
      print("No image found under the cursor")
      return
    end
    if string.sub(image_path, 1, 4) == "http" then
      print("URL image, use 'gx' to open it in the default browser.")
      return
    end
    local absolute_image_path = vim.fn.expand("%:p:h") .. "/" .. image_path
    vim.ui.img.show(absolute_image_path)
  end, { desc = "[0.13] Preview image under cursor natively" })
end

-- Refresh images in current buffer
vim.keymap.set("n", "<leader>ir", function()
  require("image").clear()
  vim.cmd("edit!")
  print("Images refreshed")
end, { desc = "Refresh images" })

-- Clear all images in current buffer
vim.keymap.set("n", "<leader>ic", function()
  require("image").clear()
  print("Images cleared")
end, { desc = "Clear images" })

-- Manual signature help in insert mode
vim.keymap.set("i", "<c-k>", function()
  if vim.lsp.get_clients() then
    vim.lsp.buf.signature_help()
  end
  return true
end, { desc = "Manual signature help" })

-- NVIM 0.13: persistent, reconnectable sessions. If your SSH connection to
-- the homelab box drops, the Neovim process keeps running instead of dying
-- with the terminal — reconnect later with :connect (or `nvim --remote-ui`
-- from another terminal against the same server).
vim.keymap.set(
  "n",
  "<leader>Sd",
  "<cmd>detach!<CR>",
  { desc = "Detach UI (Neovim survives if this terminal/SSH drops)" }
)
vim.keymap.set("n", "<leader>Sc", ":connect ", { desc = "Connect to a detached Neovim session" })

-- Sideways plugin (swap arguments)
vim.keymap.set("n", "<Leader>ah", "<Cmd>:SidewaysLeft<CR>", { desc = "Swap argument left" })
vim.keymap.set("n", "<Leader>al", "<Cmd>:SidewaysRight<CR>", { desc = "Swap argument right" })

-- no-neck-pain plugin
vim.keymap.set("n", "<leader>N", "<Cmd>:NoNeckPain<CR>", { desc = "Toggle NoNeckPain" })

-- Send last search pattern to quickfix via vimgrep
vim.keymap.set("n", "<leader>s-", function()
  local pattern = vim.fn.getreg("/")
  if pattern == "" then
    vim.notify("No previous search pattern found.", vim.log.levels.WARN)
    return
  end
  local vimgrep_cmd = string.format("vimgrep /%s/g **/*", pattern:gsub("/", "\\/"))
  vim.cmd("silent! " .. vimgrep_cmd)
  vim.cmd("copen")
  vim.notify("Search results sent to Quickfix List.", vim.log.levels.INFO)
end, { desc = "Send last search to quickfix" })

vim.keymap.set("n", "<leader>yp", ":let @+=expand('%:.')<cr>", { desc = "Copy relative path" })
vim.keymap.set("n", "<leader>yP", ":let @+=@%<cr>", { desc = "Copy absolute path" })

-- NVIM 0.13: buffer-local working directory (previously only global/tab/window scoped)
vim.keymap.set("n", "<leader>cd", ":bcd %:h<CR>", { desc = "Set buffer-local cwd to file's directory" })
vim.keymap.set("n", "gV", "`[v`]", { desc = "Select last paste area" })

-- Backspace jumps to matching bracket (replaces Shift+5)
vim.keymap.set({ "n", "x", "o" }, "<BS>", "%", { remap = true, desc = "Jump to matching bracket" })

-- Disable smooth-scroll animation temporarily for instant jumps
local function instant_scroll(cmd)
  vim.b.snacks_scroll = false
  vim.cmd("normal! " .. cmd)
  vim.schedule(function()
    vim.b.snacks_scroll = nil
  end)
end
vim.keymap.set("n", "gg", function()
  instant_scroll("gg")
end, { desc = "Instant jump to top" })
vim.keymap.set("n", "G", function()
  instant_scroll("G")
end, { desc = "Instant jump to bottom" })

vim.keymap.set("i", "<M-o>", function()
  vim.cmd("normal! O")
end, { desc = "Add new line above (stay in insert)" })

vim.keymap.set(
  "i",
  "ZZ",
  "<c-g>u<Esc>[s1z=\\]a<c-g>u",
  { noremap = true, desc = "Fix last spelling mistake in insert mode" }
)

-- Run current file in the tmux pane below, dispatched by filetype
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("write")
  local file = vim.fn.expand("%:t")
  local no_ext = vim.fn.expand("%:t:r")
  local ft = vim.bo.filetype

  local commands = {
    python = "python3 " .. file,
    go = "go run " .. file,
    rust = "cargo run",
    c = "gcc " .. file .. " -o " .. no_ext .. " && ./" .. no_ext,
    cpp = "g++ " .. file .. " -o " .. no_ext .. " && ./" .. no_ext,
    javascript = "node " .. file,
    sh = "bash " .. file,
    lua = "lua " .. file,
  }

  local cmd_str = commands[ft]
  if cmd_str then
    local tmux_cmd = string.format("tmux send-keys -t bottom C-c C-l '%s' C-m", cmd_str)
    vim.fn.system(tmux_cmd)
    vim.notify("Running " .. ft .. " file...", vim.log.levels.INFO)
  else
    vim.notify("No run command defined for: " .. ft, vim.log.levels.WARN)
  end
end, { desc = "Run current file (smart detect by filetype)" })

-- Open the current buffer in a floating window, jumped to the top
vim.keymap.set("n", "<leader>c.", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local filename = vim.fn.expand("%:t")

  local peek_win = Snacks.win({
    buf = current_buf,
    width = 0.6,
    height = 0.8,
    border = "rounded",
    title = " Peek: " .. filename .. " ",
    title_pos = "center",
  })

  vim.api.nvim_win_set_cursor(peek_win.win, { 1, 0 })

  -- NVIM 0.13: pin this float so normal window-management commands (e.g. a
  -- stray <C-w>o or another plugin closing "extra" windows) can't take it
  -- out from under you; only an explicit close targets it.
  vim.wo[peek_win.win].winpinned = true
end, { desc = "Float current buffer (peek top)" })
