local M = {}

local config = {
  target = nil 
}

function M.setup(user_config)
   config = vim.tbl_extend('force', config, user_config or {})
end


function M.get()
  return config
end


return M
