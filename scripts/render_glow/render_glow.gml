function render_glow(_camera_x, _camera_y, _camera_width, _camera_height)
{
	if (!surface_exists(surface_glow))
	{
		surface_glow = surface_create(_camera_width, _camera_height);
	}
	
	surface_set_target(surface_glow);
	draw_clear_alpha(c_black, 0);
	
	draw_sprite_ext(spr_Square, 0, 0, 0, _camera_width, _camera_height, 0, c_black, 1);
	
	gpu_set_blendmode(bm_add);
	
	with (obj_Tile_Light)
	{
		if (bloom == c_black) continue;
		
		draw_sprite_ext(spr_Glow, 0, x - _camera_x, y - _camera_y, 1, 1, 0, bloom, 1);
	}
	
	surface_reset_target();
	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
}