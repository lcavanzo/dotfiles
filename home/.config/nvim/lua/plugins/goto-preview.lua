return {
  "rmagatti/goto-preview",
  event = "BufEnter",
  config = true, -- This automatically calls require('goto-preview').setup(opts)
  keys = {
    {
      "gpd",
      "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
      desc = "Preview Definition",
    },
    {
      "gpt",
      "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
      desc = "Preview Type Definition",
    },
    {
      "gpi",
      "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
      desc = "Preview Implementation",
    },
    {
      "gpD",
      "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
      desc = "Preview Declaration",
    },
    {
      "gP",
      "<cmd>lua require('goto-preview').close_all_win()<CR>",
      desc = "Close All Previews",
    },
    {
      "gpr",
      "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
      desc = "Preview References",
    },
  },
}
