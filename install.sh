#!/usr/bin/env bash

# The Qtile Martin Andersen Desktop Environment, Qmade for short.!
# Meant to be run in the Shell on a Debian installation without any desktop environment, just after a clean install.

# bash -c "$(wget -O- https://raw.githubusercontent.com/ITmail-dk/qmade/main/install.sh)"
# or you can run the separate commands...
# sudo apt install -y git && git clone https://github.com/ITmail-dk/qmade && cd qmade && . install.sh

# Resource links to source
# https://qtile.org

# Rofi - Application launcher
# https://github.com/davatorium/rofi
# User scripts - https://github.com/davatorium/rofi/wiki/User-scripts

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

# The default font in the configuration is Noto & Jet Brains Mono.

# Installation Start *_:*:_*:*:_*_*:*:_*::*_*::*_*:_*::*_*:*:_:*:*_*:*:_*:*_:*:#

# Set Echo colors
# for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done
NC="\033[0m"
RED="\033[0;31m"
RED2="\033[38;5;196m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;94m"


# Function to check and exit on error # check_error "TXT"
check_error() {
  if [ $? -ne 0 ]; then
    echo -e "${RED} An error occurred during installation and has been stopped. ${NC}"
    echo -e "${RED} Or you have pressed CTRL + C to cancel. ${NC}"
    echo -e "${RED} Error occurred during $1 ${NC}"
    exit 1
  fi
}

clear #Clear the screen
# Check if it's a Debian system installation and get the version codename.
if [ -f /etc/debian_version ]; then
    . /etc/os-release #Get the VERSION_CODENAME
    VERSION_CODENAME_SHOULD_NOT_BE=trixie
else
    echo -e "${RED} This installation should only be run on a Debian Linux System. ${NC}"
    echo -e "${RED} See more at https://github.com/ITmail-dk/qmade/ ${NC}"
    exit 1
fi


echo -e "${GREEN} ${NC}"
echo -e "${GREEN} "
echo -e "${GREEN}      Starting the QMADE installation"
echo -e "${GREEN}      See more info at https://github.com/ITmail-dk/qmade/"
echo -e "${GREEN}      Enter your user password, to continue if necessary"
echo -e "${GREEN}      Or CTRL + C to cancel the installation"
echo -e "${GREEN} "
echo -e "${GREEN} ${NC}"

# Check and Copy Default APT Sources List
if [ ! -f /etc/apt/sources.list ]; then
    sudo cp /usr/share/doc/apt/examples/sources.list /etc/apt/sources.list
fi
check_error "Copy Default APT Sources list"

# Sudoers ------------------------------------------------------------------------------------------------------------------------------------
# Add User NOPASSWD to shutdown now and reboot
echo "$USER ALL=(ALL) NOPASSWD: /sbin/shutdown now, /sbin/reboot" | sudo tee -a /etc/sudoers.d/$USER && sudo visudo -c -f /etc/sudoers.d/$USER
check_error "Sudo User NOPASSWD to shutdown now and reboot"

# Set sudo password timeout
echo "Defaults timestamp_timeout=25" | sudo tee -a /etc/sudoers.d/$USER && sudo visudo -c -f /etc/sudoers.d/$USER
check_error "Set sudo password timeout"
# -----------------------------------------------------------------------------------------------------------------------------------------

# APT Add - contrib non-free" to the sources list
if [ -f /etc/apt/sources.list ]; then
    if ! grep -q "deb .* contrib non-free" /etc/apt/sources.list; then
        sudo sed -i 's/^deb.* main/& contrib non-free/g' /etc/apt/sources.list
    else
        echo "contrib non-free is already present in /etc/apt/sources.list"
    fi
fi

if [ -f /etc/apt/sources.list.d/debian.sources ]; then
    if ! grep -q "Components:.* contrib non-free non-free-firmware" /etc/apt/sources.list.d/debian.sources; then
        sudo sed -i 's/^Components:* main/& contrib non-free non-free-firmware/g' /etc/apt/sources.list.d/debian.sources
    else
        echo "contrib non-free non-free-firmware is already present in /etc/apt/sources.list.d/debian.sources"
    fi
fi

check_error "Sources list"

# APT Add - apt-transport-https
if ! dpkg -s apt-transport-https >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y apt-transport-https
    sudo sed -i 's+http:+https:+g' /etc/apt/sources.list
fi

# APT Git install
if ! dpkg -s git >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y git
fi

clear #Clear the screen

sudo apt update
clear #Clear the screen
check_error "APT Sources list and APT Update"

# Make .local/bin|src and git clone QMADE
cd ~
mkdir -p ~/.local/bin
mkdir -p ~/.local/src && cd ~/.local/src
git clone https://github.com/ITmail-dk/qmade

clear #Clear the screen
check_error "Make .local/bin|src and git clone QMADE"

