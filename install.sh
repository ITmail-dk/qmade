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

# linux-cpupower - CPU Governor
# Info run: sudo cpupower frequency-info

# nsxiv "Neo (or New or Not) Simple (or Small or Suckless) X Image Viewer" - https://github.com/nsxiv/nsxiv

# Neovim (nvim) - https://neovim.io/ - https://neovim.io/doc/user/vimindex.html
# Vim commands you NEED TO KNOW https://www.youtube.com/watch?v=RSlrxE21l_k

# LazyVim - Can be used after Neovim >= 0.9.0 - https://github.com/LazyVim/LazyVim
# https://github.com/folke/lazy.nvim

# The default font in the configuration is Noto & Jet Brains Mono.

# Installation Start *_:*:_*:*:_*_*:*:_*::*_*::*_*:_*::*_*:*:_:*:*_*:*:_*:*_:*:#

function start_installation() {

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

  # Run APT Update
  sudo apt update || exit 1

  clear #Clear the screen
  check_error "APT Update Nr. 1"

  # QMADE Git install + clone
  cd /tmp/

  # Check if the GIT is installed
  if ! dpkg -s git >/dev/null 2>&1; then
    echo "Git is not installed, Installing git now..."
    sudo DEBIAN_FRONTEND=noninteractive apt install -y git
  fi

  # QMADE git clone
  git clone https://github.com/ITmail-dk/qmade.git

  # qmade to usr/bin
  sudo cp qmade/install.sh /usr/bin/qmade
  sudo chmod +x /usr/bin/qmade

  # Qtile Config file
  if [ ! -f ~/.config/qtile/config.py ]; then
    mkdir -p ~/.config/qtile/
    cat qmade/src/config/qtile-config.py >~/.config/qtile/config.py
  else
    echo "Qtile config file already exists."
  fi
  clear #Clear the screen
  check_error "Qtile Config file"

  # Add Wallpapers
  if [ ! -d ~/Wallpapers ]; then
    mkdir -p ~/Wallpapers
    cp qmade/wallpapers/* ~/Wallpapers/
  else
    echo "Wallpapers folder already exists."
  fi

  # Check and Copy APT Sources List
  if [ -f /etc/apt/sources.list ]; then
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
  fi

  sudo cp -r qmade/src/apt/* /etc/apt/

  check_error "Copy APT Sources list"

  # Sudoers ------------------------------------------------------------------------------------------------------------------------------------
  # Add User NOPASSWD to shutdown now and reboot
  echo "$USER ALL=(ALL) NOPASSWD: /sbin/shutdown now, /sbin/reboot, /sbin/pm-suspend" | sudo tee -a /etc/sudoers.d/$USER && sudo visudo -c -f /etc/sudoers.d/$USER
  check_error "Sudo User NOPASSWD to shutdown now and reboot"

  # Set sudo password timeout
  echo "Defaults timestamp_timeout=25" | sudo tee -a /etc/sudoers.d/$USER && sudo visudo -c -f /etc/sudoers.d/$USER
  check_error "Set sudo password timeout"
  # Sudoers ------------------------------------------------------------------------------------------------------------------------------------

  clear #Clear the screen

  sudo apt update

  clear #Clear the screen
  check_error "APT Update Nr. 2"

  # -------------------------------------------------------------------------------------------------
  # Core System APT install
  sudo DEBIAN_FRONTEND=noninteractive apt -y --ignore-missing install bash-completion xserver-xorg x11-utils xinit acl arandr autorandr picom fwupd colord mesa-utils htop wget curl git tmux numlockx kitty neovim xdg-utils cups cups-common lm-sensors fancontrol xbacklight brightnessctl unzip network-manager dnsutils dunst libnotify-bin notify-osd xsecurelock pm-utils rofi 7zip jq poppler-utils fd-find ripgrep zoxide imagemagick nsxiv mpv flameshot mc thunar gvfs gvfs-backends parted gparted mpd mpc ncmpcpp fzf ccrypt xarchiver notepadqq font-manager fontconfig fontconfig-config fonts-recommended fonts-liberation fonts-freefont-ttf fonts-noto-core libfontconfig1 pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber libspa-0.2-bluetooth pavucontrol alsa-utils qpwgraph sddm-theme-breeze sddm-theme-maui ffmpeg cmake remmina libreoffice linux-cpupower

  # For packages that might be missing so it doesn't stop the big apt installation of packages or slow it down
  for i in policykit-1 policykit-1-gnome keynav yt-dlp; do
    sudo DEBIAN_FRONTEND=noninteractive apt -y --ignore-missing install $i
  done

  sudo DEBIAN_FRONTEND=noninteractive apt -y --ignore-missing install linux-headers-$(uname -r)
  sudo DEBIAN_FRONTEND=noninteractive apt -y install sddm --no-install-recommends
  check_error "Core System APT install"

  # APT install extra packages
  #sudo DEBIAN_FRONTEND=noninteractive apt -y --ignore-missing install

  clear #Clear the screen
  check_error "APT install extra packages"

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

  # More Audio tools
  # sudo DEBIAN_FRONTEND=noninteractive apt install -y alsa-tools

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

  echo 'alias ls="ls --color=auto --group-directories-first -v -lah"' >>$BASHALIASFILE
  echo 'alias ll="ls --color=auto --group-directories-first -v -lah"' >>$BASHALIASFILE

  echo 'alias df="df -h"' >>$BASHALIASFILE

  echo 'alias neofetch="fastfetch"' >>$BASHALIASFILE

  echo 'alias upup="sudo apt update && sudo apt upgrade -y && sudo apt clean && sudo apt autoremove -y"' >>$BASHALIASFILE

  echo 'bind '"'"'"\C-f":"open "$(fzf)"\n"'"'" >>$BASHALIASFILE
  echo 'alias lsman="compgen -c | fzf | xargs man"' >>$BASHALIASFILE

  echo 'alias qtileconfig="nano ~/.config/qtile/config.py"' >>$BASHALIASFILE
  echo 'alias qtileconfig-test="python3 ~/.config/qtile/config.py"' >>$BASHALIASFILE
  echo 'alias qtileconfig-test-venv="source /opt/qtile_venv/bin/activate && python3 ~/.config/qtile/config.py && deactivate"' >>$BASHALIASFILE
  echo 'alias autostart-edit="nano ~/.config/qtile/autostart.sh"' >>$BASHALIASFILE
  echo 'alias vi="nvim"' >>$BASHALIASFILE
  echo 'alias vim="nvim"' >>$BASHALIASFILE
  echo 'alias ytdl="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"' >>$BASHALIASFILE

  clear #Clear the screen
  check_error "Bash Alias Echo"

  PROFILESFILE=~/.profile
  echo "export color_prompt=yes" >>$PROFILESFILE

  # Set User folders via xdg-user-dirs-update & xdg-mime default.
  # ls /usr/share/applications/ Find The Default run.: "xdg-mime query default inode/directory"

  xdg-user-dirs-update

  xdg-mime default kitty.desktop text/x-shellscript
  xdg-mime default nsxiv.desktop image/jpeg
  xdg-mime default nsxiv.desktop image/png
  xdg-mime default thunar.desktop inode/directory

  mkdir -p ~/Screenshots

  check_error "xdg-user-dirs-update and xdg-mime"

  sudo rm /usr/share/sddm/faces/.face.icon
  sudo rm /usr/share/sddm/faces/root.face.icon

  sudo wget -O /usr/share/sddm/faces/root.face.icon https://github.com/ITmail-dk/qmade/blob/main/src/home/root.face.icon?raw=true
  sudo wget -O /usr/share/sddm/faces/.face.icon https://github.com/ITmail-dk/qmade/blob/main/src/home/.face.icon?raw=true
  wget -O ~/.face.icon https://github.com/ITmail-dk/qmade/blob/main/src/home/.face.icon?raw=true

  setfacl -m u:sddm:x ~/
  setfacl -m u:sddm:r ~/.face.icon

  sudo setfacl -m u:sddm:x /usr/share/sddm/faces/
  sudo setfacl -m u:sddm:r /usr/share/sddm/faces/.face.icon
  sudo setfacl -m u:sddm:r /usr/share/sddm/faces/root.face.icon

  check_error "Set User .face.icon file"

  sudo mkdir -p /etc/sddm.conf.d
  sudo bash -c 'cat << "SDDMCONFIG" >> /etc/sddm.conf.d/default.conf
[Theme]
# Set Current theme "name" breeze, maui
Current=breeze

[Wayland]
EnableHiDPI=true

[X11]
EnableHiDPI=true

SDDMCONFIG'

  # Set login wallpape under background=/ in /usr/share/sddm/themes/breeze/theme.conf
  #/usr/share/wallpapers/login-wallpape.jpg

  clear #Clear the screen
  check_error "Setup SDDM Login"

  # Midnight-Commander ini file
  mkdir -p ~/.config/mc
  cat <<"MCINI" >~/.config/mc/ini
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
  # Upgrade run: python3 -m venv --upgrade qtile_venv

  cd /opt/
  sudo python3 -m venv qtile_venv
  sudo chmod -R 777 /opt/qtile_venv
  cd /opt/qtile_venv

  if [ -d qtile ]; then
    sudo rm -rf qtile
  fi

  git clone https://github.com/qtile/qtile.git

  source /opt/qtile_venv/bin/activate
  pip install dbus-next psutil wheel pyxdg
  pip install -r qtile/requirements.txt
  bin/pip install qtile/.
  # PyWAL install via pip3 for auto-generated color themes
  pip3 install pywal16[all]
  deactivate

  sudo cp bin/qtile /usr/bin/
  sudo cp bin/wal /usr/bin/
  clear #Clear the screen
  check_error "Install Qtile and PyWAL from qtile_venv"

  mkdir -p ~/.cache/wal
  cat <<"PYWALCOLORSJSON" >~/.cache/wal/colors.json
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
  cat <<"PYWALCOLORSKITTY" >~/.cache/wal/colors-kitty.conf
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
  cat <<"PYWALCOLORSTEMPALETKITTY" >~/.config/wal/templates/colors-kitty.conf
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

  cat <<"PYWALCOLORSTEMPALETROFI" >~/.config/wal/templates/colors-rofi-dark.rasi
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
  sudo bash -c 'cat << "AUTONEWWALLPAPERANDCOLORSBIN" >> /usr/bin/auto-new-wallpaper-and-colors
#!/usr/bin/env bash

wal --cols16 darken -q -i ~/Wallpapers --backend colorz
# Backends: colorz, haishoku, wal, colorthief, fast_colorthief, okthief, schemer2, modern_colorthief

notify-send -u low "Automatically new background and color theme" "Please wait while i find a new background image and some colors to match"

qtile cmd-obj -o cmd -f reload_config
kitty +kitten themes --reload-in=all Current-theme

cp $(cat "$HOME/.cache/wal/wal") /usr/share/wallpapers/login-wallpape.jpg

notify-send -u low "Automatically new background and color theme" "The background image and colors has been updated."

AUTONEWWALLPAPERANDCOLORSBIN'

  sudo chmod +x /usr/bin/auto-new-wallpaper-and-colors
  clear #Clear the screen
  check_error "auto-new-wallpaper-and-colors bin"

  #Midnight Commander
  mkdir -p ~/.config/mc
  echo "skin=dark" >>~/.config/mc/ini
  clear #Clear the screen
  check_error "Midnight Commander config"

  # ------------------------------------------------------------------------

  sudo mkdir -p /usr/share/xsessions/
  sudo bash -c 'cat << "QTILEDESKTOP" >> /usr/share/xsessions/qtile.desktop
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Exec=/etc/sddm/Xsession
Type=Application
Keywords=wm;tiling
QTILEDESKTOP'

  # Add to user .xsession
  echo "exec /usr/bin/qtile start" >~/.xsession
  echo "exec /usr/bin/qtile start" | sudo tee -a "/etc/skel/.xsession" >/dev/null
  clear #Clear the screen
  check_error "Add Qtile .xsession"

  # Qtile Autostart.sh file
  mkdir -p ~/.config/qtile/
  if [ ! -f ~/.config/qtile/autostart.sh ]; then
    cat <<"QTILEAUTOSTART" >~/.config/qtile/autostart.sh
#!/usr/bin/env bash
# Picom - https://manpages.debian.org/stable/picom/picom.1.en.html
pgrep -x picom > /dev/null || picom --backend xrender --vsync --no-fading-openclose --no-fading-destroyed-argb &
# Picom use... --backend glx or xrender, --vsync --no-vsync --no-fading-openclose --no-fading-destroyed-argb etc.

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

keynav &

# Remove .first-login file --------------------------------------------------------------
if [ -f ~/.first-login ]; then
    rm ~/.first-login
fi

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

    cat <<EOF | tee -a "~/.config/qtile/autostart.sh" >/dev/null
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
    cat <<MPDCONFIG >~/.config/mpd/mpd.conf
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

  # Neovim setup config Start
  #git clone https://github.com/LazyVim/starter ~/.config/nvim
  #rm -rf ~/.config/nvim/.git

  if [ ! -f ~/.config/nvim/init.vim ]; then
    mkdir -p ~/.config/nvim
    cat <<"NEOVIMCONFIG" >~/.config/nvim/init.vim
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
    cat <<"KITTYTHEMECONF" >~/.cache/wal/colors-kitty.conf
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
    cat <<"TMUXCONFIG" >~/.config/tmux/tmux.conf
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
    sudo mkdir -p /etc/fonts
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

  if [ -d /usr/share/xsessions/ ]; then
    find /usr/share/xsessions/ -name plasma* -exec sudo rm -f {} \;
    sudo update-alternatives --remove x-session-manager /usr/bin/startplasma-x11
  fi
  if [ -d /usr/share/wayland-sessions/ ]; then
    find /usr/share/wayland-sessions/ -name plasma* -exec sudo rm -f {} \;
    sudo update-alternatives --remove x-session-manager /usr/bin/startplasma-x11
  fi

  check_error "Remove plasma sessions .desktop"

  sudo rm -rf /tmp/EliverLara-Nordic
  sudo git clone https://github.com/EliverLara/Nordic /tmp/EliverLara-Nordic
  sudo cp -r /tmp/EliverLara-Nordic /usr/share/themes/

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

  if [ ! -f /usr/bin/xrandr-set-max ]; then
    xrandrsetmaxcontent=$(
      cat <<"XRANDRSETMAX"
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
    echo "$xrandrsetmaxcontent" | sudo tee /usr/bin/xrandr-set-max >/dev/null

    # SDDM Before Login - /usr/share/sddm/scripts/Xsetup and After Login - /usr/share/sddm/scripts/Xsession
    #sudo sed -i '$a\. /usr/bin/xrandr-set-max' /usr/share/sddm/scripts/Xsetup
    #sudo sed -i '$a\. /usr/bin/xrandr-set-max' /usr/share/sddm/scripts/Xsession #Old

    sudo chmod +x /usr/bin/xrandr-set-max

  else
    echo "xrandr-set-max already exists."
  fi

  #if [ ! -f /etc/X11/Xsession.d/90_xrandr-set-max ]; then
  #    sudo cp /usr/bin/xrandr-set-max /etc/X11/Xsession.d/90_xrandr-set-max
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
    cat <<"ROFICONFIG" >~/.config/rofi/config.rasi
configuration {
  display-drun: "Applications:";
  display-window: "Windows:";
  drun-display-format: "{name}";
  font: "JetBrainsMono Nerd Font Propo 11";
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
    cat <<"ROFIWIFI" >~/.config/rofi/rofi-wifi-menu.sh
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

  if [ ! -f ~/.config/rofi/powermenu.sh ]; then
    mkdir -p ~/.config/rofi
    cat <<"ROFIPOWERMENU" >~/.config/rofi/powermenu.sh
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
    mkdir -p ~/.config/rofi
    cat <<"ROFIPOWERMENURASI" >~/.config/rofi/powermenu.rasi

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
    cat <<"XFCE4HELPER" >~/.config/xfce4/helpers.rc
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
    cat <<"KITTYCONFIG" >~/.config/kitty/kitty.conf
# A default configuration file can also be generated by running:
# kitty +runpy 'from kitty.config import *; print(commented_out_default_config())'
#
# The following command will bring up the interactive terminal GUI
# kitty +kitten themes
#
# kitty +kitten themes Catppuccin-Mocha
# kitty +kitten themes --reload-in=all Catppuccin-Mocha

background_opacity 0.98

font_family      JetBrainsMono Nerd Font Mono
bold_font        auto
italic_font      auto
bold_italic_font auto

font_size 14
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

  # SDDM SDDM LOGIN WALLPAPER

  sudo mkdir -p /usr/share/wallpapers
  sudo chmod 777 /usr/share/wallpapers
  sudo cp $(find /tmp/qmade/wallpapers -type f -name "*.jpg" | shuf -n 1) /usr/share/wallpapers/login-wallpape.jpg
  sudo chmod 777 /usr/share/wallpapers/login-wallpape.jpg

  # SDDM New login wallpaper
  sudo chmod 777 /usr/share/sddm/themes/breeze
  sudo chmod 777 /usr/share/sddm/themes/breeze/theme.conf

  NEW_LOGIN_WALLPAPER="/usr/share/wallpapers/login-wallpape.jpg"

  # Check if the breeze/theme.conf file exists
  if [ -f "/usr/share/sddm/themes/breeze/theme.conf" ]; then
    # Use sed to replace the background line
    sed -i "s|background=.*$|background=$NEW_LOGIN_WALLPAPER|" "/usr/share/sddm/themes/breeze/theme.conf"
    echo "Updated background image in /usr/share/sddm/themes/breeze/theme.conf"
  else
    echo "Error: File /usr/share/sddm/themes/breeze/theme.conf not found"
  fi
  check_error "NEW SDDM LOGIN WALLPAPER"

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

  cat <<EOF | sudo tee "/usr/share/applications/waterfox.desktop" >/dev/null
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
  sudo cp yazi-x86_64-unknown-linux-musl/yazi /usr/bin/
  sudo chown root:root /usr/bin/yazi
  sudo chmod +x /usr/bin/yazi

  clear #Clear the screen
  check_error "Yazi File Manager install"

  # Systemctl enable --user
  # See list run: systemctl list-unit-files --state=enabled
  if [ $(whoami) != "root" ]; then
    # Sound systemctl enable --user
    systemctl enable --user --now pipewire.socket pipewire-pulse.socket wireplumber.service
  else
    echo "#!/usr/bin/env bash" >>~/.first-login-user-setup
    echo "systemctl enable --user --now pipewire.socket pipewire-pulse.socket wireplumber.service" >>~/.first-login-user-setup
  fi
  check_error "Systemctl enable for user"

  # LM-Sensors config
  sudo sensors-detect --auto

  # Remove .first-login file --------------------------------------------------------------
  if [ -f ~/.first-login ]; then
    rm ~/.first-login
  fi

  # Edit GRUB BOOT TIMEOUT ----------------------------------------------------------------
  sudo sed -i 's+GRUB_TIMEOUT=5+GRUB_TIMEOUT=1+g' /etc/default/grub && sudo update-grub
  clear #Clear the screen
  check_error "GRUB BOOT TIMEOUT"

  # Check for Nvidia graphics card and install drivers ----------------------------------------------

  if lsmod | grep -iq nouveau; then
    #sudo rmmod -f nouveau #remove test
    echo "blacklist nouveau" | sudo tee -a /etc/modprobe.d/nouveau-blacklist.conf
  fi

  if lsmod | grep -iq nvidia; then
    sudo rmmod -f nvidia_modeset
    sudo rmmod -f nvidia_drm
    sudo rmmod -f nvidia
  fi

  if lspci | grep -i nvidia; then
    echo "Installing required packages..."
    sudo apt -y install linux-headers-$(uname -r)
    sudo apt -y install gcc make acpid dkms libglvnd-core-dev libglvnd0 libglvnd-dev
    check_error "package installation"

    echo "Removing old NVIDIA drivers..."
    sudo apt remove -y nvidia-* && sudo apt autoremove -y $(dpkg -l nvidia-driver* | grep ii | awk '{print $2}')
    check_error "removal of old NVIDIA drivers"

    echo "Enabling i386 architecture and installing 32-bit libraries..."
    sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install -y libc6:i386
    check_error "installation of i386 libraries"

    #echo "Updating GRUB configuration..."
    #GRUB_CONF="/etc/default/grub"
    #sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ rd.driver.blacklist=nouveau"/' $GRUB_CONF
    #check_error "updating GRUB configuration"
    #sudo update-grub
    #check_error "GRUB update"

    #NVIDIAGETVERSION=570.133.07
    NVIDIAGETVERSION="$(curl -s "https://www.nvidia.com/en-us/drivers/unix/" | grep "Latest Production Branch Version:" | awk -F'"> ' '{print $2}' | cut -d'<' -f1 | awk 'NR==1')"
    echo "Downloading and installing NVIDIA $NVIDIAGETVERSION driver..."
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIAGETVERSION/NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run
    check_error "downloading NVIDIA driver"

    chmod +x NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run
    #    echo 'nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"' >> ~/.config/qtile/autostart.sh
    sudo ./NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run --silent --no-questions --disable-nouveau --allow-installation-with-running-driver -M proprietary --skip-module-load
    # --run-nvidia-xconfig
  fi
  clear #Clear the screen
  check_error "NVIDIA driver installation"

  # ---------------------------------------------------------------------------------------
  # Install Done ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##
  # ---------------------------------------------------------------------------------------

  # Test Qtile config file.
  # Run qtileconfig-test-venv or qtileconfig-test for no python venv.

  # End of function start_installation
}

# Start of update_qmade function
function update_qmade() {
  cd /opt

  if [ -d qtile_venv ]; then
    sudo rm -rf qtile_venv
  fi

  sudo python3 -m venv qtile_venv
  sudo chmod -R 777 qtile_venv

  cd qtile_venv

  git clone https://github.com/qtile/qtile.git
  git clone https://github.com/ITmail-dk/qmade.git

  source bin/activate
  pip install dbus-next psutil wheel pyxdg
  pip install -r qtile/requirements.txt
  bin/pip install qtile/.

  # PyWAL install via pip3 for auto-generated color themes
  pip3 install pywal16[all]
  deactivate

  sudo cp bin/qtile /usr/bin/
  sudo cp bin/wal /usr/bin/
  sudo cp qmade/install.sh /usr/bin/qmade
  sudo chmod +x /usr/bin/qmade

  # SDDM New login wallpaper
  sudo chmod 777 /usr/share/sddm/themes/breeze
  sudo chmod 777 /usr/share/sddm/themes/breeze/theme.conf

  sudo mkdir -p /usr/share/wallpapers
  sudo chmod 777 /usr/share/wallpapers
  sudo cp $(find qmade/wallpapers -type f -name "*.jpg" | shuf -n 1) /usr/share/wallpapers/login-wallpape.jpg

  NEW_LOGIN_WALLPAPER="/usr/share/wallpapers/login-wallpape.jpg"

  if [ -f "/usr/share/sddm/themes/breeze/theme.conf" ]; then
    # Use sed to replace the background line
    sed -i "s|background=.*$|background=$NEW_LOGIN_WALLPAPER|" "/usr/share/sddm/themes/breeze/theme.conf"
    echo "Updated background image in /usr/share/sddm/themes/breeze/theme.conf"
  else
    echo "Error: File /usr/share/sddm/themes/breeze/theme.conf not found"
  fi

  if [ -d /usr/share/xsessions/ ]; then
    find /usr/share/xsessions/ -name plasma* -exec sudo rm -f {} \;
    sudo update-alternatives --remove x-session-manager /usr/bin/startplasma-x11
  fi
  if [ -d /usr/share/wayland-sessions/ ]; then
    find /usr/share/wayland-sessions/ -name plasma* -exec sudo rm -f {} \;
    sudo update-alternatives --remove x-session-manager /usr/bin/startplasma-x11
  fi

  echo "QMADE Update done ;-)"
  # End of update_qmade function
}

function nvidia_install_upgrade() {
  check_error() {
    if [ $? -ne 0 ]; then
      echo -e "${RED} An error occurred during installation and has been stopped. ${NC}"
      echo -e "${RED} Or you have pressed CTRL + C to cancel. ${NC}"
      echo -e "${RED} Error occurred during $1 ${NC}"
      exit 1
    fi
  }
  echo "Nvidia install / Update."
  if lspci | grep -i nvidia; then
    echo "Installing required packages..."
    sudo apt -y install linux-headers-$(uname -r)
    sudo apt -y install gcc make acpid dkms libglvnd-core-dev libglvnd0 libglvnd-dev
    check_error "package installation"

    echo "Removing old NVIDIA drivers..."
    sudo apt remove -y nvidia-* && sudo apt autoremove -y $(dpkg -l nvidia-driver* | grep ii | awk '{print $2}')
    check_error "removal of old NVIDIA drivers"

    echo "Enabling i386 architecture and installing 32-bit libraries..."
    sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install -y libc6:i386
    check_error "installation of i386 libraries"

    #echo "Updating GRUB configuration..."
    #GRUB_CONF="/etc/default/grub"
    #sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ rd.driver.blacklist=nouveau"/' $GRUB_CONF
    #check_error "updating GRUB configuration"
    #sudo update-grub
    #check_error "GRUB update"

    #NVIDIAGETVERSION=570.133.07
    NVIDIAGETVERSION="$(curl -s "https://www.nvidia.com/en-us/drivers/unix/" | grep "Latest Production Branch Version:" | awk -F'"> ' '{print $2}' | cut -d'<' -f1 | awk 'NR==1')"
    echo "Downloading and installing NVIDIA $NVIDIAGETVERSION driver..."
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIAGETVERSION/NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run
    check_error "downloading NVIDIA driver"

    chmod +x NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run
    #    echo 'nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"' >> ~/.config/qtile/autostart.sh
    sudo ./NVIDIA-Linux-x86_64-$NVIDIAGETVERSION.run --silent --no-questions --disable-nouveau --allow-installation-with-running-driver -M proprietary --skip-module-load
    # --run-nvidia-xconfig
  fi
  clear #Clear the screen
  check_error "NVIDIA driver installation"
  echo "Nvidia Done"
  # End of nvidia_install_upgrad function
}

function help_wiki() {
  echo "Help / WiKi for QMADE ;-)"
}

main() {
  if [ -z "$1" ]; then
    echo "Starting the installation."
    start_installation
    clear
    sudo reboot
  fi

  case $1 in
  help)
    echo "Help..!"
    help_wiki
    ;;
  update)
    echo "Update QMADE."
    update_qmade
    ;;
  system-update)
    echo "APT Update / Upgrade + QTILE / QMADE Upgrade."
    sudo apt update && sudo apt upgrade -y && sudo apt clean && sudo apt autoremove -y &&
      update_qmade &&
      nvidia_install_upgrade
    ;;
  system-dist-upgrade)
    echo "Full System Dist Update / Upgrade + QTILE & QMADE."
    sudo apt update && sudo apt full-upgrade -y && sudo apt dist-upgrade &&
      update_qmade &&
      nvidia_install_upgrade
    ;;
  *)
    echo "Unknown function: $1. Available functions are: help, update, system-update and system-dist-upgrade"
    exit 1
    ;;
  esac
}

main "$@"
