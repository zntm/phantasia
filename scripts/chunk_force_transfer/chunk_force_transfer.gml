function chunk_force_transfer(_, _camera_y, _camera_height)
{
	var _x1 = _ - CHUNK_SIZE_WIDTH_H;
	var _y1 = _camera_y - CHUNK_FORCE_REFRESH_YPADDING;
	var _x2 = _;
	var _y2 = _camera_y + _camera_height + CHUNK_FORCE_REFRESH_YPADDING;
	
	with (obj_Chunk)
	{
		if (!is_in_view) || (!is_generated) || (!surface_display) continue;
		
		var _x3 = x - TILE_SIZE_H;
		var _y3 = y - TILE_SIZE_H;
		
		if (!rectangle_in_rectangle(_x3, _y3, _x3 - 1 + CHUNK_SIZE_WIDTH, _y3 - 1 + CHUNK_SIZE_HEIGHT, _x1, _y1, _x2, _y2)) continue;
		
		var _inst = instance_nearest(xcenter, ycenter, obj_Parent_Light);
		
		if (!instance_exists(_inst)) || (!rectangle_in_rectangle(xcenter - CHUNK_SIZE_WIDTH, ycenter - CHUNK_SIZE_HEIGHT, xcenter + CHUNK_SIZE_WIDTH, ycenter + CHUNK_SIZE_HEIGHT, _inst.bbox_left, _inst.bbox_top, _inst.bbox_right, _inst.bbox_bottom))
		{
			is_in_view = false;
		}
	}
}