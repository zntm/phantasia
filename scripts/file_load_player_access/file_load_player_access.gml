function file_load_player_access(_inst)
{
	var _directory = $"{global.world_directory}/Players/{_inst.uuid}/Access_Level.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _buffer  = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
	
	var _version_major = buffer_read(_buffer2, buffer_u8);
	var _version_minor = buffer_read(_buffer2, buffer_u8);
	var _version_patch = buffer_read(_buffer2, buffer_u8);
	var _version_type  = buffer_read(_buffer2, buffer_u8);
	
    if (global.version_game[$ $"{VERSION_TYPE.BETA}_{VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}.{VERSION_NUMBER.PATCH}"] >= global.version_game[$ "1_1.2.0"])
    {
        file_load_player_access_new(_inst, _buffer2);
    }
    else
    {
        file_load_player_access_old(_inst, _buffer2);
    }
    
    buffer_delete(_buffer);
    buffer_delete(_buffer2);
}