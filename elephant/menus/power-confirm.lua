local actions = {
  suspend = {
    text = "suspend",
    subtext = "sleep system",
    command = "systemctl suspend",
    icon = "weather-clear-night-symbolic",
  },
  logout = {
    text = "log out",
    subtext = "end current session",
    command = [[sh -c 'if [ -n "${NIRI_SOCKET:-}" ]; then niri msg action quit --skip-confirmation; else loginctl terminate-session "${XDG_SESSION_ID:-}"; fi']],
    icon = "system-log-out-symbolic",
  },
  reboot = {
    text = "reboot",
    subtext = "restart system",
    command = "systemctl reboot",
    icon = "system-reboot-symbolic",
  },
  shutdown = {
    text = "shut down",
    subtext = "power off system",
    command = "systemctl poweroff",
    icon = "system-shutdown-symbolic",
  },
}

Name = "power-confirm"
NamePretty = "Confirm Power Action"
Icon = "system-shutdown-symbolic"
Action = "%VALUE%"
FixedOrder = true
HideFromProviderlist = true
SearchName = false
Parent = "power"

function GetEntries()
  local selected = actions[lastMenuValue("power")]
  if not selected then return {} end

  return {
    {
      Text = "Yes, " .. selected.text,
      Subtext = selected.subtext,
      Value = selected.command,
      Icon = selected.icon,
    },
    {
      Text = "No, cancel",
      Subtext = "keep system running",
      Value = "true",
      Icon = "window-close-symbolic",
    },
  }
end
