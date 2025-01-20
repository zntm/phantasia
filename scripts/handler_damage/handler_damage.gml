enum DAMAGE_TYPE {
	DEFAULT,
	MELEE,
	RANGED,
	MAGIC,
	BLAST,
	FALL,
	FIRE
}

#macro IMMUNITY_FRAME_MAX 60
#macro KNOCKBACK_TIME_MAX 60

function handler_damage(_id, _speed)
{
	static __inst = [ obj_Projectile, obj_Tool ];
	
	if (knockback_time > 0)
	{
		knockback_time = max(knockback_time - _speed, 0);
    }
    
	if (immunity_frame > 0)
	{
		immunity_frame = max(immunity_frame - _speed, 0);
	}
	
	if (immunity_frame > 0)
	{
		return false;
	}
	
	var _damage, _damage_type, _damage_owner;
	
	var _inst = instance_place(x, y, __inst);
	
	if (instance_exists(_inst))
	{
		_damage = _inst.damage;
		_damage_type = _inst.damage_type;
		_damage_owner = _inst.owner;
	}
	else
	{
		_inst = instance_place(x - obj_Player.x, y - obj_Player.y - 512, obj_Whip);
		
		if (!instance_exists(_inst))
		{
			return false;
		}
		
		_damage = obj_Player.whip_damage;
		_damage_type = DAMAGE_TYPE.MELEE;
		_damage_owner = _inst.owner;
	}
	
	if (is_array_contains(_inst.damage_unable, _id.object_index))
	{
		return false;
	}
	
	_damage = round((_damage * _damage_owner.buffs[$ "attack_damage"] * random_range(0.9, 1.1)) - _id.buffs[$ "defense"]);
	
	if (_damage <= 0)
	{
		return false;
	}
	
	if (_inst.object_index == obj_Projectile) && (_inst.boolean & (PROJECTILE_BOOLEAN.DESTROY_ON_COLLISION << 32))
	{
		instance_destroy(_inst);
	}
	
	hp_add(id, -_damage, _damage_type);
	
	spawn_particle(x, y, CHUNK_DEPTH_DEFAULT + 1, "phantasia:damage", irandom_range(4, 8));
	
    immunity_frame = IMMUNITY_FRAME_MAX - _speed;
    
    entity_knockback(id, sign(x - _inst.x), _speed);
	
	return true;
}