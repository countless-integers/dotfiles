require('mini.ai').setup()
require('mini.surround').setup({
  custom_surroundings = {
    ['('] = { output = { left = '(', right = ')' } },
    ['['] = { output = { left = '[', right = ']' } },
    ['{'] = { output = { left = '{', right = '}' } },
    ['<'] = { output = { left = '<', right = '>' } },
  },
})
require('mini.pairs').setup()
require('mini.bracketed').setup()
require('mini.trailspace').setup()
vim.api.nvim_create_autocmd('User', {
  pattern = 'SnacksDashboardOpened',
  callback = function(ev)
    vim.b[ev.buf].minitrailspace_disable = true
    MiniTrailspace.unhighlight()
  end,
})
vim.keymap.set('n', '<leader>cw', function() MiniTrailspace.trim() end, { desc = 'Trim trailing whitespace' })
