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
    
    if (_inst.x == global.tile_place_inst_x) && (_inst.y == global.tile_place_inst_y)
    {
        global.tile_place_inst_x = infinity;
        global.tile_place_inst_y = infinity;
    }
    
	instance_destroy(_inst);
}