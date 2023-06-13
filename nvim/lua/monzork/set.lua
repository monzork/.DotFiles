vim.opt.nu = true
vim.opt.relativenumber = true

local cwd = vim.fn.getcwd(-1, -1)

if string.match(cwd, "/phonecheck/") then
    print("phonecheck", cwd)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
else
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
end


vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "140"

vim.g.mapleader = " "
