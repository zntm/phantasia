function entity_damage(_inst, _direction, _damage, _delta_time, _type = DAMAGE_TYPE.DEFAULT)
{
	if (immunity_frame > 0) || (_damage == 0) exit;
	
	hp_add(id, -_damage, _type);
	
	immunity_frame = 1;
    
	if (object_index == obj_Player)
	{
		sfx_play("phantasia:action.damage", global.settings_value.sfx);
        
        if (id.hp <= 0) && (instance_exists(_inst)) && (_inst.object_index == obj_Creature)
        {
            var _data = global.creature_data[$ _inst.creature_id];
            var _creature = loca_translate($"{_data.get_namespace()}:{_data.get_id()}");
            
            chat_add(undefined, $"{_inst} was slain by {_creature}");
            
            exit;
        }
	}
    
    entity_knockback(id, _direction, _delta_time);
}