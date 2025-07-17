#!/usr/bin/env bash
# Debian ISO Remastering for QMADE - https://github.com/ITmail-dk/qmade/
# sudo apt install -y wget git xorriso isolinux p7zip-full fakeroot binutils

DEBIAN_ISO_URL=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/
GET_ISO_NAME=$(curl -s https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/ | grep -oP 'debian-\d+(?:\.\d+)+-amd64-netinst\.iso' | head -n 1)
PRESEED_ISO_NAME=QMADE-Debian
WORK_DIR=$(pwd)
ISO_WORK_TMP=iso-extract

# Setup the environment for creating the new ISO version.
function setup() {
  sudo apt update && sudo apt install -y wget git xorriso isolinux p7zip-full fakeroot binutils
  if [ ! -f Debian-source.iso ]; then
    wget -O Debian-source.iso $DEBIAN_ISO_URL/$GET_ISO_NAME
  fi
  xorriso -osirrox on -indev Debian-source.iso -extract / $ISO_WORK_TMP
  sudo chmod -R +w $ISO_WORK_TMP
  sudo mkdir -p $ISO_WORK_TMP/var/cache/apt/archives
  if [ ! -f preseed.cfg ]; then
    wget https://raw.githubusercontent.com/ITmail-dk/qmade/refs/heads/main/preseed.cfg
  fi
  sudo cp preseed.cfg $ISO_WORK_TMP
  sudo sed -i 's/append vga/append auto=true priority=critical vga/' $ISO_WORK_TMP/isolinux/gtk.cfg
  sudo sed -i '/spkgtk\.cfg/d; /spk\.cfg/d' $ISO_WORK_TMP/isolinux/menu.cfg
  sudo sed -i 's/--- quiet/--- quiet file=\/cdrom\/preseed.cfg/' $ISO_WORK_TMP/isolinux/gtk.cfg
  sudo sed -i '0,/--- quiet/ s/--- quiet/--- quiet file=\/cdrom\/preseed.cfg/' $ISO_WORK_TMP/boot/grub/grub.cfg
  sudo apt reinstall --download-only -y -o Dir::Cache="./" -o Dir::Cache::archives="iso-extract/var/cache/apt/archives" install \
    bash-completion xserver-xorg x11-utils xinit acl arandr autorandr picom fwupd colord mesa-utils htop wget curl git tmux \
    numlockx kitty neovim xdg-utils cups cups-common lm-sensors fancontrol xbacklight brightnessctl unzip network-manager \
    dnsutils dunst libnotify-bin notify-osd xsecurelock pm-utils rofi 7zip jq poppler-utils fd-find ripgrep zoxide sddm \
    imagemagick nsxiv mpv flameshot mc thunar gvfs gvfs-backends parted gparted mpd mpc ncmpcpp fzf ccrypt xarchiver \
    notepadqq font-manager fontconfig fontconfig-config fonts-recommended fonts-liberation fonts-freefont-ttf \
    fonts-noto-core libfontconfig1 pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
    libspa-0.2-bluetooth pavucontrol alsa-utils qpwgraph sddm-theme-breeze sddm-theme-maui ffmpeg cmake \
    policykit-1 policykit-1-gnome remmina libreoffice keynav
  sudo chmod -R +r iso-extract/var/
  make
}

# Make a new ISO file after removing the old one if it exists.
function make() {
  if [ -d $ISO_WORK_TMP ]; then
    if [ -f $PRESEED_ISO_NAME.iso ]; then rm $PRESEED_ISO_NAME.iso; fi
    xorriso -as mkisofs -o $PRESEED_ISO_NAME.iso -V "Debian QMADE" -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat $ISO_WORK_TMP
    ls -lah *.iso

  else
    echo "$ISO_WORK_TMP does not exist, runing setup..."
    setup
  fi
}

function usb() {
  lsblk
  echo -en "Enter the name of the USB Disk so sda, sdb etc..: "
  read USB_DISK
  clear
  sudo dd bs=4M status=progress conv=fsync oflag=direct if=$(pwd)/$PRESEED_ISO_NAME.iso of=/dev/$USB_DISK
  echo "ISO to USB All done ;-)"
}

# Run the function by, function_name
$@ make
