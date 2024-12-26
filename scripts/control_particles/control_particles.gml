function control_particles(_particle_data, _world_height, _bbox_l, _bbox_t, _bbox_r, _bbox_b, _speed)
{
	static __collision = function(_id, _data, _boolean)
	{
		if (_boolean & (1 << 4))
		{
			instance_destroy();
			
			return true;
		}
		
		var _xvelocity = _data.xspeed_on_collision;
		var _yvelocity = _data.yspeed_on_collision;
		
		if (_xvelocity != PARTICLE_COLLISION_EMPTY)
		{
			_id.xvelocity = _xvelocity;
		}
		
		if (_yvelocity != PARTICLE_COLLISION_EMPTY)
		{
			_id.yvelocity = _yvelocity;
		}
		
		return false;
	}
	
	static __destroy = function(_id, _bbox_l, _bbox_t, _bbox_r, _bbox_b)
	{
		if (!rectangle_in_rectangle(_id.bbox_left, _id.bbox_top, _id.bbox_right, _id.bbox_bottom, _bbox_l, _bbox_t, _bbox_r, _bbox_b))
		{
			instance_destroy();
		
			return true;
		}
		
		return false;
	}
	
	with (obj_Particle)
	{
		var _data = _particle_data[$ particle_id];
		
		life += _speed;

		if (life > life_max)
		{
			instance_destroy();
	
			continue;
		}
		
		var _boolean = _data.boolean;
		var _collision = _boolean & 2;

		if ((((xvelocity != 0) && (physics_x(abs(xvelocity) * _speed, _collision, undefined, _world_height))) || (((gravity != 0) || (yvelocity != 0)) && (physics_y(_speed, gravity, false, _collision, undefined, _world_height)))) && (__collision(id, _data, _boolean))) || (__destroy(id, _bbox_l, _bbox_t, _bbox_r, _bbox_b)) continue;
		
		if (_boolean & (1 << 5)) && (!position_meeting(x, y, obj_Light_Sun))
		{
			instance_destroy();
			
			continue;
		}

		image_angle += rotation * _speed;

		var _amount = life / life_max;

		if (_boolean & 1)
		{
			alpha = 1 - _amount;
		}
		
		if (_boolean & 4)
		{
			image_index = floor(_amount * (image_number - 1));
		}
	}
}