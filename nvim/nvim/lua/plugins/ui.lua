return {
    -- 🎨 Tema de Cores Principal
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme tokyonight-night")
        end
    },
    "nvim-tree/nvim-web-devicons",

    -- Icons
    {
        "echasnovski/mini.icons",
        config = function()
            require("mini.icons").setup()
        end,
    },

    -- 🚥 Status Line (Rodapé)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {}, -- Configuração padrão já é ótima
    },

    -- 🌳 Explorador de Arquivos
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = "NvimTreeToggle",
        opts = {
            view = { width = 30 },
            renderer = { icons = { show_only_minimized_file_indicators = true } },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
        },
    },

    -- 💅 Melhora as Janelas e Prompts (Substitui prompts feios por flutuantes)
    {
        "stevearc/dressing.nvim",
        opts = {},
    },

    -- 📑 Abas/Buffers
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                indicator = {
                    style = 'icon',
                    icon = '▎',
                },
                -- mostra apenas o nome do arquivo, sem o caminho completo
                show_buffer_close_icons = false,
                show_close_icon = false,
                sort_by = 'tabs',
                separator_style = "thin",
                highlights = {
                    buffer_selected = {
                        fg = "#cba6f7", -- Mauve
                        bold = true,
                    },
                },
            }
        }
    },

    -- 📏 Guias de Indentação Visíveis
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "▏" },
            scope = { enabled = false },
        },
    },

    -- ✨ Notificações Modernas (Substitui as mensagens padrão do vim)
    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 3000,
            stages = "static",
            top_down = false,
        },
        config = function(_, opts)
            require("notify").setup(opts)
            vim.notify = require("notify")
        end,
    },

    -- 🔔 Substitui Linha de Comando e Mensagens Flutuantes
    {
        "folke/noice.nvim",
        lazy = false,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            views = {
                cmdline_popup = {
                    size = {
                        width = 60,
                        height = 5,
                    },
                },
            },
            messages = {
                -- Substitui 'Press ENTER or type command to continue'
                view = "mini",
            },
        },
    },


    -- ⌨️  Which-Key
    {
        "folke/which-key.nvim",
        lazy = false,
        config = function()
            require("which-key").setup()
        end,
    },

    -- Terminal integrado
    {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        config = function()
            require("toggleterm").setup()
        end,
    },

    -- Startup screen
    {
        "goolord/alpha-nvim",
        config = function()
            require("alpha").setup(require("alpha.themes.dashboard").config)
        end,
    },

    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup()
        end,
    },

    -- Symbol outline
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        config = function()
            require("symbols-outline").setup()
        end,
    },

    -- Better diagnostics
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "TroubleToggle",
        config = function()
            require("trouble").setup()
        end,
    },
}
