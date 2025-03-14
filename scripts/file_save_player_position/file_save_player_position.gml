function file_save_player_position(_inst)
{
	var _buffer = buffer_create(0xff, buffer_fixed, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
    file_save_snippet_position(_buffer, _inst);
    
	buffer_save_compressed(_buffer, $"{global.world_directory}/dim/{string_replace_all(global.world.realm, ":", "/")}/pos/{_inst.uuid}.dat");
	
	buffer_delete(_buffer);
}