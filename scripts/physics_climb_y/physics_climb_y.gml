function physics_climb_y(_key_up, _key_down, _world_height, _delta_time = global.delta_time)
{
	yvelocity = 0;
	
	var _tile_x = round(x / TILE_SIZE);
	var _moved = false;
	
	var _travel = PHYSICS_GLOBAL_CLIMB_YSPEED * _delta_time;
	
	var _sign = sign(_travel);
	
	if (_key_up)
	{
		for (var i = _travel; i >= 0; --i)
		{
			var _val = y - (min(1, i) * _sign);
			
			if (tile_get(_tile_x, round(_val / TILE_SIZE), CHUNK_DEPTH_DEFAULT, undefined, _world_height) == TILE_EMPTY) || (tile_meeting(x, _val, undefined, undefined, _world_height)) break;
			
			y = _val;
			
			_moved = true;
		}
	}
	
	if (_key_down)
	{
		for (var i = _travel; i >= 0; --i)
		{
			var _val = y + (min(1, i) * _sign);
			
			if (tile_get(_tile_x, round(_val / TILE_SIZE), CHUNK_DEPTH_DEFAULT, undefined, _world_height) == TILE_EMPTY) || (tile_meeting(x, _val, _world_height)) break;
			
			y = _val;
			
			_moved = true;
		}
	}
	
	return _moved;
}