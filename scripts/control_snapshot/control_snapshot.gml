function control_snapshot(_camera_width, _camera_height)
{
	if (!surface_exists(surface_snapshot))
	{
		surface_snapshot = surface_create(_camera_width, _camera_height);
	}
	
	surface_set_target(surface_snapshot);
	
	draw_surface_stretched(application_surface, 0, 0, _camera_width, _camera_height);
	
    if (surface_exists(surface_lighting))
    {
        draw_surface_stretched(surface_lighting, 0, 0, _camera_width, _camera_height);
    }
    
    if (surface_exists(surface_lighting_pixel))
    {
        gpu_set_blendmode_ext(bm_dest_color, bm_zero);
        
        draw_surface_stretched(surface_lighting_pixel, 0, 0, _camera_width, _camera_height);
        
        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
    }
    
	if (is_opened_gui)
	{
		if (surface_exists(surface_inventory))
		{
			draw_surface_stretched(surface_inventory, 0, 0, _camera_width, _camera_height);
		}
		
		if (surface_exists(surface_hp))
		{
			draw_surface_stretched(surface_hp, 0, 0, _camera_width, _camera_height);
		}
	}
	
	surface_reset_target();
	
	surface_save(surface_snapshot, $"{DIRECTORY_SCREENSHOTS}/{datetime_to_unix()}.png");
	
	sfx_play("phantasia:generic.snapshot", global.settings_value.sfx);
    
    if (keyboard_check(vk_shift))
    {
        execute_shell_simple($"{DIRECTORY_APPDATA}/{DIRECTORY_SCREENSHOTS}/{datetime_to_unix()}.png")
    }
}