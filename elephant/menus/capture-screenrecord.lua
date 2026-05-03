Name = "capture-screenrecord"
NamePretty = "Screenrecord"
Icon = "media-record"
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
			if k then
				s[k] = (v == "true")
			end
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

function GetEntries()
	local s = read_state()
	local toggles = {
		{ key = "desktop_audio", label = "Desktop audio" },
		{ key = "mic_audio", label = "Mic audio" },
		{ key = "webcam", label = "Webcam" },
	}
	local entries = {}
	for _, t in ipairs(toggles) do
		local icon = s[t.key] and "checkbox-checked-symbolic" or "checkbox-symbolic"
		table.insert(entries, {
			Text = t.label,
			Icon = icon,
			Value = t.key,
			Actions = {
				toggle = "lua:ToggleFlag",
				record_region = "lua:RecordRegion",
				record_screen = "lua:RecordScreen",
			},
		})
	end
	return entries
end

function ToggleFlag(value)
	local s = read_state()
	s[value] = not s[value]
	write_state(s)
end

function Record(target)
	local s = read_state()
	local args = { "--region=" .. target }
	if s.desktop_audio then
		table.insert(args, "--desktop-audio")
	end
	if s.mic_audio then
		table.insert(args, "--mic-audio")
	end
	if s.webcam then
		table.insert(args, "--webcam")
	end
	os.execute("ron-capture-screenrecord " .. table.concat(args, " ") .. " &")
end

function RecordRegion()
	Record("region")
end

function RecordScreen()
	Record("screen")
end