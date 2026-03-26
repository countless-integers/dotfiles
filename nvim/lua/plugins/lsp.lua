return {
	{
		"williamboman/mason.nvim",
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"neovim/nvim-lspconfig",
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			formatters_by_ft = {
				lua    = { "stylua" },
				json   = { "jq" },
				python = { "ruff_format" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				sh     = { "shellcheck" },
				bash   = { "shellcheck" },
				python = { "ruff" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	-- specific for neovim lua dev
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^8",
		ft = "rust",
	},
	{
		"mfussenegger/nvim-ansible",
		ft = { "yaml.ansible" }, -- load this plugin only for Ansible YAML files
		config = function()
			-- Optional: Add any configuration or key mappings.
			-- For instance, you might want to map a key to run a playbook:
			vim.keymap.set(
				"n",
				"<leader>te",
				":w<CR>:lua require('ansible').run()<CR>",
				{ desc = "Run Ansible playbook", buffer = true }
			)
		end,
	},
	{
		"adibhanna/laravel.nvim",
		ft = "php",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("laravel").setup()
		end,
	},
}
