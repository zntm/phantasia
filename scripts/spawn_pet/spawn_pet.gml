global.pets = [];

function spawn_pet(_x, _y, _id)
{
	var _data = global.pet_data[$ _id];
	
	var _length = array_length(global.pets);
	
	if (_length >= obj_Player.buffs[$ "pet_max"])
	{
		var _pet = global.pets[_length - 1];
		
		sfx_play($"phantasia:pet.despawn.{_data.name}", global.settings_value.sfx);
		
		instance_destroy(_pet);
		array_pop(global.pets);
	}
	
	sfx_play($"phantasia:pet.spawn.{_data.name}", global.settings_value.sfx);
	
	var _sprite_idle   = is_array_choose(_data.sprite_idle);
	var _sprite_moving = is_array_choose(_data.sprite_moving);
	
	with (instance_create_layer(_x, _y, "Instances", obj_Pet))
	{
		sprite_index = _sprite_idle;
		
		sprite_idle   = _sprite_idle;
		sprite_moving = _sprite_moving;
		
		type = _data.type;
		pet_id = _id;
		
		xoffset = 1;
		
		xvelocity = 0;
		yvelocity = 0;
		
		array_insert(global.pets, 0, id);
	}
}