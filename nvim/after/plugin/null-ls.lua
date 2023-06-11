local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(client)
                return client.name == "null-ls"
            end
        })
        print("File formatted")
    end, { desc = "Format current buffer with LSP" })
end

null_ls.setup({
    debug = false,
    sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.prettierd,
    },
})
