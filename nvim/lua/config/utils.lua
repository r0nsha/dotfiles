local M = {}

function M.is_windows()
  return (vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1) and vim.fn.has "wsl" == 0
end

function M.is_macos()
  return vim.fn.has "macunix" == 1
end

function M.is_wsl()
  return vim.fn.has "wsl" == 1
end

function M.get_codelldb_paths()
  local mason_registry = require "mason-registry"
  local extension_path = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb"

  local this_os = vim.loop.os_uname().sysname

  -- The path in windows is different
  if this_os:find "Windows" then
    codelldb_path = extension_path .. "adapter\\codelldb.exe"
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  else
    -- The liblldb extension is .so for linux and .dylib for macOS
    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
  end

  return codelldb_path, liblldb_path
end

M.icons = {
  error = "",
  warning = "",
  info = "",
  hint = "",
  bug = "",
  clock = "",
}

function M.vsplit()
  vim.cmd "vsplit"
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)
end

return M
