enum FUNCTION_TYPE {
	TILE_PLACE,
	SPAWN_BOSS,
	SPAWN_CREATURE,
	SPAWN_ITEM_DROP,
	SPAWN_PARTICLE,
	SPAWN_PROJECTILE
}

function function_parse(_functions)
{
	var _length = array_length(_functions);
	
	var _data = array_create(_length);
	
	for (var i = 0; i < _length; ++i)
	{
		var _function = _functions[i];
		
		var _type = _function.type;
		
		if (_type == "tile_place")
		{
		}
		else if (_type == "spawn_boss")
		{
		}
		else if (_type == "spawn_creature")
		{
			_data[@ i] = [
				_function[$ "chance"],
				FUNCTION_TYPE.SPAWN_CREATURE,
				_function.creature_id,
				_function[$ "amount"],
			];
		}
		else if (_type == "spawn_particle")
		{
			var _colour = _function[$ "colour"];
			
			_data[@ i] = [
				_function[$ "chance"],
				FUNCTION_TYPE.SPAWN_PARTICLE,
				_function.particle_id,
				_function[$ "amount"],
				(_colour != undefined ? hex_parse(_colour) : undefined)
			];
		}
		else if (_type == "spawn_projectile")
		{
		}
	}
	
	return _data;
}