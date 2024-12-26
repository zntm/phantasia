function call_destroy_whip()
{
	if (room != rm_World) exit;
	
	var _id = id;
	
	with (obj_Whip)
	{
		if (owner == _id)
		{
			instance_destroy();
		}
	}
	
	layer_sequence_destroy(whip_sequence);
}