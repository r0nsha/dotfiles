local wezterm = require("wezterm") ---@type Wezterm
local act = wezterm.action

local config = wezterm.config_builder() ---@type Config

config.max_fps = 120

return config
