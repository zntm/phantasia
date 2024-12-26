function physics_sandbox(_key_left, _key_right, _world_height, _delta_time = global.delta_time)
{
	if (keyboard_check(global.settings_value.climb_up))
	{
		instance_cull(true);
        chunk_update_near_light();
        chunk_update_near_inst();
		// chunk_refresh(x, y, 1, true, true);
		
		y = clamp(y - (global.debug_settings.fly_speed * _delta_time), 0, (_world_height * TILE_SIZE) - TILE_SIZE);
		ylast = y;
	}
	
	if (_key_left)
	{
		instance_cull(true);
        chunk_update_near_light();
        chunk_update_near_inst();
		// chunk_refresh(x, y, 1, true, true);
		
		image_xscale = -1;
		x -= global.debug_settings.fly_speed * _delta_time;
	}

	if (keyboard_check(global.settings_value.climb_down))
	{
		instance_cull(true);
        chunk_update_near_light();
        chunk_update_near_inst();
		// chunk_refresh(x, y, 1, true, true);
		
		y = clamp(y + (global.debug_settings.fly_speed * _delta_time), 0, (_world_height * TILE_SIZE) - TILE_SIZE);
		ylast = y;
	}

	if (_key_right)
	{
		instance_cull(true);
        chunk_update_near_light();
        chunk_update_near_inst();
		// chunk_refresh(x, y, 1, true, true);
		
		image_xscale = 1;
		x += global.debug_settings.fly_speed * _delta_time;
	}
}