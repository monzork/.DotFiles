local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then return end


local conditional = function(fn)
    local utils = require('null-ls.utils').make_conditional_utils()
    return fn(utils)
end
local on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(client)
                return client.name == "null-ls"
            end
        })
    end, { desc = "Format current buffer with LSP" })
end

null_ls.setup({
    debug = false,
    sources = {
        null_ls.builtins.diagnostics.eslint.with({
            condition = function(utils)
                return utils.root_has_file({ '.eslintrc' })
            end
        }),
        null_ls.builtins.formatting.prettierd,
    },
    on_attach = on_attach
})
