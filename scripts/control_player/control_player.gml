function control_player(_item_data, _tick, _world_height, _entity_ymax, _delta_time)
{
	var _is_opened_chat = obj_Control.is_opened_chat;
	var _is_opened_menu = obj_Control.is_opened_menu;
	
	var _settings_value = global.settings_value;
	
	var _key_left    = false;
	var _key_right   = false;
    
	var _key_jump    = false;
    
	if (!_is_opened_chat) && (!_is_opened_menu)
	{
		_key_left  = get_control("left");
		_key_right = get_control("right");
        
		_key_jump  = get_control("jump");
	}
	
	with (obj_Player)
	{
		if (hp <= 0) continue;
		
		if (hp < hp_max)
		{
			regeneration_speed -= _delta_time;
			
			if (regeneration_speed <= 0)
			{
				regeneration_speed += buffs[$ "regeneration_speed"];
				
				hp_add(id, buffs[$ "regeneration_value"]);
                
				obj_Control.surface_refresh_hp = true;
			}
		}
		
		var _tile_on = tile_get(round(x / TILE_SIZE), round(y / TILE_SIZE), CHUNK_DEPTH_DEFAULT);
        
		if (is_climbing)
		{
			physics_climb(_key_left, _key_right, _key_jump, _tile_on, _world_height, _delta_time);
            
			y = clamp(y, 0, _entity_ymax);
            
			continue;
		}
        
		if (!DEVELOPER_MODE) || (global.debug_settings.physics)
		{
			if (!is_climbing) && (_tile_on != TILE_EMPTY) && (keyboard_check(_settings_value.climb_up) || keyboard_check(_settings_value.climb_down)) && (_item_data[$ _tile_on].type & ITEM_TYPE_BIT.CLIMBABLE)
			{
				is_climbing = true;
				
				continue;
			}
			
			var _direction = _key_right - _key_left;
            
			physics_y(_delta_time, buffs[$ "gravity"], undefined, undefined, undefined, _world_height);
            
			var _dash = buffs[$ "dash_power"];
            
			physics_dash(_key_left, _key_right, _dash, _delta_time);
            
			if (dash_speed > 0) && (_dash > 0)
			{
				physics_slow_down(dash_facing, _delta_time);
				physics_x((dash_speed + buffs[$ "movement_speed"]) * _delta_time, undefined, undefined, _world_height);
			}
			else
			{
				physics_slow_down(_direction, _delta_time);
				physics_x(buffs[$ "movement_speed"] * _delta_time, undefined, undefined, _world_height);
			}
			
			if (_direction != 0)
			{
				image_xscale = _direction * abs(image_xscale);
			}
            
			if (yvelocity != 0) || (physics_bury(undefined, _world_height))
			{
				y = clamp(y, 0, _entity_ymax);
			}
            
			if (tile_meeting(x, y + 1, undefined, undefined, _world_height))
			{
				if (entity_fall(global.difficulty_multiplier_damage[global.world_settings.difficulty]))
				{
					sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, "phantasia:action.damage");
				}
                
				jump_pressed = 0;
				jump_count = 0;
                
				coyote_time = 0;
                
                knockback_time = 0;
			}
			else if (!_key_jump)
			{
				coyote_time += _delta_time;
			}
            
			if (_key_jump)
			{
				if (keyboard_check_pressed(_settings_value.jump))
				{
					jump_pressed = 0;
                    
					++jump_count;
				}
                
				if ((jump_count < buffs[$ "jump_count_max"]) || (coyote_time <= buffs[$ "coyote_time"])) && (jump_pressed < buffs[$ "jump_time"])
				{
					yvelocity = -buffs[$ "jump_height"] * _delta_time;
                    
					jump_pressed += _delta_time;
				}
			}
            
			if (xvelocity != 0) || (yvelocity != 0)
			{
				moved = true;
                
				refresh_world();
                chunk_update_near_inst();
			}
			else if (moved)
			{
				moved = false;
                
				refresh_world();
                chunk_update_near_inst();
			}
            
			continue;
		}
        
		if (!_is_opened_chat) && (!_is_opened_menu)
		{
			physics_sandbox(_key_left, _key_right, _entity_ymax, _delta_time);
		}
	}
}