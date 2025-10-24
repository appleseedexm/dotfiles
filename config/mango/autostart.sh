#!/bin/bash

set +e

# obs
# dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1
systemctl --user set-environment XDG_CURRENT_DESKTOP=wlroots; systemctl --user import-environment WAYLAND_DISPLAY; systemctl --user start xdg-desktop-portal-wlr.service


# wallpaper
hyprpaper >/dev/null 2>&1 &

# top bar
waybar >/dev/null 2>&1 &


# xwayland dpi scale
# echo "Xft.dpi: 140" | xrdb -merge #dpi缩放
# xrdb merge ~/.Xresources >/dev/null 2>&1

# ime input
# fcitx5 --replace -d >/dev/null 2>&1 &

# keep clipboard content
# wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &

# clipboard content manager
# wl-paste --type text --watch cliphist store >/dev/null 2>&1 &

# bluetooth 
# blueman-applet >/dev/null 2>&1 &

# network
# nm-applet >/dev/null 2>&1 &

# Permission authentication
/usr/lib/xfce-polkit/xfce-polkit >/dev/null 2>&1 &

# inhibit by audio
# sway-audio-idle-inhibit >/dev/null 2>&1 &

# change light value and volume value by swayosd-client in keybind
# swayosd-server >/dev/null 2>&1 &
#

sh $XDG_CONFIG_HOME/mango/scripts/idle.sh >/dev/null 2>&1 &
sh $XDG_CONFIG_HOME/mango/scripts/lock.sh >/dev/null 2>&1 &
sh $HOME/.scripts/mute.sh -s >/dev/null 2>&1 &

easyeffects --gapplication-service >/dev/null 2>&1 &
proton-pass >/dev/null 2>&1 &
obsidian >/dev/null 2>&1 &

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
