local commands = {
  lockscreen = [[loginctl lock-session "${XDG_SESSION_ID:-}"]],
  suspend = "systemctl suspend",
  -- hibernate = "systemctl hibernate",
}

Name = "power"
NamePretty = "Power"
Icon = "system-shutdown-symbolic"
Action = "%VALUE%"
FixedOrder = true
HideFromProviderlist = false
SearchName = true

function GetEntries()
  return {
    {
      Text = "Lock screen",
      Value = commands.lockscreen,
      Icon = "system-lock-screen-symbolic",
      Keywords = { "lock", "lockscreen" },
    },
    {
      Text = "Suspend",
      Value = "suspend",
      SubMenu = "power-confirm",
      Icon = "weather-clear-night-symbolic",
      Keywords = { "sleep" },
    },
    -- {
    --   Text = "Hibernate",
    --   Value = commands.hibernate,
    --   Icon = "drive-harddisk-symbolic",
    --   Keywords = { "sleep" },
    -- },
    {
      Text = "Log out",
      Value = "logout",
      SubMenu = "power-confirm",
      Icon = "system-log-out-symbolic",
      Keywords = { "logout", "signout" },
    },
    {
      Text = "Reboot",
      Value = "reboot",
      SubMenu = "power-confirm",
      Icon = "system-reboot-symbolic",
      Keywords = { "restart" },
    },
    {
      Text = "Shut down",
      Value = "shutdown",
      SubMenu = "power-confirm",
      Icon = "system-shutdown-symbolic",
      Keywords = { "shutdown", "poweroff" },
    },
  }
end
