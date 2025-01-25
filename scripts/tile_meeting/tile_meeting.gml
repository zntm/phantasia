function tile_meeting(_x, _y, _z = CHUNK_DEPTH_DEFAULT, _type = ITEM_TYPE_BIT.SOLID, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
	if (_y < 0) || (_y >= (_world_height * TILE_SIZE))
	{
		return false;
	}
	
	var _item_data = global.item_data;
	
	var _xscale = abs(image_xscale);
	var _yscale = abs(image_yscale);
	
	var _ax1 = _x - abs(_xscale * sprite_offset_x);
	var _ay1 = _y - abs(_yscale * sprite_offset_y);
	
	var _ax2 = _ax1 + abs(_xscale * sprite_bbox_right);
	var _ay2 = _ay1 + abs(_yscale * sprite_bbox_bottom);
	
	var _x1 = (_ax1 < _ax2 ? _ax1 : _ax2) + abs(_xscale * sprite_bbox_left);
	var _y1 = (_ay1 < _ay2 ? _ay1 : _ay2) + abs(_yscale * sprite_bbox_top);
	var _x2 = (_ax1 > _ax2 ? _ax1 : _ax2);
	var _y2 = (_ay1 > _ay2 ? _ay1 : _ay2) - 1;
     
	var _xstart = floor(_x1 / TILE_SIZE);
	var _ystart = floor(_y1 / TILE_SIZE);
	
	var _xend = ceil(_x2 / TILE_SIZE);
	var _yend = ceil(_y2 / TILE_SIZE);
	
	for (var j = max(0, _ystart); j <= _yend; ++j)
	{
		if (j >= _world_height)
		{
			return false;
		}
		
		var _ytile = j * TILE_SIZE;
		
		for (var i = _xstart; i <= _xend; ++i)
		{
			var _tile = tile_get(i, j, _z, -1, _world_height);
			
			if (_tile == TILE_EMPTY) || (!_tile.get_collision()) continue;
			
			var _data = _item_data[$ _tile.item_id];
			
			if ((_data.type & _type) == 0) continue;
			
			var _xtile = i * TILE_SIZE;
            
            var _scale_rotation_index = _tile.scale_rotation_index;
			
			var _tile_xoffset = ((_scale_rotation_index >> 40) & 0xf) - 8 - 0x80;
			var _tile_yoffset = ((_scale_rotation_index >> 44) & 0xf) - 8 - 0x80;
			
			var _tile_xscale = abs(((_scale_rotation_index >> 32) & 0xf) - 8);
			var _tile_yscale = abs(((_scale_rotation_index >> 36) & 0xf) - 8);
			
			var _collision_box = _data.collision_box;
			var _collision_box_length = _data.collision_box_length;
			
			for (var l = 0; l < _collision_box_length; ++l)
			{
				var _ = _collision_box[l];
				
				var _x3 = _xtile + (((_ & 0xff) + _tile_xoffset) * _tile_xscale);
				
				if (_x2 <= _x3) || (_x1 > _x3 + ((((_ >> 16) & 0xff) + _tile_xoffset) * _tile_xscale)) continue;
				
				var _y3 = _ytile + ((((_ >> 8) & 0xff) + _tile_yoffset) * _tile_yscale);
				
				if (_y2 <= _y3) || (_y1 > _y3 + ((((_ >> 24) & 0xff) + _tile_yoffset) * _tile_yscale)) continue;
				
				return true;
			}
		}
	}
	
	return false;
}