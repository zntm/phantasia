enum LIQUID_DIRECTION {
	LEFT,
	RIGHT
}

function item_update_liquid_flow(_x, _y, _z, _liquid, _frame_amount)
{
	static __flow = function(_x, _y, _id, _xoffset, _yoffset, _frame, _item_data, _world_height, _direction, _xsize = 1, _ysize = 1)
	{
		var _tile = tile_get(_x, _y, CHUNK_DEPTH_LIQUID, -1, _world_height);
		
		if (_tile == TILE_EMPTY)
		{
			return true;
		}
		
		var _x2 = _x + _xoffset;
		var _y2 = _y + _yoffset;
		
		var _t = tile_get(_x2, _y2, CHUNK_DEPTH_DEFAULT, -1, _world_height);
		
		if (_t != -1) && (_item_data[$ _t.item_id].type & ITEM_TYPE_BIT.SOLID)
		{
			return false;
		}
		
		var _l = tile_get(_x2, _y2, CHUNK_DEPTH_LIQUID, -1, _world_height);
		
		if (_l == TILE_EMPTY)
		{
			var _s1 = _tile.state_id;
			var _v1 = (_s1 >> 16) & 0xff;
			
			if (_v1 > 1)
			{
				_tile.state_id = ((_v1 - 1) << 16) | (_s1 & 0xff00ffff);
				
				tile_place(_x, _y, CHUNK_DEPTH_LIQUID, _tile
					.set_updated()
					.set_index_offset((tile_get(_x, _y - 1, CHUNK_DEPTH_LIQUID, undefined, _world_height) == _id ? 8 : (7 - _v1)) * _frame), _world_height);
			}
			else
			{
				tile_place(_x, _y, CHUNK_DEPTH_LIQUID, TILE_EMPTY, _world_height);
			}
			
			tile_place(_x2, _y2, CHUNK_DEPTH_LIQUID, new Tile(_id)
				.set_state((_direction << 8) | 1)
				.set_updated()
				.set_index_offset((tile_get(_x2, _y2 - 1, CHUNK_DEPTH_LIQUID, undefined, _world_height) == _id ? 8 : 7) * _frame), _world_height);
		}
		else if (_l.item_id == _id)
		{
			var _s2 = _l.state_id;
			var _v2 = (_s2 >> 16) & 0xf;
			
			if (_v2 >= 8)
			{
				return false;
			}
			
			var _s1 = _tile.state_id;
			var _v1 = (_s1 >> 16) & 0xff;
			
			if (_v1 > 1)
			{
				_tile.state_id = ((_v1 - 1) << 16) | (_s1 & 0xff00ffff);
				
				tile_place(_x, _y, CHUNK_DEPTH_LIQUID, _tile
					.set_updated()
					.set_index_offset((tile_get(_x, _y - 1, CHUNK_DEPTH_LIQUID, undefined, _world_height) == _id ? 8 : (7 - _v1)) * _frame), _world_height);
			}
			else
			{
				tile_place(_x, _y, CHUNK_DEPTH_LIQUID, -1, _world_height);
			}
			
			_l.state_id = ((_v2 + 1) << 16) | (_s2 & 0xff00ffff);
			
			tile_place(_x2, _y2, CHUNK_DEPTH_LIQUID, _l
				.set_updated()
				.set_index_offset((tile_get(_x2, _y2 - 1, CHUNK_DEPTH_LIQUID, undefined, _world_height) == _id ? 8 : (7 - _v2)) * _frame), _world_height);
		}
		
		tile_update_neighbor(_x, _y, _xsize, _ysize, _world_height);
		
		return true;
	}
	
	var _item_data = global.item_data;
	var _world_height = global.world_data[$ global.world.realm].value & 0xffff;
	
	__flow(_x, _y, _liquid, 0, 1, _frame_amount, _item_data, _world_height, 0, 1, 2);
	
	__flow(_x, _y, _liquid, -1, 0, _frame_amount, _item_data, _world_height, 0, 2, 1);
	__flow(_x, _y, _liquid,  1, 0, _frame_amount, _item_data, _world_height, 0, 2, 1);
}