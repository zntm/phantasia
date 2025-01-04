#macro PLAYER_BLINK_CHANCE_OPEN 0.08
#macro PLAYER_BLINK_CHANCE_CLOSE 0.02

function render_entity(_surface_index_offset)
{
	var _item_data = global.item_data;
	
	var _camera = global.camera;
	
	var _camera_x1 = _camera.x;
	var _camera_y1 = _camera.y;
	
	var _camera_x2 = _camera_x1 + _camera.width;
	var _camera_y2 = _camera_y1 + _camera.height;
    
	static __get_alpha = function(_alpha, _immunity_frame, _immunity_alpha)
	{
		return (_immunity_frame != 0 ? _alpha * _immunity_alpha : _alpha);
	}
	
	static __draw_player_attire = function(_sprite, _x, _y, _index, _alpha)
	{
		if (!is_array(_sprite))
		{
			draw_sprite_ext(_sprite, image_index, _x, _y, image_xscale, image_yscale, _index, c_white, 1);
            
            exit;
		}
        
        var _length = array_length(_sprite);
        
        for (var i = 0; i < _length; ++i)
        {
            draw_sprite_ext(_sprite[i], image_index, _x, _y, image_xscale, image_yscale, _index, c_white, 1);
        }
	}
	
	static __draw_player_body = function(_sprite, _index, _x, _y, _xscale, _yscale, _angle, _alpha, _white, _colour)
	{
		static __match   = shader_get_uniform(shd_Colour_Replace, "match");
		static __replace = shader_get_uniform(shd_Colour_Replace, "replace");
		static __amount  = shader_get_uniform(shd_Colour_Replace, "amount");
		
		shader_set(shd_Colour_Replace);
		
		shader_set_uniform_i_array(__match, _white);
		shader_set_uniform_i_array(__replace, _colour);
		
		shader_set_uniform_i(__amount, PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
		
		draw_sprite_ext(_sprite, _index, _x, _y, _xscale, _yscale, _angle, c_white, _alpha);
		
		shader_reset();
	}
	
	var _creature_data = global.creature_data;
	var _particle_data = global.particle_data;
	
	var _immunity_alpha = 0.75 + (cos(global.world.time / 6) * 0.25);

	var _particle_additive = false;
	var _particle_exists   = instance_exists(obj_Particle);
	
	for (var _z = 0; _z < CHUNK_SIZE_Z; ++_z)
	{
		#region Particles
		
		with (obj_Particle)
		{
			if (_z != z) continue;
			
			if (_particle_data[$ particle_id].boolean & 8)
			{
				_particle_additive = true;
				
				continue;
			}
			
			carbasa_draw("particle", particle_id, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);
		}
		
		if (_particle_additive)
		{
			gpu_set_blendmode(bm_add);
			
			with (obj_Particle)
			{
				if ((_particle_data[$ particle_id].boolean & 8) == 0) continue;
				
				carbasa_draw("particle", particle_id, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);
			}
			
			gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
		}
		
		#endregion
		
		if (_z == CHUNK_DEPTH_DEFAULT)
		{
			var _timestamp = datetime_to_unix();
			
			with (obj_Item_Drop)
			{
				draw_sprite_ext(sprite_index, image_index, x, ((xvelocity == 0) && (yvelocity == 0) ? (y - (cos((x + y + _timestamp + life) / 16) * 2)) : y), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
			}
			
			with (obj_Pet)
			{
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
			}
			
			with (obj_Creature)
			{
				var _image_alpha = __get_alpha(image_alpha, immunity_frame, _immunity_alpha);
				
				var _data = _creature_data[$ creature_id];
				
				if (index == -1)
				{
					carbasa_draw("creatures", $"{creature_id}:{((xvelocity == 0) ? "idle" : "moving")}", image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
                    
					var _sprite_white = _data.sprite_white;
                    
					if (_sprite_white != undefined)
					{
						carbasa_draw("creatures", $"{creature_id}:white", image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
					}
				}
				else
				{
					carbasa_draw("creatures", $"{creature_id}:{((xvelocity == 0) ? "idle" : "moving")}{index}", image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
                    
					var _sprite_white = _data.sprite_white;
                    
					if (_sprite_white != undefined)
					{
						carbasa_draw("creatures", $"{creature_id}:white{index}", image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
					}
				}
                
				var _on_draw = _data.on_draw;
                
				if (_on_draw != undefined)
				{
					_on_draw(x, y, image_xscale, image_yscale, image_angle, image_blend, _image_alpha);
				}
			}
			
			with (obj_Boss)
			{
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, __get_alpha(image_alpha, immunity_frame, _immunity_alpha));
                
				var _length = array_length(explosion);
                
				for (var i = 0; i < _length; ++i)
				{
					var _piece = explosion[i];
                    
					if (_piece.timer <= 0) continue;
					
					draw_sprite_ext(_piece.sprite, _piece.index, _piece.x, _piece.y, 1, 1, 0, image_blend, 1);
				}
			}
			
			with (obj_Projectile)
			{
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
			}
			
			#region Player
			
			var _inventory = global.inventory;
			
			var _attire_elements = global.attire_elements_ordered;
			
			var _shader_colour_replace_amount  = global.shader_colour_replace_amount;
			var _shader_colour_replace_match   = global.shader_colour_replace_match;
			var _shader_colour_replace_replace = global.shader_colour_replace_replace;
			
			var _colour_data  = global.colour_data;
			var _colour_white = global.colour_white;
			
			with (obj_Player)
			{
				if (is_blinking)
				{
					if (chance(PLAYER_BLINK_CHANCE_OPEN * global.delta_time))
					{
						is_blinking = false;
					}
				}
				else if (chance(PLAYER_BLINK_CHANCE_CLOSE * global.delta_time))
				{
					is_blinking = true;
				}
				
				var _player_x = x;
				var _player_y = y;
				
				var _image_blend = image_blend;
				var _image_alpha = __get_alpha(image_alpha, immunity_frame, _immunity_alpha);
				
				var _xscale = abs(image_xscale);
				var _yscale = abs(image_yscale);
				
				if (!surface_exists(surface))
				{
					surface_xscale = _xscale;
					surface_yscale = _yscale;
					
					surface = surface_create(32 * _xscale, 48 * _yscale);
				}
				
				if (!surface_exists(surface2))
				{
					surface2 = surface_create(32 * _xscale, 48 * _yscale);
				}
				
				if (_xscale != surface_xscale) || (_yscale != surface_yscale)
				{
					surface_xscale = _xscale;
					surface_yscale = _yscale;
					
					surface_resize(surface, 32 * _xscale, 48 * _yscale);
					surface_resize(surface2, 32 * _xscale, 48 * _yscale);
				}
				
				surface_set_target(surface);
				draw_clear_alpha(c_white, 0);
				
				var _x = 16 * _xscale;
				var _y = 24 * _yscale;
				
				var _attire_data = global.attire_data;
				
				var _armor_helmet      = _inventory.armor_helmet[0];
				var _armor_breastplate = _inventory.armor_breastplate[0];
				var _armor_leggings    = _inventory.armor_leggings[0];
				
				var _attire = global.player.attire;
				var _body = _colour_data[_attire.body.colour];
				
				var _tool_exists = (tool != -1);
				
				var _arm_index = (_tool_exists ? (round(lerp(8, 13, tool.angle / 180))) : image_index);
				
				for (var i = 0; i < ATTIRE_ELEMENTS_ORDERED_LENGTH; ++i)
				{
					var _name = _attire_elements[i];
					
					if (_name == "body")
					{
						__draw_player_body(att_Base_Body, image_index, _x, _y, image_xscale, image_yscale, image_angle, _image_alpha, _colour_white, _body);
						
						continue;
					}
					
					if (_name == "body_arm_left")
					{
						surface_reset_target();
						
						surface_set_target(surface2);
						draw_clear_alpha(c_white, 0);
						
						__draw_player_body(att_Base_Arm_Left, _arm_index, _x, _y, image_xscale, image_yscale, image_angle, _image_alpha, _colour_white, _body);
						
						continue;
					}
					
					if (_name == "body_arm_right")
					{
						__draw_player_body(att_Base_Arm_Right, image_index, _x, _y, image_xscale, image_yscale, image_angle, _image_alpha, _colour_white, _body);
						
						continue;
					}
					
					if (_name == "body_legs")
					{
						__draw_player_body(att_Base_Legs, image_index, _x, _y, image_xscale, image_yscale, image_angle, _image_alpha, _colour_white, _body);
						
						continue;
					}
					
					if (_name == "eyes") && (is_blinking) continue;
					
					// TODO: Add Armor
					/*
					*/
						
					if (is_array(_name))
					{
						var _name2 = _name[0];
						var _index2 = _name[1];
							
						var _ = _attire[$ _name2];
							
						var _a = _attire_data[$ _name2];
						
						if (_a == undefined) continue;
						
						var _index = _.index;
						
						_a = _a[_index];
						
						if (_a == undefined) continue;
						
						var _arm_index2 = (((_name2 == "shirt") || (_name2 == "shirt_detail")) && (_index2 == 2) ? _arm_index : image_index);
						
						var _colour = _a.colour;
                        
						if (_colour != undefined) && (array_length(_colour) > _index2)
						{
							shader_set(shd_Colour_Replace);
                            
							shader_set_uniform_i_array(_shader_colour_replace_match, _colour_white);
							shader_set_uniform_i_array(_shader_colour_replace_replace, _colour_data[_.colour]);
                            
							shader_set_uniform_i(_shader_colour_replace_amount, PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
                            
							__draw_player_attire(_colour, _x, _y, _arm_index2, _image_alpha);
							
							shader_reset();
						}
							
						var _white = _a.white;
						
						if (_white != undefined) && (_white > _index2)
						{
							__draw_player_attire(_white, _x, _y, _arm_index2, _image_alpha);
						}
						
						continue;
					}
					
					var _ = _attire[$ _name];
					
					var _a = _attire_data[$ _name];
					
					if (_a == undefined) continue;
					
					var _index = _.index;
					
					_a = _a[_index];
					
					if (_a == undefined) continue;
					
					var _colour = _a.colour;
						
					if (_colour != undefined)
					{
						shader_set(shd_Colour_Replace);
                        
						shader_set_uniform_i_array(_shader_colour_replace_match, _colour_white);
						shader_set_uniform_i_array(_shader_colour_replace_replace, _colour_data[_.colour]);
                        
						shader_set_uniform_i(_shader_colour_replace_amount, PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
						
						__draw_player_attire(_colour, _x, _y, _arm_index, _image_alpha);
						
						shader_reset();
					}
						
					var _white = _a.white;
						
					if (_white != undefined)
					{
						__draw_player_attire(_white, _x, _y, _arm_index, _image_alpha);
					}
				}
				
				surface_reset_target();
				
				var _xsurface = _player_x - _x;
				var _ysurface = _player_y - _y;
				
				draw_surface_ext(surface, _xsurface, _ysurface, _xscale, _yscale, 0, _image_blend, _image_alpha);
				
				if (_tool_exists)
				{
					with (tool)
					{
						draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, _image_blend, _image_alpha);
					}
				}
				
				draw_surface_ext(surface2, _xsurface, _ysurface, _xscale, _yscale, 0, _image_blend, _image_alpha);
				
				with (obj_Whip)
				{
					draw_sprite_ext(obj_Player.whip_sprite, image_index, _player_x + x, _player_y + y + 512, image_xscale, image_yscale, image_angle, _image_blend, _image_alpha);
				}
				
				if (instance_exists(fishing_pole))
				{
					with (fishing_pole)
					{
						var _xowner = owner.x;
						var _sign = sign(x - _xowner);
						
						var _data = _item_data[$ item_id];
						
						var _detail = _data.get_fishing_line_detail();
						var _colour = _data.get_fishing_line_colour();
						
						draw_curve(x, y, _xowner, owner.y, 0, _detail, _colour);
						draw_sprite_ext(sprite_index, image_index, x, y, _sign, image_yscale, ((xvelocity != 0) && (yvelocity != 0) ? _sign * point_direction(x, y, x + abs(xvelocity), y + yvelocity) : 0), _image_blend, _image_alpha);
					}
				}
			}
			
			render_lightning();
			
			#endregion
		}
		
		var _zbit = 1 << _z;
		
		with (obj_Chunk)
		{
			if (!is_in_view) || ((surface_display & _zbit) == 0) continue;
			
			var _surface = surface[_surface_index_offset ? _z : (CHUNK_SIZE_Z + _z)];
			
			if (surface_exists(_surface))
			{
				draw_surface(_surface, x - CHUNK_SURFACE_PADDING, y - CHUNK_SURFACE_PADDING);
			}
		}
	}
	
	if (DEVELOPER_MODE)
	{
		if (global.debug_settings.instances)
		{
			with (obj_Creature)
			{
				draw_sprite_ext(spr_Entity, 0, x, y, image_xscale, image_yscale, 0, c_red, 0.5);
				
				var _eye_level = _creature_data[$ creature_id].eye_level;
				
				draw_line_colour(x, bbox_top + _eye_level, x + (TILE_SIZE * 4 * image_xscale), bbox_top + _eye_level, c_blue, c_blue);
			}
			
			with (obj_Inventory)
			{
				draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_yellow, 0.5);
			}
			
			with (obj_Tile_Container)
			{
				draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_blue, 0.5);
			}
		}
		
		if (global.debug_settings.chunk)
		{
			with (obj_Chunk)
			{
				if (!is_in_view) || (!surface_display) continue;
				
				var _x1 = x - TILE_SIZE_H;
				var _y1 = y - TILE_SIZE_H;
				var _x2 = _x1 - 1 + CHUNK_SIZE_WIDTH;
				var _y2 = _y1 - 1 + CHUNK_SIZE_HEIGHT;
				
				draw_rectangle_colour(_x1, _y1, _x2, _y2, c_red, c_yellow, c_purple, c_blue, true);
			}
		}
	}
}