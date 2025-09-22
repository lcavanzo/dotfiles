return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "v", "i" }, desc = "Tmux Navigate Left" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "v", "i" }, desc = "Tmux Navigate Left" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "v", "i" }, desc = "Tmux Navigate Up" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "v", "i" }, desc = "Tmux Navigate Right" },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n", "v", "i" }, desc = "Tmux Navigate Previous" },
  },
}
