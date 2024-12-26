function creature_check_fall_height(_x, _y, _direction, _max, _world_height)
{
	var _tile_size = TILE_SIZE * _direction;
	
	var _fall_amount = 0;

	repeat (AI_CREATURE_FALL_CHECK - 1)
	{
		if (tile_meeting(_x, _y + ((_fall_amount + 1) * _tile_size), undefined, undefined, _world_height) != -1) break;
		
		++_fall_amount;
	}
	
	return _fall_amount;
}