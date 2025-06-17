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
    Key([mod, "mod1", "control"], "a", lazy.spawn("audio-toggle"), desc='Audio Source Toggle'),

    # XF86 Audio & Brightness keys
    Key([mod, "shift"], "a", lazy.spawn("pavucontrol"), desc='Audio Control Panel'),
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
    Group("0", label="", layout="max),
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
    Key([mod, "shift"], "Return", lazy.group['scratchpad'].dropdown_toggle('term1')),
    Key([mod, "mod1", "control"], "Return", lazy.group['scratchpad'].dropdown_toggle('term2')),
    Key([mod, "shift"], "e", lazy.group['scratchpad'].dropdown_toggle('file-explorer')),
    Key([mod, "shift"], "n", lazy.group['scratchpad'].dropdown_toggle('notes')),
    Key([mod, "shift"], "m", lazy.group['scratchpad'].dropdown_toggle('music')),
])

# ScratchPads
groups.append(ScratchPad("scratchpad", [
    DropDown("term1", "kitty --class=scratch", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
    DropDown("term2", "kitty --class=scratch", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
    DropDown("file-explorer", "kitty --class=yazi -e yazi", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
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
    background=Color0,
    padding=6,
)
extension_defaults = widget_defaults.copy()

# Bar widgets - https://docs.qtile.org/en/latest/manual/ref/widgets.html

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(scale=0.7, padding=5),
                widget.Spacer(length=5),
                widget.GroupBox(fontsize=18, highlight_method="text", this_current_screen_border="#f7f7f7", highlight_color=Color14, this_screen_border=Color3, urgent_border=Color7, active=Color5, inactive=Color8, borderwidth=0),
                widget.Spacer(length=9),
                widget.Prompt(),
                widget.Spacer(), # to get transparent background add background="#000000CC"
                widget.WindowName(width=bar.CALCULATED, max_chars=120),
                widget.Spacer(), # to get transparent background add background="#000000CC"
                #widget.Systray(fmt="󱊖  {}", icon_size=16),
                # NB Wayland is incompatible with Systray, consider using StatusNotifier
                # widget.StatusNotifier(icon_size=16),
                #widget.Wallpaper(directory="~/Wallpapers/", label="", random_selection="True"),
                #widget.NetGraph(type='line', line_width=1),
                #widget.Net(prefix='M'),
                #widget.ThermalSensor(format='CPU: {temp:.0f}{unit}'),
                widget.Volume(fmt="  {}"),
		widget.Spacer(length=5),
                widget.Systray(fmt="󱊖  {}", icon_size=16),
		widget.Spacer(length=5),
                widget.Clock(fmt="  {}",format="%A %d-%m-%Y %H:%M %p"),
                widget.QuickExit(default_text='', countdown_format='{}', fontsize=16, countdown_start=3),
                widget.Spacer(length=20),
            ], 30, # Define bar height
            background="#000000CC", opacity=0.90, # Bar background color can also take transparency with "hex color code" or 0.XX
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

