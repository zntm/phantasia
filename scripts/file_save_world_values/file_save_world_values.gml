function file_save_world_values()
{
	var _command_value = global.command_value;
	
	var _names = struct_get_names(_command_value);
	var _length = array_length(_names);
	
	if (_length <= 0) exit;
	
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	buffer_write(_buffer, buffer_u32, _length);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		var _value = _command_value[$ _name];
		
		if (_value == undefined) continue;
		
		buffer_write(_buffer, buffer_string, _name);
		buffer_write(_buffer, buffer_f64, _value);
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));

	buffer_save(_buffer2, $"{global.world_directory}/Values.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}