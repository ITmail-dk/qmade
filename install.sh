#!/bin/bash

# Qtile Martin Andersen Desktop Environment, Qmade for short.! install - ITmail.dk

# bash -c "$(wget -O- https://raw.githubusercontent.com/ITmail-dk/qmade/main/install.sh)"
# sudo apt install -y git && git clone https://github.com/ITmail-dk/qmade && cd qmade && . install.sh

# Resource links to source
# https://qtile.org

# Rofi - Run menu
# https://github.com/ericmurphyxyz/rofi-wifi-menu

# autorandr 
# Autorandr “fingerprints” displays connected to the system and associate them 
# with their current X11 server settings in “profiles” which are automatically applied each time a fingerprint is matched.
# Use "arandr" to set the Screens as you want them and then save them to a profile with "autorandr --save PROFILENAME"

# autorandr --save PROFILENAME
# autorandr --remove PROFILENAME
# autorandr --default PROFILENAME

# fwupd "Firmware update daemon" - https://github.com/fwupd/fwupd
# fwupdmgr get-devices && fwupdmgr refresh
# fwupdmgr get-updates && fwupdmgr update

# fzf "general-purpose command-line fuzzy finder"
# https://github.com/junegunn/fzf
# nano $(fzf --preview='cat {}')

# nsxiv "Neo (or New or Not) Simple (or Small or Suckless) X Image Viewer" - https://github.com/nsxiv/nsxiv

# Neovim (nvim) - https://neovim.io/ - https://neovim.io/doc/user/vimindex.html
# Vim commands you NEED TO KNOW https://www.youtube.com/watch?v=RSlrxE21l_k

# LazyVim - Can be used after Neovim >= 0.9.0 - https://github.com/LazyVim/LazyVim
# https://github.com/folke/lazy.nvim



# Start the install *_:*:_*:*:_*_*:*:_*::*_*::*_*:_*::*_*:*:_:*:*_*:*:_*:*_:*:#

# Whiptail colors
export NEWT_COLORS='
root=white,gray
window=white,lightgray
border=black,lightgray
shadow=white,black
button=white,blue
actbutton=black,red
compactbutton=black,
title=black,
roottext=black,magenta
textbox=black,lightgray
acttextbox=gray,white
entry=lightgray,gray
disentry=gray,lightgray
checkbox=black,lightgray
actcheckbox=white,blue
emptyscale=,black
fullscale=,red
listbox=black,lightgray
actlistbox=lightgray,gray
actsellistbox=white,blue'

# Set Echo colors
# for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done
NC="\033[0m"
RED="\033[0;31m"
RED2="\033[38;5;196m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;94m"

clear

# Check User Sudo Access
#check_sudo_access() {
#    if sudo -n true 2>/dev/null; then
#        return 0
#    else
#        return 1
#    fi
#}

#if check_sudo_access; then
#    echo "User has SUDO Access, installation continues..."
#else
#    echo -e "${RED} ${NC}"
#    echo -e "${RED}-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'- ${NC}"
#    echo -e "${RED} ${NC}"
#    echo -e "${RED}       ERROR: This installation must be run by a normal user with SUDO Access. ${NC}"
#    echo -e "${RED} ${NC}"
#    echo -e "${RED}       So Add your user to sudo with this Command,from a user who has sudo access ${NC}"
#    echo -e "${RED}       sudo usermod -aG sudo USERNAME ${NC}"
#    echo -e "${RED} ${NC}"
#    echo -e "${RED}-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'- ${NC}"
#    echo -e "${RED} ${NC}"
#    exit 1
#fi
# Check User Sudo Access Done
clear

if ! dpkg -s whiptail >/dev/null 2>&1; then
    echo -e "${RED} "
    echo -e "${RED}-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-"
    echo -e "${RED} "
    echo -e "${RED}      Preparation before starting the installation..."
    echo -e "${RED}      Enter your user password, to continue if necessary"
    echo -e "${RED} "
    echo -e "${RED}-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-"
    echo -e "${RED} ${NC}"
    sudo apt update
    sudo apt install -y whiptail
else
    echo -e "${YELLOW} Preparation before starting the installation... done ;-) ${NC}"
fi

clear


# Installation start screen
FULLUSERNAME=$(awk -v user="$USER" -F":" 'user==$1{print $5}' /etc/passwd | rev | cut -c 4- | rev)

if (whiptail --title "Installation of the Martin Qtile Desktop" --yesno "Hi $FULLUSERNAME do you want to start \nthe installation of Qtile Martin Andersen Desktop Environment, Qmade for short.! \n \nRemember you user must have sudo \naccess to run the installation." 13 50); then
    echo -e "${GREEN} Okay, let's start the installation"
else
    exit 1
fi


echo -e "${YELLOW} Install selection choose what to install Start ${NC}"

PROGRAMS=$(whiptail --title "The Install selection" --checklist --separate-output \
"Choose what to install:" 20 78 15 \
"1" "Do you want to install Libre Office" OFF \
"2" "Is this a laptop we are installing on!" OFF \
"3" "Install XRDP Server" OFF \
"4" "Install XfreeRDP Client" OFF \
"5" "Install Google Chrome Webbrowser" ON \
"6" "Install Firefox Webbrowser" OFF \
"7" "Install Neovim Text Editor" ON \
"8" "Install VS Code Editor" OFF \
"9" "Install SMB/CIFS Storage Client" ON \
"10" "Install NFS Storage Client" OFF \
"11" "Install Ceph Storage Client" OFF 3>&1 1>&2 2>&3)

# See the actual installation below - Install selection choose what to install End


clear
echo -e "${RED} "
echo -e "${RED}-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-"
echo -e "${RED} "
echo -e "${RED}      Preparation before starting the installation..."
echo -e "${RED}      Enter your user password, to continue if necessary"
echo -e "${RED} "
echo -e "${RED}-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-"
echo -e "${RED} ${NC}"

if ! dpkg -s apt-transport-https >/dev/null 2>&1; then
    sudo apt -y install apt-transport-https
    sudo sed -i 's+http:+https:+g' /etc/apt/sources.list
else
    echo "apt-transport-https is already installed."
fi

# APT Add "contrib non-free" to the sources list
if [ -f /etc/apt/sources.list.d/debian.sources ]; then
    sudo sed -i 's/^Components:* main/& contrib non-free non-free-firmware/g' /etc/apt/sources.list.d/debian.sources
else 
	sudo sed -i 's/^deb.* main/& contrib non-free/g' /etc/apt/sources.list
fi

clear
sudo apt update

# -------------------------------------------------------------------------------------------------
clear
echo -e "${YELLOW} Core System APT install ${NC}"
sudo apt -y install xserver-xorg x11-utils xinit arandr autorandr picom fwupd mesa-utils htop wget curl git tmux numlockx kitty cups xsensors xbacklight brightnessctl unzip network-manager dunst libnotify-bin notify-osd xautolock xsecurelock pm-utils rofi imagemagick nitrogen nsxiv mpv flameshot speedcrunch mc thunar gvfs-backends parted gparted mpd mpc ncmpcpp fzf ccrypt xarchiver notepadqq fontconfig fontconfig-config fonts-liberation fonts-dejavu-core fonts-freefont-ttf fonts-noto-core libfontconfig1 fonts-arkpandora pipewire pipewire-pulse wireplumber pipewire-alsa libspa-0.2-bluetooth pavucontrol alsa-utils --ignore-missing
sudo apt -y install linux-headers-$(uname -r)
sudo apt -y install sddm --no-install-recommends

