--apps

local app_menu = "~/.config/rofi/launcher/launcher.sh"
local settings_menu = "~/.config/rofi/settings/settings.sh"
local wallpaper_menu = "~/.config/rofi/Wallpaper/wallpaper.sh"
local boot_menu = "~/.config/rofi/powermenu/powermenu.sh"
local clipboard = "~/.config/rofi/clipboard/clipboard.sh"
local projects_menu = "~/.config/rofi/projects/projects.sh"

local terminal = "kitty"
local fileManager = "thunar"
local browser = "zen-browser"
local code_editor = "nvim"
local music = "spotify"
local notes = "obsidian"
local chat = "elecwhat"
local office = "onlyoffice-desktopeditors"
local acer_sense = "DAMX"

---- KEYBINDINGS

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- --- Core apps ---
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd(terminal .. " -e " .. code_editor))
hl.bind(mainMod .. " + XF86AudioPlay", hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(chat))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(office))
hl.bind("XF86Presentation", hl.dsp.exec_cmd(acer_sense))
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd(terminal .. " -e btop"))

-- --- Rofi menus---
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(app_menu))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd(wallpaper_menu))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(boot_menu))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(settings_menu))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(projects_menu))

-- --- Window management ---
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo()) -- dwindle pseudotile
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("togglesplit")) -- dwindle split toggle

-- --- Focus movement ---
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- --- Workspace switching ---
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- --- Special workspace (scratchpad) ---
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- --- Scroll through workspaces ---
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- --- Move / resize windows with mouse ---
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- Volume Controls ---
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { repeating = true })
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && swayosd-client --input-volume mute-toggle")
)

-- --- Brightness Controls ---
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"))

-- --- Media Controls ---
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- --- CapsLock Indicator ---
hl.bind("Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"))

-- Screenshot
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.local/bin/scripts/screenshot.sh region"))
hl.bind("PRINT", hl.dsp.exec_cmd("~/.local/bin/scripts/screenshot.sh fullscreen"))

-- hyprlock
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"), { locked = true })
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("hyprlock"), { locked = true })
