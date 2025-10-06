return {
    -- Flash - Navegação rápida no buffer
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    -- Leap - Navegação rápida alternativa
    {
        "ggandor/leap.nvim",
        enabled = false, -- Desabilitado porque o flash.nvim é mais moderno
        dependencies = { "tpope/vim-repeat" },
        event = "VeryLazy",
        config = function()
            require("leap").add_default_mappings()
        end,
    },

    -- UFO - Code folding melhorado
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufReadPost",
        opts = {
            provider_selector = function()
                return { "treesitter", "indent" }
            end,
        },
        config = function(_, opts)
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

            require("ufo").setup(opts)
        end,
    },

    -- Telescope extensions úteis
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").load_extension("fzf")
        end,
    },

    -- File browser para Telescope
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").load_extension("file_browser")
            vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", { desc = "File Browser" })
        end,
    },

    -- Aerial - Outline de símbolos
    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "AerialToggle", "AerialOpen", "AerialClose" },
        keys = {
            { "<leader>a", ":AerialToggle<CR>", desc = "Aerial Toggle" },
        },
        opts = {
            layout = {
                min_width = 30,
            },
            attach_mode = "global",
        },
    },

    -- Marks - Visualização melhorada de marks
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Navbuddy - Navegação rápida por código
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Navbuddy",
        keys = {
            { "<leader>nb", ":Navbuddy<CR>", desc = "Navbuddy" },
        },
        opts = {
            lsp = { auto_attach = true },
        },
    },
}
