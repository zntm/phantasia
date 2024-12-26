function load_grimoire(_directory)
{
	var _buffer = buffer_load_decompressed($"{DIRECTORY_PLAYERS}/{_directory}/Grimoire.dat");
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
	var _length = buffer_read(_buffer, buffer_u32);
    
    global.unlocked_grimoire = array_create(_length);
	
	repeat (_length)
	{
		array_push(global.unlocked_grimoire, buffer_read(_buffer, buffer_string));
	}
	
	buffer_delete(_buffer);
}