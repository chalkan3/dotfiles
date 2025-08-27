-- /lua/slothctl/formatter.lua
-- Integração do formatador slothctl com conform.nvim.

local M = {}

-- Helper para encontrar a raiz do projeto (onde slothctl executável e stacks.lua estão)
local function find_project_root()
  local current_dir = vim.fn.getcwd()
  local path_parts = vim.split(current_dir, '[/\\]') -- Divide por / ou \

  -- Percorre a árvore de diretórios para cima
  for i = #path_parts, 1, -1 do
    local test_path = table.concat(path_parts, '/', 1, i)
    if test_path == '' then test_path = '/' end -- Lida com o caso do diretório raiz

    -- Verifica por um arquivo marcador (ex: stacks.lua)
    if vim.fn.filereadable(test_path .. '/stacks.lua') == 1 then
      return test_path
    end
  end
  return nil -- Não encontrado
end

function M.setup()
  -- Verifica se conform.nvim está disponível
  if not pcall(require, "conform") then
    vim.notify("conform.nvim não encontrado. Por favor, instale-o para usar a formatação slothctl.", vim.log.levels.WARN)
    return
  end

  local project_root = find_project_root()
  if not project_root then
    vim.notify("Não foi possível encontrar a raiz do projeto slothctl (stacks.lua não encontrado). A formatação pode não funcionar.", vim.log.levels.WARN)
  end

  -- Define o formatador 'slothctl' para conform.nvim
  require("conform").setup({
    formatters_by_ft = {
      sloth = { "slothctl" }, -- Usa o formatador 'slothctl' para o filetype 'sloth'
    },
    formatters = {
      slothctl = {
        -- O comando a ser executado. Assumimos que 'slothctl' está no PATH ou relativo à raiz do projeto
        command = function(bufnr) 
          if project_root then
            -- Se a raiz do projeto for encontrada, tenta usar ./slothctl
            local slothctl_path = project_root .. '/slothctl'
            if vim.fn.executable(slothctl_path) == 1 then
              return slothctl_path
            end
          end
          -- Retorna para 'slothctl' global se não for encontrado na raiz do projeto ou se nenhuma raiz for encontrada
          return "slothctl"
        end,
        -- Argumentos a serem passados para o comando.
        -- conform.nvim passa o conteúdo via stdin por padrão e lê do stdout.
        args = { "format", "-" }, -- Assumindo que 'slothctl format -' lê do stdin
      },
    },
  })

  vim.notify("Formatador slothctl registrado com conform.nvim. Lembre-se de configurar conform.nvim no seu init.lua!", vim.log.levels.INFO)
end

return M
