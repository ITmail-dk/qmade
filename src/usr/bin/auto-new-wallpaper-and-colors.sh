#!/usr/bin/env bash

wal --cols16 darken -q -i ~/Wallpapers --backend colorz
# Backends: colorz, haishoku, wal, colorthief, fast_colorthief, okthief, schemer2, modern_colorthief

notify-send -u low "Automatically new background and color theme" "Please wait while i find a new background image and some colors to match"

qtile cmd-obj -o cmd -f reload_config
kitty +kitten themes --reload-in=all Current-theme

cp $(cat "$HOME/.cache/wal/wal") /usr/share/wallpapers/login-wallpape.jpg

notify-send -u low "Automatically new background and color theme" "The background image and colors has been updated."
