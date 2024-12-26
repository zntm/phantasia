function save_info(_directory)
{
	var _world = global.world;
	
	// show_debug_message($"Saving World Info - {_world.name}");
	
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	buffer_write(_buffer, buffer_f64, datetime_to_unix());
	buffer_write(_buffer, buffer_string, _world.name);
	
	buffer_write(_buffer, buffer_f64, _world.seed);
	
	buffer_write(_buffer, buffer_f64, _world.time);
	buffer_write(_buffer, buffer_u64, _world.day);
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, _directory);
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
	
	// show_debug_message($"Saved World Info - {_world.name}");
}