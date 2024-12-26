function file_load_world_structures()
{
	var _directory = $"{global.world_directory}/{string_replace_all(global.world.realm, ":", "/")}/Structures.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _structure_data = global.structure_data;
	
	var _buffer = buffer_load_decompressed(_directory);
	
    var _version_major = buffer_read(_buffer, buffer_u8);
    var _version_minor = buffer_read(_buffer, buffer_u8);
    var _version_patch = buffer_read(_buffer, buffer_u8);
    var _version_type  = buffer_read(_buffer, buffer_u8);
    
    if (global.version_game[$ $"{VERSION_TYPE.BETA}_{VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}.{VERSION_NUMBER.PATCH}"] >= global.version_game[$ "1_1.2.0"])
    {
        file_load_world_structures_new(_buffer);
    }
    else
    {
        file_load_world_structures_old(_buffer);
    }
	
	buffer_delete(_buffer);
}