function ctrl_chunk_generate()
{
	static __index = [ 1, 11, 10, 6, 13, 15, 9, 2, 12, 7, 14, 3, 8, 4, 5, 16 ];
	
	var _world_height = global.world_data[$ global.world.realm].get_world_height();
	var _world_height_tile_size = (_world_height * TILE_SIZE) - CHUNK_SIZE_HEIGHT;
	
	var _item_data = global.item_data;
	
	var _camera_width_half  = global.camera_width  / 2;
	var _camera_height_half = global.camera_height / 2;
	
	var _xcenter = floor((global.camera_x + _camera_width_half)  / CHUNK_SIZE_WIDTH)  * CHUNK_SIZE_WIDTH;
	var _ycenter = floor((global.camera_y + _camera_height_half) / CHUNK_SIZE_HEIGHT) * CHUNK_SIZE_HEIGHT;
	
	var _xrefresh = ceil(_camera_width_half  / CHUNK_SIZE_WIDTH)  + 4;
	var _yrefresh = ceil(_camera_height_half / CHUNK_SIZE_HEIGHT) + 3;
	
	for (var _xoffset = -_xrefresh; _xoffset <= _xrefresh; ++_xoffset)
	{
		var _xchunk = _xcenter + (_xoffset * CHUNK_SIZE_WIDTH);
		var _xstart = floor(_xchunk / CHUNK_SIZE_WIDTH);
		
		for (var _yoffset = -_yrefresh; _yoffset <= _yrefresh; ++_yoffset)
		{
			var _ychunk = _ycenter + (_yoffset * CHUNK_SIZE_WIDTH);
			
			if (_ychunk < 0) || (_ychunk > _world_height_tile_size) continue;
			
			var _ystart = floor(_ychunk / CHUNK_SIZE_HEIGHT);
            
			var _inst = instance_position(_xchunk, _ychunk, obj_Chunk);
			
			if (!instance_exists(_inst))
			{
				_inst = instance_create_layer(_xchunk, _ychunk, "Instances", obj_Chunk);
			}
			
			with (_inst)
			{
                if (surface_display) && (chunk_nearby_mask == 0xff)
                {
                    is_in_view = true;
                }
			}
		}
	}
}