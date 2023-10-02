local status_ok, leap = pcall(require, "leap")
if not status_ok then
  print("leap failing")
end

-- true to override conflicts
leap.set_default_keymaps(true)

leap.setup({
  case_sensitive = false,
  -- disable auto-jumping to the first match
  safe_labels = {},

  special_keys = {
    repeat_search = '<enter>',
    next_phase_one_target = '<enter>',
    next_target = {'<enter>', ';'},
    prev_target = {'<tab>', ','},
    next_group = '<space>',
    prev_group = '<tab>',
    multi_accept = '<enter>',
    multi_revert = '<backspace>',
  }
})

vim.keymap.set("n", 'f',  '<Plug>(leap-forward-to)')
vim.keymap.set("n", 'F',  '<Plug>(leap-backward-to)')
