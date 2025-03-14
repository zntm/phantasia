function file_load_player_position(_inst)
{
    var _dir = $"{global.world_directory}/dim/{string_replace_all(global.world.realm, ":", "/")}/pos/{_inst.uuid}.dat";
    
    if (!file_exists(_dir))
    {
        return false;
    }
    
	var _buffer = buffer_load_decompressed(_dir);
    
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
     
    file_load_snippet_position(_buffer, _inst);
	
	buffer_delete(_buffer);
    
    return true;
}