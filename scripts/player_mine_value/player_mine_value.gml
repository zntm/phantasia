function player_mine_value(_is_mining = false, _x = undefined, _y = undefined, _z = undefined)
{
	if (_is_mining == obj_Player.is_mining) exit;
	
	obj_Player.is_mining = _is_mining;
	
	obj_Player.mining_current = 0;
	obj_Player.mining_current_fixed = 0;
	
	obj_Player.mine_position_x = _x;
	obj_Player.mine_position_y = _y;
	obj_Player.mine_position_z = _z;
}