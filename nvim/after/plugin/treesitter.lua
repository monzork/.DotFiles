require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "javascript", "typescript", "c", "lua", "vim", "vimdoc" },
    sync_install = false,
    disable = { "html" },
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
