function file_load_world_chunk(_inst, _directory)
{
	var _item_data = global.item_data;
	
	_inst.is_generated = true;
	
	var _sun_rays_y = global.sun_rays_y;
	
	var _buffer = buffer_load_decompressed(_directory);
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
    var _;
    
	if (global.version_game[$ $"{VERSION_TYPE.BETA}_{VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}.{VERSION_NUMBER.PATCH}"] >= global.version_game[$ "1_1.2.0"])
	{
		_ = file_load_world_chunk_new(_inst, _buffer);
	}
	else
	{
		_ = file_load_world_chunk_old(_inst, _buffer);
	}
	
	buffer_delete(_buffer);
    
    return _;
}