function tile_set(_x, _y, _z, _attribute, _value, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
	if (_y < 0) || (_y >= _world_height) exit;
	
	var _cx = tile_inst_x(_x);
	var _cy = tile_inst_y(_y);
	
	var _inst = instance_position(_cx, _cy, obj_Chunk);
	
	if (!instance_exists(_inst))
	{
		_inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
		_inst.chunk[@ tile_index(_x, _y, _z)][$ _attribute] = _value;
		
		exit;
	}
	
	var _index = tile_index(_x, _y, _z);
	
	if (_inst.chunk[_index] != TILE_EMPTY)
	{
		_inst.chunk[@ _index][$ _attribute] = _value;
	}
}