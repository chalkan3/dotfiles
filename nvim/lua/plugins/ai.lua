return {
    -- Copilot Chat - Chat com GitHub Copilot
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        cmd = { "CopilotChat", "CopilotChatExplain", "CopilotChatReview", "CopilotChatFix" },
        config = function()
            require("CopilotChat").setup({
                debug = false,
            })

            -- Keymaps para Copilot Chat
            vim.keymap.set("n", "<leader>cp", ":CopilotChat ", { desc = "Copilot Chat" })
            vim.keymap.set("v", "<leader>ce", ":CopilotChatExplain<CR>", { desc = "Copilot Explain" })
            vim.keymap.set("v", "<leader>cr", ":CopilotChatReview<CR>", { desc = "Copilot Review" })
            vim.keymap.set("v", "<leader>cf", ":CopilotChatFix<CR>", { desc = "Copilot Fix" })
        end,
    },

    -- Copilot.lua - Versão Lua do Copilot (mais performática)
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<Tab>",
                        accept_word = "<C-l>",
                        accept_line = "<C-j>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
                panel = {
                    enabled = true,
                    auto_refresh = true,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<CR>",
                        refresh = "gr",
                        open = "<M-CR>",
                    },
                },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
            })
        end,
    },
}
