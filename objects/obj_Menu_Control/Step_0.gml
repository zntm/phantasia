if (room != rm_World)
{
	if (keyboard_check_pressed(vk_f11))
	{
		var _fullscreen = !global.settings_value.fullscreen;
	
		global.settings_value.fullscreen = _fullscreen;
	
		window_set_fullscreen(_fullscreen);
	}
	
	global.delta_time = GAME_FPS * (delta_time / 1_000_000);
	
	if (on_escape != -1) && (!on_escape_activated) && (offset == 0) && (global.menu_bg_fade == 0) && (keyboard_check_pressed(vk_escape))
	{
		on_escape();
		on_escape_activated = true;
	}
	
	global.timer_delta += global.delta_time;
}