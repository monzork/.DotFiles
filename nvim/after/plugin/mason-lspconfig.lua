require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "tsserver",
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
