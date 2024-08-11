-- VIM editor settings
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.clipboard = "unnamedplus"
vim.o.rnu = true
-- exit terminal without closing, 
-- similar to how going back from insert to normal mode in a buffer works
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- Plugins configs
require('config.lazy')
require('config.catppuccin')
require('config.telescope')
require('config.file-navigation')
require('config.tree-sitter')
require('config.lualine')
require('config.lsp')
require('config.alpha')
require('config.completions')
require('config.debugger')
require('config.git-integrations')
require('config.noice')
