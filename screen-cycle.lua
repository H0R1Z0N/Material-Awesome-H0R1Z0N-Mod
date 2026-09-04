-- screen-cycle.lua: physically-ordered screen order for meta+o (move-window-to-screen).
-- Matched by RandR output/connector name (via screen.outputs), not geometry --
-- immune to rotation/DPI/wibar quirks that geometry comparison was vulnerable to.
local awful = require("awful")

-- Physical cycle order, by X11/RandR output name.
local screen_order = {
    "DP-2",     -- top Dell
    "DP-1",     -- VA24E (Asus, RTX 2070)
    "DP-1-2",   -- LG Ultrawide
    "DP-1-1",   -- X243W (Acer 16:10, 1920x1200)
    "DP-4",     -- bottom Dell
    "HDMI-0",   -- V226HQL (Acer, RTX 2070)
    "HDMI-1-0", -- VP247 (Asus, RTX 2080 Super)
    "HDMI-1-1", -- 27MP35 (LG 27")
}

local function output_name(s)
    for name in pairs(s.outputs) do
        return name
    end
    return nil
end

local function ordered_index(s)
    local name = output_name(s)
    if not name then return nil end
    for i, n in ipairs(screen_order) do
        if n == name then return i end
    end
    return nil
end

-- Returns the screen object in the given cycle direction from the currently
-- focused screen, or nil if the current screen isn't in screen_order.
local function target_screen(dir)
    local cur = ordered_index(awful.screen.focused())
    if not cur then return nil end
    local n = #screen_order
    local target_name = screen_order[((cur - 1 + dir) % n) + 1]
    for s in screen do
        if output_name(s) == target_name then
            return s
        end
    end
    return nil
end

local function focus_relative(dir)
    local s = target_screen(dir)
    if s then
        awful.screen.focus(s)
    else
        awful.screen.focus_relative(dir) -- fallback
    end
end

local function move_client_relative(dir)
    local c = client.focus
    if not c then return end
    local cur = ordered_index(c.screen)
    if not cur then
        awful.client.movetoscreen(c) -- fallback to default behavior
        return
    end
    local n = #screen_order
    local target_name = screen_order[((cur - 1 + dir) % n) + 1]
    for s in screen do
        if output_name(s) == target_name then
            awful.client.movetoscreen(c, s)
            return
        end
    end
    awful.client.movetoscreen(c) -- fallback if somehow not found
end

return {
    target_screen = target_screen,
    focus_next = function() focus_relative(1) end,
    focus_prev = function() focus_relative(-1) end,
    move_next = function() move_client_relative(1) end,
    move_prev = function() move_client_relative(-1) end,
}
