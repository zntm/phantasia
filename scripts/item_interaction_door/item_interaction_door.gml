function item_interaction_door(_x, _y, _z)
{
	var _tile = tile_get(_x, _y, _z, -1);
	var _boolean = _tile.boolean;
		
	if (_boolean & 0b_1)
	{
		tile_set(_x, _y, _z, "boolean", _boolean & 0b_10);
		tile_set(_x, _y, _z, "scale_rotation_index", (1 << 8) | (_tile.scale_rotation_index & 0xfffff00ff));
			
		exit;
	}
		
	tile_set(_x, _y, _z, "boolean", _boolean | 0b_1);
	tile_set(_x, _y, _z, "scale_rotation_index", _tile.scale_rotation_index & 0xfffff00ff);
}