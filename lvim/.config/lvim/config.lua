vim.opt.mouse = ""
vim.opt.clipboard = ""

vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = "xclip -selection clipboard",
    ["*"] = "xclip -selection clipboard",
  },
  paste = {
    ["+"] = "xclip -selection clipboard -o",
    ["*"] = "xclip -selection clipboard -o",
  },
  cache_enabled = 0,
}

-- Mapeia 'y' para copiar para o clipboard do sistema
vim.api.nvim_set_keymap('n', 'y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'y', '"+y', { noremap = true, silent = true })
vim.filetype.add({
  extension = {
    sls = "yaml",
  },
})

vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "solargraph" })


require("lvim.lsp.manager").setup("solargraph", {})

lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "yamlls"
end, lvim.lsp.automatic_configuration.skipped_servers)


lvim.lsp.installer.setup.ensure_installed = {}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "rubocop",
    filetypes = { "ruby" },
  },
}


lvim.plugins = {
  {
    "pocco81/auto-save.nvim",
    config = function ()
      require("auto-save").setup()
    end,
  },
  {
    dir = '~/.config/nvim/pack/vendor/start/nvim-slothctl',
    lazy = false,
  }
}

require('fast_edit').setup({ target = vim.g.output_target })
