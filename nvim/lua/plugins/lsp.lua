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
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "nvimtools/none-ls.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
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
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },
  {
    "mfussenegger/nvim-ansible",
    ft = { "yaml.ansible" },  -- load this plugin only for Ansible YAML files
    config = function()
      -- Optional: Add any configuration or key mappings.
      -- For instance, you might want to map a key to run a playbook:
      vim.keymap.set('n', '<leader>te', ":w<CR>:lua require('ansible').run()<CR>", { desc = "Run Ansible playbook", buffer = true })
    end,
  },
}
