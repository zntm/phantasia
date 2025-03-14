function file_save_player_effects(_inst)
{
	var _buffer = buffer_create(0xffff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
    file_save_snippet_effects(_buffer, _inst.effects);
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{DIRECTORY_PLAYERS}/{_inst.uuid}/effect.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}