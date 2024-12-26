function init_window()
{
	var _settings_value = global.settings_value;
	
	window_set_fullscreen(_settings_value.fullscreen);

	var _borderless = _settings_value.borderless;

	window_set_showborder(!_borderless);
	window_enable_borderless_fullscreen(_borderless);

	var _size = string_split(global.settings_data.window_size.values[_settings_value.window_size], "x");

	window_set_size(real(_size[0]), real(_size[1]));

	window_center();
}