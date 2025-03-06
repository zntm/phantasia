enum PROJECTILE_BOOLEAN {
	FADE = 1,
	POINT = 2,
	COLLISION = 4,
	DESTROY_ON_COLLISION = 8
}

function spawn_projectile(_x, _y, _damage, _sprite, _index, _xvelocity, _yvelocity, _gravity = PHYSICS_GLOBAL_GRAVITY, _rotation = 0, _boolean = PROJECTILE_BOOLEAN.DESTROY_ON_COLLISION, _life = 0, _damage_unable = undefined)
{
	with (instance_create_layer(_x, _y, "Instances", obj_Projectile))
	{
		image_index = _index;
		
		value = (_boolean << 32) | (floor(_life) << 16) | floor(_damage);
		
		xvelocity = _xvelocity;
		yvelocity = _yvelocity;
		rotation = _rotation;
		
		gravity_strength = _gravity;
		damage_unable = _damage_unable;
		
		entity_init_sprite(_sprite);
		
		if (rotation != 0)
		{
			image_angle = random(360);
		}
		
		life_current = 0;
	}
}