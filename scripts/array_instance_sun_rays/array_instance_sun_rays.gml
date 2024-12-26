function array_instance_sun_rays()
{
	with (instance_create_layer(0, 0, "Instances", obj_Light_Sun))
	{
		image_yscale = global.world_data[$ global.world.realm].value & 0xffff;
		
		return id;
	}
}