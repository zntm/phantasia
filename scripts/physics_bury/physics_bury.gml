function physics_bury(_threshold = TILE_SIZE_H - 1, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
	if (!tile_meeting(x, y, undefined, undefined, _world_height)) exit;
	
	var i = 1;
	
	repeat (_threshold)
	{
		var _y = y - i;
		
		if (tile_meeting(x, _y, undefined, undefined, _world_height))
		{
			++i;
			
			continue;
		}
		
		y = _y;
		
		return true;
	}
	
	return false;
}