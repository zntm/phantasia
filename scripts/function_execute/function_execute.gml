function function_execute(_x, _y, _z, _functions)
{
	var _particle_data = global.particle_data;
	
	var _xtile = _x * TILE_SIZE;
	var _ytile = _y * TILE_SIZE;
	
	var _length = array_length(_functions);
	
	for (var i = 0; i < _length; ++i)
	{
		var _function = _functions[i];
		
		var _chance = _function[0];
		
		if (_chance != undefined) && (!chance(_chance)) continue;
		
		var _type = _function[1];
		
		if (_type == FUNCTION_TYPE.TILE_PLACE)
		{
			
		}
		else if (_type == FUNCTION_TYPE.SPAWN_BOSS)
		{
			
		}
		else if (_type == FUNCTION_TYPE.SPAWN_CREATURE)
		{
			spawn_creature(_x, _y, _function[2], _function[3]);
		}
		else if (_type == FUNCTION_TYPE.SPAWN_ITEM_DROP)
		{
			
		}
		else if (_type == FUNCTION_TYPE.SPAWN_PARTICLE)
		{
			spawn_particle(_x, _y, _z, _function[2], _function[3], _function[4]);
		}
		else if (_type == FUNCTION_TYPE.SPAWN_PROJECTILE)
		{
			
		}
	}
}