function physics_dash(_key_left, _key_right, _dash, _delta_time)
{
    if (dash_facing == 0)
    {
        var _ = _key_right - _key_left;
        
        if (_ != 0)
        {
            dash_timer = _delta_time;
            dash_facing = _;
        }
        
        exit;
    }
    
    var _settings_value = global.settings_value;
    
    if (dash_facing == (keyboard_check_pressed(_settings_value.right) - keyboard_check_pressed(_settings_value.left)))
    {
        dash_speed = _dash;
        dash_timer = _delta_time;
        
        sfx_play("phantasia:action.dash", _settings_value.sfx, random_range(0.8, 1.2));
    }
}