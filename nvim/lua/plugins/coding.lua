return {
    {
        "folke/lazydev.nvim",
        opts = {},
    },

    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "lua_ls", "jsonls", "html", "cssls", "tsserver", "deno",
                "pyright", "rust_analyzer", "gopls", "clangd", "jdtls", "solargraph",
                "bashls", "yamlls", "dockerls", "marksman", "terraformls", "kotlin_language_server",
                "phpactor", "pylsp", "r_language_server", "svelte", "tailwindcss", "vtsls",
                "emmet_ls", "cmake", "fortran_ls", "hls", "intelephense", "metals", "omnisharp",
                "perlpls", "powershell_es", "ruby_lsp", "taplo", "terraform_lsp", "unocss",
                "vuels", "wgsl_analyzer", "zls", "typst_lsp", "nil_ls", "elixirls",
            }
        },
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            local on_attach = function(client, bufnr)
                local opts = { noremap = true, silent = true }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            end

            mason_lspconfig.setup({
                ensure_installed = {},
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            on_attach = on_attach,
                            capabilities = cmp_nvim_lsp.default_capabilities(),
                        })
                    end,

                    lua_ls = function()
                        lspconfig.lua_ls.setup({
                            on_attach = on_attach,
                            capabilities = cmp_nvim_lsp.default_capabilities(),
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    workspace = {
                                        library = {
                                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                            [vim.fn.stdpath("config") .. "/lua"] = true,
                                        },
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "zbirenbaum/copilot-cmp",
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("copilot_cmp").setup({})

            return {
                completion = {
                },
                experimental = {
                    ghost_text = true,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "cmdline" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "copilot" },
                }),
            }
        end
    },

    "nvim-treesitter/nvim-treesitter-textobjects",

    -- Git integration
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Auto-closing pairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    -- Surrounding text
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end,
    },

    -- Code formatting
    {
        "mhartington/formatter.nvim",
        config = function()
            require("config.formatter")
        end,
    },

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap").setup()
        end,
    },

    -- GitHub Copilot
    {
        "github/copilot.vim",
        cmd = "Copilot",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
            vim.api.nvim_set_keymap("i", "<C-K>", 'copilot#Next()', { silent = true, expr = true })
            vim.api.nvim_set_keymap("i", "<C-H>", 'copilot#Previous()', { silent = true, expr = true })
        end,
    },
}