function load_sun_rays()
{
	var _inst = instance_create_layer(0, 0, "Instances", obj_Light_Sun);
	
	with (_inst)
	{
		image_yscale = WORLD_HEIGHT;
	}
	
	return _inst;
}