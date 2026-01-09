vim.opt.nu = true
vim.opt.relativenumber = true

local cwd = vim.fn.getcwd(-1, -1)

if string.match(cwd, "/phonecheck/") then
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
else
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
end

vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'

vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.api.nvim_set_keymap('n', '<Leader>t', ':tabnew | terminal<CR>', { noremap = true, silent = true })
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd('tabnew | terminal')
        vim.cmd('tabprevious')
    end,
})

vim.o.completeopt = 'menuone,noselect'

vim.opt.colorcolumn = "140"

vim.g.mapleader = " "
