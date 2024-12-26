function load_grimoire(_directory)
{
	var _buffer  = buffer_load($"{DIRECTORY_PLAYERS}/{_directory}/Grimoire.dat");
	var _buffer2 = buffer_decompress(_buffer);
	
	var _version_major = buffer_read(_buffer2, buffer_u8);
	var _version_minor = buffer_read(_buffer2, buffer_u8);
	var _version_patch = buffer_read(_buffer2, buffer_u8);
	var _version_type  = buffer_read(_buffer2, buffer_u8);
	
	global.unlocked_grimoire = [];
	
	var _length = buffer_read(_buffer2, buffer_u32);
	
	repeat (_length)
	{
		array_push(global.unlocked_grimoire, buffer_read(_buffer2, buffer_string));
	}
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}