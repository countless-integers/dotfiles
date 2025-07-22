require("oil").setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
  view_options = {
    show_hidden = false,
    natural_order = true,
  },
  win_options = {
    wrap = true,
  },
})

vim.keymap.set('n', '<leader>-', ":Oil<CR>")

