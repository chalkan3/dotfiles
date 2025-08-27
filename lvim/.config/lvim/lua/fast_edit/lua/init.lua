local config = require('fast_edit.config')
local core = require('fast_edit.core')


local M = {}

function M.setup(user_config)
  config.setup(user_config)
end

function M.handle()
  target = config.get().target
  core.return_buffer_to_target(target)
end


return M
