-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_boostrap = ensure_packer()

vim.cmd([[packadd packer.nvim]])
return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")


    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use({
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            vim.cmd([[colorscheme rose-pine]])
        end,
    })


    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = {
            "nvim-treesitter/nvim-treesitter",
        },
        build = ':TSUpdate',
    })

    use("lukas-reineke/indent-blankline.nvim")
    use("mbbill/undotree")
    use("tpope/vim-fugitive")
    use("wakatime/vim-wakatime")
    use("lewis6991/gitsigns.nvim")
    use("nvim-lualine/lualine.nvim")
    use("numToStr/Comment.nvim")
    use({
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" }, -- Required
            {
                -- Optional
                "williamboman/mason.nvim",
                config = true,
                run = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            { 'folke/neodev.nvim' },
            { "williamboman/mason-lspconfig.nvim" }, -- Optional
            {
                'j-hui/fidget.nvim',
                tag = 'legacy',
                opts = {}
            },
            -- Autocompletion
            { "hrsh7th/nvim-cmp" },     -- Required
            { "hrsh7th/cmp-nvim-lsp" }, -- Required
            { "L3MON4D3/LuaSnip" },     -- Required
            { "saadparwaiz1/cmp_luasnip" },
            { "rafamadriz/friendly-snippets" }
        },
    })

    if packer_boostrap then
        require('packer').sync()
    end
end)
