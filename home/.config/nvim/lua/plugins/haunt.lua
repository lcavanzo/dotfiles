return {
  "TheNoeTrevino/haunt.nvim",
  event = "VeryLazy",
  keys = {
    -- Core Actions
    {
      "<leader>ha",
      function()
        require("haunt.api").annotate()
      end,
      desc = "Add/Edit Annotation",
    },
    {
      "<leader>hd",
      function()
        require("haunt.api").delete()
      end,
      desc = "Delete Annotation",
    },
    -- Remove all annotations in the workspace. Good for when you finish up a subtask
    {
      "<leader>hD",
      function()
        require("haunt.api").clear_all()
      end,
      desc = "Remove All the Annotations",
    },
    -- Toggle visibility of the current annotation
    {
      "<leader>ht",
      function()
        require("haunt.api").toggle_annotation()
      end,
      desc = "Toggle View",
    },
    -- Toggle visibility of the all annotations
    {
      "<leader>hT",
      function()
        require("haunt.api").toggle_all_lines()
      end,
      desc = "Toggle All Views",
    },

    -- Navigation (Jumping between ghosts)
    {
      "]h",
      function()
        require("haunt.api").next()
      end,
      desc = "Next Haunt Bookmark",
    },
    {
      "[h",
      function()
        require("haunt.api").prev()
      end,
      desc = "Prev Haunt Bookmark",
    },

    -- Search (Uses your Snacks.nvim picker)
    {
      "<leader>hl",
      function()
        require("haunt.picker").show()
      end,
      desc = "List All (Picker)",
    },
    -- Search (Uses your Snacks.nvim picker)
    {
      "<leader>hl",
      function()
        require("haunt.picker").show()
      end,
      desc = "List All (Picker)",
    },
  },
  opts = {
    -- The symbol shown in the column
    sign = "👻",
    sign_hl = "DiagnosticInfo",

    -- The text appearance next to your code
    virt_text_hl = "Comment",
    annotation_prefix = " ➜ ",

    -- Persistence: Notes are saved per git branch
    -- They are stored in .git/haunt/ by default so they don't mess up your repo
  },
}
