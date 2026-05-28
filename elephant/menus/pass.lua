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

local function entries_from_cmd(cmd)
  local entries = {}
  local handle = io.popen(cmd .. " 2>/dev/null")
  if not handle then return entries end
  for line in handle:lines() do
    if line ~= "" then
      table.insert(entries, {
        Text = line,
        Value = line,
        Icon = "dialog-password-symbolic",
        Actions = {
          pass_open = "ron-launch-pass-entry " .. shell_quote(line),
          pass_autotype = script_command("autotype", "all", line),
          pass_copy = script_command("copy", "pass", line),
        },
      })
    end
  end
  handle:close()
  return entries
end

function GetEntries()
  local handle = io.popen("command -v gopass 2>/dev/null")
  if handle then
    handle:close()
    return entries_from_cmd("gopass ls --flat")
  end

  local entries = {}
  local command = "fd --extension gpg . " .. shell_quote(pass_dir) .. " 2>/dev/null | sort"
  local handle = io.popen(command)
  if not handle then return entries end

  local esc_dir = pass_dir:gsub("([^%w])", "%%%1")
  for path in handle:lines() do
    local name = path:gsub("^" .. esc_dir .. "/", ""):gsub("%.gpg$", "")
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
