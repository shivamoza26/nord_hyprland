--autostart

hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon") --wallpaper
	hl.exec_cmd("eww-daemon & waybar") --widget and wayabr
	hl.exec_cmd("hypridle") --lockscreen
	hl.exec_cmd("swayosd-server") --on screen display
	hl.exec_cmd("nm-applet & blueman-applet") --bluetooth & wifi
	hl.exec_cmd("cliphist wipe") --wipe clipboard history
	hl.exec_cmd("wl-paste --type text --watch cliphist store & wl-paste --type image --watch cliphist store") --clipboard
end)
