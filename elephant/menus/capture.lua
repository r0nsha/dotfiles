Name = "capture"
NamePretty = "Capture"
Icon = "camera-photo-symbolic"
Cache = false
HideFromProviderlist = false
SearchName = true
FixedOrder = true

local state_file = os.getenv("HOME") .. "/.cache/elephant/capture-screenrecord.state"

local function read_state()
  local s = { desktop_audio = false, mic_audio = false, webcam = false }
  local f = io.open(state_file, "r")
  if f then
    for line in f:lines() do
      local k, v = line:match("^(%S+)%s+(%S+)$")
      if k then s[k] = (v == "true") end
    end
    f:close()
  end
  return s
end

local function write_state(s)
  os.execute("mkdir -p " .. os.getenv("HOME") .. "/.cache/elephant")
  local f = io.open(state_file, "w")
  if f then
    for k, v in pairs(s) do
      f:write(k .. " " .. tostring(v) .. "\n")
    end
    f:close()
  end
end

local function flags_label(s)
  local parts = {}
  if s.desktop_audio then table.insert(parts, "desktop audio") end
  if s.mic_audio then table.insert(parts, "mic") end
  if s.webcam then table.insert(parts, "webcam") end
  if #parts == 0 then return "" end
  return table.concat(parts, ", ")
end

local function record_args(s, region)
  local args = { "--region=" .. region }
  if s.desktop_audio then table.insert(args, "--desktop-audio") end
  if s.mic_audio then table.insert(args, "--mic-audio") end
  if s.webcam then table.insert(args, "--webcam") end
  return "ron-capture-screenrecord " .. table.concat(args, " ")
end

function IsRecording()
  local h = io.popen("pgrep -f '^gpu-screen-recorder' >/dev/null 2>&1; echo $?")
  if not h then return false end
  local r = h:read("*l")
  h:close()
  return r == "0"
end

function GetEntries()
  local s = read_state()
  local flags = flags_label(s)
  local entries = {
    {
      Text = "Take Screenshot",
      Icon = "camera-photo-symbolic",
      Value = "screenshot",
      Actions = {
        region = "ron-capture-screenshot --region=region",
        screen = "ron-capture-screenshot --region=screen",
        toggle_desktop_audio = "lua:ToggleDesktopAudio",
        toggle_mic_audio = "lua:ToggleMicAudio",
        toggle_webcam = "lua:ToggleWebcam",
      },
    },
  }

  if IsRecording() then
    table.insert(entries, {
      Text = "Stop recording",
      Icon = "media-playback-stop",
      Value = "stop",
      Actions = {
        stop = "ron-capture-screenrecord --region=screen",
        toggle_desktop_audio = "lua:ToggleDesktopAudio",
        toggle_mic_audio = "lua:ToggleMicAudio",
        toggle_webcam = "lua:ToggleWebcam",
      },
    })
  else
    local subtext = flags
    table.insert(entries, {
      Text = "Record Screen",
      Icon = "media-record",
      Value = "screenrecord",
      Subtext = subtext,
      Actions = {
        region = record_args(s, "region"),
        screen = record_args(s, "screen"),
        toggle_desktop_audio = "lua:ToggleDesktopAudio",
        toggle_mic_audio = "lua:ToggleMicAudio",
        toggle_webcam = "lua:ToggleWebcam",
      },
    })
  end

  return entries
end

function ToggleDesktopAudio()
  local s = read_state()
  s.desktop_audio = not s.desktop_audio
  write_state(s)
end

function ToggleMicAudio()
  local s = read_state()
  s.mic_audio = not s.mic_audio
  write_state(s)
end

function ToggleWebcam()
  local s = read_state()
  s.webcam = not s.webcam
  write_state(s)
end
