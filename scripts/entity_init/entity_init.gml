function entity_init(_id, _hp, _hp_max, _attributes, _colour_offset = 0, _effect_immune = undefined)
{
	with (_id)
	{
		buffs = {}
		attributes = _attributes;
		
		xvelocity = 0;
		yvelocity = 0;
        
		ylast = y;
        
		hp = _hp ?? _hp_max;
		hp_max = _hp_max;
        
		immunity_frame = 0;
        
		damage_type = DAMAGE_TYPE.DEFAULT;
		colour_offset = _colour_offset;
        
		effect_immune = _effect_immune;
		
		entity_init_sprite(sprite_index);
		
		jump_count = 0;
        jump_time = 0;
		
		effects = {}
        
        knockback_time = 0;
        knockback_direction = 0; 
	}
}