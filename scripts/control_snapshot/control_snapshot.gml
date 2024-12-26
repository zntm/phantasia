function control_snapshot(_camera_width, _camera_height)
{
	if (!surface_exists(surface_snapshot))
	{
		surface_snapshot = surface_create(_camera_width, _camera_height);
	}
	
	surface_set_target(surface_snapshot);
	
	draw_surface_stretched(application_surface, 0, 0, _camera_width, _camera_height);
	
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
	
	surface_save(surface_snapshot, $"{DIRECTORY_SNAPSHOTS}/{datetime_to_unix()}.png");
	
	sfx_play("phantasia:generic.snapshot", global.settings_value.master * global.settings_value.sfx);
}