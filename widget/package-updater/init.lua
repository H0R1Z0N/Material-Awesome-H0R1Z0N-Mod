-------------------------------------------------
-- Package Updater Widget for Awesome Window Manager
-- Checks for pending updates (official repo + AUR) via pakku, and
-- opens paru in a terminal when clicked to actually apply them.
-------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/package-updater/icons/'

-- Off by default: a real `pacman -Sy` database sync needs root, and a
-- background widget polling every 60s can't prompt for a password
-- sanely. Flip this to true only if you've also added a narrow
-- passwordless-sudo rule for exactly this command via `sudo visudo`,
-- e.g. a line like:
--   hnt ALL=(ALL) NOPASSWD: /usr/bin/pacman -Sy
-- Left as a manual step on purpose -- not something to write into
-- /etc/sudoers for you without you looking at it first.
local AUTO_SYNC = false

local CHECK_COMMAND = AUTO_SYNC and 'bash -c "sudo pacman -Sy && pakku -Qu"' or 'pakku -Qu'

-- Terminal used to launch paru when the widget is clicked. xterm is used
-- as a safe default since it's present on essentially any Linux system;
-- swap it here for your preferred terminal (e.g. 'kitty -e paru').
local UPDATE_COMMAND = 'xterm -e paru'

local updateAvailable = false
local numOfUpdatesAvailable

local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(14), dpi(14), dpi(4), dpi(4)))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(UPDATE_COMMAND)
      end
    )
  )
)

awful.tooltip(
  {
    objects = {widget_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      if updateAvailable then
        return numOfUpdatesAvailable .. ' updates are available'
      else
        return 'We are up-to-date!'
      end
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

watch(
  CHECK_COMMAND,
  60,
  function(_, stdout)
    local count = 0
    for _ in stdout:gmatch('[^\r\n]+') do
      count = count + 1
    end

    local widgetIconName
    if count > 0 then
      updateAvailable = true
      numOfUpdatesAvailable = count
      widgetIconName = 'package-up'
      widget_button.visible = true
    else
      updateAvailable = false
      widgetIconName = 'package'
      widget_button.visible = false
    end
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
    collectgarbage('collect')
  end,
  widget
)

return widget_button
