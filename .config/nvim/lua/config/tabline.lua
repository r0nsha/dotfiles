_G._myconfig = _G._myconfig or {}

_G._myconfig.tablabel = function(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local tabdir = vim.fn.getcwd(-1, n)
  local has_tabdir = vim.fn.getcwd(-1, -1) ~= tabdir
  if has_tabdir then return ("CWD: %s/"):format(vim.fn.fnamemodify(tabdir, ":t")) end
  local bufname = vim.fn.bufname(buflist[winnr])
  local isdir = bufname:sub(#bufname) == "/"
  local name = vim.fn.fnamemodify(bufname, isdir and ":h:t" or ":t") .. (isdir and "/" or "")
  name = name:len() > 20 and name:sub(1, 20) .. "…" or name
  return name == "" and "No Name" or name
end
_G._myconfig.tabline = function()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local hlgroup = (i == vim.fn.tabpagenr() and "%#TabLineSel#" or "%#TabLine#")
    s = s .. ("%s%%%dT %d: %%{v:lua._myconfig.tablabel(%d)} "):format(hlgroup, i, i, i)
  end
  -- return s .. "%#TabLineFill#%T%=%#TabLine#%999XX"
  return s .. "%#TabLineFill#"
end

vim.opt.tabline = "%!v:lua._myconfig.tabline()"
