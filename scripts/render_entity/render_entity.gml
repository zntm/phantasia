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
			draw_sprite_ext(_sprite, image_index, _x, _y, image_xscale, image_yscale, image_angle, c_white, 1);
            
            exit;
		}
        
        var _length = array_length(_sprite);
        
        for (var i = 0; i < _length; ++i)
        {
            draw_sprite_ext(_sprite[i], image_index, _x, _y, image_xscale, image_yscale, image_angle, c_white, 1);
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
			
            var _data = _particle_data[$ particle_id];
            
			if (_data.boolean & 8)
			{
				_particle_additive = true;
				
				continue;
			}
			
			draw_sprite_ext(_data.sprite, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);
		}
		
		if (_particle_additive)
		{
			gpu_set_blendmode(bm_add);
            
			with (obj_Particle)
			{
                var _data = _particle_data[$ particle_id];
                
				if ((_data.boolean & 8) == 0) continue;
				
				draw_sprite_ext(_data.sprite, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);
			}
			
			gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
		}
		
		#endregion
		
		if (_z == CHUNK_DEPTH_DEFAULT)
		{
			var _timestamp = datetime_to_unix();
			
			with (obj_Item_Drop)
			{
				draw_sprite_ext(sprite_index, image_index, x, ((xvelocity == 0) && (yvelocity == 0) ? (y - (cos((x + y + _timestamp + time_life) / 16) * 2)) : y), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
			}
			
			with (obj_Pet)
			{
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
			}
            
			with (obj_Creature)
			{
                var _xscale = sign(image_xscale) * xscale;
                var _yscale = sign(image_yscale) * yscale;
                
				var _image_alpha = __get_alpha(image_alpha, immunity_frame, _immunity_alpha);
				
				var _data = _creature_data[$ creature_id];
				
                var _sprite = ((xvelocity == 0) ? _data.sprite_idle : _data.sprite_moving);
                
                draw_sprite_ext(((is_array(_sprite)) ? _sprite[index] : _sprite), image_index, x, y, _xscale, _yscale, image_angle, image_blend, image_alpha);
                
                var _sprite_white = _data.sprite_white;
                
                if (_sprite_white != undefined)
                {
                    draw_sprite_ext(((xvelocity == 0) || (!is_array(_sprite_white)) ? _sprite_white : _sprite_white[index]), image_index, x, y, _xscale, ysc_yscaleale, image_angle, image_blend, image_alpha);
                }
                
				var _on_draw = _data.on_draw;
                
				if (_on_draw != undefined)
				{
					_on_draw(x, y, _xscale, _yscale, image_angle, image_blend, _image_alpha);
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
			
            render_entity_player(_immunity_alpha);
			
			render_lightning();
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