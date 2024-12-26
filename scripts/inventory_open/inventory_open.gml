function inventory_open(_player_x, _player_y, _nearest_x, _nearest_y)
{
	if (obj_Control.is_opened_inventory) exit;
	
	obj_Control.is_opened_inventory = true;
	
	instance_activate_object(obj_Inventory);
	
	refresh_craftables(true);
}