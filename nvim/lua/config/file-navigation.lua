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

require("neo-tree").setup({
  close_if_last_window = true,
  sources = {
    'filesystem',
    'buffers',
    'document_symbols',
  },
})

vim.keymap.set("n", "<leader>n", ":Neotree filesystem toggle left reveal_force_cwd<CR>")
vim.keymap.set("n", "<leader>N", ":Neotree filesystem toggle float reveal_force_cwd<CR>")
vim.keymap.set("n", "<leader>s", ":Neotree document_symbols toggle float reveal<CR>")
vim.keymap.set("n", "<leader>b", ":Neotree buffers toggle float reveal<CR>")
