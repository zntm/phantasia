function settings_get_refresh_rate(_default_value = display_get_frequency())
{
	var _data = global.settings_data[$ "refresh_rate"];
	
	return ((_data != undefined) ? real(_data.values[global.settings_value.refresh_rate]) : _default_value);
}