# Add Wallpapers
if [ ! -d ~/Wallpapers ]; then
mkdir -p ~/Wallpapers
cp ~/.local/src/qmade/wallpapers/* ~/Wallpapers/ && cd ~
else 
	echo "Wallpapers folder already exists."
fi
clear #Clear the screen
check_error "Add Wallpapers"

# -------------------------------------------------------------------------------------------------
# Core System APT install
sudo DEBIAN_FRONTEND=noninteractive apt -y --ignore-missing install bash-completion xserver-xorg x11-utils xinit arandr autorandr picom fwupd colord mesa-utils htop wget curl git tmux numlockx kitty neovim xdg-utils cups cups-common xsensors xbacklight brightnessctl unzip network-manager dnsutils dunst libnotify-bin notify-osd xsecurelock pm-utils rofi 7zip jq poppler-utils fd-find ripgrep zoxide imagemagick nsxiv mpv flameshot mc thunar gvfs gvfs-backends parted gparted mpd mpc ncmpcpp fzf ccrypt xarchiver notepadqq font-manager fontconfig fontconfig-config fonts-recommended fonts-liberation fonts-freefont-ttf fonts-noto-core libfontconfig1 pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber libspa-0.2-bluetooth pavucontrol alsa-utils qpwgraph sddm-theme-breeze sddm-theme-maui ffmpeg cmake policykit-1 policykit-1-gnome
sudo DEBIAN_FRONTEND=noninteractive apt -y --ignore-missing install linux-headers-$(uname -r)
sudo DEBIAN_FRONTEND=noninteractive apt -y install sddm --no-install-recommends
check_error "Core System APT install"

# APT install extra packages
sudo DEBIAN_FRONTEND=noninteractive apt -y --ignore-missing install remmina libreoffice
clear #Clear the screen
check_error "APT install extra packages"

# Dependencies so the Nordic login theme works
sudo apt install -y --no-install-recommends plasma-workspace plasma-framework
check_error "APT install under plasma-workspace plasma-framework"

if [ -f /usr/share/xsessions/plasma.desktop ]; then
    sudo rm /usr/share/xsessions/plasma.desktop
fi
check_error "Remove plasma.desktop"

# Google Chrome install.
cd /tmp/ && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo DEBIAN_FRONTEND=noninteractive apt install -y /tmp/google-chrome-stable_current_amd64.deb && rm google-chrome-stable_current_amd64.deb
clear #Clear the screen
check_error "Google Chrome install"

# Network Share Components
sudo DEBIAN_FRONTEND=noninteractive apt install -y ceph-common smbclient nfs-common && echo "# CEPH" | sudo tee -a /etc/fstab && echo "#:/  /mnt/cephfs ceph    name=clientNAME,noatime,_netdev    0       0" | sudo tee -a /etc/fstab
clear #Clear the screen
check_error "Network Share Components"

# Check if the CPU is a QEMU Virtual CPU using lscpu
if lscpu | grep -iq "QEMU"; then
    echo "QEMU Virtual CPU detected. Installing xrdp and restarting service..."
    sudo apt update
    sudo DEBIAN_FRONTEND=noninteractive apt install -y xrdp
    sudo systemctl restart xrdp.service
fi
clear #Clear the screen
check_error "Check if the CPU is a QEMU Virtual CPU and install xrdp"

# Check for Bluetooth hardware using lsusb
if lsusb | grep -iq bluetooth; then
    echo "Bluetooth detected, Installing required packages..."
    sudo DEBIAN_FRONTEND=noninteractive apt install -y bluetooth bluez bluez-cups bluez-obexd bluez-meshd pulseaudio-module-bluetooth bluez-firmware blueman
fi
clear #Clear the screen
check_error "Check for Bluetooth hardware and install"

# Check for Logitech hardware using lsusb
# Solaar - Logitech Unifying Receiver - Accessory management for Linux.
if lsusb | grep -iq Logitech; then
    echo "Logitech detected, Installing required packages..."
    sudo DEBIAN_FRONTEND=noninteractive apt install -y solaar
fi
clear #Clear the screen
check_error "Check for Logitech hardware and install"

# Audio Start - https://alsa.opensrc.org - https://wiki.debian.org/ALSA
# See hardware run: "pacmd list-sinks" or "lspci | grep -i audio" or... sudo dmesg  | grep 'snd\|firmware\|audio'
# Run.: "pw-cli info" provides detailed information about the PipeWire nodes and devices, including ALSA devices.
# Test file run: "aplay /usr/share/sounds/alsa/Front_Center.wav"
# sudo adduser $USER audio


# PipeWire Sound Server "Audio" - https://pipewire.org/
systemctl enable --user --now pipewire.socket pipewire-pulse.socket wireplumber.service

# More Audio tools
# sudo DEBIAN_FRONTEND=noninteractive apt install -y alsa-tools

# PulseAudio
# sudo DEBIAN_FRONTEND=noninteractive apt install -y pulseaudio
# systemctl --user enable pulseaudio

# sudo alsactl init
clear #Clear the screen
check_error "Audio Core System APT install"


# CPU Microcode install
export LC_ALL=C # All subsequent command output will be in English
CPUVENDOR=$(lscpu | grep "Vendor ID:" | awk '{print $3}')

if [ "$CPUVENDOR" == "GenuineIntel" ]; then
    if ! dpkg -s intel-microcode >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y intel-microcode
    fi
else
    echo -e "${GREEN} Intel Microcode OK ${NC}"
fi

if [ "$CPUVENDOR" == "AuthenticAMD" ]; then
    if ! dpkg -s amd64-microcode >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y amd64-microcode
    fi
else
    echo -e "${GREEN} Amd64 Microcode OK ${NC}"
fi
unset LC_ALL # unset the LC_ALL=C

clear #Clear the screen
check_error "CPU Microcode install"

# Alias echo to ~/.bashrc or ~/.bash_aliases
BASHALIASFILE=~/.bashrc

echo 'alias ls="ls --color=auto --group-directories-first -v -lah"' >> $BASHALIASFILE
echo 'alias ll="ls --color=auto --group-directories-first -v -lah"' >> $BASHALIASFILE

echo 'alias df="df -h"' >> $BASHALIASFILE

echo 'alias neofetch="fastfetch"' >> $BASHALIASFILE

echo 'alias upup="sudo apt update && sudo apt upgrade -y && sudo apt clean && sudo apt autoremove -y"' >> $BASHALIASFILE

echo 'bind '"'"'"\C-f":"open "$(fzf)"\n"'"'" >> $BASHALIASFILE
echo 'alias lsman="compgen -c | fzf | xargs man"' >> $BASHALIASFILE

echo 'alias qtileconfig="nano ~/.config/qtile/config.py"' >> $BASHALIASFILE
echo 'alias qtileconfig-test="python3 .config/qtile/config.py"' >> $BASHALIASFILE
echo 'alias qtileconfig-test-venv="source .local/src/qtile_venv/bin/activate && python3 .config/qtile/config.py && deactivate"' >> $BASHALIASFILE

echo 'alias vi="nvim"' >> $BASHALIASFILE

clear #Clear the screen
check_error "Alias echo"


# Set User folders via xdg-user-dirs-update & xdg-mime default.
# ls /usr/share/applications/ Find The Default run.: "xdg-mime query default inode/directory"

xdg-user-dirs-update

xdg-mime default kitty.desktop text/x-shellscript
xdg-mime default nsxiv.desktop image/jpeg
xdg-mime default nsxiv.desktop image/png
xdg-mime default thunar.desktop inode/directory

check_error "xdg-user-dirs-update and xdg-mime"

sudo rm /usr/share/sddm/faces/.face.icon
sudo rm /usr/share/sddm/faces/root.face.icon

sudo wget -O /usr/share/sddm/faces/root.face.icon https://github.com/ITmail-dk/qmade/blob/main/root.face.icon?raw=true
sudo wget -O /usr/share/sddm/faces/.face.icon https://github.com/ITmail-dk/qmade/blob/main/.face.icon?raw=true
wget -O ~/.face.icon https://github.com/ITmail-dk/qmade/blob/main/.face.icon?raw=true

setfacl -m u:sddm:x ~/
setfacl -m u:sddm:r ~/.face.icon

sudo setfacl -m u:sddm:x /usr/share/sddm/faces/
sudo setfacl -m u:sddm:r /usr/share/sddm/faces/.face.icon
sudo setfacl -m u:sddm:r /usr/share/sddm/faces/root.face.icon

check_error "Set User .face.icon file"

sudo mkdir -p /etc/sddm.conf.d
sudo bash -c 'cat << "SDDMCONFIG" >> /etc/sddm.conf.d/default.conf
[Theme]
# Set Current theme "name" breeze, maui, Nordic-darker
Current=breeze

[Wayland]
EnableHiDPI=true

[X11]
EnableHiDPI=true

SDDMCONFIG'

sudo chmod 777 /usr/share/sddm/themes/breeze/theme.conf
# Set login wallpape under background=/ in /usr/share/sddm/themes/breeze/theme.conf
#/usr/share/wallpapers/login-wallpape.jpg


clear #Clear the screen
check_error "Setup SDDM Login"

# Midnight-Commander ini file
mkdir -p ~/.config/mc
cat << "MCINI" > ~/.config/mc/ini
[Midnight-Commander]
skin=nicedark

MCINI
check_error "Setup Midnight-Commander ini file"

# Qtile Core Dependencies apt install
sudo DEBIAN_FRONTEND=noninteractive apt install -y feh python3-full python3-pip python3-venv pipx libxkbcommon-dev libxkbcommon-x11-dev libcairo2-dev pkg-config
clear #Clear the screen
check_error "Qtile Core Dependencies apt install"

# Install Qtile from source via github and Pip
cd ~
mkdir -p ~/.local/bin
mkdir -p ~/.local/src

# Python3 venv Qtile install
cd /opt/
sudo python3 -m venv qtile_venv
sudo chmod -R 777 /opt/qtile_venv
cd /opt/qtile_venv

if [ -d qtile ]; then
    sudo rm -rf qtile
fi

git clone https://github.com/qtile/qtile.git

source bin/activate
pip install dbus-next psutil wheel pyxdg
pip install -r qtile/requirements.txt
bin/pip install qtile/.
# PyWAL install via pip3 for auto-generated color themes
pip3 install pywal16[all]
deactivate

sudo cp bin/qtile /usr/local/bin/
sudo cp bin/wal /usr/local/bin/
clear #Clear the screen
check_error "Install Qtile and PyWAL from qtile_venv"


# OLD QTILE INSTALL
#cd ~/.local/src
#python3 -m venv qtile_venv && cd ~/.local/src/qtile_venv

#if [ -d qtile ]; then
#    rm -rf qtile
#fi

#git clone https://github.com/qtile/qtile.git

#source bin/activate
#pip install dbus-next psutil wheel pyxdg
#pip install -r qtile/requirements.txt
#bin/pip install qtile/.
#deactivate

#sudo cp bin/qtile /usr/local/bin/
#cp ~/.local/src/qtile_venv/bin/qtile ~/.local/bin/
#clear #Clear the screen
#check_error "Install Qtile from qtile_venv"

# if error "no module named pip" activate the virtual environment and run: python3 -m ensurepip --upgrade

# OLD INSTALL
# PyWAL install via pipx for auto-generated color themes
#pipx install pywal16

# wal --cols16 darken -q -i ~/Wallpapers
# wal --cols16 darken -q -i ~/Wallpapers --backend modern_colorthief
#clear #Clear the screen
#check_error "PyWAL Pipx install"

mkdir -p ~/.cache/wal
cat << "PYWALCOLORSJSON" > ~/.cache/wal/colors.json
{
    "checksum": "85abc768e55abc92396e0c76280093cc",
    "wallpaper": "/home/mara/Wallpapers/default_wallpaper.jpg",
    "alpha": "100",

    "special": {
        "background": "#06090c",
        "foreground": "#c0c1c2",
        "cursor": "#c0c1c2"
    },
    "colors": {
        "color0": "#06090c",
        "color1": "#1f384b",
        "color2": "#304d5c",
        "color3": "#375d6e",
        "color4": "#4e5b61",
        "color5": "#526870",
        "color6": "#66767a",
        "color7": "#899195",
        "color8": "#555f68",
        "color9": "#2a4b64",
        "color10": "#40677b",
        "color11": "#4a7d93",
        "color12": "#687a82",
        "color13": "#6e8b96",
        "color14": "#889ea3",
        "color15": "#c0c1c2"
    }
}

PYWALCOLORSJSON
clear #Clear the screen
check_error "pywal colors json"

mkdir -p ~/.config/kitty/themes
mkdir -p ~/.cache/wal/
cat << "PYWALCOLORSKITTY" > ~/.cache/wal/colors-kitty.conf
foreground         #c0c1c2
background         #06080b
background_opacity 0.98
cursor             #c0c1c2

active_tab_foreground     #06080b
active_tab_background     #c0c1c2
inactive_tab_foreground   #c0c1c2
inactive_tab_background   #06080b

active_border_color   #c0c1c2
inactive_border_color #06080b
bell_border_color     #1b394e

color0       #06080b
color8       #555b67
color1       #1b394e
color9       #244d68
color2       #245067
color10      #306b8a
color3       #33667f
color11      #4589aa
color4       #4e606e
color12      #698193
color5       #557384
color13      #729ab0
color6       #6c818e
color14      #91adbe
color7       #898d95
color15      #c0c1c2

PYWALCOLORSKITTY

ln -s ~/.cache/wal/colors-kitty.conf ~/.config/kitty/themes/current-theme.conf

# PyWal kitty template
mkdir -p ~/.config/wal/templates/
cat << "PYWALCOLORSTEMPALETKITTY" > ~/.config/wal/templates/colors-kitty.conf
foreground         {foreground}
background         {background}
background_opacity 0.98
cursor             {cursor}

active_tab_foreground     {background}
active_tab_background     {foreground}
inactive_tab_foreground   {foreground}
inactive_tab_background   {background}

active_border_color   {foreground}
inactive_border_color {background}
bell_border_color     {color1}

color0       {color0}
color8       {color8}
color1       {color1}
color9       {color9}
color2       {color2}
color10      {color10}
color3       {color3}
color11      {color11}
color4       {color4}
color12      {color12}
color5       {color5}
color13      {color13}
color6       {color6}
color14      {color14}
color7       {color7}
color15      {color15}

PYWALCOLORSTEMPALETKITTY
clear #Clear the screen
check_error "pywal colors kitty"

cat << "PYWALCOLORSTEMPALETROFI" > ~/.config/wal/templates/colors-rofi-dark.rasi
* {{
    active-background: {color2};
    active-foreground: @foreground;
    normal-background: @background;
    normal-foreground: @foreground;
    urgent-background: {color1};
    urgent-foreground: @foreground;

    alternate-active-background: @background;
    alternate-active-foreground: @foreground;
    alternate-normal-background: @background;
    alternate-normal-foreground: @foreground;
    alternate-urgent-background: @background;
    alternate-urgent-foreground: @foreground;

    selected-active-background: {color1};
    selected-active-foreground: @foreground;
    selected-normal-background: {color2};
    selected-normal-foreground: @foreground;
    selected-urgent-background: {color3};
    selected-urgent-foreground: @foreground;

    background-color: @background;
    background: {background};
    foreground: {foreground};
    border-color: @background;
    spacing: 2;
}}

#window {{
    width: 30%;
    background-color: @background;
    border: 0;
    padding: 2.5ch;
}}

#mainbox {{
    border: 0;
    padding: 0;
    background-color: @background;
    children: [inputbar, listview];
}}

#message {{
    border: 2px 0px 0px;
    border-color: @border-color;
    padding: 1px;
}}

#textbox {{
    text-color: @foreground;
}}

#inputbar {{
    children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
}}

#textbox-prompt-colon {{
    expand: false;
    str: ":";
    margin: 0px 0.3em 0em 0em;
    text-color: @normal-foreground;
}}

#listview {{
    fixed-height: 0;
    border: 2px 0px 0px;
    border-color: @border-color;
    spacing: 2px;
    scrollbar: true;
    padding: 2px 0px 0px;
}}

#element {{
    border: 0;
    padding: 8 0;
}}

#element-text {{
    background-color: inherit;
    text-color:       inherit;
}}

#element-icon {{
    size: 30;
}}

#element.normal.normal {{
    background-color: @normal-background;
    text-color: @normal-foreground;
}}

#element.normal.urgent {{
    background-color: @urgent-background;
    text-color: @urgent-foreground;
}}

#element.normal.active {{
    background-color: @active-background;
    text-color: @active-foreground;
}}

#element.selected.normal {{
    background-color: @selected-normal-background;
    text-color: @selected-normal-foreground;
}}

#element.selected.urgent {{
    background-color: @selected-urgent-background;
    text-color: @selected-urgent-foreground;
}}

#element.selected.active {{
    background-color: @selected-active-background;
    text-color: @selected-active-foreground;
}}

#element.alternate.normal {{
    background-color: @alternate-normal-background;
    text-color: @alternate-normal-foreground;
}}

#element.alternate.urgent {{
    background-color: @alternate-urgent-background;
    text-color: @alternate-urgent-foreground;
}}

#element.alternate.active {{
    background-color: @alternate-active-background;
    text-color: @alternate-active-foreground;
}}

#scrollbar {{
    width: 4px;
    border: 0;
    handle-width: 8px;
    padding: 0;
}}

#sidebar {{
    border: 2px 0px 0px;
    border-color: @border-color;
}}

#button {{
    text-color: @normal-foreground;
}}

#button.selected {{
    background-color: @selected-normal-background;
    text-color: @selected-normal-foreground;
}}

#inputbar {{
    spacing: 0;
    text-color: @normal-foreground;
    padding: 1px;
}}

#case-indicator {{
    spacing: 0;
    text-color: @normal-foreground;
}}

#entry {{
    spacing: 0;
    text-color: @normal-foreground;
}}

#prompt {{
    spacing: 0;
    text-color: @normal-foreground;
}}

PYWALCOLORSTEMPALETROFI
clear #Clear the screen
check_error "pywal colors rofi"

# Set xdg-desktop-portal prefer dark mode.
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
clear #Clear the screen
check_error "gsettings set color-scheme"


# auto-new-wallpaper-and-colors BIN
sudo bash -c 'cat << "AUTONEWWALLPAPERANDCOLORSBIN" >> /usr/local/bin/auto-new-wallpaper-and-colors
#!/usr/bin/env bash

wal --cols16 darken -q -i ~/Wallpapers --backend haishoku
# Backends: colorz, colorthief, fast_colorthief, okthief, schemer2, haishoku, modern_colorthief, wal

notify-send -u low "Automatically new background and color theme" "Please wait while i find a new background image and some colors to match"

qtile cmd-obj -o cmd -f reload_config
kitty +kitten themes --reload-in=all current-theme

notify-send -u low "Automatically new background and color theme" "The background image and colors has been updated."

AUTONEWWALLPAPERANDCOLORSBIN'

sudo chmod +x /usr/local/bin/auto-new-wallpaper-and-colors
clear #Clear the screen
check_error "auto-new-wallpaper-and-colors bin"


#Midnight Commander
mkdir -p ~/.config/mc
echo "skin=dark" >> ~/.config/mc/ini
clear #Clear the screen
check_error "Midnight Commander config"


# ------------------------------------------------------------------------

sudo mkdir -p /usr/share/xsessions/
sudo bash -c 'cat << "QTILEDESKTOP" >> /usr/share/xsessions/qtile.desktop
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Exec=qtile start
Type=Application
Keywords=wm;tiling
QTILEDESKTOP'

# Add to user .xsession
echo "qtile start" > ~/.xsession
echo "qtile start" | sudo tee -a "/etc/skel/.xsession" > /dev/null
clear #Clear the screen
check_error "Add Qtile .xsession"

# Qtile Autostart.sh file
mkdir -p ~/.config/qtile/
if [ ! -f ~/.config/qtile/autostart.sh ]; then
cat << "QTILEAUTOSTART" > ~/.config/qtile/autostart.sh
#!/usr/bin/env bash
# Picom - https://manpages.ubuntu.com/manpages/plucky/man1/picom.1.html
pgrep -x picom > /dev/null || picom --backend xrender --vsync & # Picom use... --backend glx or xrender, --vsync --no-vsync,

exec /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 & # Graphical authentication agent

autorandr --change &&

# This here if statement sets your background image, with feh...
# and is also used for the auto-generation of the background image and colors.
if [ -f ~/.fehbg ]; then
    . ~/.fehbg
else
    auto-new-wallpaper-and-colors
    #feh --bg-scale $(find ~/Wallpapers -type f | shuf -n 1)
fi

wpctl set-volume @DEFAULT_AUDIO_SINK@ 10% &
dunst &
numlockx on &
mpd &
xrdb ~/.Xresources &
xset r rate 200 35 &
xset b off &

QTILEAUTOSTART

chmod +x ~/.config/qtile/autostart.sh

else
	echo "File autostart.sh already exists."
fi
clear #Clear the screen
check_error "Qtile Autostart.sh file"


# Synaptics devices
if grep -iq 'synaptics|synap' /proc/bus/input/devices; then
    echo "Synaptics touchpad detected. Installing xserver-xorg-input-synaptics and configuring autostart..."
    sudo DEBIAN_FRONTEND=noninteractive apt install -y xserver-xorg-input-synaptics
    check_error "Failed to install xserver-xorg-input-synaptics"

    cat << EOF | tee -a "~/.config/qtile/autostart.sh" > /dev/null
# Synaptics - Touchpad left click and right click.
synclient TapButton1=1 TapButton2=3 &
EOF
fi
clear #Clear the screen
check_error "Add Synaptics Autostart.sh file"


# APT install under Unstable and Testing
if [[ "$VERSION_CODENAME" == "$VERSION_CODENAME_SHOULD_NOT_BE" ]]; then
	echo "Your version of Debian is not compatible with This package"
else
    sudo DEBIAN_FRONTEND=noninteractive apt install -y freerdp2-x11 libfreerdp-client2-2 libfreerdp2-2 libwinpr2-2
	sudo DEBIAN_FRONTEND=noninteractive apt -y --ignore-missing install xautolock speedcrunch fonts-arkpandora
    echo "# Lock the computer automatically after X time of minutes, using xautolock and xsecurelock." | tee -a ~/.config/qtile/autostart.sh
    echo 'xautolock -time 120 -locker "xsecurelock" -detectsleep -secure &' | tee -a ~/.config/qtile/autostart.sh
fi
clear #Clear the screen
check_error "APT install under Unstable and Testing"


# MPD Setup & config START

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
clear #Clear the screen
check_error "MPD Setup & config"

# Nano config START
if [ ! -f ~/.nanorc ]; then
    cp /etc/nanorc ~/.nanorc
    #sed -i 's/^# set linenumbers/set linenumbers/' ~/.nanorc
    sed -i 's/^# set minibar/set minibar/' ~/.nanorc
    sed -i 's/^# set softwrap/set softwrap/' ~/.nanorc
    sed -i 's/^# set atblanks/set atblanks/' ~/.nanorc
else
	echo "File .nanorc already exists."
fi
check_error "Nano config"


# Neovim config Start

if [ ! -f ~/.config/nvim/init.vim ]; then
mkdir -p ~/.config/nvim
cat << "NEOVIMCONFIG" > ~/.config/nvim/init.vim
syntax on
set number
set numberwidth=5
set relativenumber
set ignorecase
NEOVIMCONFIG

else
	echo "Neovim config file already exists."
fi
clear #Clear the screen
check_error "Neovim config"

# Kitty theme.conf Start

if [ ! -f ~/.cache/wal/colors-kitty.conf ]; then
mkdir -p ~/.cache/wal
cat << "KITTYTHEMECONF" > ~/.cache/wal/colors-kitty.conf
background #1e3143
foreground #cec7bc
color0 #1e3143
color1 #708191
color2 #bcc2be
color3 #9ea5a3
color4 #717c7a
color5 #a9a5a8
color6 #788483
color7 #c1c6c3
color8 #254657
color9 #496c80
color10 #28415a
color11 #b1aea6
color12 #849aa3
color13 #c6c0b6
color14 #648896
color15 #cec7bc

KITTYTHEMECONF

else
	echo "kittytheme.conf file already exists."
fi
clear #Clear the screen
check_error "Kitty config"

# Tmux config Start

if [ ! -f ~/.config/tmux/tmux.conf ]; then
mkdir -p ~/.config/tmux
cat << "TMUXCONFIG" > ~/.config/tmux/tmux.conf
unbind r
bind r source-file ~/.config/tmux/tmux.conf

TMUXCONFIG

else
	echo "Tmux config file already exists."
fi
clear #Clear the screen
check_error "Tmux config"

# -------------------------------------------------------------------------------------------------

#echo -e "${YELLOW} Xresources config Start ${NC}"

#if [ ! -f ~/.Xresources ]; then

#cat << "XRCONFIG" > ~/.Xresources

#XRCONFIG

#else 
#	echo ".Xresources config file already exists."
#fi


# Themes START
# Nerd Fonts - https://www.nerdfonts.com/font-downloads - https://www.nerdfonts.com/cheat-sheet
# RUN "fc-list" to list the fonts install on the system.
if [ ! -d /usr/share/fonts ]; then
sudo mkdir -p /usr/share/fonts

else
	echo "fonts folder already exists."
fi

#JetBrainsMono (The default front in the configuration)
curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
sudo unzip -n "JetBrainsMono.zip" -d "/usr/share/fonts/JetBrainsMono/"
rm JetBrainsMono.zip
sudo rm -f /usr/share/fonts/JetBrainsMono/*.md
sudo rm -f /usr/share/fonts/JetBrainsMono/*.txt
sudo rm -f /usr/share/fonts/JetBrainsMono/LICENSE

#RobotoMono
curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip"
sudo unzip -n "RobotoMono.zip" -d "/usr/share/fonts/RobotoMono/"
rm RobotoMono.zip
sudo rm -f /usr/share/fonts/RobotoMono/*.md
sudo rm -f /usr/share/fonts/RobotoMono/*.txt
sudo rm -f /usr/share/fonts/RobotoMono/LICENSE

sudo rm -f /usr/share/fonts/*.md
sudo rm -f /usr/share/fonts/*.txt
sudo rm -f /usr/share/fonts/LICENSE
clear #Clear the screen
check_error "Themes Nerd Fonts"

# Set the default font family to Noto in the /etc/fonts/local.conf file.
if [ ! -f /etc/fonts/local.conf ]; then
sudo mkdir -p  /etc/fonts
sudo bash -c 'cat << "FONTSLOCALCONFIG" >> /etc/fonts/local.conf
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <match>
        <edit mode="prepend" name="family"><string>Noto Sans</string></edit>
    </match>
    <match target="pattern">
        <test qual="any" name="family"><string>serif</string></test>
        <edit name="family" mode="assign" binding="same"><string>Noto Serif</string></edit>
    </match>
    <match target="pattern">
        <test qual="any" name="family"><string>sans-serif</string></test>
        <edit name="family" mode="assign" binding="same"><string>Noto Sans</string></edit>
    </match>
    <match target="pattern">
        <test qual="any" name="family"><string>monospace</string></test>
        <edit name="family" mode="assign" binding="same"><string>Noto Mono</string></edit>
    </match>
   <match target="pattern">
      <test qual="any" name="family"><string>Source Code Pro</string></test>
      <edit name="antialias" mode="assign"><bool>false</bool></edit>
   </match>
</fontconfig>

FONTSLOCALCONFIG'

else
	echo "fonts local.conf file already exists."
fi
clear #Clear the screen
check_error "Themes Fonts local.conf"

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

#sudo rm /usr/share/sddm/themes/debian-theme
#sudo mkdir -p /usr/share/sddm/themes/debian-theme/
#sudo cp -r /tmp/EliverLara-Nordic/kde/sddm/Nordic-darker/* /usr/share/sddm/themes/debian-theme/

sudo mkdir -p /usr/share/sddm/themes/Nordic-darker/
sudo cp -r /tmp/EliverLara-Nordic/kde/sddm/Nordic-darker/* /usr/share/sddm/themes/Nordic-darker/


# Nordzy-cursors --------------------------------------------------------

# https://github.com/alvatip/Nordzy-cursors

cd /tmp/
if [ -d Nordzy-cursors ]; then
    sudo rm -rf Nordzy-cursors
fi

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

if [ -d Nordzy-icon ]; then
    sudo rm -rf Nordzy-icon
fi

git clone https://github.com/alvatip/Nordzy-icon
cd Nordzy-icon/
sudo ./install.sh
cd /tmp/


# GTK Settings START --------------------------------------------------------
# /etc/gtk-3.0/settings.ini
# https://docs.gtk.org/gtk4/property.Settings.gtk-cursor-theme-name.html
if [ ! -d /etc/gtk-3.0 ]; then
sudo kdir -p /etc/gtk-3.0

else
	echo "/etc/gtk-3.0 already exists."
fi

sudo bash -c 'cat << "GTK3SETTINGS" >> /etc/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=EliverLara-Nordic
gtk-fallback-icon-theme=default
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-font-name=JetBrainsMono Nerd Font 10
gtk-application-prefer-dark-theme=1
gtk-cursor-theme-name=Nordzy-cursors
gtk-cursor-theme-size=0
gtk-icon-theme-name=Nordzy-icon
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
GTK3SETTINGS'

if [ ! -d /etc/gtk-4.0 ]; then
sudo mkdir -p /etc/gtk-4.0

else
	echo "/etc/gtk-4.0 already exists."
fi

sudo bash -c 'cat << "GTK4SETTINGS" >> /etc/gtk-4.0/settings.ini
[Settings]
gtk-theme-name=EliverLara-Nordic
gtk-fallback-icon-theme=default
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-font-name=JetBrainsMono Nerd Font 10
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
clear #Clear the screen
check_error "GTK Settings & Fonts"

# -------------------------------------------------------------------------------------------------

# xrandr-set-max + Xsession START

if [ ! -f /usr/local/bin/xrandr-set-max ]; then
# Define the content of the script
xrandrsetmaxcontent=$(cat << "XRANDRSETMAX"
#!/usr/bin/env bash

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
#sudo sed -i '$a\. /usr/local/bin/xrandr-set-max' /usr/share/sddm/scripts/Xsession

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
clear #Clear the screen
check_error "xrandr-set-max file"
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------

# Rofi Run menu START
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

/* The Theme */
@import "~/.cache/wal/colors-rofi-dark.rasi"

