---@diagnostic disable: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "bash",
    -- this is to stop help pages from crashing https://github.com/neovim/neovim/issues/29492
    "vimdoc",
    "vim",
    "regex",
    "markdown",
    "markdown_inline",
    -- other
    "javascript",
    "html",
    "css",
    "vue",
    "terraform",
    "hcl",
    "nu",
    "rust",
    "php",
  },
  auto_install = true,
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  -- disable for large files
  disable = function(lang, buf)
    local max_filesize = 100 * 1024 -- 100KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return true
    end
  end,
  additional_vim_regex_highlighting = false,
})
