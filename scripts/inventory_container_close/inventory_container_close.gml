function inventory_container_close()
{
	if (obj_Control.is_opened_container)
	{
		var _container = [];
	
		array_copy(_container, 0, global.inventory.container, 0, global.container_size);
		
		var _x = global.container_tile_position_x;
		var _y = global.container_tile_position_y;
		var _z = global.container_tile_position_z;
		
		tile_set(_x, _y, _z, "inventory", _container);
		
		var _sfx = global.item_data[$ tile_get(_x, _y, _z)].get_container_sfx();
		
		if (_sfx != undefined)
		{
			sfx_play(string_replace(_sfx, "~", "close"), global.settings_value.sfx);
		}
	}
	
	obj_Control.is_opened_container = false;
	obj_Control.surface_refresh_inventory = true;
	
	inventory_resize("container", 0);
	
	with (obj_Inventory)
	{
		if (type != "container") continue;
		
		instance_destroy();
	}
}