function chunk_refresh_fast(_x1, _y1, _x2, _y2)
{
	with (obj_Chunk)
	{
		if (!surface_display) continue;
		
		var _x = x - TILE_SIZE_H;
		var _y = y - TILE_SIZE_H;
		
		if (!rectangle_in_rectangle(_x, _y, _x - 1 + CHUNK_SIZE_WIDTH, _y - 1 + CHUNK_SIZE_HEIGHT, _x1, _y1, _x2, _y2)) continue;
		
		chunk_z_refresh |= surface_display;
	}
}