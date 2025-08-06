#!/usr/bin/env bash
# Picom - https://manpages.debian.org/stable/picom/picom.1.en.html
pgrep -x picom >/dev/null || picom --backend xrender --vsync --no-fading-openclose --no-fading-destroyed-argb &
# Picom use... --backend glx or xrender, --vsync --no-vsync --no-fading-openclose --no-fading-destroyed-argb etc.

#exec /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 & # Graphical authentication agent

autorandr --change &&

  # This here if statement sets your background image, with feh...
  # and is also used for the auto-generation of the background image and colors.
  if [ -f ~/.fehbg ]; then
    . ~/.fehbg
  else
    auto-new-wallpaper-and-colors
    #feh --bg-scale $(find ~/Wallpapers -type f | shuf -n 1)
  fi

wpctl set-volume @DEFAULT_AUDIO_SINK@ 20% &
dunst &
numlockx on &
mpd &

if [ -f ~/.Xresources ]; then
  xrdb ~/.Xresources &
fi

# Turn off the Screen after X time in seconds
# Time: standby, suspend, off
xset dpms 2700 2700 2700

#keynav &
#kdeconnectd &

# Remove .first-login file --------------------------------------------------------------
if [ -f ~/.first-login ]; then
  rm ~/.first-login
fi
