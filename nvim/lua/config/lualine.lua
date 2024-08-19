local lualine = require("lualine")

lualine.setup({
  theme = "catppuccin",
  sections = {
    lualine_b = {
      "fancy_branch",
      "fancy_diff",
    },
    lualine_x = {
      "fancy_lsp_servers",
      "encoding",
      "fileformat",
      "filetype",
    },
  },
})
