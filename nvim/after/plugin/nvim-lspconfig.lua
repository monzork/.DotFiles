vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        -- fugitive/diffview/gitsigns preview buffers inherit the source
        -- file's filetype (e.g. "go") for highlighting, so the FileType
        -- autocmd still attaches a client. Their buffer names aren't real
        -- file:// URIs, so gopls fails to parse the didOpen URI and spams
        -- "document uri scheme" JSON-RPC errors. Detach immediately.
        local bufname = vim.api.nvim_buf_get_name(event.buf)
        if bufname:match("^fugitive://") or bufname:match("^diffview://") or bufname:match("^gitsigns://") then
            vim.lsp.buf_detach_client(event.buf, event.data.client_id)
            return
        end

        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("<leader>vrn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>vd", vim.diagnostic.open_float, "Show Diagnostics")
        map("<leader>vca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
        map("gr", require("telescope.builtin").lsp_references, "References")
        map("gI", require("telescope.builtin").lsp_implementations, "Implementations")
        map("gd", require("telescope.builtin").lsp_definitions, "Definitions")
        map("gD", vim.lsp.buf.declaration, "Declaration")
        map("<leader>lf", vim.lsp.buf.format, "Format")
        map("gO", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
        map("gy", require("telescope.builtin").lsp_type_definitions, "Type Definitions")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                end,
            })
        end

        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
        end

        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_foldingRange, event.buf) then
            vim.wo[0][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end
    end,
})

vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
    } or {},
    virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
            return diagnostic.message
        end,
    },
})

-- Server-specific overrides.
--
-- mason-lspconfig v2 dropped `handlers` and `automatic_installation`. It now
-- just calls `vim.lsp.enable()` for every installed server (`automatic_enable`,
-- on by default), so per-server settings go through `vim.lsp.config()` and are
-- merged by Neovim itself. Anything passed as `handlers` is silently ignored.
--
-- Completion capabilities are deliberately NOT set here: blink.cmp registers
-- them on `vim.lsp.config['*']` from its own plugin file, and every server
-- inherits that.
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
        },
    },
})

-- mason-tool-installer resolves lspconfig names to Mason package names, so
-- either spelling works here. Non-LSP tools (formatters, linters) go in the
-- same list.
require("mason-tool-installer").setup({
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
        "emmet_language_server",
        "gopls",
        "stylua",
    },
})

require("mason-lspconfig").setup({})
