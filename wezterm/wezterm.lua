local wezterm = require 'wezterm'
local config = {}

-- Tema
config.color_scheme = "nord"

-- Fuente
config.font = wezterm.font_with_fallback({
  "FiraMono Nerd Font",
  "FiraCode Nerd Font",
})
config.font_size = 12.0

-- Apariencia
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 8,
  right = 8,
  top = 4,
  bottom = 4,
}

-- Comportamiento
config.scrollback_lines = 5000
config.enable_scroll_bar = false
config.check_for_updates = false

-- Keybindings
config.keys = {
  {key="t", mods="ALT|SHIFT", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
  {key="w", mods="ALT|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
  {key="d", mods="CTRL|ALT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
  {key="d", mods="SHIFT|ALT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
  {key="LeftArrow", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Left"}},
  {key="RightArrow", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Right"}},
  {key="UpArrow", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Up"}},
  {key="DownArrow", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Down"}},
}

-- Terminal por defecto
config.default_prog = { "pwsh.exe", "-NoLogo" }

return config

