Name = "usb"
NamePretty = "USB Devices"
Icon = "drive-removable-media-symbolic"
Action = "ron-usb-toggle '%VALUE%'"
Cache = false
HideFromProviderlist = false
SearchName = true

function GetEntries()
  local entries = {}

  local devices_handle = io.popen("udiskie-info -a 2>/dev/null")
  if not devices_handle then return entries end

  for device in devices_handle:lines() do
    local label_handle = io.popen(
      string.format(
        "udiskie-info '%s' -o '{device_file} | {drive_label} {ui_id_uuid}' 2>/dev/null",
        device
      )
    )
    local label = label_handle and label_handle:read("*l") or device
    if label_handle then label_handle:close() end

    local mount_handle =
      io.popen(string.format("udiskie-info '%s' -o '{is_mounted}' 2>/dev/null", device))
    local is_mounted = mount_handle and mount_handle:read("*l") or "False"
    if mount_handle then mount_handle:close() end

    local entry = {
      Text = label,
      Value = device,
    }

    if is_mounted == "True" then
      entry.Subtext = "mounted"
      entry.Icon = "media-eject-symbolic"
    else
      entry.Subtext = "unmounted"
      entry.Icon = "drive-removable-media-symbolic"
    end

    table.insert(entries, entry)
  end

  devices_handle:close()

  -- Sort by label text
  table.sort(entries, function(a, b) return a.Text < b.Text end)

  return entries
end
