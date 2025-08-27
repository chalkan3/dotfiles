local M = {}


local function error_checker(error_message)
  if vim.v.shell_error ~= 0 then
    vim.notify(error_message, vim.log.levels.ERROR)
  end
end

local function ensure_binary_installed(binary_name)
  local exist = vim.fn.executable(binary_name)
  if not exist then
    vim.notify(
      'binary dosent installed['..binary_name..']',
      vim.log.levels.ERROR
    )
  end

  return exist
  
end


local function get_buffer_content()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  return content
  
end

function M.return_buffer_to_target(target)
  if not target and not ensure_binary_installed(target) then return end
  
  local buffer_content = get_buffer_content() 
  
  vim.system(target, buffer_content)
  error_checker("not possible use targer or something happe with" .. target)
end


return M
