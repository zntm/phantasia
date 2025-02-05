function tile_set(_x, _y, _z, _attribute, _value, _world_height = global.world_data[$ global.world.realm].get_world_height())
{
	if (_y < 0) || (_y >= _world_height) exit;
	
	var _inst = tile_get_inst(_x, _y, "set");
	
	var _index = tile_index(_x, _y, _z);
	
	if (_inst.chunk[_index] != TILE_EMPTY)
	{
		_inst.chunk[@ _index][$ _attribute] = _value;
	}
}