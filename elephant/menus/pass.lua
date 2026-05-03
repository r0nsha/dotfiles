local pass_dir = os.getenv("PASSWORD_STORE_DIR") or os.getenv("HOME") .. "/.password-store"

Name = "pass"
NamePretty = "Pass"
Icon = "dialog-password-symbolic"
Cache = false
FixedOrder = true
HideFromProviderlist = false
SearchName = true

local function shell_quote(value) return "'" .. tostring(value):gsub("'", "'\\''") .. "'" end

local function script_command(action, target, password)
  return table.concat({
    "~/.config/elephant/scripts/pass.fish",
    shell_quote(action),
    shell_quote(target),
    shell_quote(password),
  }, " ")
end

function GetEntries()
  local entries = {}
  local command = "fd --extension gpg . " .. shell_quote(pass_dir) .. " 2>/dev/null | sort"
  local handle = io.popen(command)
  if not handle then return entries end

  for path in handle:lines() do
    local name = path:gsub("^" .. pass_dir:gsub("([^%w])", "%%%1") .. "/", ""):gsub("%.gpg$", "")
    table.insert(entries, {
      Text = name,
      Value = name,
      Icon = "dialog-password-symbolic",
      Actions = {
        pass_open = "ron-launch-pass-entry " .. shell_quote(name),
        pass_autotype = script_command("autotype", "all", name),
        pass_copy = script_command("copy", "pass", name),
      },
    })
  end

  handle:close()
  return entries
end
