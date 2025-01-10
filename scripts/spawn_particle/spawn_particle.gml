#macro PARTICLE_COLLISION_EMPTY undefined

function spawn_particle(_x, _y, _z, _id, _amount = 1, _colour = c_white)
{
	randomize();
	
	var _setting = global.settings_value.particles;
	
	if (_setting == 0) exit;
    
    if (_setting == 1) && (chance(0.5)) exit;
	
	var _particle = global.particle_data[$ _id];
	
	if (_particle == undefined) exit;
	
	var _sprite = _particle.sprite;
	
	var _xspeed = _particle.xspeed;
	var _xspeed_type = is_struct(_xspeed);
	
	var _yspeed = _particle.yspeed;
	var _yspeed_type = is_struct(_yspeed);
	
	var _rotation = _particle.rotation;
	
	var _scale = _particle.scale;
	var _lifetime = _particle.lifetime;
	
	var _gravity = _particle.gravity;
	
	var _animation_speed = _particle.animation_speed;
	
	var _sprite_xoffset = _particle.sprite_xoffset;
	var _sprite_yoffset = _particle.sprite_yoffset;
	
	var _bbox_left = _particle.bbox_left;
	var _bbox_top = _particle.bbox_top;
	var _bbox_right = _particle.bbox_right;
	var _bbox_bottom = _particle.bbox_bottom;
	
	repeat (_amount)
	{
		with (instance_create_layer(_x, _y, "Instances", obj_Particle))
		{
			particle_id = _id;
			z = _z;
			
			gravity = is_array_random(_gravity);
			
			image_xscale = is_array_random(_scale);
			image_yscale = image_xscale;
			
			image_speed = is_array_random(_animation_speed);
			
			image_blend = _colour;
			
			xvelocity = (_xspeed_type ? (function_reference(_xspeed.reference, _x, _y) + is_array_random(_xspeed[$ "offset"] ?? 0)) * is_array_random(_xspeed.multiplier) : is_array_random(_xspeed));
			yvelocity = (_yspeed_type ? (function_reference(_yspeed.reference, _x, _y) + is_array_random(_yspeed[$ "offset"] ?? 0)) * is_array_random(_yspeed.multiplier) : is_array_random(_yspeed));
			
			rotation = is_array_random(_rotation);
			
			life = 0;
			life_max = is_array_random(_lifetime);
            
            knockback_time = 0;
            knockback_direction = 0;
			
			sprite_offset_x = _sprite_xoffset;
			sprite_offset_y = _sprite_yoffset;
			
			sprite_bbox_left   = _bbox_left;
			sprite_bbox_top    = _bbox_top;
			sprite_bbox_right  = _bbox_right;
			sprite_bbox_bottom = _bbox_bottom;
			
			image_alpha = 0;
			alpha = 1;
		}
	}
}