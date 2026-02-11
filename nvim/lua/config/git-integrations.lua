require('gitsigns').setup({
  -- having some issues with on_attach, but cannot reliably reproduce, so latching onto voodoo for now:
  -- @see: https://github.com/lewis6991/gitsigns.nvim/issues/1026
  attach_to_untracked = true,
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Preview hunk" })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "Reset (restore) hunk" })

    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end, { desc = "Blame line" })
    map('n', '<leader>hB', function()
      gitsigns.blame({ full = true })
    end, { desc = "Blame file" })

    map('n', '<leader>hd', gitsigns.diffthis, { desc = "Diff unstaged" })

    map('n', '<leader>hD', function()
      gitsigns.diffthis('master')
    end, { desc = "Diff this with master" })

    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
    map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "Toggle word diff" })
  end,
})
