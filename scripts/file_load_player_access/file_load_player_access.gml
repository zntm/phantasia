function file_load_player_access(_inst)
{
	var _directory = $"{global.world_directory}/player/{_inst.uuid}/access_level.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _buffer = buffer_load_decompressed(_directory);
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
    if (global.version_game[$ $"{VERSION_TYPE.BETA}_{VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}.{VERSION_NUMBER.PATCH}"] >= global.version_game[$ "1_1.2.0"])
    {
        file_load_player_access_new(_inst, _buffer);
    }
    else
    {
        file_load_player_access_old(_inst, _buffer);
    }
    
    buffer_delete(_buffer);
}