function tile_update_neighbor(_x, _y, _xsize = 1, _ysize = 1, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
	var _xstart = _x - _xsize;
	var _ystart = _y - _ysize;
	
	var _xend = _x + _xsize;
	var _yend = _y + _ysize;
	
	for (var i = _xstart; i <= _xend; ++i)
	{
		for (var j = _ystart; j <= _yend; ++j)
		{
			for (var l = 0; l < CHUNK_SIZE_Z; ++l)
			{
				tile_update(i, j, l, _world_height);
			}
		}
	}
}