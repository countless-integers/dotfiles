require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"bashls",
		"volar",
		"terraformls",
	},
	handlers = {
		function(server_name) -- default handler (optional)
			require("lspconfig")[server_name].setup({})
		end,
		["lua_ls"] = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
		end,
		-- this is broken because JS...
		-- :MasonInstall vue-language-server@2.0.19
		-- @see: https://github.com/williamboman/mason-lspconfig.nvim/issues/371#issuecomment-2185401809
		["volar"] = function()
			require("lspconfig").volar.setup({
				filetypes = { "javascript", "vue", "json" },
				-- filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
				init_options = {
					vue = {
						hybridMode = false,
					},
					-- typescript = {
					--   tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
					-- },
				},
			})
		end,
	},
})
--local lsp_config = require("lspconfig")

-- none ls
require("mason-null-ls").setup({
	ensure_installed = {
		"stylua",
		"jq",
		"shellcheck", -- for bash
	},
	handlers = {},
})
require("null-ls").setup({
	sources = {
		-- Anything not supported by mason.
	},
})

-- bindings and the like
-- @see: :h vim.lsp.buf
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.supports_method("textDocument/completion") then
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		end
		if client.supports_method("textDocument/definition") then
			vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
		end

		vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		vim.keymap.set({ "n", "v" }, "<leader>cf", vim.lsp.buf.format, {})
		vim.keymap.set({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, {})
	end,
})

-- auto comment string
-- this is the only way I found to have native commenting working in vue files
require("ts_context_commentstring").setup({
	enable_autocmd = false,
})
local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
	return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
		or get_option(filetype, option)
end