clear
# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Audio Start - https://alsa.opensrc.org - https://wiki.debian.org/ALSA ${NC}"
# See hardware run: "pacmd list-sinks" or "lspci | grep -i audio" or... sudo dmesg  | grep 'snd\|firmware\|audio'
# Run.: "pw-cli info" provides detailed information about the PipeWire nodes and devices, including ALSA devices.
# Test file run: "aplay /usr/share/sounds/alsa/Front_Center.wav"
# sudo adduser $USER audio


# PipeWire Sound Server "Audio" - https://pipewire.org/
systemctl enable --user --now pipewire.socket pipewire-pulse.socket wireplumber.service

# More Audio tools
# sudo apt install -y alsa-tools

# PulseAudio
# sudo apt install -y pulseaudio
# systemctl --user enable pulseaudio

# sudo alsactl init

echo -e "${YELLOW} Audio End ${NC}"
# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} CPU Microcode install ${NC}"
export LC_ALL=C # All subsequent command output will be in English
CPUVENDOR=$(lscpu | grep "Vendor ID:" | awk '{print $3}')

if [ "$CPUVENDOR" == "GenuineIntel" ]; then
    if ! dpkg -s intel-microcode >/dev/null 2>&1; then
    sudo apt install -y intel-microcode
    fi
else
    echo -e "${GREEN} Intel Microcode OK ${NC}"
fi

if [ "$CPUVENDOR" == "AuthenticAMD" ]; then
    if ! dpkg -s amd64-microcode >/dev/null 2>&1; then
    sudo apt -y install amd64-microcode
    fi
else
    echo -e "${GREEN} Amd64 Microcode OK ${NC}"
fi
unset LC_ALL # unset the LC_ALL=C 
echo -e "${YELLOW} CPU Microcode install END ${NC}"
# -------------------------------------------------------------------------------------------------

echo -e "${YELLOW} Alias echo to ~/.bashrc ${NC}"
echo 'alias ls="ls --color=auto --group-directories-first -v -lah"' >> ~/.bashrc
echo 'alias upup="sudo apt update && sudo apt upgrade -y && sudo apt clean && sudo apt autoremove -y"' >> ~/.bashrc
echo 'bind '"'"'"\C-f":"open "$(fzf)"\n"'"'" >> ~/.bashrc


# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Qtile Core Dependencies apt install ${NC}"
sudo apt -y install python3 python3-pip python3-venv python3-dbus python3-psutil python3-xcffib python3-cairocffi python3-cffi libpangocairo-1.0-0 python-dbus-dev libxkbcommon-dev libxkbcommon-x11-dev feh

# Colorgram for auto-generated color themes
pip3 install colorgram.py --break-system-packages

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Set User folders via xdg-user-dirs-update & xdg-mime default. ${NC}"
# ls /usr/share/applications/ Find The Default run.: "xdg-mime query default inode/directory"

xdg-user-dirs-update

xdg-mime default kitty.desktop text/x-shellscript
xdg-mime default nsxiv.desktop image/jpeg
xdg-mime default nsxiv.desktop image/png
xdg-mime default thunar.desktop inode/directory

# Picom (Yshui) install
#sudo apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev
#cd /tmp/
#git clone https://github.com/yshui/picom
#cd picom
#meson setup --buildtype=release build && ninja -C build && sudo ninja -C build install

#mkdir -p ~/.config/picom
#cp picom.sample.conf ~/.config/picom/picom.conf

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Install Qtile from source via github and Pip ${NC}"
cd ~
mkdir -p ~/.local/bin
mkdir -p ~/.local/src && cd ~/.local/src
python3 -m venv qtile_venv && cd qtile_venv
git clone https://github.com/qtile/qtile.git
bin/pip install qtile/.
cp ~/.local/src/qtile_venv/bin/qtile ~/.local/bin/

#cd /tmp/
#sudo rm -rf qtile
#git clone https://github.com/qtile/qtile.git && cd qtile && pip install . --break-system-packages --no-warn-script-location


sudo mkdir -p /usr/share/xsessions/
sudo bash -c 'cat << "QTILEDESKTOP" >> /usr/share/xsessions/qtile.desktop
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Exec=qtile start
Type=Application
Keywords=wm;tiling
QTILEDESKTOP'

# Add .xsession
touch ~/.xsession && echo "qtile start" > ~/.xsession

# Qtile Autostart.sh file
mkdir -p ~/.config/qtile/
if [ ! -f ~/.config/qtile/autostart.sh ]; then
cat << "QTILEAUTOSTART" > ~/.config/qtile/autostart.sh
#!/bin/sh
pgrep -x picom > /dev/null || picom -b &

# This here if statement sets your background image, with feh... 
# and is also used for the auto-generation of the background image and colors.
if [ -f ~/.fehbg ]; then
    . ~/.fehbg
else
    feh --bg-scale ~/Wallpapers/default_wallpaper_by_natalia-y_on_unsplash.jpg
fi

amixer set Master 10% &
dunst &
numlockx on &
mpd &
#nitrogen --restore &

# lock computer automatically after X time of minutes.
xautolock -time 120 -locker "xsecurelock" -detectsleep -secure &

QTILEAUTOSTART

chmod +x ~/.config/qtile/autostart.sh

else 
	echo "File autostart.sh already exists."
fi

# Qtile Colors.sh file
if [ ! -f ~/.config/qtile/qtile_colors.py ]; then
cat << "QTILECOLORS" > ~/.config/qtile/qtile_colors.py
colors = {
    "base00": "#1b0200",  # Default Background
    "base01": "#240002",  # Lighter Background (Used for status bars, line number and folding marks)
    "base02": "#d74d00",  # Selection Background
    "base03": "#d74d00",  # Comments, Invisibles, Line Highlighting
    "base04": "#9c2101",  # Dark Foreground (Used for status bars)
    "base05": "#d74d00",  # Default Foreground, Caret, Delimiters, Operators
    "base06": "#d74d00",  # Light Foreground (Not often used)
    "base07": "#d74d00",  # Light Background (Not often used)
    "base08": "#d74d00",  # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    "base09": "#830508",  # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    "base0A": "#d74d00",  # Classes, Markup Bold, Search Text Background
    "base0B": "#d74d00",  # Strings, Inherited Class, Markup Code, Diff Inserted
    "base0C": "#9a292f",  # Support, Regular Expressions, Escape Characters, Markup Quotes
    "base0D": "#e46324",  # Functions, Methods, Attribute IDs, Headings
    "base0E": "#ea6f10",  # Keywords, Storage, Selector, Markup Italic, Diff Changed
    "base0F": "#ee712d",  # Deprecated, Opening/Closing Embedded Language Tags
}
QTILECOLORS

else 
	echo "File qtile_colors.py already exists."
fi

# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} MPD Setup & config START ${NC}"

mkdir -p ~/.config/mpd/playlists
mkdir -p ~/.local/state/mpd
if [ ! -f ~/.config/mpd/mpd.conf ]; then
touch ~/.config/mpd/database
cat << MPDCONFIG > ~/.config/mpd/mpd.conf
# ~/.config/mpd/mpd.conf or /etc/mpd.conf
# Example: /usr/share/doc/mpd/mpdconf.example

