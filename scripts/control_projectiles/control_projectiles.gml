function control_projectiles(_speed)
{
	with (obj_Projectile)
	{
		var _collision = (value & PROJECTILE_BOOLEAN.COLLISION);
	
		var _x = physics_x(abs(xvelocity) * _speed, _collision, physics_step_projectile);
		var _y = physics_y(_speed, gravity_strength, false, _collision, physics_step_projectile);

		life_current += _speed;
	
		var _life = (value >> 16) & 0xffff;

		if ((_life > 0) && (life_current > _life)) || ((_x || _y) && (value & (PROJECTILE_BOOLEAN.DESTROY_ON_COLLISION << 32)))
		{
			instance_destroy();
	
			continue;
		}

		image_angle = ((value & (PROJECTILE_BOOLEAN.POINT << 32)) ? point_direction(x, y, x + xvelocity, y + yvelocity) : (image_angle + (rotation * _speed)));
	
		if (value & (PROJECTILE_BOOLEAN.FADE << 32))
		{
			image_alpha = lerp(0, 1, life_current / _life);
		}
	}
}