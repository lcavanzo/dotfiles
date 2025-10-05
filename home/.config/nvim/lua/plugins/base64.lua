return {
  "taybart/b64.nvim",
  config = function()
    local keymap = vim.keymap
    keymap.set("v", "<leader>64e", "<cmd>B64Encode<CR>", { desc = "Base 64 Encode" })
    keymap.set("v", "<leader>64d", "<cmd>B64Decode<CR>", { desc = "Base 64 Decode" })
  end,
}
