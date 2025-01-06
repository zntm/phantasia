enum FPS_REDUCTION {
	AFK = 8,
	NO_FOCUS = 16
}

#macro FPS_REDUCTION_TIME_THRESHOLD (GAME_FPS * 15)

function control_fps()
{
	var _refresh_rate = settings_get_refresh_rate();
	var _gamespeed = game_get_speed(gamespeed_fps);
	
	afk_time += global.delta_time / global.world_settings.tick_speed;
	
	if (!window_has_focus())
	{
		if (_gamespeed == _refresh_rate)
		{
			game_set_speed(FPS_REDUCTION.NO_FOCUS, gamespeed_fps);
		}
	}
	else if (_gamespeed != _refresh_rate)
	{
		game_set_speed(_refresh_rate, gamespeed_fps);
		
		exit;
	}
	
	if (keyboard_check(vk_anykey)) || (mouse_wheel_up()) || (mouse_wheel_down())
	{
		afk_time = 0;
		
		if (_gamespeed != _refresh_rate)
		{
			game_set_speed(_refresh_rate, gamespeed_fps);
		}
	}
	else if (_gamespeed == _refresh_rate)
	{
		if (afk_time >= FPS_REDUCTION_TIME_THRESHOLD)
		{
			game_set_speed(FPS_REDUCTION.AFK, gamespeed_fps);
		}
	}
}