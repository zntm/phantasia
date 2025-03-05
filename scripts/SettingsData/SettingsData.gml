enum SETTINGS_TYPE {
    SWITCH,
    // Left and right arrow to switch between values
    ARROW,
    // Creates a slider from 0 to 1
    SLIDER,
    HOTKEY
}

function SettingsData(_value = 1, _type = SETTINGS_TYPE.SWITCH) constructor
{
    value = _value;
    type = _type;
    
    on_press = undefined;
    
    static set_on_press = function(_on_press)
    {
        on_press = _on_press;
        
        return self;
    }
    
    on_hold = undefined;
    
    static set_on_hold = function(_on_hold)
    {
        on_hold = _on_hold;
        
        return self;
    }
    
    on_update = undefined;
    
    static set_on_update = function(_on_update)
    {
        on_update = _on_update;
        
        return self;
    }
    
    static add_values = function()
    {
        for (var i = 0; i < argument_count; ++i)
        {
            array_push(values, string(argument[i]));
        }
        
        return self;
    }
    
    if (_type == SETTINGS_TYPE.ARROW)
    {
        values = [];
    }
}

global.settings_names = [];
global.settings_data = {}
global.settings_value = {}
global.settings_category = {}

function add_setting(_category, _type, _setting)
{
    if (!array_contains(global.settings_names, _category))
    {
        array_push(global.settings_names, _category);
    }
    
    global.settings_category[$ _category] ??= [];
    
    array_push(global.settings_category[$ _category], _type);
    
    global.settings_data[$ _type] = _setting;
    global.settings_value[$ _type] = _setting.value;
}

#region General

add_setting("general", "discord_rpc", new SettingsData(true, SETTINGS_TYPE.SWITCH)
    .set_on_press(function(_name, _value) {
        if (!_value)
        {
            __np_shutdown();
            
            exit;
        }
        
        if (!np_initdiscord(DISCORD_APP_ID, true, np_steam_app_id_empty))
        {
            throw "NekoPresence init fail.";
        }
        
        np_update();
        rpc_menu();
    }));

add_setting("general", "toast_notification", new SettingsData(true, SETTINGS_TYPE.SWITCH));

add_setting("general", "profanity_filter", new SettingsData(true, SETTINGS_TYPE.SWITCH));

add_setting("general", "skip_warning", new SettingsData(false, SETTINGS_TYPE.SWITCH));

var _frequency = display_get_frequency();

if (_frequency > 60)
{
    var _data = new SettingsData(0, SETTINGS_TYPE.ARROW)
        .add_values(60)
        .set_on_update(function(_name, _value)
        {
            game_set_speed(real(global.settings_data.refresh_rate.values[_value]), gamespeed_fps);
        });
    
    var _frequencies = [ 90, 120, 144, 165, 240, 300, 360 ];
    var _frequencies_length = array_length(_frequencies);
    
    var _max_frequency = infinity;
    
    for (var i = 0; i < _frequencies_length; ++i)
    {
        var _ = _frequencies[i];
        
        if (_frequency < _)
        {
            _max_frequency = _;
            
            break;
        }
        
        _data.add_values(_);
    }
    
    if (_max_frequency < _frequency)
    {
        _data.add_values(_max_frequency);
    }
    
    add_setting("general", "refresh_rate", _data);
}

#endregion

#region Graphics

add_setting("graphics", "background", new SettingsData(true, SETTINGS_TYPE.SWITCH));

add_setting("graphics", "particles", new SettingsData(2, SETTINGS_TYPE.ARROW)
    .add_values("None", "Min", "Max"));

add_setting("graphics", "weather", new SettingsData(2, SETTINGS_TYPE.ARROW)
    .add_values("None", "Min", "Max"));

add_setting("graphics", "coloured_lighting", new SettingsData(true, SETTINGS_TYPE.SWITCH));

add_setting("graphics", "gui_size", new SettingsData(2, SETTINGS_TYPE.ARROW)
    .add_values("960x540", "1280x720", "1366x768", "1920x1080"));

add_setting("graphics", "window_size", new SettingsData(2, SETTINGS_TYPE.ARROW)
    .add_values("960x540", "1280x720", "1366x768", "1920x1080"));

add_setting("graphics", "fullscreen", new SettingsData(false, SETTINGS_TYPE.SWITCH)
    .set_on_press(function(_name, _value)
    {
        window_set_fullscreen(_value);
        
        if (_value) exit;
        
        var _size = string_split(global.settings_data.window_size.values[global.settings_value.window_size], "x");
        
        window_set_size(real(_size[0]), real(_size[1]));
        window_center();
    }));

