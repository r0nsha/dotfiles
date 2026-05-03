local function command_output(command)
  local handle = io.popen(command)
  if not handle then return nil end

  local output = handle:read("*l")
  handle:close()

  if not output or output == "" then return nil end
  return output
end

local pictures_dir = command_output("xdg-user-dir PICTURES 2>/dev/null") or os.getenv("HOME") .. "/pictures"
local wallpaper_dir = pictures_dir .. "/backgrounds"
local thumbnail_dir = os.getenv("HOME") .. "/.cache/walker/backgrounds"

Name = "backgrounds"
NamePretty = "Backgrounds"
Icon = "image-x-generic"
Action = "ron-background-set '%VALUE%'"
Cache = false
RefreshOnChange = { wallpaper_dir }
FixedOrder = true
HideFromProviderlist = false
SearchName = true

local function basename(path) return path:match("([^/]+)$") or path end

local function file_exists(path)
  local file = io.open(path, "r")
  if not file then return false end

  file:close()
  return true
end

local function preview_path(path, filename)
  local thumbnail = string.format("%s/%s.jpg", thumbnail_dir, filename)
  return file_exists(thumbnail) and thumbnail or path
end

function GetEntries()
  local entries = {}

  local handle = io.popen("fd . '" .. wallpaper_dir .. "' 2>/dev/null")
  if not handle then return entries end

  for path in handle:lines() do
    local filename = basename(path)

    local entry = {
      Text = filename,
      Subtext = "wallpaper",
      Value = path,
      Icon = "image-x-generic",
      Preview = preview_path(path, filename),
      PreviewType = "file",
    }

    table.insert(entries, entry)
  end

  handle:close()
  return entries
end
