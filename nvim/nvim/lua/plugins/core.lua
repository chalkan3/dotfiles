return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-project.nvim" },
        cmd = "Telescope",
        opts = function()
            local telescope = require("telescope.builtin")
            return {
                extensions = {
                    project = {
                        base_dirs = { "~/projects", "~/work" },
                    },
                },
            }
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = { "lua", "vim", "ruby", "go", "yaml" },
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },

    "nvim-treesitter/nvim-treesitter-context",

    {
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            require('Comment').setup()
            vim.keymap.set({ "n", "v" }, "<leader>/", function()
                require("Comment.api").toggle.linewise.current()
            end, { desc = "Comment" })
        end,
    },
}
