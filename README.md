# Qmade - Now testing in daily use.
Qtile Martin Andersen Desktop Environment, Qmade for short.!

## Remember to install Debian without a desktop environment.
Install a fresh copy of Debian Linux - Stable via the Netinst AMD64 installer ISO.
After installation Debian, Reboot the computer and login with your username and password.
Start the installation as regular users with SUDO rights, after you login to your freshly installed machine.

Run this one command to start Qmade install and you're good to go.: 

    bash -c "$(wget -O- https://raw.githubusercontent.com/ITmail-dk/qmade/main/install.sh)"

*Or you can run these commands... if you think it's easier.*

    sudo apt install -y git && git clone https://github.com/ITmail-dk/qmade && cd qmade && . install.sh

![Screenshots of the Desktop](screenshots/screenshot_01.jpg)

## Keybindings
Default Modkey is the Windows key (**MOD4**) and **MOD1** is Alt Left.

**MOD4 + Enter** = Opens a Terminal.

**MOD4 + B** = Opens a browser.

**MOD4 + SHIFT + A** = Audio Control Panel in a ScratchPads.

**MOD4 + Control + MOD1 + P** = Power Menu for shutdown, reboot and lock screen.

**MOD4 + Control + MOD1 + T** = Autogenerate a new background image and color theme,  
from the Wallpaper folder in your home directory.

For a quick reference to the keybindings used in Qmade,  
check out the image files in the `keybinding-images` directory.
Or the Qtile config file under KEYS in "~/.config/qtile/config.py" to see them all.

![Image of mod4 keybindings](keybinding-images/keybinding_mod4.png)

## Information:
- Window Manager: Qtile
- Compositor: X11, Picom
- Bar / Panel:  Qtile Bar
- Terminal: Kitty
- Shell: Bash
- Editor: Neovim
- File Manager: Thunar + Midnight Commander
- Notification Manager: Dunst
- Application Launcher: Rofi
- Login Manager: SDDM (Nordic-darker)
- Audio Server: PipeWire, WirePlumber
- Theme: EliverLara Nordic
- Colors: PyWal 16 (Keybinding: CTRL + WIN + ALT + T = New Random Color Theme from Wallpapers)
- Font: Noto & Jet Brains Mono + Roboto Mono (Nerd Fonts)


## Roadmap:
- Compositor: Wayland + XWayland