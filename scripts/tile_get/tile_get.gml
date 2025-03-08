/// @func tile_get(x, y, z, [attribute])
/// @desc Gets the tile's item ID in the world at any given point.
/// @arg {Real} x The x position the _tile will be collected at
/// @arg {Real} y The y position the _tile will be collected at
/// @arg {Real} z The z position the _tile will be collected at
/// @arg {String} attribute The attribute of the tile will be collected at (-1 for whole data)
function tile_get(_x, _y, _z, _attribute = "item_id", _world_height = global.world_data[$ global.world.realm].get_world_height())
{
	if (_y < 0) || (_y >= _world_height)
	{
		return TILE_EMPTY;
	}
	
	var _inst = tile_get_inst(_x, _y);
	
	var _tile = _inst.chunk[tile_index(_x, _y, _z)];
	
	if (_tile == TILE_EMPTY)
	{
		return TILE_EMPTY;
	}
	
	if (_attribute == -1)
	{
		return _tile;
	}
	
	return _tile[$ _attribute];
}