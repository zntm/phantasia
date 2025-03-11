function chunk_clear(_inst, _force = false)
{
    with (_inst)
    {
        file_save_world_chunk(id, _force);
        
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
    		surface_free_existing(surface[i]);
    	}
        
        chunk_remove_nearby_mask(x, y);
        
    	instance_destroy();
    }
}