local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = {
    "lua",
    "bash",
    -- this is to stop help pages from crashing https://github.com/neovim/neovim/issues/29492
    "vimdoc",
    -- noice recommendations
    "vim",
    "regex",
    "markdown",
    "markdown_inline",
    -- other
    "javascript",
    "html",
    "css",
    "vue",
  },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})
