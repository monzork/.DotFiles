require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "-" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        vim.keymap.set("n", "<leader>gp", function()
            gitsigns.nav_hunk("prev")
        end, { buffer = bufnr, desc = "[G]o to [P]revious Hunk" })
        vim.keymap.set("n", "<leader>gn", function()
            gitsigns.nav_hunk("next")
        end, { buffer = bufnr, desc = "[G]o to [N]ext Hunk" })
        vim.keymap.set("n", "<leader>ph", gitsigns.preview_hunk, { buffer = bufnr, desc = "[P]review [H]unk" })
    end,
})
