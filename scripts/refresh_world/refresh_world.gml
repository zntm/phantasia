function refresh_world()
{
	inventory_refresh_craftable();
    chunk_update_near_light();
	
	var _ = floor(x / (CHUNK_SIZE_WIDTH / 4));
	
	if (_ != obj_Control.refresh_sun_position)
	{
		obj_Control.refresh_sun_ray = true;
		obj_Control.refresh_sun_position = _;
	}
}