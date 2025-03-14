function buffer_save_compressed(_buffer, _directory)
{
	var _buffer2 = buffer_compress(_buffer, 0, buffer_get_size(_buffer));
	
	buffer_save(_buffer2, _directory);
	
	buffer_delete(_buffer2);
}