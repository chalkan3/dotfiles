-- /plugin/slothctl.lua
-- Ponto de entrada que o Neovim carrega.

-- Obtém o caminho base do plugin uma vez
local plugin_base_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source, ":h")

-- Adia a modificação do package.path para garantir que ocorra após o carregamento do LVim
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("SlothctlPathSetup", { clear = true }),
  callback = function()
    package.path = package.path .. ";" .. plugin_base_path .. "/lua/?.lua;" .. plugin_base_path .. "/lua/?/init.lua"
    print("DEBUG: Slothctl package.path updated to: " .. package.path)
    -- Agora que o package.path está correto, podemos chamar o setup principal
    require("slothctl").setup()
  end,
})