add_setting("graphics", "borderless", new SettingsData(false, SETTINGS_TYPE.SWITCH)
    .set_on_press(function(_name, _value)
    {
        window_set_showborder(!_value);
        window_enable_borderless_fullscreen(_value);
    }));

add_setting("graphics", "vsync", new SettingsData(false, SETTINGS_TYPE.SWITCH)
    .set_on_press(function(_name, _value)
    {
        display_reset(0, _value);
    }));

#endregion

#region Conrols

add_setting("controls", "left", new SettingsData(ord("A"), SETTINGS_TYPE.HOTKEY));

add_setting("controls", "right", new SettingsData(ord("D"), SETTINGS_TYPE.HOTKEY));

add_setting("controls", "jump", new SettingsData(vk_space, SETTINGS_TYPE.HOTKEY));

add_setting("controls", "inventory", new SettingsData(ord("E"), SETTINGS_TYPE.HOTKEY));

add_setting("controls", "drop", new SettingsData(ord("Q"), SETTINGS_TYPE.HOTKEY));

add_setting("controls", "climb_up", new SettingsData(ord("W"), SETTINGS_TYPE.HOTKEY));

add_setting("controls", "climb_down", new SettingsData(ord("S"), SETTINGS_TYPE.HOTKEY));

#endregion

#region Audio

add_setting("audio", "master", new SettingsData(1, SETTINGS_TYPE.SLIDER)
    .set_on_update(function(_name, _value)
    {
        audio_sound_gain(global.music_data[$ "phantasia:phantasia"], _value * global.settings_value.music, 0);
    }));

add_setting("audio", "music", new SettingsData(1, SETTINGS_TYPE.SLIDER)
    .set_on_update(function(_name, _value)
    {
        audio_sound_gain(global.music_data[$ "phantasia:phantasia"], global.settings_value.master * _value, 0);
    }));

add_setting("audio", "sfx", new SettingsData(1, SETTINGS_TYPE.SLIDER));

add_setting("audio", "blocks", new SettingsData(1, SETTINGS_TYPE.SLIDER));

add_setting("audio", "creature_passive", new SettingsData(1, SETTINGS_TYPE.SLIDER));

add_setting("audio", "creature_hostile", new SettingsData(1, SETTINGS_TYPE.SLIDER));

#endregion

#region Accessibility

var _language = new SettingsData(0, SETTINGS_TYPE.ARROW)
    .set_on_press(function(_data, _value)
    {
        loca_setup("phantasia", $"{_value + 1}. {_data.values[_value]}");
    });

var _languages = file_read_directory($"{DATAFILES_RESOURCES}\\languages");
var _languages_length = array_length(_languages);

for (var i = 0; i < _languages_length; ++i)
{
    _language.add_values(string_split(_languages[i], " ")[1]);
}

add_setting("accessibility", "language", _language);

add_setting("accessibility", "colourblind", new SettingsData(0, SETTINGS_TYPE.ARROW)
    .add_values("Off", "Protanopia", "Deuteranopia", "Tritanopia", "Achromatopsia", "Protanopaly", "Deuteranomaly", "Tritanomaly", "Achromatomaly"));

add_setting("accessibility", "clear_text", new SettingsData(0, SETTINGS_TYPE.SWITCH)
    .set_on_press(loca_effect));

add_setting("accessibility", "camera_shake", new SettingsData(1, SETTINGS_TYPE.SLIDER));

add_setting("accessibility", "blur_strength", new SettingsData(1, SETTINGS_TYPE.SLIDER));

#endregion

if (file_exists("Global.json")) && (file_exists("setting.dat"))
{
    var _buffer = buffer_load_decompressed("setting.dat");
    
    var _version_major = buffer_read(_buffer, buffer_u8);
    var _version_minor = buffer_read(_buffer, buffer_u8);
    var _version_patch = buffer_read(_buffer, buffer_u8);
    var _version_type  = buffer_read(_buffer, buffer_u8);
    
    var _length = buffer_read(_buffer, buffer_u8);
    
    repeat (_length)
    {
        var _name = buffer_read(_buffer, buffer_string);
        
        global.settings_value[$ _name] = buffer_read(_buffer, buffer_f16);
    }
    
    buffer_delete(_buffer);
}