local filesystem = require('gears.filesystem')

-- Thanks to jo148 on github for making rofi dpi aware!
local with_dpi = require('beautiful').xresources.apply_dpi
local with_dpi = require('beautiful').xresources.apply_dpi
local rofi_command = 'env /usr/bin/rofi -dpi 96 -width ' .. with_dpi(400, 96) .. ' -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi.rasi -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'terminator',
    rofi = rofi_command,
    lock = 'i3lock-fancy',
    quake = 'terminator',
    screenshot = 'flameshot full -c',
    region_screenshot = 'flameshot gui -c',
    window_screenshot = 'flameshot screen -c',
    --screenshot = '~/.config/awesome/configuration/utils/screenshot -m',
    --region_screenshot = '~/.config/awesome/configuration/utils/screenshot -r',
    --delayed_screenshot = '~/.config/awesome/configuration/utils/screenshot --delayed -r',
    --screenshot = 'gnome-screenshot -c',
    --region_screenshot = 'gnome-screenshot -c -a',
    --window_screenshot = 'gnome-screenshot -c -w',
    browser = 'chrome',
    editor = 'notepadqq', -- gui text editor
    social = 'discord',
    game = rofi_command,
    files = 'nemo',
    music = rofi_command 
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'picom --config ' .. filesystem.get_configuration_dir() .. '/configuration/picom.conf',
    'nm-applet --indicator', -- wifi
    'pnmixer', -- shows an audiocontrol applet in systray when installed.
    'blueberry-tray', -- Bluetooth tray icon
    'numlockx on', -- enable numlock
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
--    'xfce4-power-manager', -- Power manager
     'flameshot',
     'discord',
--     'meteo-qt',
    -- 'synology-drive -minimized',
     'steam-screensaver-fix-runtime -silent',
     '/usr/lib/kdeconnectd',
     'kdeconnect-indicator',
--     'megasync-instance',
     '/usr/bin/barrier',
     '~/.local/bin/wallpaper', -- wallpaper-reddit script
    -- Add applications that need to be killed between reloads
    -- to avoid multipled instances, inside the awspawn script
    '~/.config/awesome/configuration/awspawn' -- Spawn "dirty" apps that can linger between sessions
  }
}
