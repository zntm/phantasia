enum TILE_UPDATE_CHUNK_BOOLEAN {
	KEEP_DISPLAY = 1,
	CACHE_DRAW_UPDATE = 2
}

enum TILE_UPDATE_CHUNK_CONDITION {
	CACHE_DRAW_UPDATE = 1
}

function tile_update_chunk_condition(_inst, _tile, _z, _condition = 0)
{
	static __update = function(_inst, _tile, _z, _condition)
	{
		var _cache_draw_update = global.item_data_on_draw;
        
		var _update_condition_boolean = 0;
        
		if (_cache_draw_update[$ _tile] != undefined)
		{
			_update_condition_boolean |= TILE_UPDATE_CHUNK_CONDITION.CACHE_DRAW_UPDATE;
		}
        
		var _zbit= 1 << _z;
		var _zindex = _z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
        
		var _condition_cache_draw_update = _condition & TILE_UPDATE_CHUNK_CONDITION.CACHE_DRAW_UPDATE;
        
		if (_condition_cache_draw_update) && (_inst.is_on_draw_update & _zbit)
		{
			_inst.is_on_draw_update ^= _zbit;
		}
        
		var _chunk = _inst.chunk;
		var _boolean = 0;
        
		for (var _y = 0; _y < CHUNK_SIZE_Y; ++_y)
		{
			var _yzindex = (_y << CHUNK_SIZE_X_BIT) | _zindex;
            
			for (var _x = 0; _x < CHUNK_SIZE_X; ++_x)
			{
				var _ = _chunk[_x | _yzindex];
                
				if (_ == TILE_EMPTY) continue;
                
				_boolean |= TILE_UPDATE_CHUNK_BOOLEAN.KEEP_DISPLAY;
                
				if (_condition_cache_draw_update) && (_cache_draw_update[$ _.item_id] != undefined)
				{
					_boolean |= TILE_UPDATE_CHUNK_BOOLEAN.CACHE_DRAW_UPDATE;
				}
			}
		}
        
		if (_boolean & TILE_UPDATE_CHUNK_BOOLEAN.KEEP_DISPLAY)
		{
			_inst.chunk_z_refresh |= _zbit;
		}
		else if (_inst.surface_display & _zbit)
		{
			_inst.surface_display ^= _zbit;
		}
        
		if (_boolean & TILE_UPDATE_CHUNK_BOOLEAN.CACHE_DRAW_UPDATE)
		{
			_inst.is_on_draw_update |= _zbit;
		}
	}
	
	__update(_inst, _tile, _z, _condition);
	
	if (_z == CHUNK_DEPTH_DEFAULT)
	{
		__update(_inst, _tile, CHUNK_DEPTH_WALL, _condition);
	}
}