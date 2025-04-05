return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    disable = {
      ft = {
        "neo-tree",
      },
      bt = {
        "neo-tree",
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
