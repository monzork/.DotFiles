require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "ts_ls",
        "eslint",
        "rust_analyzer",
        "pyright",
        "html",
        "cssls",
        "angularls",
        "bashls",
        "jsonls",
    },
}
