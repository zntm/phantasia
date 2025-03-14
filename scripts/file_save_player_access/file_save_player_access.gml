function file_save_player_access(_inst)
{
	var _buffer = buffer_create(0xff, buffer_fixed, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	var _access_level = _inst.access_level;
	
	var _names  = struct_get_names(_access_level);
	var _length = array_length(_names);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		
		buffer_write(_buffer, buffer_string, _name);
		buffer_write(_buffer, buffer_u64, _access_level[$ _name]);
	}
	
	buffer_save_compressed(_buffer, $"{global.world_directory}/player/{_inst.uuid}/access_level.dat");
	
	buffer_delete(_buffer);
}