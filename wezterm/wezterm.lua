
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 10,
	bottom = 0,
}
config.color_scheme = "Rasi (terminal.sexy)"
config.initial_rows = 300
config.initial_cols = 300
config.enable_kitty_keyboard = true
config.max_fps = 120
-- background

local h = {}

h.get_random_entry = function(tbl)
	local keys = {}
	for key, _ in pairs(tbl) do -- Fix: Use `pairs`, not `ipairs`
		table.insert(keys, key)
	end
	if #keys == 0 then
		return nil -- Fix: Handle case where no wallpapers are found
	end
	local randomKey = keys[math.random(1, #keys)]
	return tbl[randomKey]
end

local M = {}

M.get_wallpaper = function(dir)
	local wallpapers = wezterm.glob(dir .. "/*") -- Fix: Use `list_dir` instead of `glob`
	if not wallpapers then
		wezterm.log_error("No wallpapers found in directory: " .. dir)
		return nil
	end

	local wallpaper = h.get_random_entry(wallpapers)
	if not wallpaper then
		wezterm.log_error("Failed to select a random wallpaper.")
		return nil
	end

	return {
		source = { File = { path = wallpaper } },
		height = "Cover",
		width = "Cover",
		horizontal_align = "Center",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		opacity = 1,
		hsb = {
			brightness = 0.05,
			hue = 1.0,
			saturation = 1.0,
		},
	}
end

-- Fix: Remove unnecessary `/**` from path
local path = "/Users/shivraj/Developer/wallpaper/terminal-wallpaper/"

config.background = { M.get_wallpaper(path) }

-- and finally, return the configuration to wezterm
return config