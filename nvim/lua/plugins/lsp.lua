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
}
