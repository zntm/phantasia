icon = ico_Arrow_Right;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
	var _settings_names = global.settings_names;
	
	if (++global.menu_settings_index >= array_length(_settings_names))
	{
		global.menu_settings_index = 0;
	}
	
	inst_15A1C5E.text = loca_translate($"menu.settings.{_settings_names[global.menu_settings_index]}");
	
	menu_refresh_settings();
}