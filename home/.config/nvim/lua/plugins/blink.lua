return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      -- This disables Enter for completion and uses Tab instead
      preset = "super-tab",

      -- Or, if you want to keep the default behavior but just fix Enter,
      -- comment out `preset = "super-tab"` above and uncomment below:
      -- preset = "default",
      -- ["<CR>"] = { "fallback" },
      -- ["<Tab>"] = { "select_and_accept", "fallback" },
    },
  },
}
