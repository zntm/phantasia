global.item_data_on_draw = {}

function chunk_update(_delta_time)
{
	randomize();
	
	var _item_data_on_draw = global.item_data_on_draw;
	
	with (obj_Chunk)
	{
		if (!is_on_draw_update) || (!is_in_view) || ((surface_display & CHUNK_SIZE_Z_BIT) == 0) ||
			(!position_meeting(x - CHUNK_SIZE_WIDTH, y - CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
			(!position_meeting(x,                    y - CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
			(!position_meeting(x + CHUNK_SIZE_WIDTH, y - CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
			(!position_meeting(x - CHUNK_SIZE_WIDTH, y,                     obj_Chunk)) ||
			(!position_meeting(x + CHUNK_SIZE_WIDTH, y,                     obj_Chunk)) ||
			(!position_meeting(x - CHUNK_SIZE_WIDTH, y + CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
			(!position_meeting(x,                    y + CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
			(!position_meeting(x + CHUNK_SIZE_WIDTH, y + CHUNK_SIZE_HEIGHT, obj_Chunk)) continue;
		
		for (var _z = CHUNK_SIZE_Z - 1; _z >= 0; --_z)
		{
			var _zbit = 1 << _z;
			
			if ((surface_display & _zbit) == 0) || ((is_on_draw_update & _zbit) == 0) continue;
			
			var _zindex = _z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
			
			for (var i = 0; i < CHUNK_SIZE_X * CHUNK_SIZE_Y; ++i)
			{
				var _index = _zindex | i;
				
				var _tile = chunk[_index];
				
				if (_tile == TILE_EMPTY) || (!_tile.get_updated()) || (_item_data_on_draw[$ _tile.item_id] == undefined) continue;
				
				chunk[@ _index].set_updated(false);
			}
			
			for (var _y = CHUNK_SIZE_Y - 1; _y >= 0; --_y)
			{
				var _yzindex = (_y << CHUNK_SIZE_X_BIT) | _zindex;
				var _y2 = chunk_ystart + _y;
				
				for (var _x = CHUNK_SIZE_X - 1; _x >= 0; --_x)
				{
					var _xyzindex = _yzindex | _x;
					
					var _tile = chunk[_xyzindex];
					
					if (_tile == TILE_EMPTY) || (_tile.get_updated()) continue;
					
					var _function = _item_data_on_draw[$ _tile.item_id];
					
					if (_function == undefined) continue;
					
					chunk[@ _xyzindex].set_updated(true);
					
					_function(chunk_xstart + _x, _y2, _z, _tile, _delta_time);
				}
			}
		}
	}
}