global.menu_animcurve = animcurve_get_channel(ac_Menu, "v");

global.menu_bg_fade = 1;

global.menu_bg_blur       = false;
global.menu_bg_blur_value = 0;

global.menu_bg_position = 0;

global.menu_index_attire = 0;

global.menu_settings_name  = "";
global.menu_settings_index = 0;

global.menu_settings_keys = [
    vk_add,         "Add",
    vk_backspace,   "Backspace",
    vk_decimal,     "Decimal",
    vk_delete,      "Delete",
    vk_divide,      "Divide",
    vk_down,        "Down",
    vk_end,         "End",
    vk_enter,       "Enter",
    vk_escape,      "Escape",
    vk_f1,          "F1",
    vk_f2,          "F2",
    vk_f3,          "F3",
    vk_f4,          "F4",
    vk_f5,          "F5",
    vk_f6,          "F6",
    vk_f7,          "F7",
    vk_f8,          "F8",
    vk_f9,          "F9",
    vk_f10,         "F10",
    vk_f11,         "F11",
    vk_f12,         "F12",
    vk_home,        "Home",
    vk_insert,      "Insert",
    vk_lalt,        "Left Alt",
    vk_lcontrol,    "Left Control",
    vk_left,        "Left",
    vk_lshift,      "Left Shift",
    vk_multiply,    "Multiply",
    vk_numpad1,     "Numpad 1",
    vk_numpad2,     "Numpad 2",
    vk_numpad3,     "Numpad 3",
    vk_numpad4,     "Numpad 4",
    vk_numpad5,     "Numpad 5",
    vk_numpad6,     "Numpad 6",
    vk_numpad7,     "Numpad 7",
    vk_numpad8,     "Numpad 8",
    vk_numpad9,     "Numpad 9",
    vk_numpad0,     "Numpad 0",
    vk_pageup,      "Page Up",
    vk_pagedown,    "Page Down",
    vk_pause,       "Pause",
    vk_printscreen, "Print Screen",
    vk_return,      "Return",
    vk_ralt,        "Right Alt",
    vk_rcontrol,    "Right Control",
    vk_right,       "Right",
    vk_rshift,      "Right Shift",
    vk_space,       "Space",
    vk_subtract,    "Subtract",
    vk_tab,         "Tab",
    vk_up,          "Up"
];

#macro MENU_BUTTON_INFO_ICON_YOFFSET 0
#macro MENU_BUTTON_INFO_ICON_SCALE 2

#macro MENU_BUTTON_INFO_TEXT_YOFFSET 4
#macro MENU_BUTTON_INFO_TEXT_SCALE 1.5

#macro MENU_BUTTON_INFO_MIN_SCALE 1
#macro MENU_BUTTON_INFO_SAFE_ZONE 4

#macro MENU_TRANSITION_SPEED_FADE 0.03
#macro MENU_TRANSITION_SPEED_SWIPE 0.04

#macro MENU_CREDITS_ENTRIES_SCALE 0.8