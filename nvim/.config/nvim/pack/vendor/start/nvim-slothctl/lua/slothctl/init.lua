-- /lua/slothctl/init.lua
-- Módulo principal do plugin (versão minimalista para depuração).

local M = {}

function M.setup()
  print("slothctl: Initializing plugin setup (minimal)...")
  local ok, autocmds_module = pcall(require, "slothctl.autocmds")
  if ok then
    print("slothctl: autocmds module loaded successfully.")
    local setup_ok, setup_err = pcall(autocmds_module.setup)
    if setup_ok then
      print("slothctl: autocmds.setup() called successfully.")
    else
      print("slothctl: Error calling autocmds.setup():" .. tostring(setup_err))
    end
  else
    print("slothctl: Error requiring autocmds module:" .. tostring(autocmds_module))
  end
  print("slothctl: Plugin setup finished (minimal).")
end

return M
