-- /lua/slothctl/autocmds.lua
-- Gerencia os autocomandos do plugin.

local M = {}

function M.setup()
  -- Cria um grupo de autocomandos para ser fácil de limpar/gerenciar
  local sloth_augroup = vim.api.nvim_create_augroup("SlothctlGroup", { clear = true })

  -- Associa a extensão .sloth ao filetype 'sloth'
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = sloth_augroup,
    pattern = "*.sloth",
    callback = function()
      vim.bo.filetype = "sloth"
    end,
  })
end

return M
