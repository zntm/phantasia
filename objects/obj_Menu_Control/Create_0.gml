if (room != rm_World)
{
	var _handle = call_later(1, time_source_units_frames, menu_init_button_depth);
}
else
{
	game_set_speed(settings_get_refresh_rate(), gamespeed_fps);
}

offset = 1;
goto   = -1;

on_draw = -1;
on_escape = -1;
on_escape_activated = false;

on_exit = -1;

surface = [ -1 ];

shader = [ -1 ];
shader_function = [ -1 ];

xoffset = 0;
yoffset = 0;