// Theme location is "/usr/share/rofi/themes/name.rasi"
//@theme "/usr/share/rofi/themes/Arc-Dark.rasi"

ROFICONFIG

else
	echo "Rofi config file already exists."
fi


# Rofi Wifi menu
# https://github.com/ericmurphyxyz/rofi-wifi-menu/tree/master

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
clear #Clear the screen
check_error "Rofi Run menu"

if [ ! -f /location/powermenu.sh ]; then
mkdir -p  ~/.config/rofi
cat << "ROFIPOWERMENU" > ~/.config/rofi/powermenu.sh
#!/usr/bin/env bash
chosen=$(printf "󰒲  Suspend System\n  System Shutdown\n󰤄  Hibernate System\n  Lockdown Mode\n  Reboot" | rofi -dmenu -i -theme-str '@import "powermenu.rasi"')

case "$chosen" in
	"󰒲  Suspend System") sudo systemctl suspend ;;
    "  System Shutdown") sudo shutdown now ;;
    "󰤄  Hibernate System") sudo systemctl hibernate ;;
	"  Lockdown Mode") xsecurelock ;;
	"  Reboot") sudo reboot ;;
	*) exit 1 ;;
esac

ROFIPOWERMENU

else
	echo "powermenu.sh file already exists."
fi

