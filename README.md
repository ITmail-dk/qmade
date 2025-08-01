# Qmade - My daily Linux driver.
Qtile Martin Andersen Desktop Environment, Qmade for short.!

## Remember to install Debian without a desktop environment.
Install a fresh copy of Debian Linux - Stable via the Netinst installer ISO.
After installation Debian, Reboot the computer and login with your username and password.
Start the installation as regular users with SUDO rights, after you login to your freshly installed machine.

Run this one command to start Qmade install and you're good to go.: 

    curl -sfL https://raw.githubusercontent.com/ITmail-dk/qmade/main/install.sh | bash

Or you can use "wget" if you don't have "curl"

    wget -qO- https://raw.githubusercontent.com/ITmail-dk/qmade/main/install.sh | bash

![Screenshots of the Desktop](screenshots/screenshot_01.jpg)

## Keybindings
Default Modkey is the WINDOWS KEY (**MOD4**) and **MOD1** is the ALT KEY.

**WIN + Enter** = Opens a Terminal.

**WIN + B** = Opens a browser.

**WIN + E** = Thunar File Explorer.

**WIN + SHIFT + E** = Yazi File Explorer in a ScratchPads.

**WIN + CTRL + ALT + P** = Power Menu for shutdown, reboot and lock screen.

**WIN + SHIFT + A** = Pavucontrol, Audio Control Panel.

**WIN + ALT + A** = Toggle between two sources like speaker and headphones. (Setup in file ~/.audio-toggle)

**WIN + CTRL + ALT + T** = Autogenerate a new background image and color theme, 
from the Wallpaper folder in your home directory.


For a quick reference to the keybindings used in Qmade, 
check out the Qtile config file under Keybindings in "~/.config/qtile/config.py" to see them all.


## Custom commands after installation
"qmade update" Updates Qtile + QMADE and the Python virtual environment, and some file properties for sddm.
"qmade system-update" Runs a APT Update, Upgrade, Clean, Autoremove + QTILE & QMADE Update + NVIDIA Drivers Update.
"qmade system-dist-upgrade" Runs a system-update as a Full Dist Upgrade. (Run it after changing the source list)

## Nvidia Drivers
- Latest Beta version of the driver, will be installed during the installation if you have an NVIDIA GPU.

## Information:
- Window Manager: Qtile (Github From Source)
- Compositor: X11 & Picom
- Bar / Panel: Qtile Bar
- Terminal: Kitty
- Shell: Bash
- Web browser: Google Chrome & WaterFox
- Editor: Neovim + Notepadqq
- File Manager: Thunar + Yazi & Midnight Commander
- Notification Manager: Dunst
- Application Launcher: Rofi
- Login Manager: SDDM
- Audio Server: PipeWire, WirePlumber
- Theme: EliverLara Nordic
- Icons: Nordzy
- Cursors: Nordzy
- Colors: PyWal 16 (From the Wallpaper)
- Fonts: Noto & Jet Brains Mono + Roboto Mono (Nerd Fonts)
- Screenshot tool: Flameshot

## Roadmap:
- Compositor: Wayland when it's ready.
- Audio: Needs more work and better setup process and configuration.
- Wiki: General information about the setup and how to do things.
