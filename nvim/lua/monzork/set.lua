vim.g.have_nerd_font = true

vim.opt.nu = true
vim.opt.relativenumber = true

-- per-project indent overrides belong in that project's .editorconfig
-- (nvim >=0.9 reads it automatically); this is just the fallback default
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

vim.opt.expandtab = true
vim.opt.smartindent = true

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

-- Treesitter folding by default; LspAttach upgrades to LSP folding
-- (textDocument/foldingRange) per-window when a server supports it.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99

vim.opt.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- `goto_prev`/`goto_next` are deprecated as of nvim 0.11; `jump()` replaces them.
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- `<leader>tt`, not `<leader>t`: the LSP attach handler maps `<leader>th`
-- (inlay hints), and a mapping that is a prefix of another one stalls for
-- `timeoutlen` on every press.
vim.keymap.set("n", "<Leader>tt", "<cmd>tabnew | terminal<CR>", { silent = true, desc = "Open [t]erminal [t]ab" })

-- Scratch terminal tab on startup, but only for a bare interactive `nvim`.
-- Without these guards it also fires when nvim is opening a file, acting as
-- $EDITOR (`git commit`), or running headless -- which breaks scripted use.
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() > 0 then
            return
        end
        if #vim.api.nvim_list_uis() == 0 then
            return
        end
        vim.cmd("tabnew | terminal")
        vim.cmd("tabprevious")
    end,
})

vim.o.completeopt = "menuone,noselect"

vim.opt.colorcolumn = "140"