chmod +x ~/.config/rofi/powermenu.sh
clear #Clear the screen
check_error "Rofi Powermenu"

if [ ! -f ~/.config/rofi/powermenu.rasi ]; then
mkdir -p  ~/.config/rofi
cat << "ROFIPOWERMENURASI" > ~/.config/rofi/powermenu.rasi

inputbar {
  children: [entry];
}

listview {
	lines: 5;
}

ROFIPOWERMENURASI

else
	echo "powermenu.rasi file already exists."
fi
clear #Clear the screen
check_error "Rofi Powermenu rasi"

# Add xfce4 file helpers
if [ ! -f ~/.config/xfce4/helpers.rc ]; then
mkdir -p ~/.config/xfce4
cat << "XFCE4HELPER" > ~/.config/xfce4/helpers.rc
FileManager=Thunar
TerminalEmulator=kitty
WebBrowser=google-chrome
MailReader=

XFCE4HELPER

else
	echo "xfce4 helper config file already exists."
fi
clear #Clear the screen
check_error "xfce4 helpers.rc"

# Add kitty to open nvim and vim.
if [ -f /usr/share/applications/nvim.desktop ]; then
sudo sed -i 's/Exec=nvim %F/Exec=kitty -e nvim %F/' /usr/share/applications/nvim.desktop
else
	echo "no nvim.desktop file"
