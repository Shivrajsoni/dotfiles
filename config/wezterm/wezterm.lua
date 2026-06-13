local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── GitHub Dark color scheme ────────────────────────────────────────
config.colors = {
	foreground = "#e6edf3",
	background = "#0d1117",
	cursor_bg = "#58a6ff",
	cursor_fg = "#0d1117",
	cursor_border = "#58a6ff",
	selection_fg = "#e6edf3",
	selection_bg = "#264f78",
	scrollbar_thumb = "#30363d",
	split = "#30363d",
	ansi = {
		"#484f58", -- black
		"#ff7b72", -- red
		"#3fb950", -- green
		"#d29922", -- yellow
		"#58a6ff", -- blue
		"#bc8cff", -- magenta
		"#39c5cf", -- cyan
		"#b1bac4", -- white
	},
	brights = {
		"#6e7681", -- bright black
		"#ffa198", -- bright red
		"#56d364", -- bright green
		"#e3b341", -- bright yellow
		"#79c0ff", -- bright blue
		"#d2a8ff", -- bright magenta
		"#56d4dd", -- bright cyan
		"#f0f6fc", -- bright white
	},
	tab_bar = {
		background = "#010409",
		active_tab = { bg_color = "#0d1117", fg_color = "#e6edf3" },
		inactive_tab = { bg_color = "#010409", fg_color = "#8b949e" },
		inactive_tab_hover = { bg_color = "#161b22", fg_color = "#e6edf3" },
		new_tab = { bg_color = "#010409", fg_color = "#8b949e" },
		new_tab_hover = { bg_color = "#161b22", fg_color = "#e6edf3" },
	},
}

-- ── Font & Appearance ───────────────────────────────────────────────
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = { left = 10, right = 10, top = 20, bottom = 0 }

-- ── Performance ─────────────────────────────────────────────────────
config.enable_kitty_keyboard = true
config.max_fps = 120

-- ── Maximize on startup ─────────────────────────────────────────────
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
