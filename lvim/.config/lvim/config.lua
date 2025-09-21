-- config.lua para LunarVim - Configuração Limpa e Profissional

-- [[ Opções Gerais ]]
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.mouse = "a" -- Habilita o mouse em todos os modos

-- [[ Clipboard ]]
-- Garante que a cópia e a colagem funcionem com o clipboard do sistema
vim.opt.clipboard = "unnamedplus"

-- [[ Filetypes ]]
vim.filetype.add({
  extension = {
    sls = "yaml.salt", -- Melhor highlight para arquivos SaltStack
  },
})

-- [[ Servidores LSP ]]
-- Remove servidores que podem causar problemas ou que você não usa.
-- 'yamlls' é bom para YAML, então vamos garantir que ele NÃO seja pulado.
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "yamlls"
end, lvim.lsp.automatic_configuration.skipped_servers)

-- Garante que o Solargraph para Ruby esteja configurado, se necessário.
-- require("lvim.lsp.manager").setup("solargraph", {})

-- [[ Formatadores ]]
-- Configura formatadores via null-ls
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "stylua",
    filetypes = { "lua" },
  },
  {
    command = "rubocop",
    filetypes = { "ruby" },
    args = { "--autocorrect" }
  },
  {
    command = "shfmt",
    filetypes = { "sh" },
  }
}

-- [[ Plugins ]]
lvim.plugins = {
  -- Auto-save é um plugin muito útil para produtividade
  {
    "pocco81/auto-save.nvim",
    config = function ()
      require("auto-save").setup({
        enabled = true,
        execution_message = {
          message = function()
            return "💾 " .. vim.fn.expand("%") .. " salvo"
          end,
          dim = 0.2,
          cleaning_interval = 1250,
        },
        trigger_events = {"InsertLeave", "TextChanged"},
        debounce_delay = 150,
      })
    end,
  },
  -- Tema consistente com o terminal
  {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- Flavours: latte, frappe, macchiato, mocha
      })
    end,
  },
}

-- [[ Tema ]]
-- Define o tema Catppuccin como padrão
lvim.colorscheme = "catppuccin"