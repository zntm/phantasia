function item_update_grass(_x, _y, _z, _tile = "phantasia:dirt", _spread = true)
{
	var _delta_time = global.delta_time;
	
	if (chance(0.95 * _delta_time)) exit;
	
	var _world_height = global.world_data[$ global.world.realm].value & 0xffff;
	
	var _item_data = global.item_data;
	
	var _tile2 = tile_get(_x, _y - 1, _z, undefined, _world_height);
	
	if (_tile2 != TILE_EMPTY)
	{
		var _data = _item_data[$ _tile2];
		
		if (_data.type & ITEM_TYPE_BIT.SOLID)
		{
			tile_place(_x, _y, _z, new Tile(_tile), _world_height);
			tile_update_neighbor(_x, _y, undefined, undefined, _world_height);
			
			exit;
		}
	}
	
	if (chance(0.80 * _delta_time)) exit;
	
	var _ = tile_get(_x, _y, _z, undefined, _world_height);
	
	var _x2 = _x + irandom_range(-3, 3);
	var _y2 = _y + irandom_range(-3, 3);
	
	if (tile_get(_x2, _y2, _z, undefined, _world_height) == _tile)
	{
		var _tile3 = tile_get(_x2, _y2 - 1, _z, undefined, _world_height);
		
		if (_tile3 == TILE_EMPTY) || ((_item_data[$ _tile3].type & ITEM_TYPE_BIT.SOLID) == 0)
		{
			tile_place(_x2, _y2, _z, new Tile(_), _world_height);
			tile_update_neighbor(_x2, _y2, undefined, undefined, _world_height);
		}
	}
}