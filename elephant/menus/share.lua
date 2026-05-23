Name = "share"
NamePretty = "Share"
Icon = "send-to-symbolic"
Action = "%VALUE%"
Cache = false
HideFromProviderlist = false
SearchName = true
FixedOrder = true

function GetEntries()
  return {
    {
      Text = "Files",
      Icon = "text-x-generic-symbolic",
      Keywords = { "file", "folder", "directory", "send" },
      Actions = {
        fuzzy = "xdg-terminal-exec --app-id=ron.terminal.floating ron-share files",
        explorer = "xdg-terminal-exec --app-id=ron.terminal.floating ron-share --picker explorer files",
      },
    },
    {
      Text = "Clipboard",
      Value = "ron-share clipboard",
      Icon = "edit-paste-symbolic",
      Keywords = { "clipboard", "paste", "text" },
    },
  }
end
