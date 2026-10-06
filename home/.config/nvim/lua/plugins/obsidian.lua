-- The real Obsidian vault (the folder that contains .obsidian). It is one level
-- below the git repo root, same as in snacks.lua.
local vault = vim.fn.expand("~/git/obsidian-vault/obsidian-vault")

-- Filesystem-safe IDs (same rule as the global note_id_func below).
local function slugify(title)
  return (title or ""):gsub(" ", "-"):gsub("[^A-Za-z0-9-_]", ""):lower()
end

-- YYYY-MM-DD-slug, so notes sort chronologically.
local function dated(title)
  local slug = slugify(title)
  local day = os.date("%Y-%m-%d")
  return slug ~= "" and (day .. "-" .. slug) or day
end

-- Context -> template. A note created in `dir` gets `template` automatically,
-- and notes created from that template are placed in `dir` with that ID style.
-- Templates live in 99_Assets/templates/<name>.md
local contexts = {
  incident = { dir = "02_Job/SLB/incidents", id = dated },
  runbook = { dir = "02_Job/SLB/runbooks", id = slugify },
  decision = { dir = "02_Job/SLB/decisions", id = dated },
  meeting = { dir = "02_Job/SLB/meetings", id = dated },
  til = { dir = "03_Study/til", id = dated },
  newsletter = { dir = "03_Study/newsletters", id = dated },
  weekly = {
    dir = "01_Daily-notes/weekly",
    id = function(title)
      return title
    end,
  },
}

-- Folder rules for new files created outside the plugin (yazi, mini.files, :e).
-- `exact` = only direct children of the folder.
local folder_rules = {
  { dir = "01_Daily-notes/daily", template = "daily", exact = true },
  { dir = "08_Brag-Journal", template = "brag" },
}
local customizations = {}
for name, c in pairs(contexts) do
  customizations[name] = { notes_subdir = c.dir, note_id_func = c.id }
  table.insert(folder_rules, { dir = c.dir, template = name })
end
-- Most specific folder wins.
table.sort(folder_rules, function(a, b)
  return #a.dir > #b.dir
end)

