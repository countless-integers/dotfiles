local telescope = require("telescope")
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})

-- This is your opts table
telescope.setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
})
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
-- browse notification messages from noice
require("telescope").load_extension("noice")
