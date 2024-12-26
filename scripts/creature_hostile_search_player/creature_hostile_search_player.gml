#macro AI_CREATURE_FALL_CHECK 6

function creature_hostile_search_player(_fall_amount, _chance_switch_direction_fall)
{
	if (!instance_exists(player))
	{
		return false;
	}
	
	var _searching_x = player.x;
	
	if (point_distance(x, y, _searching_x, player.y) >= TILE_SIZE * CREATURE_HOSTILE_SEARCH_DISTANCE)
	{
		return false;
	}
	
	var _xdirection = sign(_searching_x - x);
	
	if (_fall_amount > round(AI_CREATURE_FALL_CHECK / 2))
	{
		xdirection = 0;
	}
	else if (chance(_chance_switch_direction_fall))
	{
		xdirection = -_xdirection;
	}
	
	return true;
}