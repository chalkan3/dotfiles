return {
    -- Harpoon - Navegação rápida entre arquivos importantes
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Harpoon Add" },
            { "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Menu" },
            { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon File 1" },
            { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon File 2" },
            { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon File 3" },
            { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon File 4" },
        },
        config = function()
            require("harpoon").setup()
        end,
    },

    -- Todo Comments - Destaca TODO, FIXME, NOTE, etc
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
        event = "BufReadPost",
        config = function()
            require("todo-comments").setup()

            vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find Todos" })
        end,
    },

    -- Vim Fugitive - Git integration poderosa
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
        keys = {
            { "<leader>gs", ":Git<CR>", desc = "Git Status" },
            { "<leader>gd", ":Gdiffsplit<CR>", desc = "Git Diff" },
            { "<leader>gc", ":Git commit<CR>", desc = "Git Commit" },
            { "<leader>gp", ":Git push<CR>", desc = "Git Push" },
            { "<leader>gl", ":Git pull<CR>", desc = "Git Pull" },
        },
    },

    -- LazyGit integration
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "LazyGit",
        keys = {
            { "<leader>gg", ":LazyGit<CR>", desc = "LazyGit" },
        },
    },

    -- Nvim Spectre - Busca e substituição em todo o projeto
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Spectre",
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace" },
            { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search Word" },
        },
        config = function()
            require("spectre").setup()
        end,
    },

    -- Session Manager - Salva e restaura sessões
    {
        "Shatur/neovim-session-manager",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "SessionManager",
        keys = {
            { "<leader>ss", ":SessionManager save_current_session<CR>", desc = "Save Session" },
            { "<leader>sl", ":SessionManager load_session<CR>", desc = "Load Session" },
        },
        config = function()
            local config = require("session_manager.config")
            require("session_manager").setup({
                autoload_mode = config.AutoloadMode.Disabled,
            })
        end,
    },

    -- Vim Sleuth - Detecta automaticamente indentação
    {
        "tpope/vim-sleuth",
        event = "BufReadPre",
    },

    -- Persistence - Salva automaticamente sessões
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
        },
    },
}