local function template_for(path)
  if not vim.startswith(path, vault .. "/") then
    return nil
  end
  local rel = path:sub(#vault + 2)
  for _, rule in ipairs(folder_rules) do
    local prefix = rule.dir .. "/"
    if vim.startswith(rel, prefix) and not (rule.exact and rel:sub(#prefix + 1):find("/", 1, true)) then
      return rule.template
    end
  end
end

-- Prompt for a title, then create a note from `template` in its context folder.
local function new_from(template, prompt)
  return function()
    vim.ui.input({ prompt = prompt }, function(title)
      if not title then
        return
      end
      title = vim.trim(title):gsub('[|"]', "")
      if title == "" then
        return
      end
      vim.cmd("Obsidian new_from_template " .. title .. " " .. template)
    end)
  end
end

-- One weekly review per ISO week: open it if it exists, create it otherwise.
local function weekly()
  local id = os.date("%G-W%V")
  local path = vim.fs.joinpath(vault, contexts.weekly.dir, id .. ".md")
  if vim.uv.fs_stat(path) then
    vim.cmd.edit(path)
  else
    vim.cmd("Obsidian new_from_template " .. id .. " weekly")
  end
end

-- One brag note per month: 08_Brag-Journal/<year>/<year>-<month>.md
local function brag()
  local year, id = os.date("%Y"), os.date("%Y-%m")
  local path = vim.fs.joinpath(vault, "08_Brag-Journal", year, id .. ".md")
  if vim.uv.fs_stat(path) then
    vim.cmd.edit(path)
  else
    vim.cmd("Obsidian new_from_template 08_Brag-Journal/" .. year .. "/" .. id .. " brag")
  end
end

-- Quick capture: append "- HH:MM text" to the ## Log section of today's daily
-- note without leaving the buffer you are in. Creates the note (with its
-- template) if it does not exist yet.
local function capture(text)
  local day = os.date("%Y-%m-%d")
  local path = vim.fs.joinpath(vault, "01_Daily-notes/daily", day .. ".md")
  local prev = vim.api.nvim_get_current_buf()
  local created = not vim.uv.fs_stat(path)
  if created then
    vim.cmd("Obsidian today") -- creates the note from the daily template
    vim.wait(1000, function()
      return vim.uv.fs_stat(path) ~= nil
    end, 20)
    if vim.api.nvim_buf_is_valid(prev) and vim.api.nvim_get_current_buf() ~= prev then
      vim.api.nvim_set_current_buf(prev) -- stay where you were
    end
  end
  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local entry = string.format("- %s %s", os.date("%H:%M"), text)

  local log
  for i, line in ipairs(lines) do
    if line:match("^##%s+Log%s*$") then
      log = i
      break
    end
  end
  if not log then
    -- no Log section: add one at the end
    if #lines > 0 and lines[#lines] ~= "" then
      table.insert(lines, "")
    end
    vim.list_extend(lines, { "## Log", entry })
  else
    -- end of the section = line before the next heading (or end of file)
    local last = log
    for i = log + 1, #lines do
      if lines[i]:match("^#+%s") then
        break
      end
      if lines[i] ~= "" then
        last = i
      end
    end
    if last > log and lines[last]:match("^%- %d%d:%d%d%s*$") then
      lines[last] = entry -- fill in the empty time stamp the template left
    else
      table.insert(lines, last + 1, entry)
    end
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent write")
  end)
  vim.notify("Logged to " .. day, vim.log.levels.INFO)
  if created then
    -- the plugin opens the new note a moment later; go back to where you were
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(prev) and vim.api.nvim_buf_get_name(0) == path then
        vim.api.nvim_set_current_buf(prev)
      end
    end, 200)
  end
end

local function quick_capture()
  vim.ui.input({ prompt = "Log: " }, function(text)
    text = text and vim.trim(text) or ""
    if text ~= "" then
      capture(text)
    end
  end)
end

-- Set the checkbox state of the current line (toggles back to todo if already set).
-- States match the Tasks plugin: "/" in progress, "-" cancelled.
local function set_status(char)
  return function()
    local pre, cur, post = vim.api.nvim_get_current_line():match("^(%s*[-*+] %[)(.)(%].*)$")
    if not pre then
      return vim.notify("No checkbox on this line", vim.log.levels.INFO)
    end
    vim.api.nvim_set_current_line(pre .. (cur == char and " " or char) .. post)
  end
end

-- List open tasks (grep over the vault). Dashboards in 00_Dashboard do the
-- heading-aware work/personal split, but they only render inside the Obsidian app.
local task_dirs = { "01_Daily-notes", "02_Job", "09_personal" }
local open_task = [[^\s*[-*] \[[ /]\] \S]] -- [ ] or [/] with some text
local wip_task = [[^\s*[-*] \[/\] \S]] -- [/] only
local task_scopes = {
  { label = "All open tasks", dirs = task_dirs, search = open_task },
  { label = "Work files (02_Job)", dirs = { "02_Job" }, search = open_task },
  { label = "Personal files (09_personal)", dirs = { "09_personal" }, search = open_task },
  { label = "Daily notes", dirs = { "01_Daily-notes/daily" }, search = open_task },
  { label = "In progress", dirs = task_dirs, search = wip_task },
}

local function open_tasks()
  vim.ui.select(task_scopes, {
    prompt = "Open tasks",
    format_item = function(scope)
      return scope.label
    end,
  }, function(scope)
    if not scope then
      return
    end
    local ok, snacks = pcall(require, "snacks")
    if not ok then
      return vim.notify("snacks.nvim is required for the task picker", vim.log.levels.WARN)
    end
    snacks.picker.grep({
      title = "Tasks: " .. scope.label,
      dirs = vim.tbl_map(function(dir)
        return vault .. "/" .. dir
      end, scope.dirs),
      search = scope.search,
      regex = true,
      live = false,
      glob = { "*.md" },
    })
  end)
end

-- Open the Today dashboard in the Obsidian app (its task queries only render there).
local function open_dashboard()
  local path = vault .. "/00_Dashboard/Today.md"
  local encoded = path:gsub("[^%w%-_.~]", function(c)
    return string.format("%%%02X", c:byte())
  end)
  vim.ui.open("obsidian://open?path=" .. encoded)
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- Runs at startup (before the plugin loads): give brand-new, empty notes the
  -- template that matches the folder they are created in.
  init = function()
    vim.api.nvim_create_autocmd("BufNewFile", {
      group = vim.api.nvim_create_augroup("obsidian_context_templates", { clear = true }),
      pattern = "*.md",
      callback = function(ev)
        local template = template_for(vim.fn.fnamemodify(ev.file, ":p"))
        if not template then
          return
        end
        vim.schedule(function()
          if vim.api.nvim_get_current_buf() ~= ev.buf then
            return
          end
          local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
          if #lines > 1 or (lines[1] or "") ~= "" then
            return
          end
          require("lazy").load({ plugins = { "obsidian.nvim" } })
          local ok, err = pcall(vim.cmd, "Obsidian template " .. template)
          if not ok then
            vim.notify("Obsidian: could not apply template '" .. template .. "': " .. tostring(err), vim.log.levels.WARN)
          end
        end)
      end,
    })
  end,
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
    -- Daily notes
    { "<leader>od", "<cmd>Obsidian today<CR>", desc = "Obsidian Daily Note (today)" },
    { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Obsidian Daily Note (yesterday)" },
    { "<leader>oD", "<cmd>Obsidian dailies<CR>", desc = "Obsidian Daily Notes (list)" },
    { "<leader>oL", quick_capture, desc = "Obsidian Quick Log (append to today)" },
    -- Paste an image from the clipboard (img-clip.nvim): saved as AVIF in 99_Assets/attachments
    { "<leader>op", "<cmd>PasteImage<CR>", desc = "Obsidian Paste Image (AVIF, to attachments)" },
    -- New note from a template, placed in its context folder
    { "<leader>oT", "<cmd>Obsidian new_from_template<CR>", desc = "Obsidian New From Template (pick)" },
    { "<leader>oNw", weekly, desc = "Obsidian New: Weekly Review" },
    { "<leader>oNi", new_from("incident", "Incident: "), desc = "Obsidian New: Incident" },
    { "<leader>oNr", new_from("runbook", "Runbook: "), desc = "Obsidian New: Runbook" },
    { "<leader>oNd", new_from("decision", "Decision: "), desc = "Obsidian New: Decision" },
    { "<leader>oNm", new_from("meeting", "Meeting: "), desc = "Obsidian New: Meeting" },
    { "<leader>oNt", new_from("til", "Today I learned: "), desc = "Obsidian New: TIL" },
    { "<leader>oNn", new_from("newsletter", "Newsletter: "), desc = "Obsidian New: Newsletter" },
    { "<leader>oNb", brag, desc = "Obsidian New: Brag Log (this month)" },
    -- Tasks
    { "<leader>oa", open_tasks, desc = "Obsidian Open Tasks (pick scope)" },
    { "<leader>oh", open_dashboard, desc = "Obsidian Dashboard (Today, in app)" },
    { "<leader>o/", set_status("/"), desc = "Obsidian Task: In Progress (toggle)" },
    { "<leader>o-", set_status("-"), desc = "Obsidian Task: Cancelled (toggle)" },
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "obsidian-vault",
        path = vault,
      },
    },
    notes_subdir = "limbo",
    new_notes_location = "notes_subdir",
    attachments = {
      folder = "99_Assets/attachments",
    },
    -- <leader>oc: plain todo <-> done (the default cycles through 5 states).
    -- In progress / cancelled have their own keys: <leader>o/ and <leader>o-
    checkbox = {
      order = { " ", "x" },
    },
    daily_notes = {
      folder = "01_Daily-notes/daily",
      date_format = "YYYY-MM-DD",
      template = "daily",
      workdays_only = false, -- the daily note has a personal section, so weekends count
    },
    templates = {
      folder = "99_Assets/templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      customizations = customizations,
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
