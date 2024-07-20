-- VIM editor settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
--vim.cmd("set softabstop=2")
vim.cmd("set shiftwidth=2")

require('config.lazy')
require('config.telescope')
require('config.neo-tree')
require('config.tree-sitter')
