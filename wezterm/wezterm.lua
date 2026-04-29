-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Font & Appearance ──────────────────────────────────────────────
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16
config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 10,
	right = 10,
	top = 20,
	bottom = 0,
}

-- ── Performance ────────────────────────────────────────────────────
config.enable_kitty_keyboard = true
config.max_fps = 120

-- ── Maximize on startup ────────────────────────────────────────────
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- ── Background wallpaper (optional) ────────────────────────────────
-- Set WEZTERM_WALLPAPER_DIR env variable to a directory of images.
-- If not set or empty, no background wallpaper is applied.
-- Resolve dotfiles dir: this config lives at dotfiles/wezterm/wezterm.lua
local dotfiles_dir = wezterm.config_dir .. "/.."
local wallpaper_dir = os.getenv("WEZTERM_WALLPAPER_DIR")
	or (dotfiles_dir .. "/wallpapers")

local function get_wallpaper(dir)
	local wallpapers = wezterm.glob(dir .. "/*")
	if not wallpapers or #wallpapers == 0 then
		return nil
	end
	local wallpaper = wallpapers[math.random(1, #wallpapers)]
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

-- Only set background if wallpaper directory exists and has files
local bg = get_wallpaper(wallpaper_dir)
if bg then
	config.background = { bg }
end

return config
