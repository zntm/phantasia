function physics_step_projectile(_x, _y, _id)
{
	var _boss_data = global.boss_data;
	static __inst = [ obj_Creature, obj_Boss ];
	
	var _inst = instance_place(_x, _y, __inst);
	
	if (!_inst) || (_inst.immunity_frame > 0)
	{
		return false;
	}
	
	var _value = _id.value & 0xffff;
	
	var _damage = -round(_value * random_range(0.9, 1.1));
	
	if (_damage <= 0)
	{
		var _damage_unable = _id.damage_unable;
		
		if (_damage_unable != undefined) && (is_array(_damage_unable) ? (!array_contains(_damage_unable, object_index)) : (_damage_unable != object_index))
		{
			return false;
		}
	}
	
	hp_add(_inst, -_damage, DAMAGE_TYPE.RANGED);
	
	var _object_index = _inst.object_index;
	
	if (_object_index == obj_Creature)
	{
		var _data = global.creature_data[$ _inst.creature_id];
		var _is_passive = (_data.get_type() == CREATURE_HOSTILITY_TYPE.PASSIVE);
		
		if (_is_passive)
		{
			_inst.panic_time = GAME_FPS * CREATURE_PASSIVE_PANIC_SECONDS;
		}
		
		sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, string_replace(_data.get_sfx(), "~", "hurt"), undefined, global.settings_value[$ (_is_passive ? "creature_passive" : "creature_hostile")]);
	}
	else
	{
		sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, string_replace(global.boss_data[$ _inst.boss_id].sfx, "~", "hurt"), undefined, global.settings_value.creature_hostile);
	}
	
	_inst.yvelocity = -3;
	_inst.immunity_frame = 1;
	
	if (_value & (PROJECTILE_BOOLEAN.DESTROY_ON_COLLISION << 32))
	{
		instance_destroy(_id);
		
		return true;
	}
	
	return false;
}