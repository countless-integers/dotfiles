-- VIM editor settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Plugins configs
require('config.lazy')
require('config.catppuccin')
require('config.telescope')
require('config.neo-tree')
require('config.tree-sitter')
require('config.lualine')
require('config.lsp')
require('config.alpha')
require('config.completions')
require('config.debugger')
require('config.git-integrations')
