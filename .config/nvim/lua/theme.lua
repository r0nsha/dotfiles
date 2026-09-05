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
    vim.notify(
      "Warning: " .. path .. " is a directory, not listening to color changes",
      vim.log.levels.WARN
    )
    return false
  end

  return true
end

if not validate_path() then return end

local function update_background()
  uv.fs_open(path, "r", 420, function(_err, fd)
    if not fd then return end

    uv.fs_fstat(fd, function(_err, stat)
      if not stat then
        uv.fs_close(fd)
        return
      end

      uv.fs_read(fd, stat.size, 0, function(_err, data)
        uv.fs_close(fd, function() end)
        if not data then return end

        vim.schedule(function()
          data = data:gsub("\n$", "") -- remove trailing newline
          if (data ~= types.dark and data ~= types.light) or data == vim.o.background then
            return
          end
          vim.o.background = data
        end)
      end)
    end)
  end)
end

update_background()

w.watch(path, {
  on_event = function() update_background() end,
})
