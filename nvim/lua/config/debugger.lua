local dap = require("dap")
local dapui = require("dapui")

-- Keybidings
vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {})
-- continue will continue (also start debugging)
vim.keymap.set('n', '<Leader>dc', dap.continue, {})

-- Automatically open UI on these events
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

dapui.setup()

-- Individual debuggers configurations
-- @see: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
