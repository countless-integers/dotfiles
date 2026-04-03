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
	"ini",
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
				-- Return a custom filetype like sh_jinja so treesitter injections work
				return sub_ext .. "_jinja"
			end
			return "jinja"
		end,
	},
})

-- Map *_jinja filetypes to the jinja parser.
-- Queries are still looked up under "jinja" (see after/queries/jinja/injections.scm).
vim.treesitter.language.register("jinja", "sh_jinja")
vim.treesitter.language.register("jinja", "yaml_jinja")
vim.treesitter.language.register("jinja", "ini_jinja")
vim.treesitter.language.register("jinja", "json_jinja")

-- Custom predicate used in after/queries/jinja/injections.scm to inject the
-- host language (bash, yaml, ini) only for buffers with the matching filetype.
vim.treesitter.query.add_predicate("is-filetype?", function(match, pattern, bufnr, pred)
	return vim.bo[bufnr].filetype == pred[2]
end, { force = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = function(args)
		local ft = vim.bo[args.buf].filetype

		-- Check if a treesitter parser is actually available for this filetype
		if vim.treesitter.get_parser(args.buf) then
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

-- Enable treesitter for custom *_jinja filetypes (jinja + host language injections)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sh_jinja", "yaml_jinja", "ini_jinja", "json_jinja" },
	callback = function(args)
		local bufnr = args.buf
		-- Schedule to run after all other FileType autocmds settle.
		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end
			-- Explicitly pass "jinja" — language.register maps *_jinja to jinja,
			-- but passing it directly avoids relying on that resolution at start time.
			local ok, err = pcall(vim.treesitter.start, bufnr, "jinja")
			if ok then
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			else
				vim.notify("treesitter: failed to start jinja for " .. vim.bo[bufnr].filetype .. ": " .. tostring(err), vim.log.levels.WARN)
			end
		end)
	end,
})
