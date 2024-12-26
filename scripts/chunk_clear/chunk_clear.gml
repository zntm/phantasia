function chunk_clear(_inst)
{
	if (_inst.is_generated)
	{
		file_save_world_chunk(_inst);
	}
	
	for (var i = 0; i < CHUNK_SIZE_Z; ++i)
	{
		surface_free_existing(_inst.surface[i]);
		buffer_delete_existing(_inst.surface_buffer[i]);
	}
	
	instance_destroy(_inst);
}