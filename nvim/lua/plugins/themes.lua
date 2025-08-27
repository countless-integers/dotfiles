return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = function()
        vim.cmd.colorscheme "catppuccin"
      end,
      set_light_mode = function()
        vim.o.background = "light"
        -- vim.cmd.colorscheme "gruvbox"
        vim.cmd.colorscheme "rose-pine"
      end,
      update_interval = 3000,
      fallback = "dark"
    }
  }
}
