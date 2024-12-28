function entity_damage(_xvelocity, _yvelocity, _damage, _type = DAMAGE_TYPE.DEFAULT)
{
	if (immunity_frame > 0) || (_damage == 0) exit;
	
	hp_add(id, _damage, _type);
	
	xvelocity = _xvelocity;
	yvelocity = _yvelocity;
	
	immunity_frame = 1;
	
	if (object_index == obj_Player)
	{
		sfx_play("phantasia:action.damage", global.settings_value.sfx);
	}
}