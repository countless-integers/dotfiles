local lualine = require("lualine")

lualine.setup({
  options = {
    theme = "auto",
    disabled_filetypes = {
      statusline = {
        "snacks_dashboard",
        "neo-tree",
      },
    },
    globalstatus = true,
  },
  sections = {
    lualine_b = {
      -- 	"fancy_branch",
      "fancy_diff",
      {
        'macro',
        fmt = function()
          local reg = vim.fn.reg_recording()
          if reg ~= "" then
            return "Recording @" .. reg
          end
          return nil
        end,
        color = { fg = "#ff9e64" },
        draw_empty = false,
      },
    },
    lualine_x = {
      "fancy_lsp_servers",
      "encoding",
      "fileformat",
      "filetype",
    },
  },
})
