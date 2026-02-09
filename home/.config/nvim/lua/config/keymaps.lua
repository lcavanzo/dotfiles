-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disable default keymaps(this is not working, just keep it to remember some available keymaps XD)
--vim.keymap.del("n", "<leader>L")
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

-- Insert mode: Use 'jk' to quickly exit insert mode
vim.keymap.set("i", "kj", "<ESC>", { desc = "Exit insert mode with 'kj'" })

-- Normal mode: Save the current file with '<leader>s'
vim.keymap.set("n", "<leader>s", ":write<CR>", { desc = "Save the current file with '<leader>s'" })

-- Normal mode: Save the current file without formatting '<leader>s'
vim.keymap.set("n", "<leader>ww", ":noautocmd w<CR>", { desc = "Save without formatting" })

-- Normal mode: Quit Vim with '<leader>q', or force quit with '<leader>Q'
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Quit Vim with  or force quit with '<leader>Q'" })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit Vim with 'Q'" })

-- Move Lines
-- vim.keymap.set("n", "<c-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Mode Down" })
-- vim.keymap.set("n", "<c-k>", "<cmd>execute 'move .-' . (v:count1 +1)<cr>==", { desc = "Mode Up" })
-- vim.keymap.set("i", "<c-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Mode Down" })
-- vim.keymap.set("i", "<c-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Mode Up" })
vim.keymap.set("v", "<c-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Mode Down" })
vim.keymap.set("v", "<c-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Mode Up" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Lazy
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- beginning and end of line movement
vim.keymap.set({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })

-- Normal mode: Toggle 'listchar' display with '<leader>d'
vim.keymap.set("n", "<leader>ue", ":set invlist<CR>", { desc = "Toggle 'listchar'" })

-- Jumplist Navigation
vim.keymap.set("n", "<leader>j", "``", { desc = "Jump back between Jumplist" })

-- Yanking with `y` goes to the unnamed register, accessible only within Vim.
-- The system clipboard allows sharing data between Vim and other applications.
-- Yanking with `"+y` copies text to both the unnamed register and system clipboard.
-- The `"+` register represents the system clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[P]Yank to system clipboard" })

----------------------------
-- greatest remap ever
vim.keymap.set(
  "x",
  "<leader>p",
  [["_dP]],
  { desc = " paste text over a visual selection without yanking the selected text into a register" }
)

--the selected text or object to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- sends the deleted text to the "black hole" register
vim.keymap.set(
  { "n", "v" },
  "<leader>d",
  [["_d]],
  { desc = "Delete text into the blackhole register without overwriting the clipboard" }
)

-- center the view and open folds when moving between search results.
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Scroll up/down half-page
vim.keymap.set("n", "zj", "<C-d>zz", { noremap = true, desc = "Scroll down half-page and center" })
vim.keymap.set("n", "zk", "<C-u>zz", { noremap = true, desc = "Scroll up half-page and center" })

-- Launch, limiting search/replace to current file
-- https://github.com/MagicDuck/grug-far.nvim?tab=readme-ov-file#-cookbook
vim.keymap.set(
  { "v", "n" },
  "<leader>s1",
  '<cmd>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })<cr>',
  { noremap = true, silent = true }
)

vim.keymap.set("n", "zn", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "zp", "<cmd>cprev<CR>zz")

-- Toggle between the current and last buffer
vim.keymap.set("n", "<tab>", "<C-6>", { desc = "Switch to Last Buffer" })

-- Set up a keymap to refresh the current buffer
vim.keymap.set("n", "<leader>bB", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  print("Buffer reloaded")
end, { desc = "Reload current buffer" })

-- Make the file you run the command on, executable, so you don't have to go out to the command line
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set("n", "<leader>fx", '<cmd>!chmod +x "%"<CR>', { silent = true, desc = "Make file executable" })
vim.keymap.set("n", "<leader>fX", '<cmd>!chmod -x "%"<CR>', { silent = true, desc = "Remove executable flag" })

-- Add double ticks
vim.keymap.set("n", "<leader>'", "i`` <Esc>hi", { desc = "Add double backticks and place cursor between" })

-- Duplicate a line and comment out the first line
vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p")
--------------------------------------------------------------------------------
--------------------------TMP keymaps, check if they worthy it------------------
--------------------------------------------------------------------------------
-- If this is a bash script, make it executable, and execute it in a tmux pane on the right
-- Using a tmux pane allows me to easily select text
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set("n", "<leader>cb", function()
  local file = vim.fn.expand("%:p") -- Get the current file name
  local first_line = vim.fn.getline(1) -- Get the first line of the file
  if string.match(first_line, "^#!/") then -- If first line contains shebang
    local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands

    -- Execute the script on a tmux pane on the right. On my mac I use zsh, so
    -- running this script with bash to not execute my zshrc file after
    -- vim.cmd("silent !tmux split-window -h -l 60 'bash -c \"" .. escaped_file .. "; exec bash\"'")
    -- `-l 60` specifies the size of the tmux pane, in this case 60 columns
    vim.cmd(
      "silent !tmux split-window -h -l 60 'bash -c \""
        .. escaped_file
        .. "; echo; echo Press any key to exit...; read -n 1; exit\"'"
    )
  else
    vim.cmd("echo 'Not a script. Shebang line not found.'")
  end
end, { desc = "BASH, execute file" })

-- Execute normal mode mapping from insert mode and return to insert
vim.keymap.set("i", "<C-o>", "<C-o><C-\\><C-n>", { noremap = true })
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------Could some plugin do this???????????------------------
--------------------------------------------------------------------------------
-- Normal mode: Refresh the currently open file with '<leader>e'
-- vim.keymap.set("n", "<leader>re", ":edit<CR>", { desc = "Refresh the currently open file with '<leader>e'" })
-- vim.keymap.set("n", "<leader>e", ":edit", { desc = "open file with '<leader>e'" })

-- not working but could be useful ?
-- -- double semicolon expands to the cwd when typing a command
-- vim.keymap.set("c", ";;", function()
--   return vim.fn.getcmdtype() == ":" and vim.fn.expand("%:h") .. "/" or ";;"
-- end, { expr = true })

-- ############################################################################
--                             Image section
-- ############################################################################

-- Paste images
-- I use a Ctrl keymap so that I can paste images in insert mode
-- I tried using <C-v> but duh, that's used for visual block mode
-- so don't do it
-- vim.keymap.set({ "n", "v", "i" }, "<C-a>", function()
-- 	-- Call the paste_image function from the Lua API
-- 	-- Using the plugin's Lua API (require("img-clip").paste_image()) instead of the
-- 	-- PasteImage command because the Lua API returns a boolean value indicating
-- 	-- whether an image was pasted successfully or not.
-- 	-- The PasteImage command does not
-- 	-- https://github.com/HakonHarnes/img-clip.nvim/blob/main/README.md#api
-- 	local pasted_image = require("img-clip").paste_image()
-- 	if pasted_image then
-- 		-- "Update" saves only if the buffer has been modified since the last save
-- 		vim.cmd("update")
-- 		print("Image pasted and file saved")
-- 		-- Only if updated I'll refresh the images by clearing them first
-- 		-- I'm using [[ ]] to escape the special characters in a command
-- 		require("image").clear()
-- 		-- vim.cmd([[lua require("image").clear()]])
-- 		-- Reloads the file to reflect the changes
-- 		vim.cmd("edit!")
-- 		-- Switch to the line below
-- 		vim.cmd("normal! o")
-- 		-- Switch back to command mode or normal mode
-- 		vim.cmd("startinsert")
-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("- ", true, false, true), "i", true)
-- 	else
-- 		print("No image pasted. File not updated.")
-- 	end
-- end, { desc = "[P]Paste image from system clipboard" })

-- ############################################################################

-- Open image under cursor in the Preview app (macOS)
vim.keymap.set("n", "<leader>io", function()
  local function get_image_path()
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Pattern to match image path in Markdown
    local image_pattern = "%[.-%]%((.-)%)"
    -- Extract relative image path
    local _, _, image_path = string.find(line, image_pattern)

    return image_path
  end

  -- Get the image path
  local image_path = get_image_path()

  if image_path then
    -- Check if the image path starts with "http" or "https"
    if string.sub(image_path, 1, 4) == "http" then
      print("URL image, use 'gx' to open it in the default browser.")
    else
      -- Construct absolute image path
      local current_file_path = vim.fn.expand("%:p:h")
      local absolute_image_path = current_file_path .. "/" .. image_path

      -- Construct command to open image in Preview
      local command = "open -a Preview " .. vim.fn.shellescape(absolute_image_path)
      -- Execute the command
      local success = os.execute(command)

      if success then
        print("Opened image in Preview: " .. absolute_image_path)
      else
        print("Failed to open image in Preview: " .. absolute_image_path)
      end
    end
  else
    print("No image found under the cursor")
  end
end, { desc = "[P](macOS) Open image under cursor in Preview" })

-- Open image under cursor in Finder (macOS)
--
-- THIS ONLY WORKS IF YOU'RE NNNNNOOOOOOTTTTT USING ABSOLUTE PATHS,
-- BUT INSTEAD YOURE USING RELATIVE PATHS
--
-- If using absolute paths, use the default `gx` to open the image instead
vim.keymap.set("n", "<leader>if", function()
  local function get_image_path()
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Pattern to match image path in Markdown
    local image_pattern = "%[.-%]%((.-)%)"
    -- Extract relative image path
    local _, _, image_path = string.find(line, image_pattern)

    return image_path
  end

  -- Get the image path
  local image_path = get_image_path()

  if image_path then
    -- Check if the image path starts with "http" or "https"
    if string.sub(image_path, 1, 4) == "http" then
      print("URL image, use 'gx' to open it in the default browser.")
    else
      -- Construct absolute image path
      local current_file_path = vim.fn.expand("%:p:h")
      local absolute_image_path = current_file_path .. "/" .. image_path

      -- Open the containing folder in Finder and select the image file
      local command = "open -R " .. vim.fn.shellescape(absolute_image_path)
      local success = vim.fn.system(command)

      if success == 0 then
        print("Opened image in Finder: " .. absolute_image_path)
      else
        print("Failed to open image in Finder: " .. absolute_image_path)
      end
    end
  else
    print("No image found under the cursor")
  end
end, { desc = "[P](macOS) Open image under cursor in Finder" })

-- ############################################################################

-- Delete image file under cursor using trash app (macOS)
vim.keymap.set("n", "<leader>id", function()
  local function get_image_path()
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Pattern to match image path in Markdown
    local image_pattern = "%[.-%]%((.-)%)"
    -- Extract relative image path
    local _, _, image_path = string.find(line, image_pattern)

    return image_path
  end
  -- Get the image path
  local image_path = get_image_path()
  if image_path then
    -- Check if the image path starts with "http" or "https"
    if string.sub(image_path, 1, 4) == "http" then
      vim.api.nvim_echo({
        { "URL image cannot be deleted from disk.", "WarningMsg" },
      }, false, {})
    else
      -- Construct absolute image path
      local current_file_path = vim.fn.expand("%:p:h")
      local absolute_image_path = current_file_path .. "/" .. image_path
      -- Check if trash utility is installed
      if vim.fn.executable("trash") == 0 then
        vim.api.nvim_echo({
          { "- Trash utility not installed. Make sure to install it first\n", "ErrorMsg" },
          { "- In macOS run `brew install trash`\n", nil },
        }, false, {})
        return
      end
      -- Prompt for confirmation before deleting the image
      vim.ui.select({ "yes", "no" }, { prompt = "Delete image file? " }, function(choice)
        if choice == "yes" then
          -- Delete the image file using trash app
          local success, _ = pcall(function()
            vim.fn.system({ "trash", vim.fn.fnameescape(absolute_image_path) })
          end)
          if success then
            vim.api.nvim_echo({
              { "Image file deleted from disk:\n", "Normal" },
              { absolute_image_path, "Normal" },
            }, false, {})
            -- I'll refresh the images, but will clear them first
            require("image").clear()
            -- I'm using [[ ]] to escape the special characters in a command
            -- vim.cmd([[lua require("image").clear()]])
            -- Reloads the file to reflect the changes
            vim.cmd("edit!")
            -- Delete the line the cursor is at
            vim.cmd("normal! dd")
          else
            vim.api.nvim_echo({
              { "Failed to delete image file:\n", "ErrorMsg" },
              { absolute_image_path, "ErrorMsg" },
            }, false, {})
          end
        else
          vim.api.nvim_echo({
            { "Image deletion canceled.", "Normal" },
          }, false, {})
        end
      end)
    end
  else
    vim.api.nvim_echo({
      { "No image found under the cursor", "WarningMsg" },
    }, false, {})
  end
end, { desc = "[P](macOS) Delete image file under cursor" })

-- ############################################################################

-- Refresh the images in the current buffer
-- Useful if you delete an actual image file and want to see the changes
-- without having to re-open neovim
vim.keymap.set("n", "<leader>ir", function()
  -- First I clear the images
  require("image").clear()
  -- I'm using [[ ]] to escape the special characters in a command
  -- vim.cmd([[lua require("image").clear()]])
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  print("Images refreshed")
end, { desc = "[P]Refresh images" })

-- ############################################################################

-- Set up a keymap to clear all images in the current buffer
vim.keymap.set("n", "<leader>ic", function()
  -- This is the command that clears the images
  require("image").clear()
  -- I'm using [[ ]] to escape the special characters in a command
  -- vim.cmd([[lua require("image").clear()]])
  print("Images cleared")
end, { desc = "[P]Clear images" })

vim.keymap.set("i", "<c-k>", function()
  -- Request Signature Help manually when in Insert Mode
  if vim.lsp.get_clients() then
    vim.lsp.buf.signature_help()
  end
  return true
end, { desc = "Manual Signature Help" })

-- Sideways plugin(swap arguments)
vim.keymap.set("n", "<Leader>ah", "<Cmd>:SidewaysLeft<CR>")
vim.keymap.set("n", "<Leader>al", "<Cmd>:SidewaysRight<CR>")

-- noneckpain plugin
vim.keymap.set("n", "<leader>N", "<Cmd>:NoNeckPain<CR>")

vim.keymap.set("n", "<leader>s-", function()
  -- 1. Get the last search pattern from the search register (@/)
  local pattern = vim.fn.getreg("/")

  if pattern == "" then
    vim.notify("No previous search pattern found.", vim.log.levels.WARN)
    return
  end

  -- 2. Build the vimgrep command: vimgrep /pattern/g **/*
  local vimgrep_cmd = string.format("vimgrep /%s/g **/*", pattern:gsub("/", "\\/"))

  -- The :silent! runs the command without outputting noise
  -- The | copen opens the quickfix window
  vim.cmd("silent! " .. vimgrep_cmd)
  vim.cmd("copen")

  vim.notify("Search results sent to Quickfix List.", vim.log.levels.INFO)
end, { desc = "Quickfix: Send Last / Search" })

vim.keymap.set("n", "<leader>yp", ":let @+=expand('%:.')<cr>", { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>yP", ":let @+=@%<cr>", { desc = "Copy absolute path" })

vim.keymap.set("n", "gV", "`[v`]", { desc = "select last paste area " })

-- vim.keymap.set("i", "(", "()<Left>", { desc = "Force auto-close parentheses" })
-- vim.keymap.set("i", "[", "[]<Left>", { desc = "Force auto-close square brackets" })
-- vim.keymap.set("i", "{", "{}<Left>", { desc = "Force auto-close curly braces" })

-- Helper function to disable scroll animation temporarily
local function instant_scroll(cmd)
  vim.b.snacks_scroll = false -- 1. Disable smooth scroll for this buffer
  vim.cmd("normal! " .. cmd) -- 2. Execute the motion immediately
  vim.schedule(function()
    vim.b.snacks_scroll = nil -- 3. Reset to default (re-enable)
  end)
end

-- Map gg and G to use the instant scroll helper
vim.keymap.set("n", "gg", function()
  instant_scroll("gg")
end, { desc = "Instant Top" })
vim.keymap.set("n", "G", function()
  instant_scroll("G")
end, { desc = "Instant Bottom" })

vim.keymap.set("i", "<M-o>", function()
  vim.cmd("normal! O")
end, { desc = "Add new line above (Stay in Normal Mode)" })

vim.keymap.set(
  "i",
  "ZZ",
  "<c-g>u<Esc>[s1z=\\]a<c-g>u",
  { noremap = true, desc = "Fix last spelling mistake in insert mode" }
)

-- Execute current file in the Tmux pane BELOW
-- vim.keymap.set("n", "<leader>r", function()
--   vim.cmd("write")
--
--   -- local file = vim.fn.expand("%:p")
--   local file = vim.fn.expand("%:t")
--
--   -- "-t bottom" tells tmux to send keys to the pane directly below the current one
--   -- "C-m" is the equivalent of pressing Enter
--   -- Sends: Ctrl+c (kill), Ctrl+l (clear screen), then python command
--   local cmd = string.format("tmux send-keys -t bottom C-c C-l 'py %s' C-m", file)
--
--   vim.fn.system(cmd)
--
--   vim.notify("Sent to Tmux pane below!", vim.log.levels.INFO)
-- end, { desc = "Run Code file in Tmux pane below" })

-- Execute current file in the Tmux pane BELOW
vim.keymap.set("n", "<leader>r", function()
  -- 1. Save the file
  vim.cmd("write")

  -- 2. Get file details
  local file = vim.fn.expand("%:t") -- "main.c"
  local no_ext = vim.fn.expand("%:t:r") -- "main" (useful for compiling)
  local ft = vim.bo.filetype -- "python", "rust", "cpp", etc.

  -- 3. Define the commands for each language
  -- You can add any language here!
  local commands = {
    python = "python3 " .. file,
    go = "go run " .. file,
    rust = "cargo run", -- Assumes you are in a cargo project. If script: "rustc " .. file .. " && ./" .. no_ext
    c = "gcc " .. file .. " -o " .. no_ext .. " && ./" .. no_ext,
    cpp = "g++ " .. file .. " -o " .. no_ext .. " && ./" .. no_ext, -- "r++" usually means C++
    javascript = "node " .. file,
    sh = "bash " .. file,
    lua = "lua " .. file,
  }

  -- 4. Check if we know how to run this filetype
  local cmd_str = commands[ft]

  if cmd_str then
    -- Send to Tmux (Kill prev action -> Clear -> Run)
    local tmux_cmd = string.format("tmux send-keys -t bottom C-c C-l '%s' C-m", cmd_str)
    vim.fn.system(tmux_cmd)
    vim.notify("Running " .. ft .. " file...", vim.log.levels.INFO)
  else
    vim.notify("No run command defined for: " .. ft, vim.log.levels.WARN)
  end
end, { desc = "Run current file (Smart Detect)" })
