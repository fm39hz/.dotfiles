local dap = require('dap')
local widgets = require('dap.ui.widgets')

dap.adapters.godot = {
  type = "server",
  host = '127.0.0.1',
  port = 6006,
}
dap.adapters.coreclr = {
  type = 'executable',
  command = '/home/fm39hz/.local/share/nvim/mason/packages/netcoredbg/libexec/netcoredbg/netcoredbg',
  args = {'--interpreter=vscode'}
}
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.getcwd() .. '/bin/Debug/net7.0/' .. vim.fn.substitute(vim.fn.getcwd(), '^.*/', '', '')
    end,
  },
}
return dap
