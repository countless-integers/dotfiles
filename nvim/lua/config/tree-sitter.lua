local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = {
    "lua",
    "bash",
    "javascript",
    "html",
    -- this is to stop help pages from crashing https://github.com/neovim/neovim/issues/29492
    "vimdoc",
    -- noice recommendations
    "vim",
    "regex",
    "markdown",
    "markdown_inline",
  },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})
