function physics_climb(_key_left, _key_right, _key_jump, _tile_on, _world_height, _delta_time)
{
	if (_key_jump) || (_tile_on == TILE_EMPTY) || ((global.item_data[$ _tile_on].type & ITEM_TYPE_BIT.CLIMBABLE) == 0)
	{
		is_climbing = false;
		
		exit;
	}
	
	if (_key_left) || (_key_right)
	{
		if (physics_climb_x(_key_left, _key_right, _world_height, _delta_time))
		{
			refresh_world();
		}
		
		exit;
	}
	
	var _key_up   = get_control("climb_up");
	var _key_down = get_control("climb_down");
	
	if (_key_up != _key_down) && (physics_climb_y(_key_up, _key_down, _world_height, _delta_time))
	{
		refresh_world();
	}
}