---@diagnostic disable: missing-fields
local treesitter = require("nvim-treesitter")

local languages = {
	"lua",
	"bash",
	"nu",
	"rust",
	"php",
	-- this is to stop help pages from crashing https://github.com/neovim/neovim/issues/29492
	"vimdoc",
	"vim",
	"regex",
	-- templating
	"markdown",
	"markdown_inline",
	"jinja",
	"jinja_inline",
	-- data
	"yaml",
	"json",
	-- fe
	"javascript",
	"html",
	"css",
	"vue",
	-- iac
	"terraform",
	"hcl",
}
treesitter.setup()
treesitter.install(languages)

vim.filetype.add({
	extension = {
		j2 = function(path, bufnr)
			-- Check if there is a second extension (e.g., .sh.j2)
			local base = path:match("([^/]+)%.j2$")
			local sub_ext = base:match("%.([^.]+)$")

			if sub_ext then
				-- jinja2 parser doesn't seem to exist so use jinja
				return sub_ext .. ".jinja"
			end
			return "jinja"
		end,
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = function(args)
		local ft = vim.bo[args.buf].filetype

		-- Check if a treesitter parser is actually available for this filetype
		local has_parser, _ = pcall(vim.treesitter.get_parser, args.buf)

		if has_parser then
			vim.treesitter.start()
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			-- Ensure nvim-treesitter is loaded before calling its indentexpr
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		else
			-- Fallback to standard Vim regex highlighting/indenting
			vim.bo.indentexpr = ""
		end
	end,
})
