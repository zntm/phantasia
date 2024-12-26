function file_save_world_realm_environment()
{
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	var _world_environment = global.world_environment;
	
	var _names  = struct_get_names(_world_environment);
	var _length = array_length(_names);
	
	buffer_write(_buffer, buffer_u16, _length);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		
		buffer_write(_buffer, buffer_string, _name);
		buffer_write(_buffer, buffer_f64, _world_environment[$ _name]);
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.world_directory}/Realms/{string_replace_all(global.world.realm, ":", "/")}/Environment.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}