function entity_damage(_direction, _damage, _delta_time, _type = DAMAGE_TYPE.DEFAULT)
{
	if (immunity_frame > 0) || (_damage == 0) exit;
	
	hp_add(id, -_damage, _type);
	
	immunity_frame = 1;
    
	if (object_index == obj_Player)
	{
		sfx_play("phantasia:action.damage", global.settings_value.sfx);
	}
    
    entity_damage_knockback(_direction, _delta_time);
}