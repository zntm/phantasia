function physics_dash(_key_left, _key_right, _dash, _delta_time)
{
	if (dash_speed > 0)
	{
		_key_left = false;
		_key_right = false;
		
		dash_speed -= _delta_time;
	}
	
	if (_dash <= 0)
	{
		dash_facing = 0;
		dash_speed = 0;
		
		if (dash_timer > 0)
		{
			dash_timer += _delta_time;
			
			if (dash_timer >= buffs[$ "dash_cooldown"])
			{
				dash_timer = 0;
			}
		}
		
		exit;
	}
	
	if (dash_speed > 0) exit;
	
	if (dash_timer > 0)
	{
		var _settings_value = global.settings_value;
			
		if (dash_facing == (keyboard_check_pressed(_settings_value.right) - keyboard_check_pressed(_settings_value.left)))
		{
			dash_speed = _dash;
			dash_timer = 0;
			
			sfx_play("phantasia:action.dash", _settings_value.master * _settings_value.sfx, random_range(0.8, 1.2));
			
			exit;
		}
		
		dash_timer += _delta_time;
		
		if (dash_timer > COOLDOWN_MAX_DASH)
		{
			dash_timer = 0;
		}
			
		exit;
	}
		
	dash_facing = _key_right - _key_left;
		
	if (dash_facing != 0)
	{
		dash_timer = _delta_time;
	}
}