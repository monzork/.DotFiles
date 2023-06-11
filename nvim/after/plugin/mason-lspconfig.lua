require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "tsserver", "eslint" },
}
require("mason-null-ls")
