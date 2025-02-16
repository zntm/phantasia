function tile_meeting(_x, _y, _z = CHUNK_DEPTH_DEFAULT, _type = ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM, _world_height = global.world_data[$ global.world.realm].get_world_height())
{
	if (_y < 0) || (_y >= (_world_height * TILE_SIZE))
	{
		return false;
	}
	
	var _item_data = global.item_data;
	
	var _xscale = abs(image_xscale);
	var _yscale = abs(image_yscale);
    
    var _x1 = _x - (_xscale * sprite_bbox_left);
    var _y1 = _y - (_yscale * sprite_bbox_top);
    
    var _x2 = _x1 + (_xscale * sprite_bbox_right)  - 1;
    var _y2 = _y1 + (_yscale * sprite_bbox_bottom) - 1;
    
	var _xstart = floor(_x1 / TILE_SIZE) - 1;
	var _ystart = floor(_y1 / TILE_SIZE) - 1;
	
	var _xend = ceil(_x2 / TILE_SIZE) + 1;
	var _yend = ceil(_y2 / TILE_SIZE) + 1;
	
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
			
			var _data  = _item_data[$ _tile.item_id];
			var _type2 = _data.type;
            
			if ((_type2 & _type) == 0) continue;
			
			var _xtile = i * TILE_SIZE;
            
			var _tile_xoffset = _tile.get_xoffset();
			var _tile_yoffset = _tile.get_yoffset();
			
			var _tile_xscale = _tile.get_xscale();
			var _tile_yscale = _tile.get_yscale();
			
            var _collision_box_length = _data.collision_box_length;
            
            for (var l = 0; l < _collision_box_length; ++l)
            {
                var _x3 = _xtile + ((_data.get_collision_box_left(l) + _tile_xoffset) * _tile_xscale);
                var _y3 = _ytile + ((_data.get_collision_box_top(l)  + _tile_yoffset) * _tile_yscale);
                
                var _x4 = _x3 + (_data.get_collision_box_right(l)  * _tile_xscale);
                var _y4 = _y3 + (_data.get_collision_box_bottom(l) * _tile_yscale);
                
                if (rectangle_in_rectangle(_x1, _y1, _x2, _y2, min(_x3, _x4), min(_y3, _y4), max(_x3, _x4), max(_y3, _y4)))
                {
                    return _tile;
                }
            }
		}
	}
	
	return false;
}