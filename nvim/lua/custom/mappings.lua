---@type MappingsTable
local M = {}

M.general = {
  n = {
    [":"] = { ":", "enter command mode", opts = { nowait = true } },
    [";"] = {"<cmd> lua require('fine-cmdline').open({default_value = ''}) <CR>"},

  },
}
M.disabled = {
}
-- more keybinds!
M.debug = {
  n = {
    ["<leader>b"] = {"<cmd> lua require('custom.configs.dapconfig').toggle_breakpoint() <CR>"},
    ["<f5>"] = {"<cmd> lua require('custom.configs.dapconfig').continue() <CR>"},
    ["<f10>"] = {"<cmd> lua require('custom.configs.dapconfig').step_over() <CR>"},
    ["<f11>"] = {"<cmd> lua require('custom.configs.dapconfig').step_into() <CR>"},

  },
}
return M
