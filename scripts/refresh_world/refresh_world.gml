function refresh_world()
{
	refresh_craftables();
    chunk_update_near_light();
	// chunk_refresh(x, y, 4, true, true);
	
	var _ = floor(x / (CHUNK_SIZE_WIDTH / 4));
	
	if (_ != obj_Control.refresh_sun_position)
	{
		obj_Control.refresh_sun_ray = true;
		obj_Control.refresh_sun_position = _;
	}
}