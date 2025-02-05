function render_lighting(_camera_x, _camera_y, _camera_width, _camera_height)
{
	if (!surface_exists(surface_lighting))
	{
		surface_lighting = surface_create(_camera_width, _camera_height);
	}
	
	surface_set_target(surface_lighting);
	
	draw_sprite_ext(spr_Square, 0, 0, 0, _camera_width, _camera_height, 0, c_black, 1);
	gpu_set_blendmode(bm_subtract);
	
	var _world_height = (global.world_data[$ global.world.realm].get_world_height()) * TILE_SIZE;
	
	with (obj_Parent_Light)
	{
		if (object_index != obj_Light_Sun)
		{
			draw_sprite_ext(spr_Glow, 0, x - _camera_x, y - _camera_y, 1, 1, 0, c_white, 1);
			
			continue;
		}
		
		var _x = x - _camera_x + ((image_xscale / 2) * -TILE_SIZE);
		var _y = y - _camera_y;
		
		repeat (image_xscale)
		{
			_x += TILE_SIZE;
			
			draw_sprite_ext(spr_Glow_Half, 0, _x, _y, 1, 1, 0, c_white, 1);
            draw_sprite_ext(spr_Glow_Stretch, 0, _x, _y, 1, _world_height, 0, c_white, 1);
		}
	}

    gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
	surface_reset_target();
    
    if (!surface_exists(surface_lighting_pixel))
    {
        surface_lighting_pixel = surface_create(_camera_width, _camera_height);
    }
    
    surface_set_target(surface_lighting_pixel);
    
    draw_sprite_ext(spr_Square, 0, 0, 0, _camera_width, _camera_height, 0, c_black, 1);
    gpu_set_blendmode(bm_add);
    
    var _coloured_lighting = global.settings_value.coloured_lighting;
    
    with (obj_Parent_Light)
    {
        if (object_index != obj_Light_Sun)
        {
            var _x = floor((x - _camera_x) / TILE_SIZE) * TILE_SIZE;
            var _y = floor((y - _camera_y) / TILE_SIZE) * TILE_SIZE;
            
            var _xtile = x / TILE_SIZE;
            var _ytile = y / TILE_SIZE;
            
            var _xstart = floor(_xtile) * TILE_SIZE;
            var _xend   = ceil(_xtile)  * TILE_SIZE;
            
            var _ystart = floor(_ytile) * TILE_SIZE;
            var _yend   = ceil(_ytile)  * TILE_SIZE;
            
            var _xnormalized = normalize(x, _xstart, _xend);
            var _ynormalized = normalize(y, _ystart, _yend);
            
            var _xdraw = (_xstart - _camera_x) + TILE_SIZE_H;
            var _ydraw = (_ystart - _camera_y) + TILE_SIZE_H;
            
            draw_sprite_ext(spr_Glow_Pixel, 0, _xdraw + TILE_SIZE, _ydraw, TILE_SIZE, TILE_SIZE, 0, colour_offset,     (_xnormalized) * 0.5);
            draw_sprite_ext(spr_Glow_Pixel, 0, _xdraw - TILE_SIZE, _ydraw, TILE_SIZE, TILE_SIZE, 0, colour_offset, (1 - _xnormalized) * 0.5);
            
            draw_sprite_ext(spr_Glow_Pixel, 0, _xdraw, _ydraw + TILE_SIZE, TILE_SIZE, TILE_SIZE, 0, colour_offset,     (_ynormalized) * 0.5);
            draw_sprite_ext(spr_Glow_Pixel, 0, _xdraw, _ydraw - TILE_SIZE, TILE_SIZE, TILE_SIZE, 0, colour_offset, (1 - _ynormalized) * 0.5);
            
            continue;
        }
        
        var _x = x - _camera_x + ((image_xscale / 2) * -TILE_SIZE);
        var _y = y - _camera_y;
        
        repeat (image_xscale)
        {
            _x += TILE_SIZE;
            
            draw_sprite_ext(spr_Glow_Pixel_Half, 0, _x, _y, TILE_SIZE, TILE_SIZE, 0, colour_offset, 0.25);
            draw_sprite_ext(spr_Glow_Pixel_Stretch, 0, _x, _y, TILE_SIZE, _world_height, 0, colour_offset, 0.25);
        }
    }
    
    gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
    surface_reset_target();
}