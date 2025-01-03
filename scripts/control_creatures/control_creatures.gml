#macro CREATURE_PASSIVE_PANIC_SECONDS 3
#macro CREATURE_HOSTILE_SEARCH_DISTANCE 8

function control_creatures(_creature_data, _item_data, _tick, _world_height, _camera_x, _camera_y, _camera_width, _camera_height, _entity_ymax, _delta_time)
{
	var _chance_switch_direction_default = 0.01 * _delta_time;
	var _chance_switch_direction_fall    = 0.25 * _delta_time;
	var _chance_switch_direction_panic   = 0.35 * _delta_time;
	
	var _chance_jump_default = 0.30 * _delta_time;
	var _chance_jump_double  = 0.08 * _delta_time;
	
	var _chance_sfx_idle  = 0.03 * _delta_time;
	var _chance_sfx_panic = 0.05 * _delta_time;
	
	var _camera_x2 = _camera_x + _camera_width;
	var _camera_y2 = _camera_y + _camera_height;
	
	var _panic_time = _tick * CREATURE_PASSIVE_PANIC_SECONDS;
	var _sfx_time = _tick * 12;
	
	var _volume_passive = global.settings_value.creature_passive;
	var _volume_hostile = global.settings_value.creature_hostile;
	
    var _is_moved = false;
    
	with (obj_Creature)
	{
		if (rectangle_distance(x, y, _camera_x, _camera_y, _camera_x2, _camera_y2) > TILE_SIZE * 8)
		{
			instance_destroy();
            
			continue;
		}
		
		var _data = _creature_data[$ creature_id];
		
		var _type = _data.type;
		
		var _is_passive = (_type == CREATURE_HOSTILITY_TYPE.PASSIVE);
		
		if (handler_damage(id, _delta_time)) && (_is_passive)
		{
			panic_time = _panic_time;
		}
        
        var _sfx = _data.sfx;
		
		if (hp <= 0)
		{
			creature_handle_death(_sfx, _data.drops);
			
			continue;
		}
		
		if (_is_passive) && (panic_time > 0)
		{
			panic_time -= _delta_time;
		}
		
		player = instance_nearest(x, y, obj_Player);
		
		var _xto = x + (xdirection * abs(image_xscale * 8));
		
		var _fall_amount = creature_check_fall_height(_xto, y, 1, AI_CREATURE_FALL_CHECK, _world_height);
		
		var _searching = false;
		
		if (!_is_passive)
		{
			_searching = creature_hostile_search_player(_fall_amount, _chance_switch_direction_fall);
		}
		else if (panic_time > 0) && (chance(_chance_switch_direction_panic))
		{
			xdirection = sign(x - player.x);
		}
		
		if (!_searching) && (chance(_chance_switch_direction_default))
		{
			xdirection = choose(-1, 0, 0, 0, 1);
		}
        
        #region Sound Effects
        
        if (_sfx != undefined)
        {
            if (!audio_is_playing(sfx))
            {
                sfx_time -= _delta_time;
            }
            
            if (sfx_time <= 0)
            {
                if (_is_passive)
                {
                    if (panic_time <= 0)
                    {
                        if (chance(_chance_sfx_idle))
                        {
                            sfx = sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, $"{_sfx}.idle", undefined, _volume_hostile, _world_height) ?? -1;
                            
                            sfx_time = _sfx_time;
                        }
                    }
                    else if (chance(_chance_sfx_panic))
                    {
                        sfx = sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, $"{_sfx}.panic", undefined, _volume_hostile, _world_height) ?? -1;
                        
                        sfx_time = _sfx_time;
                    }
                    
                    exit;
                }
                
                if (_searching)
                {
                    // TODO: Add searching sfx
                }
                else if (chance(_chance_sfx_idle))
                {
                    sfx = sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, $"{_sfx}.idle", undefined, _volume_hostile, _world_height) ?? -1;
                    
                    sfx_time = _sfx_time;
                }
            }
        }
        
        #endregion
		
		var _attributes = _data.attributes;
		
        var _old_x = x;
        var _old_y = y;
        
		var _move_type = _data.get_move_type();
		
		if (_move_type == CREATURE_MOVE_TYPE.DEFAULT)
		{
			physics_y(_delta_time, buffs[$ "gravity"], undefined, undefined, undefined, _world_height);
			
			if (tile_meeting(x, y + 1, undefined, undefined, _world_height))
			{
				entity_fall(undefined, _world_height);
				
				if (hp <= 0)
				{
					creature_handle_death(_sfx, _data.drops);
					
					continue;
				}
				
				coyote_time = 0;
				jump_count = 0;
			}
			else
			{
				coyote_time += _delta_time;
			}
			
			if (_fall_amount > 3) && (jump_count < buffs[$ "jump_count_max"]) && (coyote_time <= buffs[$ "coyote_time_max"]) /*((_is_passive && effects[$ "phantasia:rabid"] == undefined) || (instance_exists(player) && y > player.y)) && */
			{
				if (jump_count == 0) ? (creature_check_fall_height(_xto, y, -1, 3, _world_height) >= 3) : (chance(_chance_jump_default))
				{
					yvelocity = -buffs[$ "jump_height"];
					
					++jump_count;
				}
			}
		}
		else if (_move_type == CREATURE_MOVE_TYPE.FLY) || (_move_type == CREATURE_MOVE_TYPE.SWIM && tile_meeting(x, y, CHUNK_DEPTH_LIQUID, ITEM_TYPE_BIT.LIQUID, _world_height))
		{
			image_angle = lerp_delta(image_angle, (xdirection != 0 ? xdirection * -12 : 0), 0.1, _delta_time);
            
			if (_fall_amount > 3)
			{
				if (chance(0.04 * _delta_time))
				{
					ydirection = choose(-1, 0);
				}
				else
				{
					var _direction = tile_meeting(x - 1, y, undefined, undefined, _world_height) - tile_meeting(x + 1, y, undefined, undefined, _world_height);
                    
					if (_direction != 0)
					{
						xdirection = _direction;
					}
				}
                
				physics_y(_delta_time, buffs[$ "gravity"], undefined, undefined, undefined, _world_height);
			}
			else
			{
				ydirection = -1;
                
				physics_y(_delta_time, 0, undefined, undefined, undefined, _world_height);
			}
			
			yvelocity = lerp_delta(yvelocity, ydirection * _data.get_yspeed(), 0.2, _delta_time);
		}
		
		physics_slow_down(xdirection, _delta_time, _item_data, _world_height);
        
		physics_x(buffs[$ "movement_speed"] * _delta_time, undefined, undefined, _world_height);
		
		physics_bury(undefined, _world_height);
		
		if (xdirection != 0)
		{
			image_xscale = xdirection * abs(image_xscale);
		}
		
		y = clamp(y, 0, _entity_ymax);
        
        if (x != _old_x) || (y != _old_y)
        {
            _is_moved = true;
        }
	}
    
    if (_is_moved)
    {
        chunk_update_near_inst();
    }
}