# Recommended location for database
db_file            "~/.config/mpd/database"

# If running mpd using systemd, delete this line to log directly to systemd.
# syslog or ~/.config/mpd/log
log_file           "~/.config/mpd/log"

# The music directory is by default the XDG directory, uncomment to amend and choose a different directory
#music_directory    "~/Music"

# MPD Server network
bind_to_address     "127.0.0.1"
port                "6600"

# Suppress all messages below the given threshold.  Use "verbose" for
# troubleshooting. Available setting arguments are "notice", "info", "verbose", "warning" and "error".
log_level           "error"

# Setting "restore_paused" to "yes" puts MPD into pause mode instead of starting playback after startup.
restore_paused "yes"

# Uncomment to refresh the database whenever files in the music_directory are changed
auto_update "yes"

# Uncomment to enable the functionalities
playlist_directory "~/.config/mpd/playlists"
pid_file           "~/.config/mpd/pid"
state_file         "~/.local/state/mpd/state"
sticker_file       "~/.config/mpd/sticker.sql"
follow_inside_symlinks  "yes"
# save_absolute_paths_in_playlists       "no"


decoder {
        plugin "wildmidi"
        config_file "/etc/timidity/timidity.cfg"
        enabled "no"
}

# Audio output

audio_output {                                                                 
    type     "pipewire"                                                       
    name     "PipeWire Sound Server"                                           
    enabled  "yes"   
}
audio_output {                                                                 
    type     "pulse"                                                           
    name     "Local PulseAudio Server"                                         
    enabled  "no"                                                             
}       

MPDCONFIG

else 
	echo "mpd.conf already exists."
fi

# sudo systemctl enable mpd
#systemctl enable --now --user mpd.service
#systemctl enable --now --user mpd
# systemctl status mpd.service

#systemctl enable --now --user mpd.socket 
#systemctl enable --now --user mpd.service

# mpd --version
# mpd --stderr --no-daemon --verbose
# aplay --list-pcm

echo -e "${YELLOW} MPD END ${NC}"
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Wallpapers START ${NC}"

if [ ! -d ~/Wallpapers ]; then
mkdir -p ~/Wallpapers
echo -e "${GREEN} Download some wallpapers, Please wait..."

wget -O ~/Wallpapers/default_wallpaper_by_natalia-y_on_unsplash.jpg https://github.com/ITmail-dk/qmade/blob/main/default_wallpaper_by_natalia-y_on_unsplash.jpg?raw=true

# Download random wallpapers from https://unsplash.com
# Set the desired number of wallpapers to download
count="9"

# Categories topics for the wallpapers like, minimalist-wallpapers "Remember to put a hyphen between the words"
query="cool-colors-wallpapers"

# Downloading random wallpapers to ~/Wallpapers folder
for ((i = 1; i <= count; i++)); do
    wget -qO "$HOME/Wallpapers/unsplash_${query}_${i}.jpg" "https://source.unsplash.com/random/3440x1440/?$query"
    done

echo "Wallpapers downloaded successfully."

else 
	echo "Wallpapers folder already exists."
fi

# Nitrogen - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Download some wallpapers from https://unsplash.com/wallpapers

mkdir -p ~/.config/nitrogen

if [ ! -f ~/.config/nitrogen/bg-saved.cfg ]; then
touch ~/.config/nitrogen/bg-saved.cfg
echo "[xin_-1]" >> ~/.config/nitrogen/bg-saved.cfg
echo "file=$HOME/Wallpapers/default-wallpaper.jpg" >> ~/.config/nitrogen/bg-saved.cfg
echo "mode=5" >> ~/.config/nitrogen/bg-saved.cfg
echo "bgcolor=#2E3440" >> ~/.config/nitrogen/bg-saved.cfg
else 
	echo "Nitrogen config file already exists."
fi

if [ ! -f ~/.config/nitrogen/nitrogen.cfg ]; then
cat << "NITROGENCONFIG" > ~/.config/nitrogen/nitrogen.cfg
[geometry]
posx=5
posy=36
sizex=1908
sizey=1037

[nitrogen]
view=icon
recurse=true
sort=alpha
icon_caps=false
NITROGENCONFIG

echo "dirs=$HOME/Wallpapers/;" >> ~/.config/nitrogen/nitrogen.cfg

else 
	echo "Nitrogen config file already exists."
fi

echo -e "${YELLOW} Wallpapers END ${NC}"
# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Neovim config Start ${NC}"

if [ ! -f ~.config/nvim/init.vim ]; then
mkdir -p ~/.config/nvim
cat << "NEOVIMCONFIG" > ~.config/nvim/init.vim
syntax on
set number
set numberwidth=5
set relativenumber
set ignorecase
NEOVIMCONFIG

else 
	echo "Neovim config file already exists."
fi

echo -e "${YELLOW} Neovim config END ${NC}"
# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Kitty theme.conf Start ${NC}"

if [ ! -f $HOME/.config/kitty/themes/kittytheme.conf ]; then
mkdir -p $HOME/.config/kitty/themes
cat << "KITTYTHEMECONF" > $HOME/.config/kitty/themes/kittytheme.conf
background #1b0200
foreground #ee712d
color0 #1b0200
color1 #240002
color2 #d74d00
color3 #d74d00
color4 #9c2101
color5 #d74d00
color6 #d74d00
color7 #d74d00
color8 #d74d00
color9 #830508
color10 #d74d00
color11 #d74d00
color12 #9a292f
color13 #e46324
color14 #ea6f10
color15 #ee712d

KITTYTHEMECONF

else 
	echo "kittytheme.conf file already exists."
fi

echo -e "${YELLOW} Kitty theme.conf END ${NC}"

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Tmux config Start ${NC}"

if [ ! -f ~.config/tmux/tmux.conf ]; then
mkdir -p ~/.config/tmux
cat << "TMUXCONFIG" > ~.config/tmux/tmux.conf
unbind r
bind r source-file ~.config/tmux/tmux.conf

TMUXCONFIG

else 
	echo "Tmux config file already exists."
fi

echo -e "${YELLOW} Tmux config END ${NC}"


# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Themes START ${NC}"
# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Nerd Fonts START - https://www.nerdfonts.com/font-downloads - https://www.nerdfonts.com/cheat-sheet - - - ${NC}"
if [ ! -d ~/.fonts ]; then
mkdir -p ~/.fonts

else 
	echo ".fonts already exists."
fi

# DejaVu Sans Mono font
wget -P /tmp/ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/DejaVuSansMono.zip
unzip -q -n /tmp/DejaVuSansMono.zip -d ~/.fonts

# Space Mono
#wget -P /tmp/ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/SpaceMono.zip
#unzip -q -n /tmp/SpaceMono.zip -d ~/.fonts

# Roboto Mono
#wget -P /tmp/ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip
#unzip -q -n /tmp/RobotoMono.zip -d ~/.fonts

# Fira Mono
#wget -P /tmp/ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraMono.zip
#unzip -q -n /tmp/FiraMono.zip -d ~/.fonts

