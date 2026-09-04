-------------------------------------------------
-- Multi-device battery widget (Bluetooth peripherals, USB UPS, etc.)
-- Polls UPower for every connected power device (excluding the
-- synthetic DisplayDevice and AC/line-power) and shows the worst
-- charge level as the icon, with a tooltip listing every device.
-------------------------------------------------

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/battery/icons/'
local POLL_SCRIPT = HOME .. '/.config/awesome/widget/battery-devices/poll.sh'

local widget =
  wibox.widget {
  id = 'text',
  widget = wibox.widget.textbox,
  font = 'Overlock Regular 10',
  text = '--'
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(14), dpi(14), 4, 4))

local devices_popup =
  awful.tooltip(
  {
    objects = {widget_button},
    mode = 'outside',
    align = 'left',
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

local last_warning = {}

local function show_low_battery_warning(name, charge)
  naughty.notify {
    icon = PATH_TO_ICONS .. 'battery-alert.svg',
    icon_size = dpi(48),
    text = name .. ' is at ' .. charge .. '%',
    title = 'Device battery low',
    font = 'Overlock Regular 11',
    timeout = 5,
    hover_timeout = 0.5,
    position = 'bottom_left',
    bg = '#d32f2f',
    fg = '#EEE9EF',
    width = 248
  }
end

watch(
  'bash ' .. POLL_SCRIPT,
  5,
  function(_, stdout)
    local devices = {}
    for line in stdout:gmatch('[^\r\n]+') do
      local path, model, charge, state = line:match('([^|]+)|([^|]*)|(%d+)|([%a]*)')
      if charge then
        table.insert(devices, {path = path, name = (model ~= '' and model) or path, charge = tonumber(charge), state = state})
      end
    end

    if #devices == 0 then
      widget_button.visible = false
      devices_popup.text = 'No Bluetooth/USB battery devices connected'
      return
    end
    widget_button.visible = true

    -- Worst (lowest) charge among all devices drives the summary icon
    local worst = devices[1]
    for _, d in ipairs(devices) do
      if d.charge < worst.charge then
        worst = d
      end
    end

    local now = os.time()
    for _, d in ipairs(devices) do
      if d.charge < 15 and d.state ~= 'charging' then
        if not last_warning[d.path] or os.difftime(now, last_warning[d.path]) > 300 then
          last_warning[d.path] = now
          show_low_battery_warning(d.name, d.charge)
        end
      end
    end

    local text = worst.charge .. '%'
    if worst.state == 'charging' then
      text = text .. ' ⚡'
    end
    widget:set_text(text)

    local lines = {}
    for _, d in ipairs(devices) do
      table.insert(lines, d.name .. ': ' .. d.charge .. '% (' .. d.state .. ')')
    end
    devices_popup.text = table.concat(lines, '\n')
    collectgarbage('collect')
  end,
  widget
)

return widget_button
