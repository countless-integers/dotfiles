---@diagnostic disable: missing-fields
local treesitter = require("nvim-treesitter")

local languages = {
  "lua",
  "bash",
  -- this is to stop help pages from crashing https://github.com/neovim/neovim/issues/29492
  "vimdoc",
  "vim",
  "regex",
  "markdown",
  "markdown_inline",
  -- data 
  "yaml",
  "json",
  -- other
  "javascript",
  "html",
  "css",
  "vue",
  "terraform",
  "hcl",
  "nu",
  "rust",
  "php",
}
treesitter.setup()
treesitter.install(languages)

vim.api.nvim_create_autocmd(
  'FileType',
  {
    pattern = languages,
    callback = function()
      -- syntax highlighting, provided by Neovim
      vim.treesitter.start()
      -- folds, provided by Neovim 
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldmethod = 'expr'
      -- indentation, provided by nvim-treesitter
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  }
)
