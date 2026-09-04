## Material and Mouse driven theme for [AwesomeWM 4.3](https://awesomewm.org/)
### Original work by PapyElGringo, official development seem to have moved to [material-shell](https://github.com/PapyElGringo/material-shell)

Note: This fork focuses on streamlining the config and adding some Quality of Life touches to the theme.

An almost desktop environment made with [AwesomeWM](https://awesomewm.org/) following the [Material Design guidelines](https://material.io) with a performant opiniated mouse/keyboard workflow to increase daily productivity and comfort.

[![](./theme/PapyElGringo-theme/demo.gif?raw=true)](https://www.reddit.com/r/unixporn/comments/anp51q/awesome_material_awesome_workflow/)
*[Click to view in high quality](https://www.reddit.com/r/unixporn/comments/anp51q/awesome_material_awesome_workflow/)*

| Tiled         | Panel         | Exit screen   |
|:-------------:|:-------------:|:-------------:|
|![](https://i.imgur.com/fELCtep.png)|![](https://i.imgur.com/7IthpQS.png)|![](https://i.imgur.com/rcKOLYQ.png)|

## Installation

### 1) Get all the dependencies

#### Debian-Based

```
sudo add-apt-repository ppa:regolith-linux/unstable -y
sudo apt install awesome fonts-roboto rofi picom i3lock xclip qt5-style-plugins materia-gtk-theme lxappearance xbacklight kde-spectacle nautilus xfce4-power-manager pnmixer network-manager-applet gnome-polkit -y
wget -qO- https://git.io/papirus-icon-theme-install | sh
```

*Note: PPA is for picom since compton is old and hasn't been updated*

#### Arch-Based

```
paru -S awesome rofi picom i3lock-fancy-multimonitor xclip ttf-roboto gnome-polkit materia-gtk-theme lxappearance flameshot pasystray network-manager-applet xfce4-power-manager cmus playerctl brightnessctl blueman qt5ct -y
sudo pacman -S papirus-icon-theme
```

Overlock (the clock widget font) isn't packaged for Arch or Debian — install it directly from Google Fonts:

```
mkdir -p ~/.local/share/fonts
curl -Lo /tmp/overlock.zip "https://fonts.google.com/download?family=Overlock"
unzip /tmp/overlock.zip -d ~/.local/share/fonts/Overlock
fc-cache -f
```

#### Program list

- [AwesomeWM](https://awesomewm.org/) as the window manager - universal package install: awesome
- [Roboto](https://fonts.google.com/specimen/Roboto) as the **font** - Debian: fonts-roboto Arch: ttf-roboto
- [Overlock](https://fonts.google.com/specimen/Overlock) as the **clock widget font** - not packaged for any distro; download from Google Fonts and install into `~/.local/share/fonts` (see command above)
- [Rofi](https://github.com/DaveDavenport/rofi) for the app launcher - universal install: rofi
- [picom](https://github.com/yshui/picom) for the compositor (blur and animations) universal install: picom - Debian users need PPA (`sudo add-apt-repository ppa:regolith-linux/unstable`)
- [i3lock-fancy-multimonitor](https://github.com/meskarune/i3lock-fancy) the lockscreen application - Arch: AUR package i3lock-fancy-multimonitor (adds proper multi-monitor support over the base i3lock-fancy)
- [xclip](https://github.com/astrand/xclip) for copying screenshots to clipboard package: xclip
- [gnome-polkit] recommend using the gnome-polkit as it integrates nicely for elevating programs that need root access
- [Materia](https://github.com/nana-4/materia-theme) as GTK theme - Arch Install: materia-theme debian: materia-gtk-theme
- [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) as icon theme - Arch: officially in the `extra` repo, install directly with `sudo pacman -S papirus-icon-theme` (no script needed). Debian: `wget -qO- https://git.io/papirus-icon-theme-install | sh`
- [lxappearance](https://sourceforge.net/projects/lxde/files/LXAppearance/) to set up the gtk and icon theme
- [qt5ct](https://github.com/trialuser02/qt5ct) for consistent Qt theming alongside GTK - Arch: officially in the `extra` repo, install with `sudo pacman -S qt5ct`
- (Laptop) [brightnessctl](https://github.com/Hummer12007/brightnessctl) for adjusting backlight brightness (replaces xbacklight, which fails on a lot of modern hardware with "No outputs have backlight property"; also doesn't depend on X, so it works under Wayland sessions too). Note: this only controls laptop-panel backlights — external desktop monitors need `ddcutil` (DDC/CI) instead, a different mechanism entirely.
- [flameshot](https://flameshot.js.org/#/) my personal screenshot utility of choice, can be replaced by whichever you want, just remember to edit the apps.lua file
- [pasystray](https://github.com/christophgysin/pasystray) Audio Tray icon (replaces pnmixer)
- [blueman](https://github.com/blueman-project/blueman) Bluetooth tray icon (`blueman-applet`)
- [network-manager-applet](https://gitlab.gnome.org/GNOME/network-manager-applet) nm-applet is a Network Manager Tray display from GNOME.
- [xfce4-power-manager](https://docs.xfce.org/xfce/xfce4-power-manager/start) XFCE4's power manager is excellent and a great way of dealing with sleep, monitor timeout, and other power management features.


### 2) Clone the configuration

```
git clone https://github.com/H0R1Z0N/Material-Awesome-H0R1Z0N-Mod ~/.config/awesome
```

### 3) Set the themes

Start `lxappearance` to active the **icon** theme and **GTK** theme
Note: for cursor theme, edit `~/.icons/default/index.theme` and `~/.config/gtk3-0/settings.ini`, for the change to also show up in applications run as root, copy the 2 files over to their respective place in `/root`.

### 4) Same theme for Qt/KDE applications and GTK applications, and fix missing indicators

First install `qt5-style-plugins` (debian) | `qt5ct` (arch, see install command above) and add this to the bottom of your `/etc/environment`

```bash
XDG_CURRENT_DESKTOP=GNOME
QT_QPA_PLATFORMTHEME=qt5ct
```

The first variable fixes most indicators (especially electron based ones!), the second tells Qt applications to use the theme you configure via the `qt5ct` GUI (run `qt5ct` once to set it up, matching your GTK theme for consistency).

### 5) Read the documentation

The documentation live within the source code.

The project is split in functional directories and in each of them there is a readme where you can get additional information about the them.

* [Configuration](./configuration) is about all the **settings** available
* [Layout](./layout) hold the **disposition** of all the widgets
* [Module](./module) contain all the **features** available
* [Theme](./theme) hold all the **aesthetic** aspects
* [Widget](./widget) contain all the **widgets** available
