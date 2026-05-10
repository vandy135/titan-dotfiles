return {
    -- Colorschemes (active one selected by config/colorscheme.lua, templated from chezmoi `theme`)
    { "catppuccin/nvim",          name = "catppuccin", lazy = false, priority = 1000 },
    { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            require("everforest").setup({ background = "medium" })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "lua", "vim", "vimdoc", "bash", "json", "yaml",
                "toml", "markdown", "markdown_inline",
                "python", "rust", "go", "javascript", "typescript",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "lua", "vim", "help", "bash", "sh", "json", "yaml",
                    "toml", "markdown",
                    "python", "rust", "go", "javascript", "typescript",
                },
                callback = function()
                    pcall(vim.treesitter.start)
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help" },
        },
    },

    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
        },
        config = function()
            require("nvim-tree").setup({})
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup()
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = { theme = "auto" },
            })
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup()
        end,
    },
}
