local dap = require('dap')

dap.adapters.coreclr = {
    type = 'executable',
    command = '/usr/local/bin/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}

vim.keymap.set('n', '<F5>', ':lua require"dap".continue()<CR>')
vim.keymap.set('n', '<F10>', ':lua require"dap".step_over()<CR>')
vim.keymap.set('n', '<F10>', ':lua require"dap".step_over()<CR>')
vim.keymap.set('n', '<F10>', ':lua require"dap".step_over()<CR>')
vim.keymap.set('n', '<F10>', ':lua require"dap".step_over()<CR>')
vim.keymap.set('n', '<leader>B', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
vim.keymap.set('n', '<leader>lp', ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message:"))<CR>')
vim.keymap.set('n', '<leader>b', ':lua require("dap").toggle_breakpoint()<CR>')
