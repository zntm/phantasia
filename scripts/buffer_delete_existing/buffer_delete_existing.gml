function buffer_delete_existing(_buffer)
{
	gml_pragma("forceinline");
	
	if (buffer_exists(_buffer))
	{
		buffer_delete(_buffer);
	}
}