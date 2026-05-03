Name = "unified"
NamePretty = "Tools"
Icon = "utilities-terminal-symbolic"
Action = "%VALUE%"
FixedOrder = true
HideFromProviderlist = false
SearchName = true

function GetEntries()
  return {
    {
      Text = "Capture",
      Icon = "camera-photo-symbolic",
      SubMenu = "capture",
      Keywords = { "capture", "screen", "shot", "record" },
    },
    {
      Text = "Calculator",
      Value = "ron-launch-walker -m calc",
      Icon = "accessories-calculator-symbolic",
      Keywords = { "calc", "math", "arithmetic" },
    },
    {
      Text = "Color Picker",
      Value = "hyprpicker --autocopy --format=hex --lowercase-hex",
      Icon = "color-select-symbolic",
      Keywords = { "color", "picker", "hex", "rgb" },
    },
    {
      Text = "Passwords",
      SubMenu = "pass",
      Icon = "dialog-password-symbolic",
      Keywords = { "password", "pass", "secret", "key" },
    },
    {
      Text = "Backgrounds",
      SubMenu = "backgrounds",
      Icon = "preferences-desktop-wallpaper-symbolic",
      Keywords = { "background", "wallpaper", "image", "picture" },
    },
    {
      Text = "Bluetooth",
      Value = "ron-launch-walker -m bluetooth",
      Icon = "bluetooth-symbolic",
      Keywords = { "bluetooth", "wireless", "connection" },
    },
    {
      Text = "Wifi",
      Value = "iwmenu -l custom --launcher-command 'walker -d -p Wifi --width 200 --height 300'",
      Icon = "network-wireless-symbolic",
      Keywords = { "wifi", "network", "internet", "connection" },
    },
    {
      Text = "USB",
      SubMenu = "usb",
      Icon = "drive-harddisk-usb-symbolic",
      Keywords = { "usb", "drive", "storage", "device" },
    },
    {
      Text = "Audio",
      Value = "ron-launch-walker -m wireplumber -p Audio",
      Icon = "audio-volume-high-symbolic",
      Keywords = { "audio", "sound", "volume", "settings" },
    },
    {
      Text = "Power",
      SubMenu = "power",
      Icon = "system-shutdown-symbolic",
      Keywords = { "power", "shutdown", "reboot", "suspend" },
    },
  }
end

