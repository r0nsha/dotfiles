_G._myconfig = _G._myconfig or {}

---@param n integer
_G._myconfig.tablabel = function(n)
  local tabpage = vim.api.nvim_list_tabpages()[n]
  if not tabpage then return "No Name" end

  local tabdir = vim.fn.getcwd(-1, n)
  local has_tabdir = vim.fn.getcwd(-1, -1) ~= tabdir
  if has_tabdir then return ("CWD: %s/"):format(vim.fs.basename(tabdir)) end
  local win = vim.api.nvim_tabpage_get_win(tabpage)
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
  local isdir = bufname:sub(#bufname) == "/"
  local name = vim.fs.basename(isdir and vim.fs.dirname(bufname) or bufname)
    .. (isdir and "/" or "")
  name = name:len() > 20 and name:sub(1, 20) .. "…" or name
  return name == "" and "No Name" or name
end
_G._myconfig.tabline = function()
  local s = ""
  local curtab = vim.api.nvim_tabpage_get_number(0)
  for i = 1, #vim.api.nvim_list_tabpages() do
    local hlgroup = (i == curtab and "%#TabLineSel#" or "%#TabLine#")
    s = s .. ("%s%%%dT %d: %%{v:lua._myconfig.tablabel(%d)} "):format(hlgroup, i, i, i)
  end
  -- return s .. "%#TabLineFill#%T%=%#TabLine#%999XX"
  return s .. "%#TabLineFill#"
end

vim.opt.tabline = "%!v:lua._myconfig.tabline()"
