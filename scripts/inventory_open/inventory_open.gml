function inventory_open()
{
	if (obj_Control.is_opened_inventory) exit;
	
	obj_Control.is_opened_inventory = true;
	
	instance_activate_object(obj_Inventory);
	
	refresh_craftables(true);
}