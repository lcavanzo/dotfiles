return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>of",
      function()
        return require("obsidian").util.gf_passthrough()
      end,
      expr = true,
      desc = "Obsidian Follow Link",
    },
    { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Obsidian Backlinks" },
    { "<leader>ol", "<cmd>Obsidian links<CR>", desc = "Obsidian Links" },
    { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Obsidian New Note" },
    { "<leader>ot", "<cmd>Obsidian template<CR>", desc = "Obsidian Insert Template" },
    { "<leader>oc", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Obsidian Toggle Checkbox" },
    { "<leader>or", "<cmd>Obsidian rename<CR>", desc = "Obsidian Rename Note" },
    { "<leader>oe", "<cmd>Obsidian extract_note<CR>", mode = "v", desc = "Obsidian Extract Note" },
    { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Obsidian Search" },
    { "<leader>oq", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian Quick Switch" },
    { "<leader>og", "<cmd>Obsidian tags<CR>", desc = "Obsidian Browse Tags" },
    { "<leader>ox", "<cmd>Obsidian toc<CR>", desc = "Obsidian TOC" },
    { "<leader>oo", "<cmd>Obsidian open<CR>", desc = "Obsidian Open in App" },
    { "<leader>ow", "<cmd>Obsidian workspace<CR>", desc = "Obsidian Switch Workspace" },
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "obsidian-vault",
        path = "~/git/obsidian-vault",
      },
    },
    notes_subdir = "limbo",
    new_notes_location = "notes_subdir",
    attachments = {
      folder = "99_Assets/attachments",
    },
    daily_notes = {
      template = "note",
    },
    templates = {
      folder = "99_Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    note_id_func = function(title)
      if title then
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-_]", ""):lower()
      end
      return tostring(os.time())
    end,
    frontmatter = {
      func = function(note)
        local date_str = os.date("%Y-%m-%d")
        local out = { id = note.id, aliases = note.aliases, tags = note.tags, date = date_str }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            if out[k] == nil then
              out[k] = v
            end
          end
        end

        return out
      end,
    },
  },
}