fi

if [ -f /usr/share/applications/vim.desktop ]; then
sudo sed -i 's/Exec=vim %F/Exec=kitty -e vim %F/' /usr/share/applications/vim.desktop
else
	echo "no vim.desktop file"
fi
clear #Clear the screen
check_error "Add kitty to open nvim and vim"

# # # # # # # # # # #
# Kitty config file.

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

font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto

font_size 13
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

#mouse_map right click paste_from_clipboard

url_color #0087bd
url_style curly

open_url_with default

url_prefixes http https file ftp gemini irc gopher mailto news git

detect_urls yes

#url_excluded_characters 

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

#resize_draw_strategy static

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

include ~/.cache/wal/colors-kitty.conf

KITTYCONFIG

else
	echo "Kitty config already exists."
fi
clear #Clear the screen
check_error "Kitty config file"

# -------------------------------------------------------------------------------------------------
# Check for Nvidia graphics card and install drivers ----------------------------------------------

if lspci | grep -i nvidia; then

    echo "Installing required packages..."
    sudo apt -y install linux-headers-$(uname -r)
    sudo apt -y install gcc make acpid dkms libglvnd-core-dev libglvnd0 libglvnd-dev
    check_error "package installation"

    echo "Blacklisting nouveau..."
    BLACKLIST_CONF="/etc/modprobe.d/blacklist.conf"
    echo "blacklist nouveau" | sudo tee -a $BLACKLIST_CONF
    check_error "blacklisting nouveau"

    echo "Removing old NVIDIA drivers..."
    sudo apt remove -y nvidia-* && sudo apt autoremove -y $(dpkg -l nvidia-driver* | grep ii | awk '{print $2}')
    check_error "removal of old NVIDIA drivers"

    echo "Enabling i386 architecture and installing 32-bit libraries..."
    sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install -y libc6:i386
    check_error "installation of i386 libraries"

    echo "Updating GRUB configuration..."
    GRUB_CONF="/etc/default/grub"
    sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ rd.driver.blacklist=nouveau"/' $GRUB_CONF
    check_error "updating GRUB configuration"
    sudo update-grub
    check_error "GRUB update"

    #NVIDIAGETVERSION=570.133.07
    NVIDIAGETVERSION="$(curl -s "https://www.nvidia.com/en-us/drivers/unix/" | grep "Latest Production Branch Version:" | awk -F'"> ' '{print $2}' | cut -d'<' -f1 | awk 'NR==1')"
    echo "Downloading and installing NVIDIA $NVIDIAGETVERSION driver..."
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIAGETVERSION/NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run
    check_error "downloading NVIDIA driver"

    chmod +x NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run
    sudo ./NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run --no-questions --run-nvidia-xconfig
    
    echo 'nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"' >> ~/.config/qtile/autostart.sh
