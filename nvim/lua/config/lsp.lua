require("mason").setup()

-- vim.lsp.config() calls must happen BEFORE mason-lspconfig.setup() so that
-- when automatic_enable calls vim.lsp.enable(), the FileType autocmds are
-- registered with the correct (extended) filetype lists.
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("bashls", {
  capabilities = capabilities,
  filetypes = { "sh", "bash", "sh_jinja" },
})

vim.lsp.config("terraformls", {
  capabilities = capabilities,
  filetypes = { "terraform", "terraform-vars", "hcl" },
})

vim.lsp.config("ansiblels", {
  capabilities = capabilities,
})

vim.lsp.config("jinja_lsp", {
  capabilities = capabilities,
  filetypes = { "jinja", "sh_jinja", "yaml_jinja", "ini_jinja", "json_jinja" },
})

-- Direct autocmd for sh_jinja → bashls.
-- vim.lsp.config/enable may not register FileType autocmds for unknown filetypes
-- reliably, so this ensures bashls always attaches to .sh.j2 files.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh_jinja",
  callback = function(args)
    vim.lsp.start({
      name = "bashls",
      cmd = { "bash-language-server", "start" },
      root_dir = vim.fs.root(args.buf, { ".git" }) or vim.fn.expand("%:p:h"),
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    }, { bufnr = args.buf })
  end,
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "bashls",
    "terraformls",
    "intelephense",
    "pyright",
    --"ruff",
    "marksman",
    "ansiblels",
    "jinja_lsp",
  },
})

-- it's none ls, but still name as the original package
require("null-ls").setup({})
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
  -- automated setup, supposedly
  handlers = {},
})

-- Disable bashls diagnostics on Jinja templates — the Jinja syntax ({{ }}, {% %})
-- is always flagged as invalid bash, making diagnostics useless for these files.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "bashls" and vim.bo[args.buf].filetype == "sh_jinja" then
      vim.diagnostic.enable(false, { bufnr = args.buf })
    end
  end,
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
