require("mason").setup()
require("mason-lspconfig").setup({
  automatic_installation = false,
  ensure_installed = {
    "lua_ls",
    "bashls",
    "volar",
    "terraformls",
    "intelephense",
  },
  handlers = {
    function(server_name) -- default handler (optional)
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
      })
    end,
    ["lua_ls"] = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
    end,
    -- this is broken because JS...
    -- :MasonInstall vue-language-server@2.0.19
    -- @see: https://github.com/williamboman/mason-lspconfig.nvim/issues/371#issuecomment-2185401809
    ["volar"] = function()
      require("lspconfig").volar.setup({
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        filetypes = { "javascript", "vue", "json" },
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      })
    end,
  },
})

-- none ls
require("mason-null-ls").setup({
  automatic_installation = false,
  ensure_installed = {
    "stylua",
    "jq",
    "shellcheck", -- for bash
    "codelldb",
  },
  methods = {
    diagnostics = true,
    formatting = true,
    code_actions = true,
    completion = false,
    hover = false,
  },
  handlers = nil,
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
    if client and client.supports_method("textDocument/completion") then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if client and client.supports_method("textDocument/definition") then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    vim.keymap.set({ "n", "v" }, "<leader>cf", vim.lsp.buf.format, {})
    vim.keymap.set({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, {})
  end,
})

-- some stuff for running lua
-- vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>")
-- vim.keymap.set("v", "<leader>x", "<cmd>lua<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")
