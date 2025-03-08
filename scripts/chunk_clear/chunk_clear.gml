function chunk_clear(_inst)
{
	if (_inst.is_generated)
	{
		file_save_world_chunk(_inst);
	}
    
    for (var i = 0; i < CHUNK_SIZE_X * CHUNK_SIZE_Y * CHUNK_SIZE_Z; ++i)
    {
        var _tile = chunk[i];
        
        if (_tile != TILE_EMPTY)
        {
            // Feather disable once GM1052
            delete _tile;
        }
    }
	
	for (var i = 0; i < CHUNK_SIZE_Z * 2; ++i)
	{
		surface_free_existing(_inst.surface[i]);
	}
    
	instance_destroy(_inst);
}