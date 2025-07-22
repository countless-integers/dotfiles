require("mason").setup()
require("mason-lspconfig").setup({
  automatic_installation = false,
  ensure_installed = {
    "lua_ls",
    "bashls",
    "terraformls",
    "intelephense",
    "pyright",
    --"ruff",
    "marksman",
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
    ["ruff"] = function()
      require("lspconfig").ruff.setup({
        init_options = {
          settings = {
            lineLength = 30,
            fixAll = true,
            showSyntaxErrors = true,
            organizeImports = true,
            codeAction = {
              fixViolation = {
                enable = true
              }
            }
          }
        }
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
    "ruff",
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

    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show docs" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references"})
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action"})
    vim.keymap.set({ "n", "v" }, "<leader>cf", vim.lsp.buf.format, { desc = "Code format"})
    -- vim.keymap.set({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, {})
    vim.keymap.set("n", "<leader>cr", function()
      -- Check if any attached LSP supports rename
      for _, lsp_client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if lsp_client.supports_method("textDocument/rename") then
          return vim.lsp.buf.rename()
        end
      end

      -- Fallback: Open the :%s command for manual renaming
      local current_word = vim.fn.expand("<cword>")
      local command = ":%s/\\<" .. current_word .. "\\>//g<Left><Left>"
      -- from_part = true, do_lt = false, special = true
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(command, true, false, true), "n", false)
    end, { silent = true, noremap = true, desc = "LSP rename or fallback to :%s" })
  end,
})

-- some stuff for running lua
-- vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>")
-- vim.keymap.set("v", "<leader>x", "<cmd>lua<CR>")
-- vim.keymap.set("n", "<leader>x", ":.lua<CR>")
-- vim.keymap.set("v", "<leader>x", ":lua<CR>")

local function execute_code(code)
  local filetype = vim.bo.filetype
  if filetype == "lua" then
    vim.cmd('lua ' .. code)
  elseif filetype == "python" then
    vim.cmd('!python -c "' .. code .. '"')
  elseif filetype == "javascript" then
    vim.cmd('!node -e "' .. code .. '"')
  elseif filetype == "sh" then
    vim.cmd('!sh -c "' .. code .. '"')
  else
    print("Unsupported file type for execution: " .. filetype)
  end
end

vim.keymap.set("n", "<leader>x", function()
  local line = vim.api.nvim_get_current_line()
  execute_code(line)
end)
vim.keymap.set("v", "<leader>x", function()
  local visual_selection = vim.fn.getreg('"')
  execute_code(visual_selection)
end)