fi
clear #Clear the screen
check_error "NVIDIA driver installation"

# Qtile Config file

if [ ! -f ~/.config/qtile/config.py ]; then

cat << "QTILECONFIG" > ~/.config/qtile/config.py
# Qtile Config - Start
# https://docs.qtile.org/en/latest/index.html
# -',.-'-,.'-,'.-',.-',-.'-,.'-,.'-,.'-,'.-',.-'-

import os
import subprocess
import json
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown, re
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal # terminal = guess_terminal()


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

#Pywal Colors
colors = os.path.expanduser("~/.cache/wal/colors.json")
colordict = json.load(open(colors))
Color0 = colordict["colors"]["color0"]
Color1 = colordict["colors"]["color1"]
Color2 = colordict["colors"]["color2"]
Color3 = colordict["colors"]["color3"]
Color4 = colordict["colors"]["color4"]
Color5 = colordict["colors"]["color5"]
Color6 = colordict["colors"]["color6"]
Color7 = colordict["colors"]["color7"]
Color8 = colordict["colors"]["color8"]
Color9 = colordict["colors"]["color9"]
Color10 = colordict["colors"]["color10"]
Color11 = colordict["colors"]["color11"]
Color12 = colordict["colors"]["color12"]
Color13 = colordict["colors"]["color13"]
Color14 = colordict["colors"]["color14"]
Color15 = colordict["colors"]["color15"]

