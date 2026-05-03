Name = "capture"
NamePretty = "Capture"
Icon = "camera-photo"
Cache = false
HideFromProviderlist = false
SearchName = true
FixedOrder = true

function IsRecording()
  local h = io.popen("pgrep -f '^gpu-screen-recorder' >/dev/null 2>&1; echo $?")
  local r = h:read("*l")
  h:close()
  return r == "0"
end

function GetEntries()
  local entries = {
    {
      Text = "Screenshot",
      Icon = "camera-photo-symbolic",
      Actions = {
        shot_region = "ron-capture-screenshot --region=region",
        shot_screen = "ron-capture-screenshot --region=screen",
      },
    },
  }
  if IsRecording() then
    table.insert(entries, {
      Text = "Stop recording",
      Icon = "media-playback-stop",
      Actions = { stop = "ron-capture-screenrecord --region=screen" },
    })
  else
    table.insert(entries, {
      Text = "Screenrecord",
      Icon = "media-record",
      SubMenu = "capture-screenrecord",
    })
  end
  return entries
end
