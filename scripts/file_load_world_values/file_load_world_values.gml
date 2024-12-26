function file_load_world_values(_directory)
{
	if (!file_exists(_directory)) exit;
	
	var _buffer = buffer_load_decompressed(_directory);
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
	var _length = buffer_read(_buffer, buffer_u32);
	
	repeat (_length)
	{
		var _name  = buffer_read(_buffer, buffer_string);
		var _value = buffer_read(_buffer, buffer_f64);
		
		global.command_value[$ _name] = _value;
	}
	
	buffer_delete(_buffer);
}