# Colors use example active=Color1,


mod = "mod4"
terminal = "kitty -o background_opacity=0.95"
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
    Key([mod, "mod1"], "l", lazy.spawn(os.path.expanduser("xsecurelock")), desc="Computer Lockdown"),
    Key([mod, "control", "mod1"], "t", lazy.spawn(os.path.expanduser("auto-new-wallpaper-and-colors")), desc="Random Color Theme from Wallpapers"),
    Key([mod, "control", "mod1"], "w", lazy.spawn(os.path.expanduser("~/.config/rofi/rofi-wifi-menu.sh")), desc="WiFi Manager"),
    Key([mod, "control", "mod1"], "p", lazy.spawn(os.path.expanduser("~/.config/rofi/powermenu.sh")), desc="Power Menu"),
    Key([mod, "control", "mod1"], "n", lazy.spawn(os.path.expanduser("kitty -e sudo nmtui")), desc="Network Manager"),

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
    Key([mod, "mod1"], "Up", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"), desc='Volume Up'),
    Key([mod, "mod1"], "Down", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc='Volume Down'),
    Key([mod, "mod1"], "m", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc='Volume Mute Toggle'),

    # XF86 Audio & Brightness keys
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"), desc='Volume Up'),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc='Volume Down'),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc='Volume Mute Toggle'),
# mute/unmute the microphone - wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
# Show volume level - wpctl get-volume @DEFAULT_AUDIO_SINK@

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc='Play-Pause'),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc='Previous'),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc='Next'),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%"), desc='Brightness UP'),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-"), desc='Brightness Down'),
    Key([], "Print", lazy.spawn("bash -c 'flameshot gui --path ~/Screenshots'"), desc='Screenshot'),
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
# nf-fa-volume_high   nf-fa-volume_low  nf-fa-volume_xmark 
# nf-md-pac_man 󰮯 nf-md-ghost 󰊠 nf-fa-circle  nf-cod-circle_large  nf-cod-circle_filled  nf-md-circle_small 󰧟 nf-md-circle_medium 󰧞 

