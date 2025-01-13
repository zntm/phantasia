function creature_check_fall_height(_x, _y, _direction, _max, _world_height)
{
	var _tile_size = TILE_SIZE * _direction;
	
	var _fall_amount = 0;

	for (var i = 0; i < _max; ++i)
	{
		if (tile_meeting(_x, _y + ((_fall_amount + 1) * _tile_size), undefined, undefined, _world_height))
        {
            return i;
        }
	}
	
	return _max;
}