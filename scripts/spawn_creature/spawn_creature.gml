#macro SPAWN_CREATURE_MAX 200

function spawn_creature(_x, _y, _id, _amount = 1)
{
	var _data = global.creature_data[$ _id];
	var _type = _data.type;
	
	var _is_passive = (_data.get_hostility_type() == CREATURE_HOSTILITY_TYPE.PASSIVE);
	
	var _sprite = _data.sprite_idle;
	
	var _hp = round(_data.hp * global.difficulty_multiplier_hp[global.world_settings.difficulty]);
	
	var _attributes = _data.attributes;
	
	var _colour_offset = _data.colour_offset;
	var _effect_immune = _data.effect_immune;
	
	var _sprite_index = _data.sprite_index;
	
	if (is_struct(_sprite_index))
	{
		var _index2 = _sprite_index[$ bg_get_biome(round(_x / TILE_SIZE), round(_y / TILE_SIZE))] ?? _sprite_index[$ "default"];
		
		repeat (_amount)
		{
			var _id2 = instance_create_layer(_x, _y, "Instances", obj_Creature, new Creature(_id, _is_passive)
				.set_index(is_array_choose(_index2)));
			
            _id2.sfx = -1;
            
			entity_init(_id2, undefined, _hp, _attributes, _colour_offset, _effect_immune);
			get_buffs(_attributes, _id2);
		}
		
		exit;
	}
	
	repeat (_amount)
	{
		var _id2 = instance_create_layer(_x, _y, "Instances", obj_Creature, new Creature(_id, _is_passive)
			.set_index(is_array_choose(_sprite_index)));
		
        _id2.sfx = -1;
        
		entity_init(_id2, undefined, _hp, _attributes, _colour_offset, _effect_immune);
		get_buffs(_attributes, _id2);
	}
}