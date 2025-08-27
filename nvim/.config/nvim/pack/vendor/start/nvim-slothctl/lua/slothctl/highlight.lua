-- /lua/slothctl/highlight.lua
-- Gerencia o destaque de sintaxe para o filetype "sloth".

local M = {}

-- Função que aplica as regras de sintaxe
local function apply_syntax()
  if vim.b.current_syntax == "sloth" then return end

  -- Palavras-chave e tipos
  vim.cmd([[syntax keyword slothKeyword platform workloads loop as do outputs depends_on]])
  vim.cmd([[syntax keyword slothBuiltin resource incus container image build values company salt provision service shell command action]])
  vim.cmd([[syntax keyword slothConstant true false]])
  vim.cmd([[syntax match slothNumber "\v\d+GB?"]])
  vim.cmd([[syntax match slothNumber "\d\+"]])
  vim.cmd([[syntax region slothString start=/[="]\s*"/ end=/"/ keepend]])
  vim.cmd([[syntax match slothComment /--.*$/]])

  -- Links para os grupos de destaque padrão
  vim.api.nvim_set_hl(0, "slothKeyword", { link = "Keyword" })
  vim.api.nvim_set_hl(0, "slothBuiltin", { link = "Type" })
  vim.api.nvim_set_hl(0, "slothConstant", { link = "Constant" })
  vim.api.nvim_set_hl(0, "slothNumber", { link = "Number" })
  vim.api.nvim_set_hl(0, "slothString", { link = "String" })
  vim.api.nvim_set_hl(0, "slothComment", { link = "Comment" })

  vim.b.current_syntax = "sloth"
end

function M.setup()
  -- Roda a função apply_syntax sempre que um buffer com filetype 'sloth' for aberto
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "sloth",
    callback = apply_syntax,
    group = vim.api.nvim_create_augroup("SlothctlHighlight", { clear = true }),
  })
end

return M
