function file_save_player_spawn(_inst)
{
	var _buffer = buffer_create(0xff, buffer_fixed, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	buffer_write(_buffer, buffer_string, global.world.realm);
	
	buffer_write(_buffer, buffer_f64, _inst.x);
	buffer_write(_buffer, buffer_f64, _inst.y);
	
	buffer_write(_buffer, buffer_f16, _inst.xvelocity);
	buffer_write(_buffer, buffer_f16, _inst.yvelocity);
	
	buffer_write(_buffer, buffer_f64, _inst.ylast);
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.world_directory}/Players/{_inst.uuid}/Spawnpoint.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}