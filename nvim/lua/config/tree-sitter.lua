local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "lua", "bash", "javascript", "html" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },  
})
