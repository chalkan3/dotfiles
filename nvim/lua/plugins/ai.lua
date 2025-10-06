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
                    keymap = {
                        accept = "<C-l>",
                        next = "<C-]>",
                        prev = "<C-[>",
                    },
                },
                panel = {
                    enabled = true,
                },
            })
        end,
    },
}
