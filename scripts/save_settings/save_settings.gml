function save_settings()
{
	var _buffer = buffer_create(0x800, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	var _settings_value = global.settings_value;
	var _settings_value_names = struct_get_names(_settings_value);
	var _settings_value_length = array_length(_settings_value_names);
	
	buffer_write(_buffer, buffer_u8, _settings_value_length);
	
	for (var i = 0; i < _settings_value_length; ++i)
	{
		var _settings_value_name = _settings_value_names[i];
		
		buffer_write(_buffer, buffer_string, _settings_value_name);
		buffer_write(_buffer, buffer_f16, _settings_value[$ _settings_value_name]);
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, "Settings.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}