rm -f ~/.fonts/*.md
rm -f ~/.fonts/*.txt

echo -e "${YELLOW} Nerd Fonts END - https://www.nerdfonts.com/font-downloads "
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------

# ls -d /usr/share/themes/*
# ls -d /usr/share/icons/*
# ls -d /usr/share/
# sudo nano /etc/gtk-3.0/settings.ini
# sudo nano /etc/gtk-2.0/gtkrc

# https://github.com/EliverLara/Nordic

sudo rm -rf /tmp/EliverLara-Nordic
sudo git clone https://github.com/EliverLara/Nordic /tmp/EliverLara-Nordic
sudo cp -r /tmp/EliverLara-Nordic /usr/share/themes/

# Nordzy-cursors --------------------------------------------------------

# https://github.com/alvatip/Nordzy-cursors

cd /tmp/
sudo rm -rf Nordzy-cursors
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
sudo ./install.sh
cd /tmp/

# .Xresources
# Xcursor.theme: Nordzy-cursors
# Xcursor.size: 22

# Nordzy-icon --------------------------------------------------------
# https://github.com/alvatip/Nordzy-icon

cd /tmp/
sudo rm -rf Nordzy-icon
git clone https://github.com/alvatip/Nordzy-icon
cd Nordzy-icon/
sudo ./install.sh
cd /tmp/


# GTK Settings START --------------------------------------------------------
# /etc/gtk-3.0/settings.ini
# https://docs.gtk.org/gtk4/property.Settings.gtk-cursor-theme-name.html
if [ ! -d /etc/gtk-3.0 ]; then
mkdir -p /etc/gtk-3.0

else 
	echo "/etc/gtk-3.0 already exists."
fi

sudo bash -c 'cat << "GTK3SETTINGS" >> /etc/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=EliverLara-Nordic
gtk-fallback-icon-theme=default
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-font-name=DejaVu Sans Mono 10
gtk-application-prefer-dark-theme=1
gtk-cursor-theme-name=Nordzy-cursors
gtk-cursor-theme-size=0
gtk-icon-theme-name=Nordzy-icon
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
GTK3SETTINGS'

if [ ! -d /etc/gtk-4.0 ]; then
mkdir -p /etc/gtk-4.0

else 
	echo "/etc/gtk-4.0 already exists."
fi

sudo bash -c 'cat << "GTK4SETTINGS" >> /etc/gtk-4.0/settings.ini
[Settings]
gtk-theme-name=EliverLara-Nordic
gtk-fallback-icon-theme=default
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-font-name=DejaVu Sans Mono 10
gtk-application-prefer-dark-theme=1
gtk-cursor-theme-name=Nordzy-cursors
gtk-cursor-theme-size=0
gtk-icon-theme-name=Nordzy-icon
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
GTK4SETTINGS'


sudo sed -i 's/Adwaita/Nordzy-cursors/g' /usr/share/icons/default/index.theme

# GTK Settings END --------------------------

sudo fc-cache -fv

echo -e "${YELLOW} Themes END ${NC}"
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} xrandr-set-max + Xsession START ${NC}"

if [ ! -f /usr/local/bin/xrandr-set-max ]; then
# Define the content of the script
xrandrsetmaxcontent=$(cat << "XRANDRSETMAX"
#!/bin/bash

# Get the names of all connected displays
displays=$(xrandr | awk '/ connected/{print $1}')

# Loop through each connected display and set its resolution to the maximum supported resolution
for display in $displays; do
    # Get the maximum supported resolution for the current display
    max_resolution=$(xrandr | awk '/'"$display"'/ && / connected/{getline; print $1}')

    # Set the screen resolution to the maximum supported resolution for the current display
    xrandr --output "$display" --mode "$max_resolution"
done
XRANDRSETMAX
)

# Write the script content to the target file using sudo
echo "$xrandrsetmaxcontent" | sudo tee /usr/local/bin/xrandr-set-max >/dev/null

# SDDM Before Login - /usr/share/sddm/scripts/Xsetup and After Login - /usr/share/sddm/scripts/Xsession
sudo sed -i '$a\. /usr/local/bin/xrandr-set-max' /usr/share/sddm/scripts/Xsetup
sudo sed -i '$a\. /usr/local/bin/xrandr-set-max' /usr/share/sddm/scripts/Xsession

sudo chmod +x /usr/local/bin/xrandr-set-max

else 
	echo "xrandr-set-max already exists."
fi

#if [ ! -f /etc/X11/Xsession.d/90_xrandr-set-max ]; then
#    sudo cp /usr/local/bin/xrandr-set-max /etc/X11/Xsession.d/90_xrandr-set-max
#    # Run at Login /etc/X11/Xsession.d/FILENAME
#else
#	echo "/etc/X11/Xsession.d/90_xrandr-set-max already exists."
#fi

echo -e "${YELLOW} xrandr-set-max + Xsession END ${NC}"
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Download Unsplash Wallpapers BIN START ${NC}"
sudo bash -c 'cat << "UNSPLASHDOWNLOADBIN" >> /usr/local/bin/unsplash-download-wallpapers
#!/bin/bash

# Function to download wallpapers
download_wallpapers() {
    # Set the desired number of wallpapers to download
    count="$2"

    # Categories topics for the wallpapers like, minimalist-wallpapers "Remember to put a hyphen between the words"
    query="$1"

    echo "Wallpapers are being downloaded, Please wait..."

    # Download images
    for ((i = 1; i <= count; i++)); do
        wget -qO "$HOME/Wallpapers/unsplash_${query}_${i}.jpg" "https://source.unsplash.com/random/3440x1440/?$query"
    done

    echo "Wallpapers downloaded successfully."
}

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: unsplash-download-wallpapers <query> <count>"
    echo "Example: unsplash-download-wallpapers hd-nature-landscape 15"
    exit 1
fi

query="$1"
count="$2"

download_wallpapers "$query" "$count"
UNSPLASHDOWNLOADBIN'

sudo chmod +x /usr/local/bin/unsplash-download-wallpapers

echo -e "${YELLOW} Download Unsplash Wallpapers BIN END ${NC}"
# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} auto-new-wallpaper-and-colors BIN START ${NC}"
sudo bash -c 'cat << "AUTONEWWALLPAPERANDCOLORSBIN" >> /usr/local/bin/auto-new-wallpaper-and-colors
#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.local/bin

if [ ! -f "$HOME/.config/qtile/extract_colors.py" ]; then
    echo "$HOME/.config/qtile/extract_colors.py not found! Please ensure the Python script is in the same directory."
    exit 1
fi

RWALLP="$(find $HOME/Wallpapers -type f | shuf -n 1)"

notify-send -u low "Automatically new background and color theme" "Please wait while we find a new background image and some colors to match"

python3 $HOME/.config/qtile/extract_colors.py $RWALLP
feh --bg-scale $RWALLP
qtile cmd-obj -o cmd -f reload_config
kitty +kitten themes --reload-in=all Kittytheme

notify-send -u low "Automatically new background and color theme" "The background image and colors has been updated."

AUTONEWWALLPAPERANDCOLORSBIN'

sudo chmod +x /usr/local/bin/auto-new-wallpaper-and-colors

echo -e "${YELLOW} auto-new-wallpaper-and-colors BIN END ${NC}"

# Extract New-Colors file
if [ ! -f ~/.config/qtile/extract_colors.py ]; then
cat << "EXTRACTCOLORS" > ~/.config/qtile/extract_colors.py
import sys
import os
import colorgram
from PIL import Image, ImageDraw, ImageFont

def rgb_to_hex(rgb):
    return '#{:02x}{:02x}{:02x}'.format(rgb[0], rgb[1], rgb[2])

def luminance(rgb):
    r, g, b = rgb[0]/255.0, rgb[1]/255.0, rgb[2]/255.0
    a = [r, g, b]
    for i in range(len(a)):
        if a[i] <= 0.03928:
            a[i] = a[i] / 12.92
        else:
            a[i] = ((a[i] + 0.055) / 1.055) ** 2.4
    return 0.2126 * a[0] + 0.7152 * a[1] + 0.0722 * a[2]

def choose_text_color(background_color):
    if luminance(background_color) > 0.5:
        return (0, 0, 0)  # dark text for light background
    else:
        return (255, 255, 255)  # light text for dark background

def create_color_grid(colors, base16_colors, filename='color_grid.png'):
    grid_size = 4  # 4x4 grid
    square_size = 150  # Size of each small square
    img_size = square_size * grid_size  # Calculate total image size

    img = Image.new('RGB', (img_size, img_size))
    draw = ImageDraw.Draw(img)

    # Load a font
    try:
        font = ImageFont.truetype("arial.ttf", 30)
    except IOError:
        font = ImageFont.load_default()

    # Fill the grid with colors and add text labels
    for i, (key, value) in enumerate(base16_colors.items()):
        x = (i % grid_size) * square_size
        y = (i // grid_size) * square_size
        draw.rectangle([x, y, x + square_size, y + square_size], fill=value)
        # Choose text color based on background color luminance
        text_color = choose_text_color(tuple(int(value[i:i+2], 16) for i in (1, 3, 5)))
        # Add text label
        text_position = (x + 10, y + 10)
        draw.text(text_position, key, fill=text_color, font=font)

    img.save(filename)


def main(image_path):
    colors = colorgram.extract(image_path, 16)

    # Ensure there are exactly 16 colors by duplicating if necessary
    while len(colors) < 16:
        colors.append(colors[len(colors) % len(colors)])

    # Sort colors by luminance
    colors.sort(key=lambda col: luminance(col.rgb))

    # Assign colors to Base16 scheme slots ensuring the tonal range
    base16_colors = {
        'base00': rgb_to_hex(colors[0].rgb),
        'base01': rgb_to_hex(colors[5].rgb),
        'base02': rgb_to_hex(colors[12].rgb),
        'base03': rgb_to_hex(colors[9].rgb),
        'base04': rgb_to_hex(colors[4].rgb),
        'base05': rgb_to_hex(colors[10].rgb),
        'base06': rgb_to_hex(colors[6].rgb),
        'base07': rgb_to_hex(colors[14].rgb),
        'base08': rgb_to_hex(colors[2].rgb),
        'base09': rgb_to_hex(colors[3].rgb),
        'base0A': rgb_to_hex(colors[1].rgb),
        'base0B': rgb_to_hex(colors[11].rgb),
        'base0C': rgb_to_hex(colors[8].rgb),
        'base0D': rgb_to_hex(colors[13].rgb),
        'base0E': rgb_to_hex(colors[7].rgb),
        'base0F': rgb_to_hex(colors[15].rgb),
    }

    descriptions = [
        "Default Background",
        "Lighter Background (Used for status bars, line number and folding marks)",
        "Selection Background",
        "Comments, Invisibles, Line Highlighting",
        "Dark Foreground (Used for status bars)",
        "Default Foreground, Caret, Delimiters, Operators",
        "Light Foreground (Not often used)",
        "Light Background (Not often used)",
        "Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted",
        "Integers, Boolean, Constants, XML Attributes, Markup Link Url",
        "Classes, Markup Bold, Search Text Background",
        "Strings, Inherited Class, Markup Code, Diff Inserted",
        "Support, Regular Expressions, Escape Characters, Markup Quotes",
        "Functions, Methods, Attribute IDs, Headings",
        "Keywords, Storage, Selector, Markup Italic, Diff Changed",
        "Deprecated, Opening/Closing Embedded Language Tags",
    ]

    # Ensure the directory exists
    qtile_config_dir = os.path.expanduser('~/.config/qtile/')
    os.makedirs(qtile_config_dir, exist_ok=True)

    # Path to the output file
    output_file_path = os.path.join(qtile_config_dir, 'qtile_colors.py')

    # Write the colors to the Python file
    with open(output_file_path, 'w') as f:
        f.write("colors = {\n")
        for key, value in base16_colors.items():
            description = descriptions.pop(0)
            f.write(f'    "{key}": "{value}",  # {description}\n')
        f.write("}\n")

    # Ensure the directory exists
    kitty_config_dir = os.path.expanduser('~/.config/kitty/themes/')
    os.makedirs(kitty_config_dir, exist_ok=True)

    # Path to the output file
    output_file_path = os.path.join(kitty_config_dir, 'kittytheme.conf')

    with open(output_file_path, 'w') as f:
        f.write(f'background {base16_colors["base00"]}\n')
        f.write(f'foreground {base16_colors["base0F"]}\n')
        for index, (_, value) in enumerate(base16_colors.items()):
            f.write(f'color{index} {value}\n')
    # Create a PNG file with the extracted colors and labels
    create_color_grid(colors, base16_colors)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: extract_colors.py <image_path>")
    else:
        main(sys.argv[1])

EXTRACTCOLORS

else 
	echo "File ~/.config/qtile/extract_colors.py already exists."
fi

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Rofi Run menu START ${NC}"
if [ ! -d ~/.config/rofi ]; then
mkdir -p ~/.config/rofi

else 
	echo "Rofi folder already exists."
fi

if [ ! -f ~/.config/rofi/config.rasi ]; then
#touch ~/.config/rofi/config.rasi
cat << "ROFICONFIG" > ~/.config/rofi/config.rasi
configuration {
  display-drun: "Applications:";
  display-window: "Windows:";
  drun-display-format: "{name}";
  font: "DejaVuSansMono Nerd Font Book 10";
  modi: "window,run,drun";
}

@theme "/dev/null"

* {
  bg: #10171c;
  bg-alt: #344959;

  fg: #EBEBEB;
  fg-alt: #768ca3;

  background-color: @bg;
  
  border: 0;
  margin: 0;
  padding: 0;
  spacing: 0;
}

window {
  width: 30%;
}

element {
  padding: 8 0;
  text-color: @fg-alt;
}

element selected {
  text-color: @fg;
}

element-text {
  background-color: inherit;
  text-color: inherit;
  vertical-align: 0.5;
}

element-icon {
  size: 30;
}

entry {
  background-color: @bg-alt;
  padding: 12;
  text-color: @fg;
}

inputbar {
  children: [prompt, entry];
}

listview {
  padding: 8 12;
  background-color: @bg;
  columns: 1;
  lines: 8;
}

mainbox {
  background-color: @bg;
  children: [inputbar, listview];
}

prompt {
  background-color: @bg-alt;
  enabled: true;
  padding: 12 0 0 12;
  text-color: @fg;
}

/* vim: ft=sass

// Theme location is "/usr/share/rofi/themes/name.rasi"
//@theme "/usr/share/rofi/themes/Arc-Dark.rasi"

ROFICONFIG

else 
	echo "Rofi config file already exists."
fi

echo -e "${YELLOW} Rofi Run menu END ${NC}"

# Rofi Wifi menu
# https://github.com/ericmurphyxyz/rofi-wifi-menu/tree/master
echo -e "${YELLOW} Rofi Wifi menu Start ${NC}"
if [ ! -f ~/.config/rofi/rofi-wifi-menu.sh ]; then
cat << "ROFIWIFI" > ~/.config/rofi/rofi-wifi-menu.sh
#!/usr/bin/env bash

notify-send "Getting list of available Wi-Fi networks..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="󰖪  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="󰖩  Enable Wi-Fi"
fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " )
# Get name of connection
read -r chosen_id <<< "${chosen_network:3}"

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
  	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -p "Password: " )
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
    fi
fi

ROFIWIFI

chmod +x ~/.config/rofi/rofi-wifi-menu.sh

else 
	echo "Rofi WiFi menu file already exists."
fi

echo -e "${YELLOW} Rofi Wifi menu END ${NC}"

# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Kitty config file START ${NC}"

if [ ! -f ~/.config/kitty/kitty.conf ]; then
mkdir -p ~/.config/kitty/themes
cat << "KITTYCONFIG" > ~/.config/kitty/kitty.conf
# A default configuration file can also be generated by running:
# kitty +runpy 'from kitty.config import *; print(commented_out_default_config())'
#
# The following command will bring up the interactive terminal GUI
# kitty +kitten themes
#
# kitty +kitten themes Catppuccin-Mocha
# kitty +kitten themes --reload-in=all Catppuccin-Mocha

background_opacity 0.98

font_family      monospace
bold_font        auto
italic_font      auto
bold_italic_font auto

font_size 12
force_ltr no

adjust_line_height  0
adjust_column_width 0

adjust_baseline 0

disable_ligatures never

box_drawing_scale 0.001, 1, 1.5, 2

cursor #f2f2f2

cursor_text_color #f2f2f2

cursor_shape underline

cursor_beam_thickness 1.5

cursor_underline_thickness 2.0

cursor_blink_interval -1

cursor_stop_blinking_after 99.0

scrollback_lines 5000

scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER

scrollback_pager_history_size 0

scrollback_fill_enlarged_window no

wheel_scroll_multiplier 5.0

touch_scroll_multiplier 1.0

mouse_hide_wait 3.0

mouse_map right click paste_from_clipboard

url_color #0087bd
url_style curly

open_url_with default

url_prefixes http https file ftp gemini irc gopher mailto news git

detect_urls yes

url_excluded_characters 

copy_on_select yes

strip_trailing_spaces never

select_by_word_characters @-./_~?&=%+#

click_interval -1.0

focus_follows_mouse no

pointer_shape_when_grabbed arrow

default_pointer_shape beam

pointer_shape_when_dragging beam

mouse_map left            click ungrabbed mouse_click_url_or_select
mouse_map shift+left      click grabbed,ungrabbed mouse_click_url_or_select
mouse_map ctrl+shift+left release grabbed,ungrabbed mouse_click_url

mouse_map ctrl+shift+left press grabbed discard_event

mouse_map middle        release ungrabbed paste_from_selection
mouse_map left          press ungrabbed mouse_selection normal
mouse_map ctrl+alt+left press ungrabbed mouse_selection rectangle
mouse_map left          doublepress ungrabbed mouse_selection word
mouse_map left          triplepress ungrabbed mouse_selection line

mouse_map ctrl+alt+left triplepress ungrabbed mouse_selection line_from_point

#mouse_map right               press ungrabbed mouse_selection extend
mouse_map shift+middle        release ungrabbed,grabbed paste_selection
mouse_map shift+left          press ungrabbed,grabbed mouse_selection normal
mouse_map shift+ctrl+alt+left press ungrabbed,grabbed mouse_selection rectangle
mouse_map shift+left          doublepress ungrabbed,grabbed mouse_selection word
mouse_map shift+left          triplepress ungrabbed,grabbed mouse_selection line

mouse_map shift+ctrl+alt+left triplepress ungrabbed,grabbed mouse_selection line_from_point

repaint_delay 10

input_delay 5

sync_to_monitor yes

enable_audio_bell no

visual_bell_duration 0.0

window_alert_on_bell no

bell_on_tab no

command_on_bell none

remember_window_size  yes
initial_window_width  800
initial_window_height 500

enabled_layouts *

window_resize_step_cells 2
window_resize_step_lines 2

window_border_width 0.0pt

draw_minimal_borders yes

window_margin_width 0

single_window_margin_width -1

window_padding_width 3

placement_strategy center

active_border_color #f2f2f2

inactive_border_color #cccccc

bell_border_color #ff5a00

inactive_text_alpha 1.0

hide_window_decorations no

resize_debounce_time 0.1

resize_draw_strategy static

resize_in_steps no

confirm_os_window_close 0

tab_bar_edge bottom

tab_bar_margin_width 0.0

tab_bar_margin_height 0.0 0.0

tab_bar_style fade

tab_bar_min_tabs 2

tab_switch_strategy previous

tab_fade 0.25 0.5 0.75 1

tab_separator " |"

tab_powerline_style angled

tab_activity_symbol none

tab_title_template "{title}"

active_tab_title_template none

active_tab_foreground   #000
active_tab_background   #eee
active_tab_font_style   bold-italic
inactive_tab_foreground #444
inactive_tab_background #999
inactive_tab_font_style normal

tab_bar_background none

background_image none

background_image_layout tiled

background_image_linear no

dynamic_background_opacity no

background_tint 0.0

dim_opacity 0.75

selection_foreground #000000

selection_background #fffacd

mark1_foreground black

mark1_background #98d3cb

mark2_foreground black

mark2_background #f2dcd3

mark3_foreground black

mark3_background #f274bc

shell .

editor .

close_on_child_death no

allow_remote_control yes

listen_on none

update_check_interval 0

startup_session none

clipboard_control write-clipboard write-primary

allow_hyperlinks yes

term xterm-kitty

wayland_titlebar_color system

macos_titlebar_color system

macos_option_as_alt no

macos_hide_from_tasks no

macos_quit_when_last_window_closed no

macos_window_resizable yes

macos_thicken_font 0

macos_traditional_fullscreen no

macos_show_window_title_in all

macos_custom_beam_cursor no

linux_display_server auto

kitty_mod ctrl+shift

clear_all_shortcuts no
map kitty_mod+c copy_to_clipboard
map kitty_mod+v paste_from_clipboard
map kitty_mod+up        scroll_line_up
map kitty_mod+down      scroll_line_down
map kitty_mod+page_up   scroll_page_up
map kitty_mod+page_down scroll_page_down
map kitty_mod+home      scroll_home
map kitty_mod+end       scroll_end
map kitty_mod+h         show_scrollback
map kitty_mod+w close_window
map kitty_mod+] next_window
map kitty_mod+[ previous_window
map kitty_mod+f move_window_forward
map kitty_mod+b move_window_backward
map kitty_mod+` move_window_to_top
map kitty_mod+r start_resizing_window
map kitty_mod+1 first_window
map kitty_mod+2 second_window
map kitty_mod+3 third_window
map kitty_mod+4 fourth_window
map kitty_mod+5 fifth_window
map kitty_mod+6 sixth_window
map kitty_mod+7 seventh_window
map kitty_mod+8 eighth_window
map kitty_mod+9 ninth_window
map kitty_mod+0 tenth_window
map kitty_mod+right next_tab
map kitty_mod+left  previous_tab
map kitty_mod+t     new_tab
map kitty_mod+q     close_tab
map shift+cmd+w     close_os_window
map kitty_mod+.     move_tab_forward
map kitty_mod+,     move_tab_backward
map kitty_mod+alt+t set_tab_title
map kitty_mod+l next_layout
map kitty_mod+equal     change_font_size all +2.0
map kitty_mod+minus     change_font_size all -2.0
map kitty_mod+backspace change_font_size all 0
map kitty_mod+e kitten hints
map kitty_mod+p>f kitten hints --type path --program -
map kitty_mod+p>shift+f kitten hints --type path
map kitty_mod+p>l kitten hints --type line --program -
map kitty_mod+p>w kitten hints --type word --program -
map kitty_mod+p>h kitten hints --type hash --program -
map kitty_mod+p>n kitten hints --type linenum
map kitty_mod+p>y kitten hints --type hyperlink
map kitty_mod+f11    toggle_fullscreen
map kitty_mod+f10    toggle_maximized
map kitty_mod+u      kitten unicode_input
map kitty_mod+f2     edit_config_file
map kitty_mod+escape kitty_shell window
map kitty_mod+a>m    set_background_opacity +0.1
map kitty_mod+a>l    set_background_opacity -0.1
map kitty_mod+a>1    set_background_opacity 1
map kitty_mod+a>d    set_background_opacity default
map kitty_mod+delete clear_terminal reset active
map kitty_mod+f5 load_config_file
map kitty_mod+f6 debug_config

include ~/.config/kitty/themes/kittytheme.conf

KITTYCONFIG

else 
	echo "Kitty config already exists."
fi


echo -e "${YELLOW} Kitty config file END ${NC}"
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Edit GRUB BOOT TIMEOUT START ${NC}"
sudo sed -i 's+GRUB_TIMEOUT=5+GRUB_TIMEOUT=1+g' /etc/default/grub && sudo update-grub
echo -e "${YELLOW} Edit GRUB BOOT TIMEOUT END ${NC}"
# -------------------------------------------------------------------------------------------------

echo -e "${YELLOW} Install selection choose what to install Start ${NC}"
for PROGRAM in $PROGRAMS
do
    case $PROGRAM in
        "1")
            sudo apt install -y libreoffice
            ;;
        "2")
            sudo apt install -y tlp tlp-rdw bluetooth bluez bluez-cups bluez-obexd bluez-meshd pulseaudio-module-bluetooth bluez-firmware blueman
            ;;
        "3")
            sudo apt install -y xrdp && sudo systemctl restart xrdp.service
            ;;
        "4")
            sudo apt install -y freerdp2-x11 libfreerdp-client2-2 libfreerdp2-2 libwinpr2-2
            ;;
        "5")
            cd /tmp/ && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb && rm google-chrome-stable_current_amd64.deb
            ;;
        "6")
            sudo apt install -y firefox-esr
            ;;
        "7")
            sudo apt install -y neovim
            ;;
        "8")
            cd /tmp/ && wget -O vscode_amd64.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' && sudo apt install -y /tmp/vscode_amd64.deb && rm vscode_amd64.deb
            ;;
        "9")
            sudo apt install -y smbclient
            ;;
        "10")
            sudo apt install -y nfs-common
            ;;
        "11")
            sudo apt install -y ceph-commen
            ;;
    esac
done
echo -e "${YELLOW} Install selection choose what to install End ${NC}"


# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Qtile Config file START ${NC}"

if [ ! -f ~/.config/qtile/config.py ]; then

cat << "QTILECONFIG" > ~/.config/qtile/config.py
# Qtile Config - Start
# https://docs.qtile.org/en/latest/index.html
# -',.-'-,.'-,'.-',.-',-.'-,.'-,.'-,.'-,'.-',.-'-
#
import os
import subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown, re
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal # terminal = guess_terminal()
from qtile_colors import colors
#from libqtile.dgroups import simple_key_binder


# Custom code start ----------------------------------------------------

def guess_browser():
    """Guess the default web browser."""
    # Define a list of common web browsers
    browsers = ["google-chrome", "firefox", "chromium", "vivaldi", "opera", "brave-browser", "safari"]

    # Loop through the list of browsers and check if they exist in PATH
    for browser in browsers:
        try:
            subprocess.run(["which", browser], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            return browser
        except subprocess.CalledProcessError:
            continue

    # If no browser is found, return None
    return None



# Custom code end ------------------------------------------------------

# Colors use example active=colors["3"],


mod = "mod4"
terminal = guess_terminal()
browser = guess_browser()
fileexplorer = "thunar"
runmenu = 'rofi -modi "drun,run,window,filebrowser" -show drun' # Switch between -modi... Default key CTRL+TAB


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    #
    # Examples:
    # a key binding that can run an external Script or Command
    # Key([mod], "l", lazy.spawn(os.path.expanduser("xsecurelock")), desc='Computer Lockdown'),
    #
    # a normal key binding that pulls from a variable
    # Key([mod], "Return", lazy.spawn(terminal), desc="Launch Terminal"),

    # Keybindings
    Key([mod], "Return", lazy.spawn(terminal), desc="Terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="Web Browser"),
    Key([mod], "e", lazy.spawn(fileexplorer), desc="File Explorer"),
    Key([mod], "r", lazy.spawn(runmenu), desc="Run Menu"),
    Key([mod, "shift"], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod, "control", "mod1"], "l", lazy.spawn(os.path.expanduser("xsecurelock")), desc="Computer Lockdown"),
    Key([mod, "control", "mod1"], "t", lazy.spawn(os.path.expanduser("auto-new-wallpaper-and-colors")), desc="Random Theme"),
    Key([mod, "control", "mod1"], "w", lazy.spawn(os.path.expanduser("~/.config/rofi/rofi-wifi-menu.sh")), desc="WiFi Menu"),

    # Default
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), lazy.layout.grow(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), lazy.layout.shrink(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "n", lazy.layout.normalize(), lazy.layout.reset(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "mod1", "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "mod1", "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Audio
    Key([mod, "mod1"], "Up", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +1%"), desc='Volume Up'),
    Key([mod, "mod1"], "Down", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"), desc='Volume Down'),
    Key([mod, "mod1"], "m", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc='Volume Mute Toggle'),

    # XF86 Audio & Brightness keys
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+"), desc='Volume Up'),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc='Volume down'),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc='Volume Mute toggle'),
# mute/unmute the microphone - wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
# Show volume level - wpctl get-volume @DEFAULT_AUDIO_SINK@

#    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +1%"), desc='Volume Up'),
#    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"), desc='Volume down'),
#    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc='Volume Mute toggle'),

#    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer set Master 2%+"), desc='Volume Up'),
#    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer set Master 5%+"), desc='Volume down'),
#    Key([], "XF86AudioMute", lazy.spawn("amixer set Master toggle"), desc='Volume Mute'),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc='Play-Pause'),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc='Previous'),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc='Next'),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10"), desc='brightness UP'),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10-"), desc='brightness Down'),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


# Create labels for groups and assign them a default layout.
# Find icons here - https://www.nerdfonts.com/cheat-sheet
# nf-linux-debian  nf-md-rocket_launch 󱓞 nf-cod-rocket  nf-cod-settings  nf-dev-android  nf-dev-chrome  nf-dev-terminal 
# nf-dev-prolog  nf-fa-apple  nf-fa-earlybirds  nf-fa-egg  nf-fa-grav  nf-fa-linux  nf-fa-snapchat 
# nf-fa-steam  nf-fa-terminal  nf-fa-wifi  nf-fae-pi  nf-md-recycle 󰑌 nf-md-symbol 󱔁 nf-fa-mug_hot 
# nf-fa-thermometer_2  nf-md-battery_medium 󱊢 nf-md-battery_charging 󰂄
# nf-fa-volume_high  nf-fa-volume_low  nf-fa-volume_xmark 
# nf-md-pac_man 󰮯 nf-md-ghost 󰊠 nf-fa-circle  nf-cod-circle_large  nf-cod-circle_filled  nf-md-circle_small 󰧟 nf-md-circle_medium 󰧞 

groups = [
    Group("1", label="", layout="monadtall", matches=[Match(wm_class=re.compile(r"^(Google\-chrome)$"))]),
    Group("2", label="", layout="monadtall"),
    Group("3", label="", layout="monadtall"),
    Group("4", label="", layout="monadtall"),
    Group("5", label="", layout="monadtall"),
    Group("6", label="", layout="monadtall"),
    Group("7", label="", layout="monadtall"),
    Group("8", label="", layout="monadtall"),
    Group("9", label="", layout="monadtall", matches=[Match(wm_class=re.compile(r"^(Firefox\-esr)$"))]),
    Group("0", label="", layout="bsp"),
]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

# ScratchPad Keybindings
keys.extend([
    Key([mod, "shift"], "Return", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([mod, "shift"], "e", lazy.group['scratchpad'].dropdown_toggle('mc')),
    Key([mod, "shift"], "a", lazy.group['scratchpad'].dropdown_toggle('audio')),
    Key([mod, "shift"], "n", lazy.group['scratchpad'].dropdown_toggle('notes')),
    Key([mod, "shift"], "m", lazy.group['scratchpad'].dropdown_toggle('music')),
])

# ScratchPads
groups.append(ScratchPad("scratchpad", [
    DropDown("term", "kitty --class=scratch", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
    DropDown("mc", "kitty --class=mc -e mc", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
    DropDown("audio", "kitty --class=volume -e alsamixer", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
    DropDown("notes", "notepadqq", width=0.6, height=0.6, x=0.2, y=0.2, opacity=1),
    DropDown("music", "kitty --class=music -e ncmpcpp", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
]))

# Define layouts and layout themes
def init_layout_theme():
    return {"margin":5,
            "border_width":1,
            "border_focus": colors["base06"],
            "border_normal": colors["base02"]
            }

layout_theme = init_layout_theme()

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    #layout.Bsp(**layout_theme),
    #layout.Columns(**layout_theme),
    #layout.Stack(num_stacks=2),
    #layout.Matrix(**layout_theme),
    #layout.MonadWide(**layout_theme),
    #layout.RatioTile(**layout_theme),
    #layout.Tile(**layout_theme),
    #layout.TreeTab(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="DejaVu Sans Mono, sans",
    fontsize=14,
    padding=5,
)
extension_defaults = widget_defaults.copy()

# Bar widgets - https://docs.qtile.org/en/latest/manual/ref/widgets.html

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(scale=0.7, padding=10),
                widget.Spacer(length=5),
                widget.GroupBox(fontsize=18, highlight_method="text", this_current_screen_border="#f7f7f7", highlight_color=colors["base0B"], this_screen_border=colors["base04"], urgent_border=colors["base03"], active=colors["base05"], inactive=colors["base03"], rounded="False", borderwidth=0),                widget.Spacer(length=9),
                widget.Prompt(),
                widget.Spacer(),
                widget.WindowName(width=bar.CALCULATED, max_chars=120),
                widget.Spacer(),
                widget.Systray(fmt="󱊖  {}", icon_size=20),
                # NB Wayland is incompatible with Systray, consider using StatusNotifier
                # widget.StatusNotifier(),
                #widget.Wallpaper(directory="~/Wallpapers/", label="", random_selection="True"),
                #widget.NetGraph(type='line', line_width=1),
                #widget.Net(prefix='M'),
                widget.ThermalSensor(format='CPU: {temp:.0f}{unit}'),
                widget.Volume(fmt="  {}"),
                widget.Spacer(length=5),
                widget.Clock(fmt="  {}",format="%H:%M %A %d-%m-%Y %p"),
                #widget.QuickExit(default_text="LOGOUT", countdown_format="     {}     "),
                widget.Spacer(length=20),
            ], 30, # Define bar height
            background=colors["base00"], opacity=0.95, # Bar background color can also take transparency with "hex color code" or .75
            margin=[5, 5, 0, 5], # Space around bar as int or list of ints [N E S W]
            border_width=[0, 0, 0, 0],  # Width of border as int of list of ints [N E S W]
            border_color=["f7f7f7", "f7f7f7", "f7f7f7", "f7f7f7"]  # Border colour as str or list of str [N E S W]
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
        #wallpaper="~/Wallpapers/default-wallpaper.jpg",
        #wallpaper_mode="fill"
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(**layout_theme,
    float_rules=[
        # Run the utility xprop to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# Remember to add, "hook" "import os" "import subprocess" "Match"
@hook.subscribe.startup_once
def autostart():
    autostartscript = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([autostartscript])

@hook.subscribe.client_new
def move_window_to_group(client):
    for group in groups:
        if any(client.match(match) for match in group.matches):
            client.togroup(group.name)
            client.qtile.groups_map[group.name].toscreen()
            break


# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

wmname = "Qtile"

QTILECONFIG

else 
	echo "Qtile config file already exists."
fi

# -------------------------------------------------------------------------------------------------
echo -e "${YELLOW} Qtile Config file END ${NC}"
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------

# Install closing screen ##### ##### ##### ##### ##### ##### ##### ##### ##### ####
clear
if (whiptail --title "Installation Complete" --yesno "Qmade Installation is complete. \nDo you want to restart the computer ?\n\nSome practical information. \nWindows key + Enter opens a terminal \nWindows key + B opens a web browser \nWindows key + W closes the active window" 15 60); then
    cd ~
    clear
    echo -e "${RED} "
    echo -e "${RED}-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-"
    echo -e "${RED} "
    echo -e "${RED}      Enter your user password, to continue if necessary"
    echo -e "${RED} "
    echo -e "${RED}-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-"
    echo -e "${RED} ${NC}"
    sudo reboot
    echo -e "${GREEN}See you later alligator..."
    echo -e "${GREEN} "
    echo -e "${GREEN} ${NC}"
else
    cd ~
    clear
    echo -e "${GREEN} -'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-"
    echo -e "${GREEN} "
    echo -e "${GREEN}    You chose not to restart the computer, Installation complete."
    echo -e "${GREEN}                Run startx to get to the login screen"
    echo -e "${GREEN} "
    echo -e "${GREEN} -'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'-'- ${NC}"
fi

# Install Done ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##

# Test Qtile config file.
# python3 ~/.config/qtile/config.py
