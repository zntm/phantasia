function effect_set(_type, _time, _level = 1, _object = id, _particle = true)
{
	var _effect_data = global.effect_data;
	
	var _data = _effect_data[$ _type];
	
	if (_data == undefined) exit;
	
	var _effect_immune = _object.effect_immune;
	
	if (_effect_immune != undefined) && (array_contains(_effect_immune, _type)) exit;
	
	with (_object)
	{
		effects[$ _type] = {
			timer: _time * GAME_FPS,
			level: _level,
			particle: _particle
		}
		
		if (object_index == obj_Creature)
		{
			get_buffs(global.creature_data[$ creature_id].attributes);
		}
		else if (object_index == obj_Player)
		{
			get_buffs(global.attributes_player);
		}
	}
	
	/*
	var _on_effect = _data.on_effect;
	
	if (_on_effect != undefined)
	{
		_on_effect(x, y, id);
	}
	*/
}