# Group Match example:
# Group("1", label="", layout="monadtall", matches=[Match(wm_class=re.compile(r"^(Google\-chrome)$"))]),

groups = [
    Group("1", label="", layout="monadtall"),
    Group("2", label="", layout="monadtall"),
    Group("3", label="", layout="monadtall"),
    Group("4", label="", layout="monadtall"),
    Group("5", label="", layout="monadtall"),
    Group("6", label="", layout="monadtall"),
    Group("7", label="", layout="monadtall"),
    Group("8", label="", layout="monadtall"),
    Group("9", label="", layout="monadtall"),
    Group("0", label="", layout="monadtall"),
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
            "border_focus": Color6,
            "border_normal": Color2
            }

layout_theme = init_layout_theme()

layouts = [
    layout.MonadTall(ratio=0.65, **layout_theme),
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
    font="JetBrainsMono Nerd Font",
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
                widget.GroupBox(fontsize=18, highlight_method="text", this_current_screen_border="#f7f7f7", highlight_color=Color14, this_screen_border=Color3, urgent_border=Color7, active=Color5, inactive=Color8, rounded="False", borderwidth=0),
                widget.Spacer(length=9),
                widget.Prompt(),
                widget.Spacer(),
                widget.WindowName(width=bar.CALCULATED, max_chars=120),
                widget.Spacer(),
                widget.Systray(fmt="󱊖  {}", icon_size=16),
                # NB Wayland is incompatible with Systray, consider using StatusNotifier
                # widget.StatusNotifier(icon_size=16),
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
            background=Color0, opacity=0.90, # Bar background color can also take transparency with "hex color code" or 0.XX
            margin=[5, 5, 0, 5], # Space around bar as int or list of ints [N E S W]
            border_width=[0, 0, 0, 0], # Width of border as int of list of ints [N E S W]
            border_color=[Color2, Color2, Color2, Color2] # Border colour as str or list of str [N E S W]
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
        #wallpaper="~/Wallpapers/default-wallpaper.png",
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
    ],
    no_reposition_rules=[
        Match(wm_class="pavucontrol"),
    ],
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
clear #Clear the screen
check_error "Qtile Config file"




# ---------------------------------------------------------------------------------------
cd /tmp/

# FastFetch Install.
FASTFETCH_VERSION=2.40.3
wget https://github.com/fastfetch-cli/fastfetch/releases/download/$FASTFETCH_VERSION/fastfetch-linux-amd64.deb && sudo dpkg -i fastfetch-linux-amd64.deb && rm fastfetch-linux-amd64.deb
clear #Clear the screen
check_error "FastFetch install"


# WaterFox install - https://www.waterfox.net/download/
WATERFOX_VERSION=6.5.7
wget -O waterfox.tar.bz2 https://cdn1.waterfox.net/waterfox/releases/$WATERFOX_VERSION/Linux_x86_64/waterfox-$WATERFOX_VERSION.tar.bz2
tar -xvf waterfox.tar.bz2
sudo mv waterfox /opt/
sudo chown -R root:root /opt/waterfox/

cat << EOF | sudo tee "/usr/share/applications/waterfox.desktop" > /dev/null
[Desktop Entry]
Name=Waterfox
Exec=/opt/waterfox/waterfox
Icon=/opt/waterfox/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
EOF

sudo ln -s /opt/waterfox/waterfox /usr/bin/waterfox

clear #Clear the screen
check_error "WaterFox install"


# Yazi File Manager
# https://github.com/sxyazi/yazi/releases/latest
YAZI_VERSION=v25.4.8
wget https://github.com/sxyazi/yazi/releases/download/$YAZI_VERSION/yazi-x86_64-unknown-linux-musl.zip
unzip yazi-x86_64-unknown-linux-musl.zip
sudo cp yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/
sudo chown root:root /usr/local/bin/yazi
sudo chmod +x /usr/local/bin/yazi

clear #Clear the screen
check_error "Yazi File Manager install"


# Remove .first-login file --------------------------------------------------------------
if [ -f ~/.first-login ]; then
    rm ~/.first-login
fi

# Edit GRUB BOOT TIMEOUT ----------------------------------------------------------------
sudo sed -i 's+GRUB_TIMEOUT=5+GRUB_TIMEOUT=1+g' /etc/default/grub && sudo update-grub
clear #Clear the screen
check_error "GRUB BOOT TIMEOUT"
# ---------------------------------------------------------------------------------------
# Install Done ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##
# ---------------------------------------------------------------------------------------
clear #Clear the screen
sudo reboot

# Test Qtile config file.
# Run qtileconfig-test-venv or qtileconfig-test for no python venv.
