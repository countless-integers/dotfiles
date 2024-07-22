require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
  }
})
local lsp_config = require('lspconfig')

-- @fixme: make this check for that module first...
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- setup LSPs for different languages
lsp_config.lua_ls.setup({
  capabilities = capabilities
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

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
    vim.keymap.set({ 'n', 'v' }, '<leader>cf', vim.lsp.buf.format, {})
  end,
})
