local wezterm = require("wezterm")
local act = wezterm.action
local cb = wezterm.action_callback
local scrollback_lines = 10000

local config = wezterm.config_builder()

config.automatically_reload_config = false

config.animation_fps = 30
config.audible_bell = "Disabled"
config.check_for_updates = false
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500
config.default_cursor_style = "BlinkingBlock"

config.colors = {
    foreground = "#000000",
    background = "#ffffff",
    selection_fg = "#000000",
    selection_bg = "#d3d3d3",
    cursor_bg = "#000000",
    cursor_fg = "#ffffff",
    split = "#8888cc",
    tab_bar = {
        active_tab = {
            bg_color = "#c0ffff",
            fg_color = "#000000",
        },
        inactive_tab = {
            bg_color = "#eaffff",
            fg_color = "#000000",
        },
        inactive_tab_hover = {
            bg_color = "#eaffff",
            fg_color = "#000000",
        },
        new_tab = {
            bg_color = "#eaffff",
            fg_color = "#757575",
        },
        new_tab_hover = {
            bg_color = "#eaffff",
            fg_color = "#000000",
            italic = true,
        },
        inactive_tab_edge = "#eaffff",
    },
    ansi = {
        "#000000",
        "#a50000",
        "#005d26",
        "#714700",
        "#1d3ccf",
        "#88267a",
        "#185570",
        "#efefef",
    },
    brights = {
        "#000000",
        "#992030",
        "#4a5500",
        "#8a3600",
        "#2d45b0",
        "#700dc9",
        "#005289",
        "#ffffff",
    },
}

config.disable_default_key_bindings = true

config.font = wezterm.font_with_fallback({
    { family = "Roboto Mono" },
    { family = "Noto Emoji Color" },
    { family = "Symbols Nerd Font Mono" },
    { family = "Source Han Mono" },
})
config.font_size = 14.0
config.line_height = 1.2

-- wezterm is ignoring the system repeat rate on wayland
-- see https://github.com/wez/wezterm/issues/669#issuecomment-818403023
config.enable_wayland = false
config.hide_tab_bar_if_only_one_tab = true
config.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.9,
}

local function is_inside_vim(pane)
    local tty = pane:get_tty_name()
    if tty == nil then
        return false
    end

    local success, _, _ = wezterm.run_child_process({
        "sh",
        "-c",
        "ps -o state= -o comm= -t"
            .. wezterm.shell_quote_arg(tty)
            .. " | "
            .. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
    })

    return success
end

local function navigate(window, pane, key, dir)
    if is_inside_vim(pane) then
        window:perform_action(act.SendKey({ key = key, mods = "CTRL" }), pane)
    else
        window:perform_action(act.ActivatePaneDirection(dir), pane)
    end
end

wezterm.on("format-window-title", function()
    return "🍓"
end)

wezterm.on("TriggerVimWithVisibleText", function(window, pane)
    local viewport_text = pane:get_lines_as_text(scrollback_lines)

    local name = os.tmpname()
    local f = io.open(name, "w+")
    f:write(viewport_text)
    f:flush()
    f:close()

    window:perform_action(
        act.SplitPane({
            direction = "Down",
            command = { args = { "/usr/local/bin/nvim", "+$", name } },
            size = { Percent = 90 },
        }),
        pane
    )

    wezterm.sleep_ms(1000)
    os.remove(name)
end)

config.leader = { key = "s", mods = "CTRL" }
config.keys = {
    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
    {
        key = "s",
        mods = "LEADER",
        action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }),
    },
    {
        key = "v",
        mods = "LEADER",
        action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    {
        key = "c",
        mods = "LEADER",
        action = act({
            SpawnTab = "CurrentPaneDomain",
        }),
    },
    {
        key = ",",
        mods = "LEADER",
        action = act.PromptInputLine({
            description = "Enter new name for tab",
            action = cb(function(window, _, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },
    {
        key = "h",
        mods = "CTRL",
        action = cb(function(win, pane)
            navigate(win, pane, "h", "Left")
        end),
    },
    {
        key = "j",
        mods = "CTRL",
        action = cb(function(win, pane)
            navigate(win, pane, "j", "Down")
        end),
    },
    {
        key = "k",
        mods = "CTRL",
        action = cb(function(win, pane)
            navigate(win, pane, "k", "Up")
        end),
    },
    {
        key = "l",
        mods = "CTRL",
        action = cb(function(win, pane)
            navigate(win, pane, "l", "Right")
        end),
    },
    {
        key = "h",
        mods = "ALT",
        action = act({ AdjustPaneSize = { "Left", 2 } }),
    },
    {
        key = "j",
        mods = "ALT",
        action = act({ AdjustPaneSize = { "Down", 2 } }),
    },
    {
        key = "k",
        mods = "ALT",
        action = act({ AdjustPaneSize = { "Up", 2 } }),
    },
    {
        key = "l",
        mods = "ALT",
        action = act({
            AdjustPaneSize = { "Right", 2 },
        }),
    },
    -- Clears the scrollback and viewport, and then sends CTRL-L to ask the
    -- shell to redraw its prompt
    {
        key = "L",
        mods = "CTRL|SHIFT",
        action = act.Multiple({
            act.ClearScrollback("ScrollbackAndViewport"),
            act.SendKey({ key = "L", mods = "CTRL" }),
        }),
    },
    { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
    { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
    {
        key = "n",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ToggleFullScreen,
    },
    { key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
    { key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
    { key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
    { key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
    { key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
    { key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
    { key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
    { key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
    { key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },
    {
        key = "[",
        mods = "LEADER",
        action = act.EmitEvent("TriggerVimWithVisibleText"),
    },
    { key = "¥", mods = "ALT", action = act.SendString("\\") },
    { key = "O", mods = "CTRL", action = act.RotatePanes("Clockwise") },
}

for i = 1, 8 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "CTRL|ALT",
        action = wezterm.action.MoveTab(i - 1),
    })
end

config.max_fps = 240
config.native_macos_fullscreen_mode = true

-- copy by selecting text and paste with right click
-- see https://github.com/wez/wezterm/discussions/3541#discussioncomment-5633570
config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane)
                ~= ""
            if has_selection then
                window:perform_action(
                    act.CopyTo("ClipboardAndPrimarySelection"),
                    pane
                )
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
            end
        end),
    },
}

config.scrollback_lines = scrollback_lines
config.use_ime = true
config.window_frame = {
    font = wezterm.font({ family = "Roboto Mono" }),
    font_size = 14.0,
    active_titlebar_bg = "#eaffff",
    inactive_titlebar_bg = "#eaffff",
}
config.window_padding = {
    bottom = 0,
}

return config
