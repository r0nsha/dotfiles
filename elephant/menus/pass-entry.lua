Name = "pass-entry"
NamePretty = "Pass Entry"
Icon = "dialog-password-symbolic"
Action = "%VALUE%"
Cache = false
FixedOrder = true
HideFromProviderlist = true
SearchName = false
Parent = "pass"

local open_entry_path = os.getenv("HOME") .. "/.cache/rofi-pass/open_entry"

local function shell_quote(value) return "'" .. tostring(value):gsub("'", "'\\''") .. "'" end

local function script_command(action, target, password)
  return table.concat({
    "~/.config/elephant/scripts/pass.fish",
    shell_quote(action),
    shell_quote(target),
    shell_quote(password),
  }, " ")
end

local function selected_password()
  local file = io.open(open_entry_path, "r")
  if file then
    local password = file:read("*l")
    file:close()
    os.remove(open_entry_path)
    if password and password ~= "" then return password end
  end

  return lastMenuValue("pass")
end

local function add_field_entries(entries, password, field, label, hidden)
  table.insert(entries, {
    Text = label,
    Value = script_command("type", field, password),
    Icon = hidden and "dialog-password-symbolic" or "insert-text-symbolic",
    Keywords = { field, "type", "copy" },
    Actions = {
      pass_copy = script_command("copy", field, password),
    },
  })
end

function GetEntries()
  local password = selected_password()
  if not password or password == "" then return {} end

  local entries = {
    {
      Text = "Autotype",
      Subtext = "type user/email, tab, password",
      Value = script_command("autotype", "all", password),
      Icon = "input-keyboard-symbolic",
      Keywords = { "login", "type" },
    },
  }

  add_field_entries(entries, password, "pass", "password", true)

  local handle = io.popen("pass show " .. shell_quote(password) .. " 2>/dev/null")
  if not handle then return entries end

  local first = true
  local seen = { pass = true }

  for line in handle:lines() do
    if first then
      first = false
    else
      local field = line:match("^([^:]+):%s*.+$")
      if field and not seen[field] then
        seen[field] = true
        add_field_entries(entries, password, field, field, false)
      end
    end
  end

  handle:close()
  return entries
end
