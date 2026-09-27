local types = { dark = "dark", light = "light" }

local path = vim.fs.normalize("~/.cache") .. "/theme"

---@return boolean
local function validate_path()
  local stat = vim.uv.fs_stat(path)

  -- create theme file if it doesn't exist, default to dark
  if not stat then
    local fd = vim.uv.fs_open(path, "w", 420)
    if not fd then return false end

    vim.uv.fs_write(fd, types.dark, -1)
    vim.uv.fs_close(fd)
  end

  -- warn if it exists but is a directory
  if stat and stat.type == "directory" then
    vim.notify(
      "Warning: " .. path .. " is a directory, not listening to color changes",
      vim.log.levels.WARN
    )
    return false
  end

  return true
end

if not validate_path() then return end

---@async
local function update_background()
  local open_err, fd = vim.async.await(4, vim.uv.fs_open, path, "r", 420)
  if open_err or not fd then return end

  local data
  local stat_err, stat = vim.async.await(2, vim.uv.fs_fstat, fd)
  if not stat_err and stat then
    local read_err, content = vim.async.await(4, vim.uv.fs_read, fd, stat.size, 0)
    if not read_err then data = content end
  end

  vim.async.await(2, vim.uv.fs_close, fd)
  if not data then return end

  vim.async.await(vim.schedule) -- resume on the main loop

  data = data:gsub("\n$", "") -- remove trailing newline
  if (data ~= types.dark and data ~= types.light) or data == vim.o.background then return end
  vim.o.background = data
end

vim.async.run("theme.update_background", update_background)

require("watch").watch(path, { on_event = require("utils").debounce(update_background, 50) })
