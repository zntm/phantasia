function file_load_world_settings()
{
	if (!directory_exists($"{global.world_directory}/Settings.dat")) exit;
	
	var _buffer = buffer_load_decompressed($"{global.world_directory}/Settings.dat");
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
	var _length = buffer_read(_buffer, buffer_u16);
	
	repeat (_length)
	{
		var _name  = buffer_read(_buffer, buffer_string);
		var _value = buffer_read(_buffer, buffer_f64);
		
		global.world_settings[$ _name] = _value;
	}
	
	buffer_delete(_buffer);
}