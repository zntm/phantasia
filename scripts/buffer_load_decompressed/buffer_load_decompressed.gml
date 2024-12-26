function buffer_load_decompressed(_directory)
{
	var _buffer  = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
	
	buffer_delete(_buffer);
	
	return _buffer2;
}