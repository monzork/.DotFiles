local dap, dapui = require('dap'), require('dapui')

dap.adapters.coreclr = {
    type = 'executable',
    command = '/usr/local/bin/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    -- {
    --     type = "coreclr",
    --     name = "launch - netcoredbg",
    --     request = "launch",
    --     program = function()
    --         return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    --     end,
    -- },
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "attach",
        processId = function()
            return vim.fn.input('Path to dll', 'processId')
        end,
    }
}

vim.keymap.set('n', '<F5>', ':lua require"dap".continue()<CR>')
vim.keymap.set('n', '<F2>', ':lua require"dap".step_over()<CR>')
vim.keymap.set('n', '<F3>', ':lua require"dap".step_into()<CR>')
vim.keymap.set('n', '<F4>', ':lua require"dap".step_out()<CR>')
vim.keymap.set('n', '<leader>ba', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
vim.keymap.set('n', '<leader>lp', ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message:"))<CR>')
vim.keymap.set('n', '<leader>bb', ':lua require("dap").toggle_breakpoint()<CR>')
vim.keymap.set('n', '<leader>dr', ':lua require"dap".repl.open()<CR>')

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
