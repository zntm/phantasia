function file_load_player_spawn(_inst)
{
    var _dir = $"{global.world_directory}/dim/{string_replace_all(global.world.realm, ":", "/")}/player/{_inst.uuid}/spawn.dat";
    
    if (!file_exists(_dir))
    {
        return false;
    }
    
	var _buffer = buffer_load_decompressed(_dir);
    
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
     
    with (_inst)
    {
        x = buffer_read(_buffer, buffer_f64);
        y = buffer_read(_buffer, buffer_f64);
        
        xvelocity = buffer_read(_buffer, buffer_f16);
        yvelocity = buffer_read(_buffer, buffer_f16);
        
        ylast = buffer_read(_buffer, buffer_f64);
    }
	
	buffer_delete(_buffer);
    
    return true;
}