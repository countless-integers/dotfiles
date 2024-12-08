-- VIM editor settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.rnu = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

local unimpared_mappings = {
	b = { ":bprevious<CR>", ":bnext<CR>" },
	w = { "<C-w>p", "<C-w>w" },
	q = { ":cprevious<CR>", ":cnext<CR>" },
	l = { ":lprevious<CR>", ":lnext<CR>" },
}
for key, cmds in pairs(unimpared_mappings) do
	vim.keymap.set("n", "[" .. key, cmds[1], { silent = true })
	vim.keymap.set("n", "]" .. key, cmds[2], { silent = true })
end
-- exit terminal without closing,
-- similar to how going back from insert to normal mode in a buffer works
-- also see autocommands for starting insert mode when terminal is opened
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- Plugins configs
require("config.lazy")
require("config.catppuccin")
require("config.telescope")
require("config.file-navigation")
require("config.tree-sitter")
require("config.lualine")
require("config.lsp")
require("config.alpha")
require("config.completions")
require("config.debugger")
require("config.git-integrations")
require("config.noice")
require("config.mini")
require("config.autocommands")
