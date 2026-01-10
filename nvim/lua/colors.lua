local uv = vim.uv
local w = require("watch")

local types = {
  dark = "dark",
  light = "light",
}

local path = vim.fn.expand("~/.cache") .. "/theme"

---@return boolean
local function validate_path()
  local stat = uv.fs_stat(path)

  -- create theme file if it doesn't exist, default to dark
  if not stat then
    local fd = uv.fs_open(path, "w", 420)
    if not fd then return false end

    uv.fs_write(fd, types.dark, -1)
    uv.fs_close(fd)
  end

  -- warn if it exists but is a directory
  if stat and stat.type == "directory" then
    vim.notify("Warning: " .. path .. " is a directory, not listening to color changes", vim.log.levels.WARN)
    return false
  end

  return true
end

if not validate_path() then return end

local function update_background()
  local fd = uv.fs_open(path, "r", 420)
  if not fd then return end

  local stat = uv.fs_fstat(fd)
  if not stat then return end

  local data = uv.fs_read(fd, stat.size, 0)
  if not data then return end

  uv.fs_close(fd)

  data = data:gsub("\n$", "") -- remove trailing newline

  vim.schedule(function()
    if data == types.dark then
      vim.cmd("set background=dark")
    elseif data == types.light then
      vim.cmd("set background=light")
    end
    vim.cmd("redraw!")
  end)
end

update_background()

w.watch(path, {
  ---@diagnostic disable-next-line: unused-local
  on_event = function(filename, events, unwatch) update_background() end,
})
